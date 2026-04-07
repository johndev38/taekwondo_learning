import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'home_screen.dart';

class QuizGameScreen extends StatefulWidget {
  final String belt;
  final List<String> fileNames;

  const QuizGameScreen({super.key, required this.belt, required this.fileNames});

  @override
  QuizGameScreenState createState() => QuizGameScreenState();
}

class QuizGameScreenState extends State<QuizGameScreen> {
  List<dynamic> questions = [];
  int currentQuestionIndex = 0;
  int score = 0;
  bool isGameOver = false;
  final Set<String> _selectedOptions = {};

  @override
  void initState() {
    super.initState();
    loadQuestions();
  }

  Future<void> loadQuestions() async {
    List<dynamic> combinedQuestions = [];

    for (String fileName in widget.fileNames) {
      final String response = await rootBundle.loadString('assets/$fileName');
      final data = await json.decode(response);

      data.forEach((key, value) {
        combinedQuestions.addAll(value as List<dynamic>);
      });
    }

    // Éliminer les doublons en utilisant les identifiants uniques
    final Map<int, dynamic> uniqueQuestionsMap = {};
    for (var question in combinedQuestions) {
      uniqueQuestionsMap[question['id']] = question;
    }
    final uniqueQuestions = uniqueQuestionsMap.values.toList();

    setState(() {
      uniqueQuestions.shuffle();
      questions = uniqueQuestions.take(10).toList();
    });
  }

  void checkAnswer(String selectedAnswer) {
    final correctAnswer = questions[currentQuestionIndex]['correctAnswer'];
    final bool isCorrect;

    if (correctAnswer is List) {
      final acceptedAnswers = List<String>.from(correctAnswer);
      isCorrect = acceptedAnswers.contains(selectedAnswer);
    } else {
      isCorrect = selectedAnswer == correctAnswer;
    }

    if (isCorrect) {
      score++;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Bonne réponse!'),
          duration: Duration(seconds: 1),
        ),
      );
    } else {
      final String answerText = correctAnswer is List
          ? List<String>.from(correctAnswer).join(' | ')
          : correctAnswer.toString();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Mauvaise réponse. La bonne réponse est : $answerText'),
          duration: const Duration(seconds: 2),
        ),
      );
    }

    _goToNextQuestion();
  }

  void checkMultipleAnswers() {
    final correctAnswer = questions[currentQuestionIndex]['correctAnswer'];
    final acceptedAnswers = List<String>.from(correctAnswer as List);
    final selected = _selectedOptions.toSet();

    final bool isCorrect = selected.length == acceptedAnswers.length &&
        selected.containsAll(acceptedAnswers);

    if (isCorrect) {
      score++;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Bonne réponse!'),
          duration: Duration(seconds: 1),
        ),
      );
    } else {
      final String answerText = acceptedAnswers.join(' | ');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Mauvaise réponse. Les bonnes réponses sont : $answerText'),
          duration: const Duration(seconds: 2),
        ),
      );
    }

    _goToNextQuestion();
  }

  void _goToNextQuestion() {
    if (currentQuestionIndex < questions.length - 1) {
      setState(() {
        currentQuestionIndex++;
        _selectedOptions.clear();
      });
    } else {
      setState(() {
        isGameOver = true;
        _selectedOptions.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final bool isModuleBQuiz = widget.fileNames
        .any((name) => name.startsWith('questions_module_b_'));

    final double questionFontSize = screenWidth > 800
        ? 26
        : screenWidth > 600
            ? 22
            : 20;

    final double optionFontSize = screenWidth > 800
        ? 20
        : screenWidth > 600
            ? 18
            : 16;

    if (isGameOver) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                score >= 8 ? 'Vous avez gagné !' : 'Vous avez perdu.',
                style: TextStyle(
                    fontSize: questionFontSize, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Text(
                'Votre score: $score/10',
                style: TextStyle(fontSize: optionFontSize),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const HomeScreen()),
                  );
                },
                child: Text('Recommencer',
                    style: TextStyle(fontSize: optionFontSize)),
              ),
            ],
          ),
        ),
      );
    } else if (questions.isEmpty) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else {
      final currentQuestion = questions[currentQuestionIndex];
      final List<String> options =
          List<String>.from(currentQuestion['options']);
      final bool isMultipleChoice = isModuleBQuiz ||
          (currentQuestion['correctAnswer'] is List &&
              (currentQuestion['correctAnswer'] as List).length > 1);

      return Scaffold(
        appBar: AppBar(
          title: Text('Question ${currentQuestionIndex + 1}/10'),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (currentQuestion['image'] != null)
                Center(
                    child: Image.asset(currentQuestion['image'])),
              const SizedBox(height: 20),
              Center(
                child: Text(
                  currentQuestion['question'],
                  style: TextStyle(
                      fontSize: questionFontSize, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 20),
              if (isMultipleChoice)
                Text(
                  'Sélectionnez votre/vos réponse(s), puis validez.',
                  style: TextStyle(
                    fontSize: optionFontSize - 2,
                    color: Colors.grey[700],
                  ),
                  textAlign: TextAlign.center,
                ),
              if (isMultipleChoice) const SizedBox(height: 8),
              ...options.map<Widget>((option) {
                if (isMultipleChoice) {
                  return CheckboxListTile(
                    value: _selectedOptions.contains(option),
                    title: Text(
                      option,
                      style: TextStyle(fontSize: optionFontSize),
                    ),
                    controlAffinity: ListTileControlAffinity.leading,
                    onChanged: (checked) {
                      setState(() {
                        if (checked ?? false) {
                          _selectedOptions.add(option);
                        } else {
                          _selectedOptions.remove(option);
                        }
                      });
                    },
                  );
                }

                return Center(
                  child: ListTile(
                    title: Text(
                      option,
                      style: TextStyle(fontSize: optionFontSize),
                      textAlign: TextAlign.center,
                    ),
                    onTap: () => checkAnswer(option),
                  ),
                );
              }),
              if (isMultipleChoice) ...[
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed:
                        _selectedOptions.isEmpty ? null : checkMultipleAnswers,
                    child: const Text('Valider mes réponses'),
                  ),
                ),
              ],
            ],
          ),
        ),
      );
    }
  }
}
