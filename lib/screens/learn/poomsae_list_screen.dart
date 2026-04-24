import 'package:flutter/material.dart';
import '../app_shell.dart';
import 'video_screen.dart';

class PoomsaeListScreen extends StatelessWidget {
  const PoomsaeListScreen({super.key});

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
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          const AppShellAppBar(
            title: 'POOMSAE',
            subtitle: 'Formes techniques officielles',
            icon: Icons.sports_martial_arts_rounded,
            showBack: true,
          ),
          ..._buildBeltGroups(context),
        ],
      ),
    );
  }

  List<Widget> _buildBeltGroups(BuildContext context) {
    final groups = <String, List<Map>>{
      'Jaune': [],
      'Bleu': [],
      'Rouge': [],
      'Noire': []
    };
    for (final p in _poomsaes) {
      groups[p['belt'] as String]?.add(p);
    }

    final slivers = <Widget>[];
    groups.forEach((belt, items) {
      if (items.isEmpty) return;

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
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            children: [
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
