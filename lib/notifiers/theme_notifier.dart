import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeNotifier with ChangeNotifier {
  final String key = "theme";
  SharedPreferences? _prefs;
  bool _darkTheme;

  bool get darkTheme => _darkTheme;

  ThemeNotifier() : _darkTheme = false {
    _loadFromPrefs();
  }

  void toggleTheme() {
    _darkTheme = !_darkTheme;
    _saveToPrefs();
    notifyListeners();
  }

  Future<void> _initPrefs() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  Future<void> _loadFromPrefs() async {
    await _initPrefs();
    _darkTheme = _prefs!.getBool(key) ?? false;
    notifyListeners();
  }

  Future<void> _saveToPrefs() async {
    await _initPrefs();
    _prefs!.setBool(key, _darkTheme);
  }
}

// ─── Couleurs de marque (identiques en light/dark) ───────────────
const Color kBrandNavy = Color(0xFF0A1628);
const Color kBrandRed = Color(0xFFCC1122);

// ─── Thème clair ─────────────────────────────────────────────────
final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  useMaterial3: true,
  scaffoldBackgroundColor: const Color(0xFFF0F2F5),
  cardColor: Colors.white,
  dividerColor: const Color(0xFFE0E4EA),
  colorScheme: const ColorScheme.light(
    primary: kBrandNavy,
    secondary: kBrandRed,
    surface: Colors.white,
    onSurface: Color(0xFF1A2340),
    surfaceContainerHighest: Color(0xFFF0F2F5),
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: kBrandNavy,
    foregroundColor: Colors.white,
    elevation: 0,
  ),
  listTileTheme: const ListTileThemeData(
    tileColor: Colors.white,
  ),
  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: Color(0xFF1A2340)),
    bodyMedium: TextStyle(color: Color(0xFF37474F)),
    titleMedium: TextStyle(color: Color(0xFF1A2340)),
  ),
);

// ─── Thème sombre ────────────────────────────────────────────────
final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  useMaterial3: true,
  scaffoldBackgroundColor: const Color(0xFF121218),
  cardColor: const Color(0xFF1E1E24),
  dividerColor: const Color(0xFF2A2A32),
  colorScheme: const ColorScheme.dark(
    primary: Color(0xFF1565C0),
    secondary: kBrandRed,
    surface: Color(0xFF1E1E24),
    onSurface: Color(0xFFE4E6EB),
    surfaceContainerHighest: Color(0xFF2A2A32),
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: kBrandNavy,
    foregroundColor: Colors.white,
    elevation: 0,
  ),
  listTileTheme: const ListTileThemeData(
    tileColor: Color(0xFF1E1E24),
  ),
  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: Color(0xFFE4E6EB)),
    bodyMedium: TextStyle(color: Color(0xFFB0B3B8)),
    titleMedium: TextStyle(color: Color(0xFFE4E6EB)),
  ),
);
