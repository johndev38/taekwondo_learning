import 'package:flutter/material.dart';

import 'question_type_selection_screen.dart';

class BeltSelectionScreen extends StatelessWidget {
  final List<Map<String, String>> belts = [
    {'name': 'Jaune (9e keup)', 'file': 'questions_jaune.json'},
    {
      'name': 'Jaune 1ère barrette (8e keup)',
      'file': 'questions_jaune_barrette1.json'
    },
    {
      'name': 'Jaune 2ème barrette (7e keup)',
      'file': 'questions_jaune_barrette2.json'
    },
    {'name': 'Bleu (6e keup)', 'file': 'questions_bleu.json'},
    {
      'name': 'Bleu 1ère barrette (5e keup)',
      'file': 'questions_bleu_barrette1.json'
    },
    {
      'name': 'Bleu 2ème barrette (4e keup)',
      'file': 'questions_bleu_barrette2.json'
    },
    {'name': 'Rouge (3e keup)', 'file': 'questions_rouge.json'},
    {
      'name': 'Rouge 1ère barrette (2e keup)',
      'file': 'questions_rouge_barrette1.json'
    },
    {'name': 'Noire (1e keup)', 'file': 'questions_noire.json'},
  ];

  BeltSelectionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sélectionner la ceinture'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: screenWidth > 600 ? 2 : 1,
            childAspectRatio: 5,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemCount: belts.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                // Naviguer vers le nouvel écran de sélection du type de questions
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => QuestionTypeSelectionScreen(
                      belt: belts[index]['name']!,
                      beltIndex: index,
                      belts: belts,
                    ),
                  ),
                );
              },
              child: Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                color: Colors.grey[50],
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 16.0),
                    child: Text(
                      belts[index]['name']!,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
