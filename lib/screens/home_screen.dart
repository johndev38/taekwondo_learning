import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'qcm_selection_screen.dart';
import 'learning_hub_screen.dart';
import 'package:taekwondo_knowledge/screens/belt_requirements_screen.dart';
import 'video_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  static const Color _navyDark = Color(0xFF0A1628);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: _navyDark,
        statusBarIconBrightness: Brightness.light,
      ),
    );

    return Scaffold(
      backgroundColor: const Color(0xFFF0F2F5),
      body: IndexedStack(
        index: _selectedIndex,
        children: const [
          _AccueilView(),
          _PoomsaeView(),
        ],
      ),
      bottomNavigationBar: _AppBottomNav(
        currentIndex: _selectedIndex,
        onTap: (i) => setState(() => _selectedIndex = i),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
//  BARRE DE NAVIGATION
// ─────────────────────────────────────────────────────────────

class _AppBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const _AppBottomNav({required this.currentIndex, required this.onTap});

  static const Color _navyDark = Color(0xFF0A1628);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: _navyDark,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            blurRadius: 12,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            _NavItem(
              icon: Icons.home_rounded,
              label: 'Accueil',
              selected: currentIndex == 0,
              onTap: () => onTap(0),
            ),
            _NavItem(
              icon: Icons.sports_martial_arts_rounded,
              label: 'Poomsae',
              selected: currentIndex == 1,
              onTap: () => onTap(1),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  static const Color _accentRed = Color(0xFFCC1122);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        splashColor: _accentRed.withOpacity(0.15),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(
                color: selected ? _accentRed : Colors.transparent,
                width: 2.5,
              ),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: selected ? _accentRed : Colors.white38,
                size: 26,
              ),
              const SizedBox(height: 3),
              Text(
                label,
                style: TextStyle(
                  color: selected ? _accentRed : Colors.white38,
                  fontSize: 11,
                  fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
//  ONGLET ACCUEIL
// ─────────────────────────────────────────────────────────────

class _AccueilView extends StatelessWidget {
  const _AccueilView();

  static const Color _navyDark = Color(0xFF0A1628);
  static const Color _accentRed = Color(0xFFCC1122);

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        // ── Header officiel ──
        SliverAppBar(
          expandedHeight: screenHeight * 0.24,
          floating: false,
          pinned: true,
          backgroundColor: _navyDark,
          elevation: 0,
          flexibleSpace: FlexibleSpaceBar(
            collapseMode: CollapseMode.pin,
            titlePadding: const EdgeInsets.fromLTRB(20, 0, 20, 14),
            title: const Row(
              children: [
                Icon(Icons.sports_martial_arts_rounded,
                    color: Colors.white70, size: 18),
                SizedBox(width: 8),
                Text(
                  'DOJANG',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontSize: 18,
                    letterSpacing: 4,
                  ),
                ),
              ],
            ),
            background: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF0A1628), Color(0xFF162840), Color(0xFF0A1628)],
                ),
                image: DecorationImage(
                  image: AssetImage('assets/images/background_poster.png'),
                  fit: BoxFit.cover,
                  opacity: 0.12,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 56, 24, 56),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo + Nom
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 64,
                          height: 64,
                          decoration: BoxDecoration(
                            color: _accentRed.withOpacity(0.18),
                            borderRadius: BorderRadius.circular(32),
                            border: Border.all(
                              color: _accentRed.withOpacity(0.7),
                              width: 2.5,
                            ),
                          ),
                          child: const Icon(
                            Icons.sports_martial_arts_rounded,
                            color: Colors.white,
                            size: 32,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'DOJANG',
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                                letterSpacing: 5,
                              ),
                            ),
                            Row(
                              children: [
                                Container(
                                  width: 30,
                                  height: 2,
                                  color: _accentRed,
                                ),
                                const SizedBox(width: 8),
                                const Text(
                                  'TAEKWONDO',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w300,
                                    color: Color(0xFFCC1122),
                                    letterSpacing: 5,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Text(
                      'Votre guide officiel d\'entraînement',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.white.withOpacity(0.5),
                        letterSpacing: 1.2,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),

        // ── Contenu principal ──
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _SectionLabel(label: 'MODULES'),
                const SizedBox(height: 16),

                // QCM
                _BigCard(
                  title: 'QCM',
                  subtitle: 'Testez vos connaissances',
                  description: 'Termes · Module B',
                  icon: Icons.quiz_rounded,
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF1565C0), Color(0xFF0D47A1)],
                  ),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const QcmSelectionScreen()),
                  ),
                ),
                const SizedBox(height: 14),

                // Apprentissage
                _BigCard(
                  title: 'Apprentissage',
                  subtitle: 'Étude & révisions',
                  description: 'Kibon · Histoire · Règles',
                  icon: Icons.menu_book_rounded,
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF2E7D32), Color(0xFF1B5E20)],
                  ),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const LearningHubScreen()),
                  ),
                ),
                const SizedBox(height: 14),

                // Critères de passage
                _BigCard(
                  title: 'Critères de passage',
                  subtitle: 'Exigences par ceinture',
                  description: 'Blanc · Jaune · Orange · Vert · Bleu · Rouge · Noir',
                  icon: Icons.workspace_premium_rounded,
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFFB8860B), Color(0xFF7B5800)],
                  ),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const BeltRequirementsScreen()),
                  ),
                ),

                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────
