import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taekwondo_knowledge/notifiers/belt_notifier.dart';
import 'package:taekwondo_knowledge/notifiers/theme_notifier.dart';
import 'package:taekwondo_knowledge/screens/hanban_list_screen.dart';
import 'package:taekwondo_knowledge/screens/rules_screen.dart';
import 'package:taekwondo_knowledge/screens/belt_requirements_screen.dart';
import 'belt_selection_for_learning_screen.dart';
import 'video_list_screen.dart';
import 'belt_selection_screen.dart';
import 'history_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    final beltNotifier = Provider.of<BeltNotifier>(context);

    // Récupération des dimensions de l'écran
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    // Définition des hauteurs dynamiques pour l'image de fond
    final topImageHeight = screenHeight * 0.25; // 25% de la hauteur de l'écran
    final itemFontSize =
        screenWidth * 0.045; // Taille de police relative à la largeur

    // Taille des icônes ajustée selon les dimensions de l'écran
    double iconSize;
    if (screenWidth > 800) {
      iconSize = screenWidth * 0.05;
    } else if (screenWidth > 600) {
      iconSize = screenWidth * 0.06;
    } else {
      iconSize = screenWidth * 0.07;
    }

    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Profil & Thème'),
      //   actions: [
      //     IconButton(
      //       icon: Icon(themeNotifier.darkTheme ? Icons.wb_sunny : Icons.nightlight_round),
      //       onPressed: () {
      //         themeNotifier.toggleTheme();
      //       },
      //     ),
      //   ],
      // ),
      // Retrait de backgroundColor: Colors.white, pour utiliser le thème
      body: SafeArea(
        child: Column(
          children: [
            // Partie supérieure avec l'image de fond et sélecteur de ceinture + switch de thème
            Container(
              height: topImageHeight, // Hauteur de l'image ajustée
              padding: EdgeInsets.all(screenWidth * 0.03),
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/background_poster.png'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      DropdownButton<String>(
                        value: beltNotifier.currentBelt,
                        hint: const Text("Ceinture",
                            style: TextStyle(color: Colors.white70)),
                        dropdownColor: Colors.black87,
                        icon: const Icon(Icons.arrow_drop_down,
                            color: Colors.white),
                        style: TextStyle(
                            color: Colors.white, fontSize: itemFontSize * 0.8),
                        underline: Container(
                          height: 2,
                          color: Colors.white70,
                        ),
                        items: beltNotifier.belts
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          if (newValue != null) {
                            beltNotifier.setCurrentBelt(newValue);
                          }
                        },
                      ),
                      Row(
                        children: [
                          Text(themeNotifier.darkTheme ? "Clair" : "Sombre",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: itemFontSize * 0.8)),
                          Switch(
                            value: themeNotifier.darkTheme,
                            onChanged: (value) {
                              themeNotifier.toggleTheme();
                            },
                            activeTrackColor: Colors.white70,
                            activeColor: Colors.blueAccent,
                          ),
                        ],
                      ),
                    ],
                  ),
                  Text(
                    'Taekwondo learning',
                    style: TextStyle(
                      fontSize:
                          screenWidth * 0.06, // Taille de police adaptative
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          blurRadius: 10.0,
                          color: Colors.black.withOpacity(0.5),
                          offset: const Offset(2.0, 2.0),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Section des onglets avec coins arrondis
            Expanded(
              child: Container(
                // Retrait de la couleur fixe pour utiliser celle du thème
                // decoration: BoxDecoration(
                //   color: Colors.white, <- Supprimé
                // ...
                // ),
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.03,
                  vertical: screenHeight * 0.02,
                ),
                decoration: BoxDecoration(
                  // Utilise la couleur de fond du thème actuel
                  color: Theme.of(context).scaffoldBackgroundColor,
                  boxShadow: const [
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
                    _buildListTile(
                      context,
                      icon: Icons.emoji_events,
                      iconColor: Colors.amber,
                      text: 'Passage de Ceinture',
                      fontSize: itemFontSize,
                      iconSize: iconSize,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const BeltRequirementsScreen()),
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
      // Amélioration du feedback visuel avec InkWell pour l'effet "ripple"
      child: InkWell(
        onTap: onTap,
        splashColor: iconColor.withOpacity(0.3), // Couleur de l'effet ripple
        highlightColor:
            iconColor.withOpacity(0.1), // Couleur au survol/appui long
        child: ListTile(
          leading: CircleAvatar(
            radius: iconSize, // Taille de l'icône adaptative
            backgroundColor: iconColor.withOpacity(0.2),
            child: Icon(icon, color: iconColor, size: iconSize),
          ),
          title: Text(
            text,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.w600,
              // La couleur du texte s'adaptera au thème (clair/sombre)
              // color: Colors.black87, // <- Supprimé pour utiliser la couleur par défaut du thème
            ),
          ),
          trailing: const Icon(
            Icons.arrow_forward_ios,
            // La couleur de l'icône s'adaptera également
            // color: Colors.black87 // <- Supprimé
          ),
          // onTap: onTap, // Déplacé vers InkWell
        ),
      ),
    );
  }
}
