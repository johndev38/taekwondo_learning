import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'home_screen.dart';

class QuizGameScreen extends StatefulWidget {
  final String belt;
  final String fileName;

  QuizGameScreen({required this.belt, required this.fileName});

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
    final String response = await rootBundle.loadString('assets/${widget.fileName}');
    final data = await json.decode(response);

    setState(() {
      questions = data['questions'];
      questions.shuffle();  // Mélange les questions
      if (questions.length > 10) {
        questions = questions.take(10).toList();  // Limite à 10 questions
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
              ...options.map<Widget>(
                    (option) => ListTile(
                  title: Text(option),
                  onTap: () => checkAnswer(option),
                ),
              ).toList(),
            ],
          ),
        ),
      );
    }
  }
}
