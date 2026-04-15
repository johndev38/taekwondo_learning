import 'package:flutter/material.dart';
import 'question_type_selection_screen.dart';

class BeltSelectionScreen extends StatelessWidget {
  static const List<Map<String, String>> belts = [
    {'name': 'Jaune (9e keup)', 'file': 'questions_jaune.json'},
    {
      'name': 'Jaune 1ère barrette (8e keup)',
      'file': 'questions_jaune_barrette1.json'
    },
    {
      'name': 'Jaune 2ème barrette (7e keup)',
      'file': 'questions_jaune_barrette2.json'
    },
    {'name': 'Bleu (6e keup)', 'file': 'questions_bleu.json'},
    {
      'name': 'Bleu 1ère barrette (5e keup)',
      'file': 'questions_bleu_barrette1.json'
    },
    {
      'name': 'Bleu 2ème barrette (4e keup)',
      'file': 'questions_bleu_barrette2.json'
    },
    {'name': 'Rouge (3e keup)', 'file': 'questions_rouge.json'},
    {
      'name': 'Rouge 1ère barrette (2e keup)',
      'file': 'questions_rouge_barrette1.json'
    },
    {'name': 'Noire (1e keup)', 'file': 'questions_noire.json'},
  ];

  static const _groups = [
    _BeltGroup(
      family: 'Ceinture Jaune',
      image: 'assets/images/ceinture_jaune.png',
      topColor: Color(0xFFF9A825),
      bottomColor: Color(0xFFE65100),
      indices: [0, 1, 2],
    ),
    _BeltGroup(
      family: 'Ceinture Bleu',
      image: 'assets/images/ceinture_bleu.png',
      topColor: Color(0xFF1565C0),
      bottomColor: Color(0xFF0D47A1),
      indices: [3, 4, 5],
    ),
    _BeltGroup(
      family: 'Ceinture Rouge',
      image: 'assets/images/ceinture_rouge.png',
      topColor: Color(0xFFCC1122),
      bottomColor: Color(0xFF8B0000),
      indices: [6, 7],
    ),
    _BeltGroup(
      family: 'Ceinture Noire',
      image: 'assets/images/ceinture_noire.png',
      topColor: Color(0xFF1A1A2E),
      bottomColor: Color(0xFF0A1628),
      indices: [8],
    ),
  ];

  const BeltSelectionScreen({super.key});

  static const Color _navy = Color(0xFF0A1628);
  static const Color _red = Color(0xFFCC1122);

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFFF0F2F5),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            expandedHeight: screenHeight * 0.2,
            pinned: true,
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
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    'assets/images/background_poster.png',
                    fit: BoxFit.cover,
                    color: Colors.black.withOpacity(0.72),
                    colorBlendMode: BlendMode.darken,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          _navy.withOpacity(0.5),
                          _navy.withOpacity(0.95),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 52, 24, 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'QCM',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            letterSpacing: 5,
                          ),
                        ),
                        Row(children: [
                          Container(width: 28, height: 2.5, color: _red),
                          const SizedBox(width: 8),
                          Text(
                            'TERMES OFFICIELS',
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.white.withOpacity(0.6),
                              letterSpacing: 3,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ]),
                        const SizedBox(height: 6),
                        Text(
                          'Choisissez votre niveau de ceinture',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white.withOpacity(0.5),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          ..._groups.map((g) => _buildGroupSliver(context, g)),
          const SliverToBoxAdapter(child: SizedBox(height: 24)),
        ],
      ),
    );
  }

  Widget _buildGroupSliver(BuildContext context, _BeltGroup g) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Bannière groupe
            Container(
              height: 62,
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [g.topColor, g.bottomColor]),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  const SizedBox(width: 14),
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.asset(g.image, fit: BoxFit.contain),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      g.family.toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        fontSize: 15,
                        letterSpacing: 2,
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(right: 14),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.18),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '${g.indices.length} niveau${g.indices.length > 1 ? 'x' : ''}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            ...g.indices.map((i) {
              final belt = belts[i];
              final name = belt['name']!;
              final keup = _extractKeup(name);
              return _BeltItemCard(
                name: name,
                keup: keup,
                accentColor: g.topColor,
                beltImage: g.image,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => QuestionTypeSelectionScreen(
                      belt: name,
                      beltIndex: i,
                      belts: belts,
                      beltColor: g.topColor,
                      beltImage: g.image,
                    ),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  static String _extractKeup(String name) {
    final match = RegExp(r'\(.*\)').firstMatch(name);
    return match?.group(0) ?? '';
  }
}

class _BeltGroup {
  final String family;
  final String image;
  final Color topColor;
  final Color bottomColor;
  final List<int> indices;

  const _BeltGroup({
    required this.family,
    required this.image,
    required this.topColor,
    required this.bottomColor,
    required this.indices,
  });
}

class _BeltItemCard extends StatelessWidget {
  final String name;
  final String keup;
  final Color accentColor;
  final String beltImage;
  final VoidCallback onTap;

  const _BeltItemCard({
    required this.name,
    required this.keup,
    required this.accentColor,
    required this.beltImage,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final label = name.replaceAll(RegExp(r'\s*\(.*\)'), '');
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Material(
        borderRadius: BorderRadius.circular(12),
        elevation: 2,
        shadowColor: Colors.black.withOpacity(0.1),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            height: 62,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: accentColor.withOpacity(0.18)),
            ),
            child: Row(
              children: [
                Container(
                  width: 5,
                  decoration: BoxDecoration(
                    color: accentColor,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(12),
                      bottomLeft: Radius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Image.asset(beltImage,
                    width: 30, height: 30, fit: BoxFit.contain),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        label,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF0A1628),
                        ),
                      ),
                      if (keup.isNotEmpty)
                        Text(
                          keup,
                          style: TextStyle(
                            fontSize: 11,
                            color: accentColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(right: 12),
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: accentColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(Icons.quiz_rounded, size: 16, color: accentColor),
                ),
                const Padding(
                  padding: EdgeInsets.only(right: 12),
                  child: Icon(Icons.arrow_forward_ios_rounded,
                      size: 13, color: Color(0xFFBBBBBB)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
