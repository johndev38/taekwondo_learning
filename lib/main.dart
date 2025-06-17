import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taekwondo_knowledge/notifiers/belt_notifier.dart';
import 'package:taekwondo_knowledge/notifiers/theme_notifier.dart';
import 'screens/home_screen.dart'; // Importation du fichier où HomeScreen est défini

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ThemeNotifier>(create: (_) => ThemeNotifier()),
        ChangeNotifierProvider<BeltNotifier>(create: (_) => BeltNotifier()),
      ],
      child: Consumer<ThemeNotifier>(
        builder: (context, themeNotifier, child) {
          return MaterialApp(
            title: 'Taekwondo Knowledge',
            theme: themeNotifier.darkTheme ? darkTheme : lightTheme,
            darkTheme:
                darkTheme, // Optionnel : définir explicitement le thème sombre
            themeMode:
                themeNotifier.darkTheme ? ThemeMode.dark : ThemeMode.light,
            debugShowCheckedModeBanner: false,
            home: const HomeScreen(), // Référence à HomeScreen
          );
        },
      ),
    );
  }
}
