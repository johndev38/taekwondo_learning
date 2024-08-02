import 'package:flutter/material.dart';
import 'belt_selection_for_learning_screen.dart';
import 'video_list_screen.dart';
import 'belt_selection_screen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // L'image en haut
          Expanded(
            flex: 2,
            child: Container(
              width: double.infinity,
              child: Image.asset(
                'assets/images/background.jpg',
                fit: BoxFit.cover,
              ),
            ),
          ),
          // La section avec fond gris contenant les boutons
          Expanded(
            flex: 2,
            child: Container(
              color: Colors.black, // Fond gris clair derrière les boutons
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Card(
                    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    elevation: 5,
                    color: Colors.white, // Fond blanc pour la carte (bouton)
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: ListTile(
                      leading: Icon(Icons.video_library, color: Colors.red), // Icône rouge
                      title: Text(
                        'Regarder les vidéos',
                        style: TextStyle(color: Colors.black),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => VideoListScreen()),
                        );
                      },
                    ),
                  ),
                  Card(
                    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    elevation: 5,
                    color: Colors.white, // Fond blanc pour la carte (bouton)
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: ListTile(
                      leading: Icon(Icons.school, color: Colors.green), // Icône verte
                      title: Text(
                        'Apprendre',
                        style: TextStyle(color: Colors.black),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => BeltSelectionForLeaningScreen()),
                        );
                      },
                    ),
                  ),
                  Card(
                    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    elevation: 5,
                    color: Colors.white, // Fond blanc pour la carte (bouton)
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: ListTile(
                      leading: Icon(Icons.quiz, color: Colors.blue), // Icône bleue
                      title: Text(
                        'Passer les QCM',
                        style: TextStyle(color: Colors.black),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => BeltSelectionScreen()),
                        );
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
