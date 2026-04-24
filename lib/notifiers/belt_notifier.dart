import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BeltNotifier with ChangeNotifier {
  final String key = "current_belt";
  SharedPreferences? _prefs;
  String? _currentBelt;

  String? get currentBelt => _currentBelt;

  // Liste des ceintures disponibles (vous pouvez la charger depuis une autre source si nécessaire)
  final List<String> belts = [
    'Blanche (10e keup)',
    'Jaune (9e keup)',
    'Jaune 1ère barrette (8e keup)',
    'Jaune 2ème barrette (7e keup)',
    'Bleu (6e keup)',
    'Bleu 1ère barrette (5e keup)',
    'Bleu 2ème barrette (4e keup)',
    'Rouge (3e keup)',
    'Rouge 1ère barrette (2e keup)',
    'Rouge 2ème barrette (1e keup)',
    'Noire',
  ];

  BeltNotifier() {
    _loadCurrentBelt();
  }

  Future<void> setCurrentBelt(String belt) async {
    if (belts.contains(belt)) {
      _currentBelt = belt;
      await _saveCurrentBelt();
    }
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
      debugPrint(
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

  // Méthode pour obtenir le poomsae correspondant à la ceinture
  String? getPoomsaeForBelt(String? belt) {
    if (belt == null) return null;

    final Map<String, String> beltToPoomsae = {
      'Blanche (10e keup)': 'TAEGEUK1JANG',
      'Jaune (9e keup)': 'TAEGEUK1JANG',
      'Jaune 1ère barrette (8e keup)': 'TAEGEUK2JANG',
      'Jaune 2ème barrette (7e keup)': 'TAEGEUK3JANG',
      'Bleu (6e keup)': 'TAEGEUK4JANG',
      'Bleu 1ère barrette (5e keup)': 'TAEGEUK5JANG',
      'Bleu 2ème barrette (4e keup)': 'TAEGEUK6JANG',
      'Rouge (3e keup)': 'TAEGEUK7JANG',
      'Rouge 1ère barrette (2e keup)': 'TAEGEUK8JANG',
      'Rouge 2ème barrette (1e keup)': 'KORYO',
      'Noire': 'KORYO',
    };

    return beltToPoomsae[belt];
  }

  // Méthode pour obtenir le niveau hanbon correspondant à la ceinture
  String? getHanbonForBelt(String? belt) {
    if (belt == null) return null;

    if (belt.contains('Jaune')) {
      return 'Ceinture jaune';
    } else if (belt.contains('Bleu')) {
      return 'Ceinture bleu';
    } else if (belt.contains('Rouge') || belt.contains('Noire')) {
      return 'Ceinture rouge';
    }

    return null;
  }

  // Méthode pour obtenir le niveau kibon correspondant à la ceinture
  String? getKibonForBelt(String? belt) {
    if (belt == null) return null;

    final Map<String, String> beltToKibon = {
      'Blanche (10e keup)': 'Jaune (9e keup)',
      'Jaune (9e keup)': 'Jaune (9e keup)',
      'Jaune 1ère barrette (8e keup)': 'Jaune 1ère barrette (8e keup)',
      'Jaune 2ème barrette (7e keup)': 'Jaune 2ème barrette (7e keup)',
      'Bleu (6e keup)': 'Bleu (6e keup)',
      'Bleu 1ère barrette (5e keup)': 'Bleu 1ère barrette (5e keup)',
      'Bleu 2ème barrette (4e keup)': 'Bleu 2ème barrette (4e keup)',
      'Rouge (3e keup)': 'Rouge (3e keup)',
      'Rouge 1ère barrette (2e keup)': 'Rouge 1ère barrette (2e keup)',
      'Rouge 2ème barrette (1e keup)': 'Noire (1e keup)',
      'Noire': 'Noire (1e keup)',
    };

    return beltToKibon[belt];
  }

  // Méthode pour obtenir la progression de ceinture correspondante pour les exigences
  String? getBeltTransitionKey(String? belt) {
    if (belt == null) return null;

    final Map<String, String> beltToTransition = {
      'Blanche (10e keup)': '10_to_9_keup',
      'Jaune (9e keup)': '9_to_8_keup',
      'Jaune 1ère barrette (8e keup)': '8_to_7_keup',
      'Jaune 2ème barrette (7e keup)': '7_to_6_keup',
      'Bleu (6e keup)': '6_to_5_keup',
      'Bleu 1ère barrette (5e keup)': '5_to_4_keup',
      'Bleu 2ème barrette (4e keup)': '4_to_3_keup',
      'Rouge (3e keup)': '3_to_2_keup',
      'Rouge 1ère barrette (2e keup)': '2_to_1_keup',
      'Rouge 2ème barrette (1e keup)': '1_to_dan_keup',
    };

    return beltToTransition[belt];
  }
}
