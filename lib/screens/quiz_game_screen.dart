import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'home_screen.dart';

class QuizGameScreen extends StatefulWidget {
  final String belt;
  final List<String> fileNames;

  const QuizGameScreen({Key? key, required this.belt, required this.fileNames})
      : super(key: key);

  @override
  QuizGameScreenState createState() => QuizGameScreenState();
}

class QuizGameScreenState extends State<QuizGameScreen> {
  List<dynamic> questions = [];
  int currentQuestionIndex = 0;
  int score = 0;
  bool isGameOver = false;

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

    if (selectedAnswer == correctAnswer) {
      score++;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Bonne réponse!'),
          duration: Duration(seconds: 1),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text('Mauvaise réponse. La bonne réponse est : $correctAnswer'),
          duration: const Duration(seconds: 2),
        ),
      );
    }

    if (currentQuestionIndex < questions.length - 1) {
      setState(() {
        currentQuestionIndex++;
      });
    } else {
      setState(() {
        isGameOver = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

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
                    MaterialPageRoute(builder: (context) => HomeScreen()),
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
      final List<String> options =
          List<String>.from(questions[currentQuestionIndex]['options']);
      options.shuffle();

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
              if (questions[currentQuestionIndex]['image'] != null)
                Center(
                    child:
                        Image.asset(questions[currentQuestionIndex]['image'])),
              const SizedBox(height: 20),
              Center(
                child: Text(
                  questions[currentQuestionIndex]['question'],
                  style: TextStyle(
                      fontSize: questionFontSize, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 20),
              ...options.map<Widget>(
                (option) => Center(
                  child: ListTile(
                    title: Text(
                      option,
                      style: TextStyle(fontSize: optionFontSize),
                      textAlign: TextAlign.center,
                    ),
                    onTap: () => checkAnswer(option),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }
  }
}
