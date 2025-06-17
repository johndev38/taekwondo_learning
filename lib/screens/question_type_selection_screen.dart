import 'package:flutter/material.dart';
import 'quiz_game_screen.dart';

class QuestionTypeSelectionScreen extends StatelessWidget {
  final String belt;
  final int beltIndex;
  final List<Map<String, String>> belts;

  const QuestionTypeSelectionScreen({
    Key? key,
    required this.belt,
    required this.beltIndex,
    required this.belts,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: Text('Type de Questions'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Sélectionnez le type de questions que vous voulez :',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                // Questions uniquement pour la ceinture sélectionnée
                List<String> selectedFiles = [];
                selectedFiles.add(belts[beltIndex]['file']!);

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => QuizGameScreen(
                      belt: belt,
                      fileNames: selectedFiles,
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
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 16.0, horizontal: 12.0),
                  child: Center(
                    child: Text(
                      'Questions uniquement pour la ceinture sélectionnée',
                      style: TextStyle(
                        fontSize: screenWidth > 600 ? 18 : 16,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                // Questions mélangées entre la ceinture blanche et la ceinture sélectionnée
                List<String> selectedFiles = [];
                for (int i = 0; i <= beltIndex; i++) {
                  selectedFiles.add(belts[i]['file']!);
                }

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => QuizGameScreen(
                      belt: belt,
                      fileNames: selectedFiles,
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
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 16.0, horizontal: 12.0),
                  child: Center(
                    child: Text(
                      'Questions mélangées entre la ceinture blanche et la ceinture sélectionnée',
                      style: TextStyle(
                        fontSize: screenWidth > 600 ? 18 : 16,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
