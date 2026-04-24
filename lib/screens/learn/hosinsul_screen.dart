import 'package:flutter/material.dart';
import '../app_shell.dart';

class HosinsulScreen extends StatelessWidget {
  const HosinsulScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: CustomScrollView(
        physics: BouncingScrollPhysics(),
        slivers: [
          AppShellAppBar(
            title: 'HOSINSUL',
            subtitle: 'Self-défense',
            icon: Icons.shield_rounded,
            iconAccent: Color(0xFF283593),
            showBack: true,
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _ComingSoonCard(
                    color: Color(0xFF283593),
                    icon: Icons.shield_rounded,
                    title: 'Contenu en préparation',
                    description:
                        'Les fiches Hosinsul arrivent bientôt : dégagements face aux saisies, esquives, clés et projections. Obligatoire aux passages de DAN.',
                  ),
                  SizedBox(height: 20),
                  SectionLabel(label: 'SOMMAIRE PRÉVU'),
                  SizedBox(height: 14),
                  _SectionPreview(
                    title: 'Saisies de poignet',
                    description: 'Dégagements et contrôles',
                    icon: Icons.pan_tool_rounded,
                  ),
                  SizedBox(height: 10),
                  _SectionPreview(
                    title: 'Étranglements',
                    description: 'Face, arrière, latéral',
                    icon: Icons.warning_amber_rounded,
                  ),
                  SizedBox(height: 10),
                  _SectionPreview(
                    title: 'Projections (Nakpop)',
                    description: 'Techniques de chute et projection',
                    icon: Icons.swap_vert_rounded,
                  ),
                  SizedBox(height: 10),
                  _SectionPreview(
                    title: 'Clés articulaires',
                    description: 'Contrôles au sol et debout',
                    icon: Icons.lock_rounded,
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

class _ComingSoonCard extends StatelessWidget {
  final Color color;
  final IconData icon;
  final String title;
  final String description;

  const _ComingSoonCard({
    required this.color,
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(20),
      elevation: 4,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [color, color.withOpacity(0.7)],
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.all(22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 54,
                  height: 54,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.3),
                      width: 1.5,
                    ),
                  ),
                  child: Icon(icon, color: Colors.white, size: 28),
                ),
                const SizedBox(width: 14),
                const Expanded(
                  child: Text(
                    'BIENTÔT DISPONIBLE',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 2,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              description,
              style: TextStyle(
                color: Colors.white.withOpacity(0.88),
                fontSize: 13,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionPreview extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  const _SectionPreview({
    required this.title,
    required this.description,
    required this.icon,
  });
  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(12),
      color: Colors.white,
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: const Color(0xFF283593).withOpacity(0.1),
                borderRadius: BorderRadius.circular(11),
              ),
              child: Icon(icon, color: const Color(0xFF283593)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                          fontWeight: FontWeight.w700, fontSize: 14)),
                  const SizedBox(height: 2),
                  Text(
                    description,
                    style: TextStyle(
                        fontSize: 12, color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),
            const Icon(Icons.schedule_rounded,
                color: Colors.grey, size: 18),
          ],
        ),
      ),
    );
  }
}
