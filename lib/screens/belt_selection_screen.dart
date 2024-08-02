import 'package:flutter/material.dart';
import 'quiz_game_screen.dart';

class BeltSelectionScreen extends StatelessWidget {
  final List<String> belts = [
    'Jaune (9e keup)',
    'Jaune 1ère barrette (8e keup)',
    'Jaune 2ème barrette (7e keup)',
    'Bleu (6e keup)',
    'Bleu 1ère barrette (5e keup)',
    'Bleu 2ème barrette (4e keup)',
    'Rouge (3e keup)',
    'Rouge 1ère barrette (2e keup)',
    'Noire (1e keup)',
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
            title: Text('Ceinture ${belts[index]}'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => QuizGameScreen(belt: belts[index], belts: belts),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
