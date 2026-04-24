import 'package:flutter/material.dart';
import '../app_shell.dart';
import '../common/search_screen.dart';
import '../common/settings_screen.dart';
import '../training/module_b_review_screen.dart';
import 'belt_requirements_screen.dart';
import 'enfants_screen.dart';
import 'my_progress_screen.dart';

/// Hub de progression : parcours structurés par niveau (adultes / enfants / DAN)
/// + écran personnel « Ma progression ».
class ProgressionHubScreen extends StatelessWidget {
  const ProgressionHubScreen({super.key});

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
                    colors: [_navyDark, Color(0xFF1A3A1F)],
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
                        child: const Icon(Icons.trending_up_rounded,
                            color: Colors.white, size: 26),
                      ),
                      const SizedBox(width: 14),
                      const Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'PROGRESSION',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w900,
                                fontSize: 22,
                                letterSpacing: 3,
                              ),
                            ),
                            Text(
                              'Parcours par niveau',
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
                  // Ma progression (en tête)
                  _ProgressCard(
                    title: 'Ma progression',
                    subtitle: 'Mon parcours personnalisé',
                    description:
                        'Visualise ton avancement par ceinture, tes critères cochés et tes objectifs.',
                    icon: Icons.person_rounded,
                    topColor: const Color(0xFF0A1628),
                    bottomColor: const Color(0xFF162840),
                    tag: 'Moi',
                    tagIcon: Icons.account_circle_rounded,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const MyProgressScreen()),
                    ),
                  ),

                  const SizedBox(height: 28),

                  // ═════════ PARCOURS ═════════
                  const SectionLabel(label: 'PARCOURS'),
                  const SizedBox(height: 12),
                  _ProgressCard(
                    title: 'Adultes',
                    subtitle: 'Critères de passage Blanc → Noir',
                    description:
                        'Toutes les exigences par ceinture : positions, techniques, poomsae, combat et histoire.',
                    icon: Icons.workspace_premium_rounded,
                    topColor: const Color(0xFFB8860B),
                    bottomColor: const Color(0xFF7B5800),
                    tag: 'Adultes',
                    tagIcon: Icons.group_rounded,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const BeltRequirementsScreen()),
                    ),
                  ),
                  const SizedBox(height: 14),
                  _ProgressCard(
                    title: 'Enfants',
                    subtitle: 'Progression 14ᵉ → 6ᵉ keup',
                    description:
                        'Fiches officielles FFTDA enfants : positions, blocages, coups de pied, poomsae, combat, code moral.',
                    icon: Icons.child_care_rounded,
                    topColor: const Color(0xFF6A1B9A),
                    bottomColor: const Color(0xFF38006B),
                    tag: 'Enfants',
                    tagIcon: Icons.stars_rounded,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const EnfantsScreen()),
                    ),
                  ),
                  const SizedBox(height: 14),
                  _ProgressCard(
                    title: 'Ceinture noire (DAN)',
                    subtitle: 'Module B — fiches de révision',
                    description:
                        'Préparation aux passages 2ème et 3ème DAN : questions officielles + révision complète.',
                    icon: Icons.military_tech_rounded,
                    topColor: const Color(0xFF4A148C),
                    bottomColor: const Color(0xFF1A1040),
                    tag: 'DAN',
                    tagIcon: Icons.verified_rounded,
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

class _ProgressCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String description;
  final IconData icon;
  final Color topColor;
  final Color bottomColor;
  final String tag;
  final IconData tagIcon;
  final VoidCallback onTap;

  const _ProgressCard({
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