//  ONGLET POOMSAE
// ─────────────────────────────────────────────────────────────

class _PoomsaeView extends StatelessWidget {
  const _PoomsaeView();

  static const _poomsaes = [
    {
      'title': 'TAEGEUK 1 JANG',
      'videoPath': 'assets/videos/TAEGEUK1JANG.mp4',
      'startAt': 86,
      'endAt': 186,
      'belt': 'Jaune',
      'keup': '8e keup',
    },
    {
      'title': 'TAEGEUK 2 JANG',
      'videoPath': 'assets/videos/TAEGEUK2JANG.mp4',
      'startAt': 70,
      'endAt': 170,
      'belt': 'Jaune',
      'keup': '7e keup',
    },
    {
      'title': 'TAEGEUK 3 JANG',
      'videoPath': 'assets/videos/TAEGEUK3JANG.mp4',
      'startAt': 76,
      'endAt': 176,
      'belt': 'Bleu',
      'keup': '6e keup',
    },
    {
      'title': 'TAEGEUK 4 JANG',
      'videoPath': 'assets/videos/TAEGEUK4JANG.mp4',
      'startAt': 95,
      'endAt': 195,
      'belt': 'Bleu',
      'keup': '5e keup',
    },
    {
      'title': 'TAEGEUK 5 JANG',
      'videoPath': 'assets/videos/TAEGEUK5JANG.mp4',
      'startAt': 76,
      'endAt': 176,
      'belt': 'Bleu',
      'keup': '4e keup',
    },
    {
      'title': 'TAEGEUK 6 JANG',
      'videoPath': 'assets/videos/TAEGEUK6JANG.mp4',
      'startAt': 60,
      'endAt': 160,
      'belt': 'Rouge',
      'keup': '3e keup',
    },
    {
      'title': 'TAEGEUK 7 JANG',
      'videoPath': 'assets/videos/TAEGEUK7JANG.mp4',
      'startAt': 65,
      'endAt': 165,
      'belt': 'Rouge',
      'keup': '2e keup',
    },
    {
      'title': 'TAEGEUK 8 JANG',
      'videoPath': 'assets/videos/TAEGEUK8JANG.mp4',
      'startAt': 70,
      'endAt': 170,
      'belt': 'Noire',
      'keup': '1e keup',
    },
    {
      'title': 'KORYO',
      'videoPath': 'assets/videos/KORYO.mp4',
      'startAt': 53,
      'endAt': 153,
      'belt': 'Noire',
      'keup': '1er Dan',
    },
    {
      'title': 'GEUMGANG',
      'videoPath': 'assets/videos/GEUMGANG.mp4',
      'startAt': 78,
      'endAt': 178,
      'belt': 'Noire',
      'keup': '2e Dan',
    },
  ];

