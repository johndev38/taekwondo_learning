import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BeltNotifier with ChangeNotifier {
  final String key = "current_belt";
  SharedPreferences? _prefs;
  String? _currentBelt;

  String? get currentBelt => _currentBelt;

  // Liste des ceintures disponibles (vous pouvez la charger depuis une autre source si nécessaire)
  final List<String> belts = [
    'Jaune (9e keup)',
    'Jaune 1ère barrette (8e keup)',
    'Jaune 2ème barrette (7e keup)',
    'Bleu (6e keup)',
    'Bleu 1ère barrette (5e keup)',
    'Bleu 2ème barrette (4e keup)',
    'Rouge (3e keup)',
    'Rouge 1ère barrette (2e keup)',
    'Rouge 2ème barrette (1e keup)',
    'Noire 1er Dan'
  ];

  BeltNotifier() {
    _loadCurrentBelt();
  }

  Future<void> setCurrentBelt(String belt) async {
    _currentBelt = belt;
    await _saveCurrentBelt();
    notifyListeners();
  }

  Future<void> _initPrefs() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  Future<void> _loadCurrentBelt() async {
    await _initPrefs();
    _currentBelt = _prefs!.getString(key);

    // Vérifier si la ceinture stockée existe dans la liste actuelle
    if (_currentBelt != null && !belts.contains(_currentBelt)) {
      print(
          'Ceinture stockée "$_currentBelt" non trouvée dans la liste des ceintures disponibles');
      _currentBelt = null; // Réinitialiser si la valeur n'est pas valide
    }

    // Si aucune ceinture n'est sauvegardée ou la valeur n'est pas valide, on définit une valeur par défaut
    if (_currentBelt == null && belts.isNotEmpty) {
      _currentBelt = belts.first;
      await _saveCurrentBelt();
    }
    notifyListeners();
  }

  Future<void> _saveCurrentBelt() async {
    await _initPrefs();
    if (_currentBelt != null) {
      _prefs!.setString(key, _currentBelt!);
    }
  }

  // Méthode pour réinitialiser la ceinture actuelle
  Future<void> resetCurrentBelt() async {
    await _initPrefs();
    await _prefs!.remove(key);
    _currentBelt = belts.isNotEmpty ? belts.first : null;
    if (_currentBelt != null) {
      await _saveCurrentBelt();
    }
    notifyListeners();
  }
}
