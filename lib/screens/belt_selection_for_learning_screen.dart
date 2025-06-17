import 'package:flutter/material.dart';
import 'term_learning_screen.dart';

class BeltSelectionForLeaningScreen extends StatelessWidget {
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

  BeltSelectionForLeaningScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    // Taille de police adaptée pour les grands écrans
    final double titleFontSize = screenWidth > 800
        ? 18
        : screenWidth > 600
            ? 16
            : 14; // Police légèrement réduite pour les cartes compactes

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
            childAspectRatio: 5, // Ratio élevé pour réduire la hauteur
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: belts.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TermLearningScreen(
                      belt: belts[index],
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
                      belts[index],
                      style: TextStyle(
                        fontSize: titleFontSize,
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