  static Color _beltColor(String belt) {
    switch (belt) {
      case 'Jaune':
        return const Color(0xFFFFC107);
      case 'Bleu':
        return const Color(0xFF1565C0);
      case 'Rouge':
        return const Color(0xFFCC1122);
      case 'Noire':
        return const Color(0xFF1A1A1A);
      default:
        return const Color(0xFF546E7A);
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        // Header Poomsae
        SliverAppBar(
          pinned: true,
          expandedHeight: 120,
          backgroundColor: const Color(0xFF0A1628),
          elevation: 0,
          automaticallyImplyLeading: false,
          flexibleSpace: FlexibleSpaceBar(
            collapseMode: CollapseMode.pin,
            titlePadding: const EdgeInsets.fromLTRB(20, 0, 20, 14),
            title: const Row(
              children: [
                Icon(Icons.sports_martial_arts_rounded,
                    color: Colors.white70, size: 18),
                SizedBox(width: 8),
                Text(
                  'POOMSAE',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontSize: 18,
                    letterSpacing: 4,
                  ),
                ),
              ],
            ),
            background: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFF0A1628), Color(0xFF162840)],
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 48, 24, 16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Icon(Icons.sports_martial_arts_rounded,
                        color: Color(0xFFCC1122), size: 28),
                    const SizedBox(width: 12),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'POOMSAE',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                            fontSize: 26,
                            letterSpacing: 4,
                          ),
                        ),
                        Text(
                          '${_poomsaes.length} formes disponibles',
                          style: const TextStyle(
                            color: Colors.white54,
                            fontSize: 12,
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

        // Groupes par ceinture
        ..._buildBeltGroups(context),
      ],
    );
  }

  List<Widget> _buildBeltGroups(BuildContext context) {
    final groups = <String, List<Map>>{'Jaune': [], 'Bleu': [], 'Rouge': [], 'Noire': []};
    for (final p in _poomsaes) {
      groups[p['belt'] as String]?.add(p);
    }

    final slivers = <Widget>[];
    groups.forEach((belt, items) {
      if (items.isEmpty) return;

      // En-tête du groupe
      slivers.add(
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
            child: Row(
              children: [
                Container(
                  width: 14,
                  height: 14,
                  decoration: BoxDecoration(
                    color: _beltColor(belt),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  'Ceinture $belt',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF37474F),
                    letterSpacing: 1,
                  ),
                ),
              ],
            ),
          ),
        ),
      );

      // Liste des formes
      for (final item in items) {
        slivers.add(
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
              child: _PoomsaeCard(
                title: item['title'] as String,
                keup: item['keup'] as String,
                belt: item['belt'] as String,
                beltColor: _beltColor(item['belt'] as String),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => VideoScreen(
                      title: item['title'] as String,
                      videoPath: item['videoPath'] as String,
                      startAt: item['startAt'] as int,
                      endAt: item['endAt'] as int?,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      }
    });

    slivers.add(const SliverToBoxAdapter(child: SizedBox(height: 20)));
    return slivers;
  }
}

class _PoomsaeCard extends StatelessWidget {
  final String title;
  final String keup;
  final String belt;
  final Color beltColor;
  final VoidCallback onTap;

  const _PoomsaeCard({
    required this.title,
    required this.keup,
    required this.belt,
    required this.beltColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(14),
      elevation: 2,
      shadowColor: Colors.black.withOpacity(0.12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            children: [
              // Bande couleur ceinture
              Container(
                width: 6,
                height: 64,
                decoration: BoxDecoration(
                  color: beltColor,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(14),
                    bottomLeft: Radius.circular(14),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              // Icône play
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: beltColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.play_circle_rounded,
                  color: beltColor,
                  size: 24,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF0A1628),
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      keup,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(right: 14),
                child: Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 14,
                  color: Color(0xFFBBBBBB),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
//  WIDGETS RÉUTILISABLES
// ─────────────────────────────────────────────────────────────

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

class _BigCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String description;
  final IconData icon;
  final Gradient gradient;
  final VoidCallback onTap;

  const _BigCard({
    required this.title,
    required this.subtitle,
    required this.description,
    required this.icon,
    required this.gradient,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(20),
      elevation: 5,
      shadowColor: Colors.black.withOpacity(0.25),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          height: 116,
          decoration: BoxDecoration(
            gradient: gradient,
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          child: Row(
            children: [
              // Icône
              Container(
                width: 68,
                height: 68,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.25),
                    width: 1.5,
                  ),
                ),
                child: Icon(icon, size: 34, color: Colors.white),
              ),
              const SizedBox(width: 18),
              // Textes
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
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
                    const SizedBox(height: 3),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.white.withOpacity(0.75),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.18),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        description,
                        style: const TextStyle(
                          fontSize: 11,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios_rounded,
                  color: Colors.white60, size: 16),
            ],
          ),
        ),
      ),
    );
  }
}
