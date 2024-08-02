import 'package:flutter/material.dart';
import 'screens/home_screen.dart'; // Importation du fichier où HomeScreen est défini

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Taekwondo QCM App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: HomeScreen(), // Référence à HomeScreen
    );
  }
}
