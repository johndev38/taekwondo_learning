import 'dart:convert';
import 'package:flutter/services.dart';

class BeltRequirement {
  final String beltColor;
  final List<String> poomses;
  final List<String> terms;
  final List<String> techniques;
  final String description;
  final Map<String, dynamic>? keupRequirements;
  final Map<String, dynamic>? babyRequirements;

  BeltRequirement({
    required this.beltColor,
    required this.poomses,
    required this.terms,
    required this.techniques,
    required this.description,
    this.keupRequirements,
    this.babyRequirements,
  });

  static Future<List<BeltRequirement>> getAllRequirements() async {
    // Charger les données JSON
    final String jsonString =
        await rootBundle.loadString('assets/belt_requirements.json');
    final Map<String, dynamic> jsonData = json.decode(jsonString);

    // Créer la liste des exigences
    List<BeltRequirement> requirements = [
      BeltRequirement(
        beltColor: 'Blanche',
        poomses: ['Saju Jirugi', 'Saju Makgi'],
        terms: [
          'Charyot (Attention)',
          'Kyongye (Salut)',
          'Junbi (Position de départ)',
          'Baro (Retour)',
          'Swiyo (Repos)'
        ],
        techniques: [
          'Position de combat (Ap Seogi)',
          'Coup de poing direct (Jirugi)',
          'Blocage bas (Arae Makgi)',
          'Blocage moyen (Momtong Makgi)'
        ],
        description: 'Première ceinture, débutant',
        babyRequirements: jsonData['baby_program'],
      ),
      BeltRequirement(
        beltColor: 'Jaune',
        poomses: ['Taegeuk Il Jang'],
        terms: [
          'Dojang (Salle d\'entraînement)',
          'Dobok (Tenue d\'entraînement)',
          'Sabum (Instructeur)',
          'Kihap (Cri)'
        ],
        techniques: [
          'Coup de pied frontal (Ap Chagi)',
          'Coup de pied latéral (Yop Chagi)',
          'Blocage haut (Olgul Makgi)',
          'Coup de poing croisé (Bandae Jirugi)'
        ],
        description: 'Deuxième ceinture, débutant avancé',
      ),
      BeltRequirement(
        beltColor: 'Verte',
        poomses: ['Taegeuk Yi Jang'],
        terms: [
          'Kup (Grade)',
          'Dan (Degré)',
          'Kyorugi (Combat)',
          'Hosinsul (Self-défense)'
        ],
        techniques: [
          'Coup de pied circulaire (Dollyo Chagi)',
          'Coup de pied retourné (Dwi Chagi)',
          'Blocage croisé (Kawi Makgi)',
          'Coup de poing double (Dung Jumok Jirugi)'
        ],
        description: 'Troisième ceinture, intermédiaire',
      ),
      BeltRequirement(
        beltColor: 'Bleue',
        poomses: ['Taegeuk Sam Jang'],
        terms: [
          'Poomsae (Forme)',
          'Kyukpa (Casse)',
          'Do (Voie)',
          'Tae Kwon (Art du pied et du poing)'
        ],
        techniques: [
          'Coup de pied crochet (Huryo Chagi)',
          'Coup de pied retourné latéral (Dwi Yop Chagi)',
          'Blocage double (Doo Makgi)',
          'Coup de poing marteau (Me Jumok Jirugi)'
        ],
        description: 'Quatrième ceinture, intermédiaire avancé',
      ),
      BeltRequirement(
        beltColor: 'Rouge',
        poomses: ['Taegeuk Sa Jang'],
        terms: [
          'Kamsahamnida (Merci)',
          'Annyeong Haseyo (Bonjour)',
          'Annyeonghi Gaseyo (Au revoir)',
          'Gamsahamnida (Merci beaucoup)'
        ],
        techniques: [
          'Coup de pied saut (Twimyo Chagi)',
          'Coup de pied double (Doo Chagi)',
          'Blocage en X (Kyocha Makgi)',
          'Coup de poing coude (Palkup Jirugi)'
        ],
        description: 'Cinquième ceinture, avancé',
        keupRequirements: jsonData['keup_progression']['4_to_3_keup'],
      ),
      BeltRequirement(
        beltColor: 'Noire',
        poomses: ['Taegeuk Oh Jang'],
        terms: [
          'Dojang (Salle d\'entraînement)',
          'Sabum (Instructeur)',
          'Kwanjangnim (Maître)',
          'Sunbae (Senior)',
          'Hubae (Junior)'
        ],
        techniques: [
          'Coup de pied retourné saut (Twimyo Dwi Chagi)',
          'Coup de pied double saut (Twimyo Doo Chagi)',
          'Blocage circulaire (Dollyo Makgi)',
          'Coup de poing coude retourné (Dwi Palkup Jirugi)'
        ],
        description: 'Sixième ceinture, expert',
        keupRequirements: jsonData['keup_progression']['2_to_1_keup'],
      ),
    ];

    return requirements;
  }

  // Méthode pour charger directement les données JSON brutes
  static Future<Map<String, dynamic>> loadBeltRequirements() async {
    final String jsonString =
        await rootBundle.loadString('assets/belt_requirements.json');
    return json.decode(jsonString) as Map<String, dynamic>;
  }
}
