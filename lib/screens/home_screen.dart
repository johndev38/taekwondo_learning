import 'package:flutter/material.dart';
import 'package:taekwondo_knowledge/screens/hanban_list_screen.dart';
import 'package:taekwondo_knowledge/screens/rules_screen.dart';
import 'belt_selection_for_learning_screen.dart';
import 'video_list_screen.dart';
import 'belt_selection_screen.dart';
import 'history_screen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Récupération des dimensions de l’écran
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    // Définition des hauteurs dynamiques pour l’image de fond
    final topImageHeight = screenHeight * 0.25; // 25% de la hauteur de l'écran
    final itemFontSize = screenWidth * 0.045; // Taille de police relative à la largeur

    // Taille des icônes ajustée selon les dimensions de l'écran
    double iconSize;
    if (screenWidth > 800) {
      iconSize = screenWidth * 0.05; // Petite taille pour les écrans de grande taille (tablettes 10 pouces)
    } else if (screenWidth > 600) {
      iconSize = screenWidth * 0.06; // Taille moyenne pour tablettes 7-8 pouces
    } else {
      iconSize = screenWidth * 0.07; // Taille normale pour petits écrans
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Partie supérieure avec l'image de fond
            Container(
              height: topImageHeight, // Hauteur de l'image ajustée
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/background_poster.png'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Center(
                child: Text(
                  'Taekwondo learning',
                  style: TextStyle(
                    fontSize: screenWidth * 0.06, // Taille de police adaptative
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            // Section des onglets avec coins arrondis
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.03,
                  vertical: screenHeight * 0.02,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      offset: Offset(0, -5),
                    ),
                  ],
                ),
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    _buildListTile(
                      context,
                      icon: Icons.directions_run,
                      iconColor: Colors.red,
                      text: 'Poomse',
                      fontSize: itemFontSize,
                      iconSize: iconSize,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => VideoListScreen()),
                        );
                      },
                    ),
                    _buildListTile(
                      context,
                      icon: Icons.directions_run,
                      iconColor: Colors.pinkAccent,
                      text: 'HANBON KYEUROGUI',
                      fontSize: itemFontSize,
                      iconSize: iconSize,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => HanbanListScreen()),
                        );
                      },
                    ),
                    _buildListTile(
                      context,
                      icon: Icons.school,
                      iconColor: Colors.green,
                      text: 'Kibon',
                      fontSize: itemFontSize,
                      iconSize: iconSize,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  BeltSelectionForLeaningScreen()),
                        );
                      },
                    ),
                    _buildListTile(
                      context,
                      icon: Icons.history_edu,
                      iconColor: Colors.orange,
                      text: 'Histoire du Taekwondo',
                      fontSize: itemFontSize,
                      iconSize: iconSize,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => TaekwondoHistoryScreen()),
                        );
                      },
                    ),
                    _buildListTile(
                      context,
                      icon: Icons.gavel,
                      iconColor: Colors.brown,
                      text: 'Arbitrage',
                      fontSize: itemFontSize,
                      iconSize: iconSize,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => TaekwondoRulesScreen()),
                        );
                      },
                    ),
                    _buildListTile(
                      context,
                      icon: Icons.quiz,
                      iconColor: Colors.blue,
                      text: 'QCM',
                      fontSize: itemFontSize,
                      iconSize: iconSize,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => BeltSelectionScreen()),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListTile(BuildContext context,
      {required IconData icon,
        required Color iconColor,
        required String text,
        required double fontSize,
        required double iconSize,
        required VoidCallback onTap}) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Card(
      elevation: 4.0,
      margin: EdgeInsets.symmetric(
        vertical: screenWidth * 0.015, // Marges verticales adaptatives
        horizontal: screenWidth * 0.04, // Marges horizontales adaptatives
      ),
      child: ListTile(
        leading: CircleAvatar(
          radius: iconSize, // Taille de l’icône adaptative
          backgroundColor: iconColor.withOpacity(0.2),
          child: Icon(icon, color: iconColor, size: iconSize),
        ),
        title: Text(
          text,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        trailing: Icon(Icons.arrow_forward_ios, color: Colors.black87),
        onTap: onTap,
      ),
    );
  }
}
