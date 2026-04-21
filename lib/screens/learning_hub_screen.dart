import 'package:flutter/material.dart';
import 'belt_selection_for_learning_screen.dart';
import 'enfants_screen.dart';
import 'history_screen.dart';
import 'module_b_review_screen.dart';
import 'reference_officielle_screen.dart';
import 'package:taekwondo_knowledge/screens/rules_screen.dart';

class LearningHubScreen extends StatelessWidget {
  const LearningHubScreen({super.key});

  static const Color _navyDark = Color(0xFF0A1628);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F2F5),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // ── Header ──
          SliverAppBar(
            pinned: true,
            expandedHeight: 130,
            backgroundColor: _navyDark,
            foregroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_rounded, size: 20),
              onPressed: () => Navigator.pop(context),
            ),
            flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.pin,
              titlePadding: const EdgeInsets.fromLTRB(56, 0, 20, 14),
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF0A1628), Color(0xFF1A2E1A)],
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 56, 24, 16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: const Color(0xFF2E7D32).withOpacity(0.3),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: const Color(0xFF2E7D32).withOpacity(0.7),
                            width: 1.5,
                          ),
                        ),
                        child: const Icon(
                          Icons.menu_book_rounded,
                          color: Colors.white,
                          size: 26,
                        ),
                      ),
                      const SizedBox(width: 14),
                      const Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'APPRENTISSAGE',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w900,
                              fontSize: 22,
                              letterSpacing: 3,
                            ),
                          ),
                          Text(
                            'Étude & révisions',
                            style: TextStyle(
                              color: Colors.white54,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // ── Contenu ──
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const _SectionLabel(label: 'RUBRIQUES'),
                  const SizedBox(height: 16),

                  // Kibon - Vocabulaire
                  _LearningCard(
                    title: 'Termes',
                    subtitle: 'Vocabulaire & techniques coréennes',
                    description:
                        'Apprenez les termes officiels du Taekwondo : commandes, noms des techniques de pied et de poing, positions et déplacements.',
                    icon: Icons.record_voice_over_rounded,
                    topColor: const Color(0xFF00695C),
                    bottomColor: const Color(0xFF004D40),
                    tag: 'Flashcards',
                    tagIcon: Icons.style_rounded,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) =>
                              const BeltSelectionForLeaningScreen()),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Histoire
                  _LearningCard(
                    title: 'Histoire',
                    subtitle: 'Origines & évolution du Taekwondo',
                    description:
                        'Découvrez l\'histoire fascinante du Taekwondo, des arts martiaux coréens anciens jusqu\'à sa reconnaissance olympique.',
                    icon: Icons.history_edu_rounded,
                    topColor: const Color(0xFFBF360C),
                    bottomColor: const Color(0xFF870000),
                    tag: 'Lecture',
                    tagIcon: Icons.book_rounded,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const TaekwondoHistoryScreen()),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Règles
                  _LearningCard(
                    title: 'Règles',
                    subtitle: 'Règlement officiel de compétition',
                    description:
                        'Maîtrisez les règles d\'arbitrage : zones de marque, pénalités, système de points et déroulement d\'un combat officiel.',
                    icon: Icons.gavel_rounded,
                    topColor: const Color(0xFF283593),
                    bottomColor: const Color(0xFF1A237E),
                    tag: 'Réglementation',
                    tagIcon: Icons.verified_rounded,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const TaekwondoRulesScreen()),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Enfants
                  _LearningCard(
                    title: 'Enfants',
                    subtitle: 'Progression 6e→12e keup',
                    description:
                        'Consultez les fiches de progression officielle FFTDA pour les ceintures enfants : positions, blocages, coups de pied, poomsae, combat et code moral par niveau.',
                    icon: Icons.child_care_rounded,
                    topColor: const Color(0xFF6A1B9A),
                    bottomColor: const Color(0xFF38006B),
                    tag: 'Progression',
                    tagIcon: Icons.trending_up_rounded,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const EnfantsScreen()),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Référence officielle FFTDA
                  _LearningCard(
                    title: 'Référence officielle',
                    subtitle: 'Positions · Techniques · Lexique FFTDA',
                    description:
                        'Consultez le référentiel officiel FFTDA : les 17 positions de base, les techniques de pied (Tchagui), les 50 blocages (Maki), les attaques membres supérieurs et le lexique coréen complet.',
                    icon: Icons.library_books_rounded,
                    topColor: const Color(0xFF4A148C),
                    bottomColor: const Color(0xFF1A0A2E),
                    tag: 'FFTDA',
                    tagIcon: Icons.verified_rounded,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) =>
                              const ReferenceOfficielleScreen()),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Module B — Fiches
                  _LearningCard(
                    title: 'Questionnaire Ceinture noire',
                    subtitle: '2ème DAN · 3ème DAN',
                    description:
                        'Révisez toutes les questions et réponses officielles du Module B : gouvernance, vie associative, arbitrage, compétition Poomsé et Kyorugi.',
                    icon: Icons.fact_check_rounded,
                    topColor: const Color(0xFF4A148C),
                    bottomColor: const Color(0xFF1A1040),
                    tag: 'Q&R',
                    tagIcon: Icons.checklist_rounded,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const ModuleBReviewScreen()),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LearningCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String description;
  final IconData icon;
  final Color topColor;
  final Color bottomColor;
  final String tag;
  final IconData tagIcon;
  final VoidCallback onTap;

  const _LearningCard({
    required this.title,
    required this.subtitle,
    required this.description,
    required this.icon,
    required this.topColor,
    required this.bottomColor,
    required this.tag,
    required this.tagIcon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(20),
      elevation: 5,
      shadowColor: Colors.black.withOpacity(0.2),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [topColor, bottomColor],
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.all(22),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Ligne titre + tag
              Row(
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.25),
                        width: 1.5,
                      ),
                    ),
                    child: Icon(icon, size: 28, color: Colors.white),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            letterSpacing: 0.3,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          subtitle,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.18),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(tagIcon, size: 11, color: Colors.white),
                        const SizedBox(width: 4),
                        Text(
                          tag,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Container(
                height: 1,
                color: Colors.white.withOpacity(0.15),
              ),
              const SizedBox(height: 14),
              Text(
                description,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.white.withOpacity(0.85),
                  height: 1.55,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.35),
                        width: 1,
                      ),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Accéder',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(width: 6),
                        Icon(Icons.arrow_forward_rounded,
                            color: Colors.white, size: 16),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String label;

  const _SectionLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 20,
          decoration: BoxDecoration(
            color: const Color(0xFFCC1122),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 10),
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w800,
            color: Color(0xFF37474F),
            letterSpacing: 2,
          ),
        ),
      ],
    );
  }
}
