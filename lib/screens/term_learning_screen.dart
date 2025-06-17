import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
// home_screen.dart n'est pas utilisé ici, vous pouvez le supprimer si ce n'est pas nécessaire ailleurs.

// Modèle pour les termes
class Term {
  final String term;
  final String explanation;
  final String category;

  Term({required this.term, required this.explanation, required this.category});

  factory Term.fromJson(Map<String, dynamic> json) {
    return Term(
      term: json['term'] ?? '',
      explanation: json['explanation'] ?? '',
      category: json['category'] ?? 'Non classé', // Catégorie par défaut
    );
  }
}

class TermLearningScreen extends StatefulWidget {
  final String belt;
  // final List<String> belts; // belts n'est pas utilisé, peut être supprimé si non nécessaire

  const TermLearningScreen(
      {super.key, required this.belt /*, required this.belts*/});

  @override
  TermLearningScreenState createState() => TermLearningScreenState();
}

class TermLearningScreenState extends State<TermLearningScreen> {
  Map<String, List<Term>> categorizedTerms = {};
  bool isLoading = true;
  bool _showFlashcards = false;
  List<Term> allTermsForBelt = [];
  int _currentFlashcardIndex = 0;
  bool _flashcardIsFlipped = false;

  @override
  void initState() {
    super.initState();
    loadTerms();
  }

  Future<void> loadTerms() async {
    setState(() {
      isLoading = true;
    });
    try {
      final String response = await rootBundle.loadString('assets/terms.json');
      final data = await json.decode(response);

      if (data[widget.belt] != null) {
        List<Term> termsList = List<Term>.from(
            data[widget.belt].map((item) => Term.fromJson(item)));

        allTermsForBelt = List.from(termsList); // Copie pour les flashcards

        Map<String, List<Term>> tempCategorizedTerms = {};
        for (var term in termsList) {
          if (tempCategorizedTerms.containsKey(term.category)) {
            tempCategorizedTerms[term.category]!.add(term);
          } else {
            tempCategorizedTerms[term.category] = [term];
          }
        }
        categorizedTerms = tempCategorizedTerms;
      }
    } catch (e) {
      // Affichage d'une erreur utilisateur
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur lors du chargement des termes : $e')),
        );
      }
    }
    setState(() {
      isLoading = false;
      if (allTermsForBelt.isNotEmpty) {
        allTermsForBelt.shuffle(); // Mélanger pour le mode flashcard
      }
    });
  }

  void _toggleViewMode() {
    setState(() {
      _showFlashcards = !_showFlashcards;
      _currentFlashcardIndex = 0; // Réinitialiser l'index des flashcards
      _flashcardIsFlipped = false;
      if (_showFlashcards && allTermsForBelt.isNotEmpty) {
        allTermsForBelt.shuffle();
      }
    });
  }

  void _nextFlashcard() {
    setState(() {
      _flashcardIsFlipped = false;
      if (allTermsForBelt.isNotEmpty) {
        _currentFlashcardIndex =
            (_currentFlashcardIndex + 1) % allTermsForBelt.length;
      }
    });
  }

  void _previousFlashcard() {
    setState(() {
      _flashcardIsFlipped = false;
      if (allTermsForBelt.isNotEmpty) {
        _currentFlashcardIndex =
            (_currentFlashcardIndex - 1 + allTermsForBelt.length) %
                allTermsForBelt.length;
      }
    });
  }

  void _flipFlashcard() {
    setState(() {
      _flashcardIsFlipped = !_flashcardIsFlipped;
    });
  }

  Widget _buildListView() {
    if (categorizedTerms.isEmpty) {
      return const Center(
          child: Text('Aucun terme trouvé pour cette ceinture.'));
    }
    return ListView(
      shrinkWrap: true, // Important pour ListView dans Column
      children: categorizedTerms.keys.map((category) {
        return ExpansionTile(
          title: Text(category,
              style:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          children: categorizedTerms[category]!.map((term) {
            return ListTile(
              title: Text(term.term),
              subtitle: Text(term.explanation),
              // On pourrait ajouter un bouton audio ici plus tard
            );
          }).toList(),
        );
      }).toList(),
    );
  }

  Widget _buildFlashcardView() {
    if (allTermsForBelt.isEmpty) {
      return const Center(child: Text('Aucun terme pour le mode flashcard.'));
    }

    Term currentTerm = allTermsForBelt[_currentFlashcardIndex];

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
            "Flashcard (${_currentFlashcardIndex + 1}/${allTermsForBelt.length})"),
        const SizedBox(height: 20),
        GestureDetector(
          onTap: _flipFlashcard,
          child: Card(
            elevation: 8,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.8,
              height: MediaQuery.of(context).size.height * 0.3,
              alignment: Alignment.center,
              padding: const EdgeInsets.all(16),
              child: Text(
                _flashcardIsFlipped
                    ? currentTerm.explanation
                    : currentTerm.term,
                textAlign: TextAlign.center,
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
        Text(_flashcardIsFlipped ? "Définition" : "Terme",
            style: const TextStyle(fontStyle: FontStyle.italic)),
        const SizedBox(height: 30),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ElevatedButton(
                onPressed: _previousFlashcard, child: const Text('Précédent')),
            ElevatedButton(
                onPressed: _flipFlashcard,
                child: const Icon(Icons.flip_camera_android)),
            ElevatedButton(
                onPressed: _nextFlashcard, child: const Text('Suivant')),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Termes pour ${widget.belt}'),
        actions: [
          IconButton(
            icon: Icon(_showFlashcards
                ? Icons.list_alt
                : Icons.style), // style est une icône de flashcard
            tooltip: _showFlashcards ? 'Voir la liste' : 'Mode Flashcard',
            onPressed: _toggleViewMode,
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: _showFlashcards ? _buildFlashcardView() : _buildListView(),
            ),
    );
  }
}
