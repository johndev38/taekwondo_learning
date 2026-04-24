import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:taekwondo_knowledge/notifiers/belt_notifier.dart';
import 'package:taekwondo_knowledge/notifiers/progress_notifier.dart';
import 'package:taekwondo_knowledge/notifiers/theme_notifier.dart';
import 'screens/app_shell.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Active l'affichage bord à bord (requis pour les applis ciblant le SDK 35
  // sur Android 15) et rend les barres système transparentes afin que
  // Flutter gère lui-même le rendu sous les encarts système.
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.light,
      systemNavigationBarContrastEnforced: false,
    ),
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ThemeNotifier>(create: (_) => ThemeNotifier()),
        ChangeNotifierProvider<BeltNotifier>(create: (_) => BeltNotifier()),
        ChangeNotifierProvider<ProgressNotifier>(
          create: (_) => ProgressNotifier()..init(),
        ),
      ],
      child: Consumer<ThemeNotifier>(
        builder: (context, themeNotifier, child) {
          return MaterialApp(
            title: 'Taekwondo Knowledge',
            theme: themeNotifier.darkTheme ? darkTheme : lightTheme,
            darkTheme: darkTheme,
            themeMode:
                themeNotifier.darkTheme ? ThemeMode.dark : ThemeMode.light,
            debugShowCheckedModeBanner: false,
            home: const AppShell(),
          );
        },
      ),
    );
  }
}
