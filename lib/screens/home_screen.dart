import 'package:flutter/material.dart';
import 'package:taekwondo_knowledge/screens/rules_screen.dart';
import 'belt_selection_for_learning_screen.dart';
import 'video_list_screen.dart';
import 'belt_selection_screen.dart';
import 'history_screen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea( // Ajout de SafeArea pour éviter les chevauchements avec la barre de statut
        child: Column(
          children: [
            // Partie supérieure avec l'image de fond
            Expanded(
              flex: 2,
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/background_poster.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Center(
                    child: Text(
                      'Taekwondo learning',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Section des onglets avec coins arrondis
            Expanded(
              flex: 3,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
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
                  children: [
                    _buildListTile(
                      context,
                      icon: Icons.directions_run,
                      iconColor: Colors.red,
                      text: 'Poomse',
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
                      icon: Icons.school,
                      iconColor: Colors.green,
                      text: 'Kibon',
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
        required VoidCallback onTap}) {
    return Card(
      elevation: 4.0,
      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: ListTile(
        leading: CircleAvatar(
          radius: 25,
          backgroundColor: iconColor.withOpacity(0.2),
          child: Icon(icon, color: iconColor, size: 25),
        ),
        title: Text(
          text,
          style: TextStyle(
            fontSize: 18,
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
