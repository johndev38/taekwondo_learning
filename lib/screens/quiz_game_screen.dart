import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'home_screen.dart';

class QuizGameScreen extends StatefulWidget {
  final String belt;
  final List<String> belts;

  QuizGameScreen({required this.belt, required this.belts});

  @override
  _QuizGameScreenState createState() => _QuizGameScreenState();
}

class _QuizGameScreenState extends State<QuizGameScreen> {
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
    final String response = await rootBundle.loadString('assets/questions.json');
    final data = await json.decode(response);

    setState(() {
      List<dynamic> combinedQuestions = [];
      bool includeQuestions = true;

      for (String belt in widget.belts) {
        if (belt == widget.belt) {
          includeQuestions = true;
        }

        if (includeQuestions) {
          combinedQuestions.addAll(data[belt]);
        }

        if (belt == widget.belt) {
          break;
        }
      }

      combinedQuestions.shuffle();
      questions = combinedQuestions.take(10).toList();

      if (questions.length < 10) {
        throw Exception("Not enough questions for the selected belt and its predecessors in the JSON file.");
      }
    });
  }

  void checkAnswer(String selectedAnswer) {
    final correctAnswer = questions[currentQuestionIndex]['correctAnswer'];

    if (selectedAnswer == correctAnswer) {
      score++;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Bonne réponse!'),
          duration: Duration(seconds: 1),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Mauvaise réponse. La bonne réponse est : $correctAnswer'),
          duration: Duration(seconds: 2),
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
    if (isGameOver) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                score >= 8 ? 'Vous avez gagné !' : 'Vous avez perdu.',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              Text(
                'Votre score: $score/10',
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => HomeScreen()),
                  );
                },
                child: Text('Recommencer'),
              ),
            ],
          ),
        ),
      );
    } else if (questions.isEmpty) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else {
      // Shuffle options for the current question
      final List<String> options = List<String>.from(questions[currentQuestionIndex]['options']);
      options.shuffle();

      return Scaffold(
        appBar: AppBar(
          title: Text('Question ${currentQuestionIndex + 1}/10'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (questions[currentQuestionIndex]['image'] != null)
                Image.asset(questions[currentQuestionIndex]['image']),
              SizedBox(height: 20),
              Text(
                questions[currentQuestionIndex]['question'],
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              ...options
                  .map<Widget>(
                    (option) => ListTile(
                  title: Text(option),
                  onTap: () => checkAnswer(option),
                ),
              )
                  .toList(),
            ],
          ),
        ),
      );
    }
  }
}
