import 'package:flutter/material.dart';
import 'quiz_game_screen.dart';

class BeltSelectionScreen extends StatelessWidget {
  final List<Map<String, String>> belts = [
    {'name': 'Jaune (9e keup)', 'file': 'questions_jaune.json'},
    {'name': 'Jaune 1ère barrette (8e keup)', 'file': 'questions_jaune_barrette1.json'},
    {'name': 'Jaune 2ème barrette (7e keup)', 'file': 'questions_jaune_barrette2.json'},
    {'name': 'Bleu (6e keup)', 'file': 'questions_bleu.json'},
    {'name': 'Bleu 1ère barrette (5e keup)', 'file': 'questions_bleu_barrette1.json'},
    {'name': 'Bleu 2ème barrette (4e keup)', 'file': 'questions_bleu_barrette2.json'},
    {'name': 'Rouge (3e keup)', 'file': 'questions_rouge.json'},
    {'name': 'Rouge 1ère barrette (2e keup)', 'file': 'questions_rouge_barrette1.json'},
    {'name': 'Noire (1e keup)', 'file': 'questions_noire.json'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sélectionner la ceinture'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        itemCount: belts.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('Ceinture ${belts[index]['name']}'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => QuizGameScreen(
                    belt: belts[index]['name']!,
                    fileName: belts[index]['file']!,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
