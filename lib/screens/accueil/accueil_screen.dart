import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../notifiers/progress_notifier.dart';
import '../app_shell.dart';
import '../common/search_screen.dart';
import '../common/settings_screen.dart';
import '../learn/poomsae_list_screen.dart';
import '../learn/belt_selection_for_learning_screen.dart';
import '../progression/belt_requirements_screen.dart';
import '../progression/enfants_screen.dart';
import '../progression/my_progress_screen.dart';
import '../training/training_hub_screen.dart';

class AccueilScreen extends StatelessWidget {
  const AccueilScreen({super.key});

  static const Color _navyDark = Color(0xFF0A1628);
  static const Color _accentRed = Color(0xFFCC1122);

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverAppBar(
          expandedHeight: screenHeight * 0.22,
          floating: false,
          pinned: true,
          backgroundColor: _navyDark,
          elevation: 0,
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
              tooltip: 'Rechercher',
              icon: const Icon(Icons.search_rounded, color: Colors.white),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SearchScreen()),
              ),
            ),
            IconButton(
              tooltip: 'Paramètres',
              icon: const Icon(Icons.settings_rounded, color: Colors.white),
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
                  colors: [
                    _navyDark,
                    Color(0xFF162840),
                    _navyDark,
                  ],
                ),
                image: DecorationImage(
                  image: AssetImage('assets/images/background_poster.png'),
                  fit: BoxFit.cover,
                  opacity: 0.10,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 56, 24, 16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 56,
                          height: 56,
                          decoration: BoxDecoration(
                            color: _accentRed.withOpacity(0.18),
                            borderRadius: BorderRadius.circular(28),
                            border: Border.all(
                              color: _accentRed.withOpacity(0.7),
                              width: 2.5,
                            ),
                          ),
                          child: const Icon(
                            Icons.sports_martial_arts_rounded,
                            color: Colors.white,
                            size: 28,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'DOJANG',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                                letterSpacing: 5,
                              ),
                            ),
                            Row(
                              children: [
                                Container(
                                  width: 28,
                                  height: 2,
                                  color: _accentRed,
                                ),
                                const SizedBox(width: 8),
                                const Text(
                                  'TAEKWONDO',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w300,
                                    color: _accentRed,
                                    letterSpacing: 4,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
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
                // Carte ceinture actuelle
                const _CurrentBeltCard(),
                const SizedBox(height: 20),
                const SectionLabel(label: 'ACCÈS RAPIDE'),
                const SizedBox(height: 14),
                _QuickAccessGrid(
                  items: [
                    _QuickAccessItem(
                      title: 'QCM',
                      icon: Icons.quiz_rounded,
                      color: const Color(0xFF1565C0),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const TrainingHubScreen()),
                      ),
                    ),
                    _QuickAccessItem(
                      title: 'Termes',
                      icon: Icons.translate_rounded,
                      color: const Color(0xFF00695C),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) =>
                                const BeltSelectionForLeaningScreen()),
                      ),
                    ),
                    _QuickAccessItem(
                      title: 'Poomsae',
                      icon: Icons.play_circle_filled_rounded,
                      color: const Color(0xFF6A1B9A),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const PoomsaeListScreen()),
                      ),
                    ),
                    _QuickAccessItem(
                      title: 'Critères',
                      icon: Icons.workspace_premium_rounded,
                      color: const Color(0xFFB8860B),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const BeltRequirementsScreen()),
                      ),
                    ),
                    _QuickAccessItem(
                      title: 'Enfants',
                      icon: Icons.child_care_rounded,
                      color: const Color(0xFF6A1B9A),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const EnfantsScreen()),
                      ),
                    ),
                    _QuickAccessItem(
                      title: 'Progression',
                      icon: Icons.trending_up_rounded,
                      color: const Color(0xFF2E7D32),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const MyProgressScreen()),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                const SectionLabel(label: 'ASTUCE DU JOUR'),
                const SizedBox(height: 12),
                _TipCard(),
                const SizedBox(height: 24),
                const _LastActivityCard(),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _CurrentBeltCard extends StatelessWidget {
  const _CurrentBeltCard();

  @override
  Widget build(BuildContext context) {
    return Consumer<ProgressNotifier>(
      builder: (context, progress, _) {
        final belt = progress.currentBeltId;
        final hasBelt = belt.isNotEmpty && belt != 'none';
        return Material(
          borderRadius: BorderRadius.circular(20),
          elevation: 6,
          shadowColor: Colors.black.withOpacity(0.2),
          child: InkWell(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const MyProgressScreen()),
            ),
            borderRadius: BorderRadius.circular(20),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF0A1628), Color(0xFF162840)],
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Container(
                    width: 58,
                    height: 58,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.25),
                        width: 1.5,
                      ),
                    ),
                    child: const Icon(
                      Icons.military_tech_rounded,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          hasBelt ? 'Ma ceinture actuelle' : 'Ma progression',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.65),
                            fontSize: 12,
                            letterSpacing: 2,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          hasBelt
                              ? _prettyBeltName(belt)
                              : 'Définis ta ceinture',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 19,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          hasBelt
                              ? 'Suivre mes objectifs →'
                              : 'Configure dans Paramètres',
                          style: const TextStyle(
                            color: Color(0xFFCC1122),
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.arrow_forward_ios_rounded,
                      color: Colors.white54, size: 14),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  String _prettyBeltName(String id) {
    switch (id) {
      case '14K':
        return 'Ceinture jaune (14ᵉ keup)';
      case '13K':
        return 'Jaune barrette orange (13ᵉ)';
      case '12K':
        return 'Ceinture orange (12ᵉ)';
      case '11K':
        return 'Orange barrette verte (11ᵉ)';
      case '10K':
        return 'Ceinture verte (10ᵉ)';
      case '9K':
        return 'Verte barrette violette (9ᵉ)';
      case '8K':
        return 'Ceinture violette (8ᵉ)';
      case '7K':
        return 'Violette barrette bleue (7ᵉ)';
      case '6K':
        return 'Ceinture bleue (6ᵉ)';
      case '5K':
        return 'Bleue barrette rouge (5ᵉ)';
      case '4K':
        return 'Ceinture rouge (4ᵉ)';
      case '3K':
        return 'Rouge barrette noire (3ᵉ)';
      case '2K':
        return 'Rouge barrette noire (2ᵉ)';
      case '1K':
        return 'Rouge barrette noire (1ᵉ)';
      case '1D':
        return 'Ceinture noire 1ᵉʳ Dan';
      case '2D':
        return 'Ceinture noire 2ᵉ Dan';
      case '3D':
        return 'Ceinture noire 3ᵉ Dan';
      default:
        return id;
    }
  }
}

