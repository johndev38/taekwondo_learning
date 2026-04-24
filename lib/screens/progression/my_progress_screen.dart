import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../notifiers/progress_notifier.dart';
import '../app_shell.dart';

class MyProgressScreen extends StatelessWidget {
  const MyProgressScreen({super.key});

  static const _belts = [
    ('14K', 'Jaune', Color(0xFFFFC107)),
    ('13K', 'Jaune barrette orange', Color(0xFFFFB300)),
    ('12K', 'Orange', Color(0xFFFF9800)),
    ('11K', 'Orange barrette verte', Color(0xFFFF7043)),
    ('10K', 'Verte', Color(0xFF43A047)),
    ('9K', 'Verte barrette violette', Color(0xFF2E7D32)),
    ('8K', 'Violette', Color(0xFF6A1B9A)),
    ('7K', 'Violette barrette bleue', Color(0xFF5E35B1)),
    ('6K', 'Bleue', Color(0xFF1565C0)),
    ('5K', 'Bleue barrette rouge', Color(0xFF0277BD)),
    ('4K', 'Rouge', Color(0xFFCC1122)),
    ('3K', 'Rouge barrette noire 1', Color(0xFFB71C1C)),
    ('2K', 'Rouge barrette noire 2', Color(0xFF8B0000)),
    ('1K', 'Rouge barrette noire 3', Color(0xFF6A0000)),
    ('1D', '1ᵉʳ Dan', Color(0xFF1A1A1A)),
    ('2D', '2ᵉ Dan', Color(0xFF0D0D0D)),
    ('3D', '3ᵉ Dan', Color(0xFF000000)),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Consumer<ProgressNotifier>(
        builder: (context, notifier, _) {
          return CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              const AppShellAppBar(
                title: 'MA PROGRESSION',
                subtitle: 'Mon parcours personnalisé',
                icon: Icons.person_rounded,
                iconAccent: Color(0xFF2E7D32),
                showBack: true,
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _CurrentBeltPicker(notifier: notifier),
                      const SizedBox(height: 24),
                      const SectionLabel(label: 'AVANCEMENT PAR CEINTURE'),
                      const SizedBox(height: 14),
                      ..._belts.map((b) => Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: _BeltProgressRow(
                              id: b.$1,
                              name: b.$2,
                              color: b.$3,
                              completedCount:
                                  notifier.completedCount(b.$1),
                              isCurrent: notifier.currentBeltId == b.$1,
                            ),
                          )),
                      const SizedBox(height: 20),
                      _FavoritesCounter(count: notifier.favorites.length),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _CurrentBeltPicker extends StatelessWidget {
  final ProgressNotifier notifier;
  const _CurrentBeltPicker({required this.notifier});

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(18),
      elevation: 3,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Ma ceinture actuelle',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w800,
                color: Color(0xFF37474F),
                letterSpacing: 1.8,
              ),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: notifier.currentBeltId == 'none'
                  ? null
                  : notifier.currentBeltId,
              isExpanded: true,
              hint: const Text('Sélectionner…'),
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color(0xFFF5F7FA),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: 14, vertical: 4),
              ),
              items: MyProgressScreen._belts
                  .map((b) => DropdownMenuItem(
                        value: b.$1,
                        child: Row(
                          children: [
                            Container(
                              width: 14,
                              height: 14,
                              decoration: BoxDecoration(
                                color: b.$3,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                                child: Text(b.$2,
                                    overflow: TextOverflow.ellipsis)),
                          ],
                        ),
                      ))
                  .toList(),
              onChanged: (v) {
                if (v != null) notifier.setCurrentBelt(v);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _BeltProgressRow extends StatelessWidget {
  final String id;
  final String name;
  final Color color;
  final int completedCount;
  final bool isCurrent;

  const _BeltProgressRow({
    required this.id,
    required this.name,
    required this.color,
    required this.completedCount,
    required this.isCurrent,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(14),
      elevation: isCurrent ? 4 : 1,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Container(
              width: 12,
              height: 38,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          name,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF0A1628),
                          ),
                        ),
                      ),
                      if (isCurrent)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: const Color(0xFFCC1122),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            'Actuelle',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    completedCount > 0
                        ? '$completedCount item(s) validé(s)'
                        : 'Non commencé',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FavoritesCounter extends StatelessWidget {
  final int count;
  const _FavoritesCounter({required this.count});

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(14),
      elevation: 1,
      color: Colors.white,
      child: ListTile(
        leading: Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: const Color(0xFFFFF3CD),
            borderRadius: BorderRadius.circular(11),
          ),
          child: const Icon(Icons.bookmark_rounded,
              color: Color(0xFFB8860B)),
        ),
        title: const Text('Mes favoris',
            style: TextStyle(fontWeight: FontWeight.w700)),
        subtitle: Text(count > 0 ? '$count élément(s)' : 'Aucun favori'),
        trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    );
  }
}
