import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

class Term {
  final String term;
  final String explanation;
  final String category;

  Term({required this.term, required this.explanation, required this.category});

  factory Term.fromJson(Map<String, dynamic> json) {
    return Term(
      term: json['term'] ?? '',
      explanation: json['explanation'] ?? '',
      category: json['category'] ?? 'Techniques',
    );
  }
}

class TermLearningScreen extends StatefulWidget {
  final String belt;

  const TermLearningScreen({super.key, required this.belt});

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

  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  late AnimationController _flipController;

  // ─── Palette tirée de la ceinture ───
  Color get _beltAccent {
    final b = widget.belt.toLowerCase();
    if (b.startsWith('jaune')) return const Color(0xFFF9A825);
    if (b.startsWith('bleu')) return const Color(0xFF1565C0);
    if (b.startsWith('rouge')) return const Color(0xFFCC1122);
    if (b.startsWith('noire')) return const Color(0xFF1A1A2E);
    return const Color(0xFF00695C);
  }

  String get _beltImage {
    final b = widget.belt.toLowerCase();
    if (b.startsWith('jaune')) return 'assets/images/ceinture_jaune.png';
    if (b.startsWith('bleu')) return 'assets/images/ceinture_bleu.png';
    if (b.startsWith('rouge')) return 'assets/images/ceinture_rouge.png';
    if (b.startsWith('noire')) return 'assets/images/ceinture_noire.png';
    return 'assets/images/ceinture_jaune.png';
  }

