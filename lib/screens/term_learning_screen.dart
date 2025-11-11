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
      category:
          json['category'] ?? 'Techniquess', // Catégorie par défaut améliorée
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

class TermLearningScreenState extends State<TermLearningScreen>
    with TickerProviderStateMixin {
  Map<String, List<Term>> categorizedTerms = {};
  bool isLoading = true;
  bool _showFlashcards = false;
  List<Term> allTermsForBelt = [];
  int _currentFlashcardIndex = 0;
  bool _flashcardIsFlipped = false;
  String _searchQuery = '';
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );
    loadTerms();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
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

        allTermsForBelt = List.from(termsList);

        Map<String, List<Term>> tempCategorizedTerms = {};
        for (var term in termsList) {
          final category = term.category.isEmpty ? 'Techniques' : term.category;
          if (tempCategorizedTerms.containsKey(category)) {
            tempCategorizedTerms[category]!.add(term);
          } else {
            tempCategorizedTerms[category] = [term];
          }
        }
        categorizedTerms = tempCategorizedTerms;
      }
      _animationController.forward();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur lors du chargement des termes : $e'),
            backgroundColor: Colors.red.shade600,
          ),
        );
      }
    }
    setState(() {
      isLoading = false;
      if (allTermsForBelt.isNotEmpty) {
        allTermsForBelt.shuffle();
      }
    });
  }

  void _toggleViewMode() {
    setState(() {
      _showFlashcards = !_showFlashcards;
      _currentFlashcardIndex = 0;
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

  List<Term> get filteredTerms {
    if (_searchQuery.isEmpty) return allTermsForBelt;
    return allTermsForBelt
        .where((term) =>
            term.term.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            term.explanation
                .toLowerCase()
                .contains(_searchQuery.toLowerCase()) ||
            term.category.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();
  }

  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'positions':
        return Colors.blue.shade600;
      case 'frappes':
        return Colors.red.shade600;
      case 'blocages':
        return Colors.purple.shade600;
      case 'déplacements':
        return Colors.orange.shade600;
      case 'techniques':
        return Colors.green.shade600;
      default:
        return Colors.teal.shade600;
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'positions':
        return Icons.accessibility;
      case 'frappes':
        return Icons.sports_martial_arts;
      case 'blocages':
        return Icons.shield;
      case 'déplacements':
        return Icons.directions_walk;
      case 'techniques':
        return Icons.psychology;
      default:
        return Icons.school;
    }
  }

  Widget _buildModernListView() {
    if (allTermsForBelt.isEmpty) {
      return _buildEmptyState();
    }

    final filtered = filteredTerms;

    return Column(
      children: [
        // Barre de recherche moderne
        Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300),
          ),
          // child: TextField(
          //   onChanged: (value) => setState(() => _searchQuery = value),
          //   decoration: InputDecoration(
          //     hintText: 'Rechercher un terme...',
          //     prefixIcon: Icon(Icons.search, color: Colors.grey.shade600),
          //     border: InputBorder.none,
          //     suffixIcon: _searchQuery.isNotEmpty
          //         ? IconButton(
          //             icon: const Icon(Icons.clear),
          //             onPressed: () => setState(() => _searchQuery = ''),
          //           )
          //         : null,
          //   ),
          // ),
        ),

        // // Statistiques
        // Container(
        //   margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        //   padding: const EdgeInsets.all(16),
        //   decoration: BoxDecoration(
        //     gradient: LinearGradient(
        //       colors: [Colors.green.shade100, Colors.teal.shade100],
        //     ),
        //     borderRadius: BorderRadius.circular(12),
        //   ),
        //   child: Row(
        //     mainAxisAlignment: MainAxisAlignment.spaceAround,
        //     children: [
        //       _buildStatistic('Total', allTermsForBelt.length.toString(),
        //           Icons.library_books),
        //       _buildStatistic('Catégories', categorizedTerms.length.toString(),
        //           Icons.category),
        //       _buildStatistic(
        //           'Affichés', filtered.length.toString(), Icons.visibility),
        //     ],
        //   ),
        // ),

        // Liste des termes
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: filtered.length,
            itemBuilder: (context, index) {
              final term = filtered[index];
              return _buildTermCard(term, index);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildStatistic(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.green.shade600, size: 24),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.green.shade700,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.green.shade600,
          ),
        ),
      ],
    );
  }

  Widget _buildTermCard(Term term, int index) {
    final categoryColor = _getCategoryColor(term.category);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Material(
        borderRadius: BorderRadius.circular(16),
        elevation: 3,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: categoryColor.withOpacity(0.3)),
          ),
          child: Column(
            children: [
              // Header avec catégorie
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: categoryColor.withOpacity(0.1),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: categoryColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        _getCategoryIcon(term.category),
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        term.term,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: categoryColor,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: categoryColor.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        term.category,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: categoryColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Contenu
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                child: Text(
                  term.explanation,
                  style: const TextStyle(
                    fontSize: 16,
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 80,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            _searchQuery.isNotEmpty
                ? 'Aucun terme trouvé'
                : 'Aucun terme disponible',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _searchQuery.isNotEmpty
                ? 'Essayez avec d\'autres mots-clés'
                : 'Les termes pour cette ceinture ne sont pas encore disponibles',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFlashcardView() {
    if (allTermsForBelt.isEmpty) {
      return _buildEmptyState();
    }

    Term currentTerm = allTermsForBelt[_currentFlashcardIndex];

    return Column(
      children: [
        // Indicateur de progression
        Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.blue.shade100,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            'Flashcard ${_currentFlashcardIndex + 1} sur ${allTermsForBelt.length}',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.blue.shade700,
            ),
          ),
        ),

        // Flashcard
        Expanded(
          child: Center(
            child: GestureDetector(
              onTap: _flipFlashcard,
              child: Container(
                width: MediaQuery.of(context).size.width * 0.85,
                height: MediaQuery.of(context).size.height * 0.4,
                margin: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: _flashcardIsFlipped
                        ? [Colors.green.shade100, Colors.teal.shade100]
                        : [Colors.blue.shade100, Colors.purple.shade100],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 15,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      _flashcardIsFlipped ? Icons.lightbulb : Icons.quiz,
                      size: 40,
                      color: _flashcardIsFlipped
                          ? Colors.green.shade600
                          : Colors.blue.shade600,
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Text(
                        _flashcardIsFlipped
                            ? currentTerm.explanation
                            : currentTerm.term,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: _flashcardIsFlipped
                              ? Colors.green.shade700
                              : Colors.blue.shade700,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Text(
                        _flashcardIsFlipped ? 'Définition' : 'Terme',
                        style: TextStyle(
                          fontStyle: FontStyle.italic,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),

        // Contrôles
        Container(
          margin: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildFlashcardButton(
                icon: Icons.arrow_back,
                label: 'Précédent',
                onPressed: _previousFlashcard,
                color: Colors.grey.shade600,
              ),
              _buildFlashcardButton(
                icon: Icons.flip_camera_android,
                label: 'Retourner',
                onPressed: _flipFlashcard,
                color: Colors.blue.shade600,
              ),
              _buildFlashcardButton(
                icon: Icons.arrow_forward,
                label: 'Suivant',
                onPressed: _nextFlashcard,
                color: Colors.green.shade600,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFlashcardButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
    required Color color,
  }) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(12),
          ),
          child: IconButton(
            icon: Icon(icon, color: Colors.white),
            onPressed: onPressed,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: color,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kibon - ${widget.belt}'),
        backgroundColor: Colors.green.shade600,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: IconButton(
              icon: Icon(_showFlashcards ? Icons.list_alt : Icons.style),
              tooltip: _showFlashcards ? 'Voir la liste' : 'Mode Flashcard',
              onPressed: _toggleViewMode,
            ),
          ),
        ],
      ),
      body: isLoading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: Colors.green.shade600),
                  const SizedBox(height: 16),
                  Text(
                    'Chargement des termes...',
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                ],
              ),
            )
          : FadeTransition(
              opacity: _fadeAnimation,
              child: _showFlashcards
                  ? _buildFlashcardView()
                  : _buildModernListView(),
            ),
    );
  }
}
