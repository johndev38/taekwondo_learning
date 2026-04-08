import 'package:flutter/material.dart';
import 'term_learning_screen.dart';

class BeltSelectionForLeaningScreen extends StatelessWidget {
  const BeltSelectionForLeaningScreen({super.key});

  static const Color _navyDark = Color(0xFF0A1628);
  static const Color _accentRed = Color(0xFFCC1122);

  static const _groups = [
    _BeltGroup(
      family: 'Ceinture Jaune',
      image: 'assets/images/ceinture_jaune.png',
      topColor: Color(0xFFF9A825),
      bottomColor: Color(0xFFE65100),
      items: [
        _BeltItem('Jaune (9e keup)', '9e keup'),
        _BeltItem('Jaune 1ère barrette (8e keup)', '8e keup'),
        _BeltItem('Jaune 2ème barrette (7e keup)', '7e keup'),
      ],
    ),
    _BeltGroup(
      family: 'Ceinture Bleu',
      image: 'assets/images/ceinture_bleu.png',
      topColor: Color(0xFF1565C0),
      bottomColor: Color(0xFF0D47A1),
      items: [
        _BeltItem('Bleu (6e keup)', '6e keup'),
        _BeltItem('Bleu 1ère barrette (5e keup)', '5e keup'),
        _BeltItem('Bleu 2ème barrette (4e keup)', '4e keup'),
      ],
    ),
    _BeltGroup(
      family: 'Ceinture Rouge',
      image: 'assets/images/ceinture_rouge.png',
      topColor: Color(0xFFCC1122),
      bottomColor: Color(0xFF8B0000),
      items: [
        _BeltItem('Rouge (3e keup)', '3e keup'),
        _BeltItem('Rouge 1ère barrette (2e keup)', '2e keup'),
      ],
    ),
    _BeltGroup(
      family: 'Ceinture Noire',
      image: 'assets/images/ceinture_noire.png',
      topColor: Color(0xFF1A1A2E),
      bottomColor: Color(0xFF0A1628),
      items: [
        _BeltItem('Noire (1e keup)', '1er keup'),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFFF0F2F5),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // ── Header ──
          SliverAppBar(
            expandedHeight: screenHeight * 0.22,
            pinned: true,
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
              title: const Row(
                children: [
                  Icon(Icons.record_voice_over_rounded,
                      color: Colors.white70, size: 16),
                  SizedBox(width: 8),
                  Text(
                    'KIBON',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      fontSize: 18,
                      letterSpacing: 4,
                    ),
                  ),
                ],
              ),
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
                          _navyDark.withOpacity(0.6),
                          _navyDark.withOpacity(0.9),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 56, 24, 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'KIBON',
                          style: TextStyle(
                            fontSize: 34,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            letterSpacing: 5,
                          ),
                        ),
                        Row(
                          children: [
                            Container(
                                width: 32,
                                height: 2.5,
                                color: _accentRed),
                            const SizedBox(width: 8),
                            Text(
                              'VOCABULAIRE OFFICIEL',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w400,
                                color: Colors.white.withOpacity(0.6),
                                letterSpacing: 3,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Sélectionnez votre niveau de ceinture',
                          style: TextStyle(
                            fontSize: 13,
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

          // ── Groupes de ceintures ──
          ..._groups.map((group) => _buildGroup(context, group)),
          const SliverToBoxAdapter(child: SizedBox(height: 24)),
        ],
      ),
    );
  }

  Widget _buildGroup(BuildContext context, _BeltGroup group) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // En-tête de groupe avec image ceinture
            Container(
              height: 68,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [group.topColor, group.bottomColor],
                ),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  const SizedBox(width: 16),
                  // Image ceinture
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.asset(
                        group.image,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(
                      group.family.toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        fontSize: 16,
                        letterSpacing: 2,
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(right: 16),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '${group.items.length} niveau${group.items.length > 1 ? 'x' : ''}',
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
            // Éléments du groupe
            ...group.items.map((item) => _BeltItemCard(
                  item: item,
                  accentColor: group.topColor,
                  beltImage: group.image,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          TermLearningScreen(belt: item.beltKey),
                    ),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}

class _BeltGroup {
  final String family;
  final String image;
  final Color topColor;
  final Color bottomColor;
  final List<_BeltItem> items;

  const _BeltGroup({
    required this.family,
    required this.image,
    required this.topColor,
    required this.bottomColor,
    required this.items,
  });
}

class _BeltItem {
  final String beltKey;
  final String keup;

  const _BeltItem(this.beltKey, this.keup);
}

class _BeltItemCard extends StatelessWidget {
  final _BeltItem item;
  final Color accentColor;
  final String beltImage;
  final VoidCallback onTap;

  const _BeltItemCard({
    required this.item,
    required this.accentColor,
    required this.beltImage,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
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
              border: Border.all(
                color: accentColor.withOpacity(0.18),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                // Bande couleur
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
                // Image ceinture miniature
                Image.asset(
                  beltImage,
                  width: 32,
                  height: 32,
                  fit: BoxFit.contain,
                ),
                const SizedBox(width: 14),
                // Textes
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.beltKey,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF0A1628),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        item.keup,
                        style: TextStyle(
                          fontSize: 12,
                          color: accentColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                // Icône flashcard
                Container(
                  margin: const EdgeInsets.only(right: 12),
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: accentColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.style_rounded,
                    size: 16,
                    color: accentColor,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(right: 12),
                  child: Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 13,
                    color: Color(0xFFBBBBBB),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
