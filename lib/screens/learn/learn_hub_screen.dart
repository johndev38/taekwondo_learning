import 'package:flutter/material.dart';
import '../app_shell.dart';
import '../common/search_screen.dart';
import '../common/settings_screen.dart';
import 'belt_selection_for_learning_screen.dart';
import 'history_screen.dart';
import 'hosinsul_screen.dart';
import 'kyorugi_screen.dart';
import 'poomsae_list_screen.dart';
import 'reference_officielle_screen.dart';
import 'rules_screen.dart';

/// Hub d'apprentissage : contenu théorique et technique, organisé en 3 familles
/// (Technique · Théorie & Culture · Réglementation).
class LearnHubScreen extends StatelessWidget {
  const LearnHubScreen({super.key});

  static const Color _navyDark = Color(0xFF0A1628);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 130,
            backgroundColor: _navyDark,
            foregroundColor: Colors.white,
            elevation: 0,
            automaticallyImplyLeading: false,
            actions: [
              IconButton(
                tooltip: 'Rechercher',
                icon: const Icon(Icons.search_rounded),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SearchScreen()),
                ),
              ),
              IconButton(
                tooltip: 'Paramètres',
                icon: const Icon(Icons.settings_rounded),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SettingsScreen()),
                ),
              ),
              const SizedBox(width: 4),
            ],
            flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.pin,
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [_navyDark, Color(0xFF1A2E1A)],
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
                        child: const Icon(Icons.menu_book_rounded,
                            color: Colors.white, size: 26),
                      ),
                      const SizedBox(width: 14),
                      const Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'APPRENDRE',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w900,
                                fontSize: 22,
                                letterSpacing: 3,
                              ),
                            ),
                            Text(
                              'Technique · Théorie · Règlement',
                              style: TextStyle(
                                color: Colors.white54,
                                fontSize: 12,
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
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ═════════ TECHNIQUE ═════════
                  const SectionLabel(label: 'TECHNIQUE'),
                  const SizedBox(height: 12),
                  _LearnCard(
                    title: 'Référence officielle',
                    subtitle: 'Positions · Techniques · Lexique FFTDA',
                    description:
                        'Le référentiel officiel FFTDA : 17 positions de base, techniques de pied (Tchagui), 50 blocages (Maki), attaques membres supérieurs et lexique coréen.',
                    icon: Icons.library_books_rounded,
                    topColor: const Color(0xFF4A148C),
                    bottomColor: const Color(0xFF1A0A2E),
                    tag: 'FFTDA',
                    tagIcon: Icons.verified_rounded,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const ReferenceOfficielleScreen()),
                    ),
                  ),
                  const SizedBox(height: 14),
                  _LearnCard(
                    title: 'Poomsae',
                    subtitle: 'Taegeuk · Koryo · Geumgang',
                    description:
                        'Vidéos des formes techniques officielles : Taegeuk 1 à 8 (Jang) et poomsae Dan (Koryo, Geumgang).',
                    icon: Icons.play_circle_filled_rounded,
                    topColor: const Color(0xFF6A1B9A),
                    bottomColor: const Color(0xFF38006B),
                    tag: 'Vidéos',
                    tagIcon: Icons.play_circle_rounded,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const PoomsaeListScreen()),
                    ),
                  ),
                  const SizedBox(height: 14),
                  _LearnCard(
                    title: 'Kyorugi / Combat',
                    subtitle: 'Ilbo · Sambo taeryon · Stratégie',
                    description:
                        'Techniques de combat codifiées : exercices à deux (Ilbo taeryon, Sambo taeryon), enchaînements et stratégie.',
                    icon: Icons.sports_kabaddi_rounded,
                    topColor: const Color(0xFFBF360C),
                    bottomColor: const Color(0xFF870000),
                    tag: 'Combat',
                    tagIcon: Icons.flash_on_rounded,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const KyorugiScreen()),
                    ),
                  ),
                  const SizedBox(height: 14),
                  _LearnCard(
                    title: 'Hosinsul',
                    subtitle: 'Techniques de self-défense',
                    description:
                        'Méthodes de défense personnelle : dégagements, projections et contrôles. Requis pour certains passages.',
                    icon: Icons.shield_rounded,
                    topColor: const Color(0xFF283593),
                    bottomColor: const Color(0xFF0D1B54),
                    tag: 'Défense',
                    tagIcon: Icons.security_rounded,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const HosinsulScreen()),
                    ),
                  ),

                  const SizedBox(height: 28),

                  // ═════════ THÉORIE & CULTURE ═════════
                  const SectionLabel(label: 'THÉORIE & CULTURE'),
                  const SizedBox(height: 12),
                  _LearnCard(
                    title: 'Termes',
                    subtitle: 'Vocabulaire & techniques coréennes',
                    description:
                        'Apprenez les termes officiels : commandes, noms des techniques de pied et de poing, positions et déplacements.',
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
                  const SizedBox(height: 14),
                  _LearnCard(
                    title: 'Histoire',
                    subtitle: 'Origines & évolution du Taekwondo',
                    description:
                        'Des arts martiaux coréens anciens (Taekkyeon, Subak) jusqu\'à la reconnaissance olympique du Taekwondo moderne.',
                    icon: Icons.history_edu_rounded,
                    topColor: const Color(0xFFBF360C),
                    bottomColor: const Color(0xFF601818),
                    tag: 'Monde',
                    tagIcon: Icons.public_rounded,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const TaekwondoHistoryScreen()),
                    ),
                  ),
                  const SizedBox(height: 14),
                  _LearnCard(
                    title: 'Histoire fédérale',
                    subtitle: 'Chronologie FFTDA — France',
                    description:
                        'Grandes dates du Taekwondo en France : de l\'introduction en 1968 aux médailles olympiques de Paris 2024.',
                    icon: Icons.flag_rounded,
                    topColor: const Color(0xFF0D47A1),
                    bottomColor: const Color(0xFF0A1628),
                    tag: 'FFTDA',
                    tagIcon: Icons.verified_rounded,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) =>
                              const TaekwondoHistoryScreen.federal()),
                    ),
                  ),

                  const SizedBox(height: 28),

                  // ═════════ RÉGLEMENTATION ═════════
                  const SectionLabel(label: 'RÉGLEMENTATION'),
                  const SizedBox(height: 12),
                  _LearnCard(
                    title: 'Règles de compétition',
                    subtitle: 'Arbitrage · Points · Pénalités',
                    description:
                        'Maîtrisez les règles officielles : zones de marque, pénalités, système de points et déroulement d\'un combat.',
                    icon: Icons.gavel_rounded,
                    topColor: const Color(0xFF283593),
                    bottomColor: const Color(0xFF1A237E),
                    tag: 'Règlement',
                    tagIcon: Icons.verified_rounded,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const TaekwondoRulesScreen()),
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

class _LearnCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String description;
  final IconData icon;
  final Color topColor;
  final Color bottomColor;
  final String tag;
  final IconData tagIcon;
  final VoidCallback onTap;

  const _LearnCard({
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
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.25),
                        width: 1.5,
                      ),
                    ),
                    child: Icon(icon, size: 26, color: Colors.white),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            letterSpacing: 0.3,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          subtitle,
                          style: TextStyle(
                            fontSize: 11.5,
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
              const SizedBox(height: 12),
              Container(
                height: 1,
                color: Colors.white.withOpacity(0.15),
              ),
              const SizedBox(height: 12),
              Text(
                description,
                style: TextStyle(
                  fontSize: 12.5,
                  color: Colors.white.withOpacity(0.85),
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 14),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 7),
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
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(width: 6),
                        Icon(Icons.arrow_forward_rounded,
                            color: Colors.white, size: 15),
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
