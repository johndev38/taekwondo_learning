import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

// ─── Modèle ───────────────────────────────────────────────────
class _QA {
  final int id;
  final String question;
  final List<String> options;
  final List<String> correctAnswers;

  _QA({
    required this.id,
    required this.question,
    required this.options,
    required this.correctAnswers,
  });

  factory _QA.fromJson(Map<String, dynamic> j) {
    final ca = j['correctAnswer'];
    return _QA(
      id: j['id'] as int,
      question: j['question'] as String,
      options: List<String>.from(j['options'] as List),
      correctAnswers: ca is List
          ? List<String>.from(ca)
          : [ca.toString()],
    );
  }
}

class _Section {
  final String title;
  final Color color;
  final List<_QA> questions;

  _Section({required this.title, required this.color, required this.questions});
}

// ─── Écran principal ──────────────────────────────────────────
class ModuleBReviewScreen extends StatefulWidget {
  const ModuleBReviewScreen({super.key});

  @override
  State<ModuleBReviewScreen> createState() => _ModuleBReviewScreenState();
}

class _ModuleBReviewScreenState extends State<ModuleBReviewScreen> {
  List<_Section> sections = [];
  bool isLoading = true;

  static const Color _navy = Color(0xFF0A1628);

  // fichiers → (nom section, couleur)
  static const _files = [
    (
      'questions_module_b_2eme_dan.json',
      '2ème DAN — Compétition',
      Color(0xFF00695C),
    ),
    (
      'questions_module_b_3eme_dan_partie1.json',
      '3ème DAN — Gouvernance',
      Color(0xFF4527A0),
    ),
    (
      'questions_module_b_3eme_dan_partie2.json',
      '3ème DAN — Compétition',
      Color(0xFF283593),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final List<_Section> loaded = [];
    for (final f in _files) {
      final raw = await rootBundle.loadString('assets/${f.$1}');
      final data = json.decode(raw) as Map<String, dynamic>;
      final List<_QA> qs = [];
      data.forEach((_, v) {
        for (final item in v as List<dynamic>) {
          qs.add(_QA.fromJson(item as Map<String, dynamic>));
        }
      });
      loaded.add(_Section(title: f.$2, color: f.$3, questions: qs));
    }
    setState(() {
      sections = loaded;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // ── Header ──
          SliverAppBar(
            pinned: true,
            expandedHeight: 170,
            backgroundColor: _navy,
            foregroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_rounded, size: 20),
              onPressed: () => Navigator.pop(context),
            ),
            flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.pin,
              titlePadding: const EdgeInsets.fromLTRB(56, 0, 20, 14),
              title: const Text(
                'MODULE B — FICHES',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  fontSize: 16,
                  letterSpacing: 1.5,
                ),
              ),
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF0A1628), Color(0xFF1A1040)],
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 56, 24, 48),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: const Color(0xFF4527A0).withOpacity(0.3),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: const Color(0xFF4527A0).withOpacity(0.7),
                            width: 1.5,
                          ),
                        ),
                        child: const Icon(Icons.fact_check_rounded,
                            color: Colors.white, size: 26),
                      ),
                      const SizedBox(width: 14),
                      const Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'MODULE B',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w900,
                                fontSize: 22,
                                letterSpacing: 3,
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              'Fiches questions / réponses',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colors.white54,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // ── Contenu ──
          if (isLoading)
            const SliverFillRemaining(
              child: Center(child: CircularProgressIndicator()),
            )
          else
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (ctx, i) => _SectionWidget(section: sections[i]),
                childCount: sections.length,
              ),
            ),
          const SliverToBoxAdapter(child: SizedBox(height: 32)),
        ],
      ),
    );
  }
}

// ─── Widget section ───────────────────────────────────────────
class _SectionWidget extends StatefulWidget {
  final _Section section;
  const _SectionWidget({required this.section});

  @override
  State<_SectionWidget> createState() => _SectionWidgetState();
}

class _SectionWidgetState extends State<_SectionWidget> {
  bool _expanded = true;