class _QuickAccessItem {
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  _QuickAccessItem({
    required this.title,
    required this.icon,
    required this.color,
    required this.onTap,
  });
}

class _QuickAccessGrid extends StatelessWidget {
  final List<_QuickAccessItem> items;
  const _QuickAccessGrid({required this.items});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 0.95,
      children: items
          .map((it) => Material(
                borderRadius: BorderRadius.circular(16),
                elevation: 2,
                shadowColor: Colors.black.withOpacity(0.12),
                color: Colors.white,
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: it.onTap,
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: it.color.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(it.icon, color: it.color, size: 22),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          it.title,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF0A1628),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ))
          .toList(),
    );
  }
}

class _TipCard extends StatelessWidget {
  static const _tips = [
    "Charyeot signifie « garde-à-vous » en coréen.",
    "Le Taekwondo est devenu sport olympique officiel en 2000 à Sydney.",
    "Ap chagui = coup de pied de face (direct).",
    "Les 17 positions de base (Seogui) sont la fondation de toutes les techniques.",
    "Le code moral : Courtoisie, Intégrité, Persévérance, Maîtrise de soi, Esprit indomptable.",
    "Taegeuk signifie « grand suprême » — les 8 poomsae représentent les trigrammes du I Ching.",
    "Kihap = cri qui canalise l'énergie pendant l'exécution technique.",
    "Dobok = tenue traditionnelle. Tti = ceinture.",
  ];

  @override
  Widget build(BuildContext context) {
    final idx = DateTime.now().day % _tips.length;
    return Material(
      borderRadius: BorderRadius.circular(16),
      elevation: 2,
      shadowColor: Colors.black.withOpacity(0.1),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: const Color(0xFFFFF3CD),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.lightbulb_rounded,
                  color: Color(0xFFB8860B), size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                _tips[idx],
                style: const TextStyle(
                  fontSize: 13,
                  height: 1.5,
                  color: Color(0xFF0A1628),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LastActivityCard extends StatelessWidget {
  const _LastActivityCard();

  @override
  Widget build(BuildContext context) {
    return Consumer<ProgressNotifier>(
      builder: (context, progress, _) {
        final label = progress.progress.lastActivityLabel;
        if (label == null || label.isEmpty) return const SizedBox.shrink();
        return Material(
          borderRadius: BorderRadius.circular(16),
          elevation: 2,
          shadowColor: Colors.black.withOpacity(0.1),
          color: Colors.white,
          child: ListTile(
            leading: Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: const Color(0xFF0A1628).withOpacity(0.08),
                borderRadius: BorderRadius.circular(11),
              ),
              child: const Icon(Icons.restart_alt_rounded,
                  color: Color(0xFF0A1628)),
            ),
            title: const Text('Continuer',
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 13,
                  letterSpacing: 1.5,
                  color: Color(0xFF37474F),
                )),
            subtitle: Text(label,
                style: const TextStyle(
                    fontSize: 14, fontWeight: FontWeight.w600)),
            trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16)),
          ),
        );
      },
    );
  }
}