  static const Color _navy = Color(0xFF0A1628);

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeIn));

    _flipController = AnimationController(
      duration: const Duration(milliseconds: 350),
      vsync: this,
    );

    loadTerms();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _flipController.dispose();
    super.dispose();
  }

  Future<void> loadTerms() async {
    setState(() => isLoading = true);
    try {
      final String response = await rootBundle.loadString('assets/terms.json');
      final data = json.decode(response);

      if (data[widget.belt] != null) {
        final List<Term> termsList =
            List<Term>.from(data[widget.belt].map((e) => Term.fromJson(e)));
        allTermsForBelt = List.from(termsList);

        final Map<String, List<Term>> temp = {};
        for (final t in termsList) {
          final cat = t.category.isEmpty ? 'Techniques' : t.category;
          (temp[cat] ??= []).add(t);
        }
        categorizedTerms = temp;
      }
      _fadeController.forward();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur lors du chargement : $e'),
            backgroundColor: Colors.red.shade600,
          ),
        );
      }
    }
    setState(() {
      isLoading = false;
      if (allTermsForBelt.isNotEmpty) allTermsForBelt.shuffle();
    });
  }

  void _toggleViewMode() {
    setState(() {
      _showFlashcards = !_showFlashcards;
      _currentFlashcardIndex = 0;
      _flashcardIsFlipped = false;
      _flipController.reset();
      if (_showFlashcards && allTermsForBelt.isNotEmpty) {
        allTermsForBelt.shuffle();
      }
    });
  }

  void _nextFlashcard() {
    setState(() {
      _flashcardIsFlipped = false;
      _flipController.reset();
      if (allTermsForBelt.isNotEmpty) {
        _currentFlashcardIndex =
            (_currentFlashcardIndex + 1) % allTermsForBelt.length;
      }
    });
  }

  void _previousFlashcard() {
    setState(() {
      _flashcardIsFlipped = false;
      _flipController.reset();
      if (allTermsForBelt.isNotEmpty) {
        _currentFlashcardIndex =
            (_currentFlashcardIndex - 1 + allTermsForBelt.length) %
                allTermsForBelt.length;
      }
    });
  }

  void _flipFlashcard() {
    setState(() => _flashcardIsFlipped = !_flashcardIsFlipped);
    if (_flashcardIsFlipped) {
      _flipController.forward();
    } else {
      _flipController.reverse();
    }
  }

  List<Term> get filteredTerms {
    if (_searchQuery.isEmpty) return allTermsForBelt;
    final q = _searchQuery.toLowerCase();
    return allTermsForBelt
        .where((t) =>
            t.term.toLowerCase().contains(q) ||
            t.explanation.toLowerCase().contains(q) ||
            t.category.toLowerCase().contains(q))
        .toList();
  }

  Color _categoryColor(String cat) {
    switch (cat.toLowerCase()) {
      case 'positions':
        return const Color(0xFF1565C0);
      case 'frappes':
        return const Color(0xFFCC1122);
      case 'blocages':
        return const Color(0xFF6A1B9A);
      case 'déplacements':
        return const Color(0xFFE65100);
      case 'techniques':
        return const Color(0xFF2E7D32);
      default:
        return const Color(0xFF00695C);
    }
  }

  IconData _categoryIcon(String cat) {
    switch (cat.toLowerCase()) {
      case 'positions':
        return Icons.accessibility_new_rounded;
      case 'frappes':
        return Icons.sports_martial_arts_rounded;
      case 'blocages':
        return Icons.shield_rounded;
      case 'déplacements':
        return Icons.directions_walk_rounded;
      case 'techniques':
        return Icons.fitness_center_rounded;
      default:
        return Icons.school_rounded;
    }
  }

  // ─────────────────────────────────────────────────────────
  //  VUE LISTE
  // ─────────────────────────────────────────────────────────

  Widget _buildListView() {
    if (allTermsForBelt.isEmpty) return _buildEmptyState();

    final filtered = filteredTerms;

    return Column(
      children: [
        // Barre de recherche
        Container(
          margin: const EdgeInsets.fromLTRB(16, 14, 16, 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade200),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
              )
            ],
          ),
          child: TextField(
            onChanged: (v) => setState(() => _searchQuery = v),
            decoration: InputDecoration(
              hintText: 'Rechercher un terme…',
              hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
              prefixIcon:
                  Icon(Icons.search_rounded, color: _beltAccent, size: 20),
              suffixIcon: _searchQuery.isNotEmpty
                  ? IconButton(
                      icon: Icon(Icons.close_rounded,
                          color: Colors.grey.shade400, size: 18),
                      onPressed: () => setState(() => _searchQuery = ''),
                    )
                  : null,
              border: InputBorder.none,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            ),
          ),
        ),

        // Compteur
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
          child: Row(
            children: [
              Text(
                '${filtered.length} terme${filtered.length > 1 ? 's' : ''}',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade500,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),

        // Liste
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            itemCount: filtered.length,
            itemBuilder: (ctx, i) => _TermCard(
              term: filtered[i],
              accentColor: _categoryColor(filtered[i].category),
              icon: _categoryIcon(filtered[i].category),
            ),
          ),
        ),
      ],
    );
  }

  // ─────────────────────────────────────────────────────────
  //  VUE FLASHCARD
  // ─────────────────────────────────────────────────────────

  Widget _buildFlashcardView() {
    if (allTermsForBelt.isEmpty) return _buildEmptyState();

    final term = allTermsForBelt[_currentFlashcardIndex];
    final progress = (_currentFlashcardIndex + 1) / allTermsForBelt.length;

    return Column(
      children: [
        // Barre de progression
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Carte ${_currentFlashcardIndex + 1} / ${allTermsForBelt.length}',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: _beltAccent,
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: _beltAccent.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      _flashcardIsFlipped ? 'Définition' : 'Terme',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: _beltAccent,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: progress,
                  backgroundColor: Colors.grey.shade200,
                  color: _beltAccent,
                  minHeight: 4,
                ),
              ),
            ],
          ),
        ),

        // Carte principale
        Expanded(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: GestureDetector(
                onTap: _flipFlashcard,
                child: AnimatedBuilder(
                  animation: _flipController,
                  builder: (ctx, child) {
                    return _FlashCard(
                      term: term,
                      isFlipped: _flashcardIsFlipped,
                      beltAccent: _beltAccent,
                      beltImage: _beltImage,
                      progress: progress,
                    );
                  },
                ),
              ),
            ),
          ),
        ),

        // Hint tap
        Text(
          'Appuyez sur la carte pour révéler la définition',
          style: TextStyle(fontSize: 12, color: Colors.grey.shade400),
        ),
        const SizedBox(height: 14),

        // Boutons navigation
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
          child: Row(
            children: [
              // Précédent
              Expanded(
                child: _NavButton(
                  icon: Icons.arrow_back_rounded,
                  label: 'Précédent',
                  color: Colors.grey.shade600,
                  onPressed: _previousFlashcard,
                ),
              ),
              const SizedBox(width: 12),
              // Retourner
              Expanded(
                flex: 2,
                child: _NavButton(
                  icon: Icons.flip_rounded,
                  label: 'Retourner',
                  color: _beltAccent,
                  filled: true,
                  onPressed: _flipFlashcard,
                ),
              ),
              const SizedBox(width: 12),
              // Suivant
              Expanded(
                child: _NavButton(
                  icon: Icons.arrow_forward_rounded,
                  label: 'Suivant',
                  color: Colors.grey.shade600,
                  onPressed: _nextFlashcard,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off_rounded, size: 72, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          Text(
            _searchQuery.isNotEmpty
                ? 'Aucun terme trouvé'
                : 'Aucun terme disponible',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF37474F),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _searchQuery.isNotEmpty
                ? 'Essayez d\'autres mots-clés'
                : 'Les termes pour ce niveau ne sont pas encore disponibles',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey.shade500, fontSize: 13),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F2F5),
      appBar: AppBar(
        backgroundColor: _navy,
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            Image.asset(_beltImage, width: 28, height: 28, fit: BoxFit.contain),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                widget.belt,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(3),
          child: Container(height: 3, color: _beltAccent),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: IconButton(
              icon: Icon(
                _showFlashcards ? Icons.list_alt_rounded : Icons.style_rounded,
                size: 22,
              ),
              tooltip: _showFlashcards ? 'Liste' : 'Flashcards',
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
                  CircularProgressIndicator(color: _beltAccent),
                  const SizedBox(height: 16),
                  Text(
                    'Chargement des termes…',
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                ],
              ),
            )
          : FadeTransition(
              opacity: _fadeAnimation,
              child:
                  _showFlashcards ? _buildFlashcardView() : _buildListView(),
            ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
//  WIDGETS EXTRAITS
// ─────────────────────────────────────────────────────────────

class _TermCard extends StatelessWidget {
  final Term term;
  final Color accentColor;
  final IconData icon;

  const _TermCard({
    required this.term,
    required this.accentColor,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: accentColor.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header catégorie + terme
          Container(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 10),
            decoration: BoxDecoration(
              color: accentColor.withOpacity(0.08),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(14),
                topRight: Radius.circular(14),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(7),
                  decoration: BoxDecoration(
                    color: accentColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: Colors.white, size: 16),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    term.term,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: accentColor,
                    ),
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: accentColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    term.category,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: accentColor,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Définition
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 10, 14, 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 3,
                  height: 40,
                  decoration: BoxDecoration(
                    color: accentColor.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    term.explanation,
                    style: const TextStyle(
                      fontSize: 14,
                      height: 1.5,
                      color: Color(0xFF37474F),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FlashCard extends StatelessWidget {
  final Term term;
  final bool isFlipped;
  final Color beltAccent;
  final String beltImage;
  final double progress;

  const _FlashCard({
    required this.term,
    required this.isFlipped,
    required this.beltAccent,
    required this.beltImage,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 350),
      transitionBuilder: (child, animation) {
        return FadeTransition(opacity: animation, child: child);
      },
      child: Container(
        key: ValueKey(isFlipped),
        width: double.infinity,
        constraints: const BoxConstraints(minHeight: 260, maxHeight: 340),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isFlipped
                ? [
                    beltAccent.withOpacity(0.9),
                    Color.lerp(beltAccent, Colors.black, 0.35)!,
                  ]
                : [
                    const Color(0xFF0A1628),
                    const Color(0xFF162840),
                  ],
          ),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: (isFlipped ? beltAccent : const Color(0xFF0A1628))
                  .withOpacity(0.35),
              blurRadius: 24,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Image de fond subtile
            Positioned(
              right: -20,
              bottom: -20,
              child: Opacity(
                opacity: 0.08,
                child: Image.asset(
                  beltImage,
                  width: 140,
                  height: 140,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            // Contenu
            Padding(
              padding: const EdgeInsets.all(28),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Badge face
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          isFlipped
                              ? Icons.lightbulb_rounded
                              : Icons.translate_rounded,
                          size: 13,
                          color: Colors.white70,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          isFlipped ? 'DÉFINITION' : 'TERME CORÉEN',
                          style: const TextStyle(
                            fontSize: 10,
                            color: Colors.white70,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Texte principal
                  Text(
                    isFlipped ? term.explanation : term.term,
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      height: 1.3,
                    ),
                  ),
                  if (isFlipped) ...[
                    const SizedBox(height: 14),
                    Container(
                      height: 1,
                      color: Colors.white.withOpacity(0.2),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Terme : ${term.term}',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.white.withOpacity(0.6),
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                  if (!isFlipped) ...[
                    const SizedBox(height: 16),
                    Text(
                      'Touchez pour révéler la définition',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white.withOpacity(0.45),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onPressed;
  final bool filled;

  const _NavButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onPressed,
    this.filled = false,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(12),
      color: filled ? color : color.withOpacity(0.1),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Column(
            children: [
              Icon(icon, color: filled ? Colors.white : color, size: 22),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: filled ? Colors.white : color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
