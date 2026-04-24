import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A1628),
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'À PROPOS',
          style: TextStyle(
            fontWeight: FontWeight.w900,
            fontSize: 17,
            letterSpacing: 3,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Material(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(18),
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF0A1628), Color(0xFF162840)],
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(Icons.sports_martial_arts_rounded,
                        color: Color(0xFFCC1122), size: 36),
                  ),
                  const SizedBox(height: 14),
                  const Text(
                    'DOJANG',
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 26,
                      letterSpacing: 5,
                      color: Color(0xFF0A1628),
                    ),
                  ),
                  const Text(
                    'TAEKWONDO',
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xFFCC1122),
                      letterSpacing: 4,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    'Version 1.0.0',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          const _Section(
            title: 'SOURCES OFFICIELLES',
            child: Text(
              'Les contenus techniques, les critères de passage, le lexique coréen et les questionnaires Module B sont basés sur les référentiels officiels de la FFTDA (Fédération Française de Taekwondo et Disciplines Associées).',
              style: TextStyle(height: 1.5, fontSize: 13),
            ),
          ),
          const SizedBox(height: 14),
          const _Section(
            title: 'UTILISATION',
            child: Text(
              'Application d\'entraînement et de révision pour pratiquants du Taekwondo, de la ceinture blanche au 3ᵉ Dan.',
              style: TextStyle(height: 1.5, fontSize: 13),
            ),
          ),
          const SizedBox(height: 14),
          const _Section(
            title: 'CONTENU',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _BulletLine('Référentiel officiel (positions, Tchagui, Maki, attaques)'),
                _BulletLine('Poomsae : vidéos Taegeuk 1 à 8, Koryo, Geumgang'),
                _BulletLine('Vocabulaire et termes coréens par ceinture'),
                _BulletLine('QCM interactifs par ceinture'),
                _BulletLine('Module B — 2ème et 3ème DAN (Q&R officielles)'),
                _BulletLine('Critères de passage adultes et enfants'),
                _BulletLine('Histoire et règles de compétition'),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Center(
            child: Text(
              '© ${DateTime.now().year} Dojang Taekwondo',
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 11,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  final String title;
  final Widget child;
  const _Section({required this.title, required this.child});
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).cardColor,
      borderRadius: BorderRadius.circular(14),
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w800,
                color: Color(0xFF37474F),
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 10),
            child,
          ],
        ),
      ),
    );
  }
}

class _BulletLine extends StatelessWidget {
  final String text;
  const _BulletLine(this.text);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 6, right: 8),
            child: Icon(Icons.circle, size: 6, color: Color(0xFFCC1122)),
          ),
          Expanded(
              child: Text(text,
                  style: const TextStyle(height: 1.5, fontSize: 13))),
        ],
      ),
    );
  }
}