  @override
  Widget build(BuildContext context) {
    final s = widget.section;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Bannière section cliquable pour réduire/étendre
          GestureDetector(
            onTap: () => setState(() => _expanded = !_expanded),
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [s.color, Color.lerp(s.color, Colors.black, 0.3)!],
                ),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(7),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.fact_check_rounded,
                        color: Colors.white, size: 18),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          s.title.toUpperCase(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                            fontSize: 14,
                            letterSpacing: 1.5,
                          ),
                        ),
                        Text(
                          '${s.questions.length} question${s.questions.length > 1 ? 's' : ''}',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.65),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    _expanded
                        ? Icons.keyboard_arrow_up_rounded
                        : Icons.keyboard_arrow_down_rounded,
                    color: Colors.white70,
                    size: 22,
                  ),
                ],
              ),
            ),
          ),

          // Cartes Q/A
          AnimatedCrossFade(
            duration: const Duration(milliseconds: 250),
            crossFadeState: _expanded
                ? CrossFadeState.showFirst
                : CrossFadeState.showSecond,
            firstChild: Column(
              children: [
                const SizedBox(height: 8),
                ...s.questions.asMap().entries.map(
                      (e) => _QACard(
                        index: e.key + 1,
                        qa: e.value,
                        accentColor: s.color,
                      ),
                    ),
              ],
            ),
            secondChild: const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}

// ─── Carte Q/A ────────────────────────────────────────────────
class _QACard extends StatefulWidget {
  final int index;
  final _QA qa;
  final Color accentColor;

  const _QACard({
    required this.index,
    required this.qa,
    required this.accentColor,
  });

  @override
  State<_QACard> createState() => _QACardState();
}

class _QACardState extends State<_QACard> {
  bool _showAnswers = false;

  @override
  Widget build(BuildContext context) {
    final isMulti = widget.qa.correctAnswers.length > 1;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: widget.accentColor.withOpacity(0.15)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header question ──
          InkWell(
            onTap: () => setState(() => _showAnswers = !_showAnswers),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Numéro
                  Container(
                    width: 28,
                    height: 28,
                    margin: const EdgeInsets.only(top: 1, right: 10),
                    decoration: BoxDecoration(
                      color: widget.accentColor.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        '${widget.index}',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          color: widget.accentColor,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.qa.question,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF0A1628),
                            height: 1.4,
                          ),
                        ),
                        if (isMulti)
                          Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: widget.accentColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                '${widget.qa.correctAnswers.length} réponses',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  color: widget.accentColor,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    _showAnswers
                        ? Icons.expand_less_rounded
                        : Icons.expand_more_rounded,
                    color: Colors.grey.shade400,
                    size: 20,
                  ),
                ],
              ),
            ),
          ),

          // ── Réponses (dépliables) ──
          AnimatedCrossFade(
            duration: const Duration(milliseconds: 200),
            crossFadeState: _showAnswers
                ? CrossFadeState.showFirst
                : CrossFadeState.showSecond,
            firstChild: Padding(
              padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(height: 1, color: Colors.grey.shade100),
                  const SizedBox(height: 10),
                  // Toutes les options avec mise en valeur des bonnes
                  ...widget.qa.options.map((opt) {
                    final isCorrect =
                        widget.qa.correctAnswers.contains(opt);
                    return Container(
                      margin: const EdgeInsets.only(bottom: 6),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 9),
                      decoration: BoxDecoration(
                        color: isCorrect
                            ? const Color(0xFF2E7D32).withOpacity(0.1)
                            : Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: isCorrect
                              ? const Color(0xFF2E7D32).withOpacity(0.5)
                              : Colors.grey.shade200,
                          width: isCorrect ? 1.5 : 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            isCorrect
                                ? Icons.check_circle_rounded
                                : Icons.radio_button_unchecked_rounded,
                            size: 16,
                            color: isCorrect
                                ? const Color(0xFF2E7D32)
                                : Colors.grey.shade400,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              opt,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: isCorrect
                                    ? FontWeight.w700
                                    : FontWeight.w400,
                                color: isCorrect
                                    ? const Color(0xFF2E7D32)
                                    : Colors.grey.shade600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),
            secondChild: const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}
