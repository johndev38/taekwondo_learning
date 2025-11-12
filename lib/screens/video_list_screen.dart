import 'package:flutter/material.dart';
import 'video_screen.dart';

class VideoListScreen extends StatefulWidget {
  const VideoListScreen({super.key});

  @override
  State<VideoListScreen> createState() => _VideoListScreenState();
}

class _VideoListScreenState extends State<VideoListScreen> {
  final List<Map<String, dynamic>> videos = [
    {
      'title': 'TAEGEUK1JANG',
      'videoPath': 'assets/videos/TAEGEUK1JANG.mp4',
      'startAt': 86,
      'endAt': 186,
    },
    {
      'title': 'TAEGEUK2JANG',
      'videoPath': 'assets/videos/TAEGEUK2JANG.mp4',
      'startAt': 70,
      'endAt': 170,
    },
    {
      'title': 'TAEGEUK3JANG',
      'videoPath': 'assets/videos/TAEGEUK3JANG.mp4',
      'startAt': 76,
      'endAt': 176,
    },
    {
      'title': 'TAEGEUK4JANG',
      'videoPath': 'assets/videos/TAEGEUK4JANG.mp4',
      'startAt': 95,
      'endAt': 195,
    },
    {
      'title': 'TAEGEUK5JANG',
      'videoPath': 'assets/videos/TAEGEUK5JANG.mp4',
      'startAt': 76,
      'endAt': 176,
    },
    {
      'title': 'TAEGEUK6JANG',
      'videoPath': 'assets/videos/TAEGEUK6JANG.mp4',
      'startAt': 60,
      'endAt': 160,
    },
    {
      'title': 'TAEGEUK7JANG',
      'videoPath': 'assets/videos/TAEGEUK7JANG.mp4',
      'startAt': 65,
      'endAt': 165,
    },
    {
      'title': 'TAEGEUK8JANG',
      'videoPath': 'assets/videos/TAEGEUK8JANG.mp4',
      'startAt': 70,
      'endAt': 170,
    },
    {
      'title': 'KORYO',
      'videoPath': 'assets/videos/KORYO.mp4',
      'startAt': 53,
      'endAt': 153,
    },
    {
      'title': 'GEUMGANG',
      'videoPath': 'assets/videos/GEUMGANG.mp4',
      'startAt': 78,
      'endAt': 178,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    final double titleFontSize = screenWidth > 800
        ? 18
        : screenWidth > 600
            ? 16
            : 14;

    final int crossAxisCount = screenWidth > 800
        ? 3
        : screenWidth > 600
            ? 2
            : 1;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Poomsae'),
        backgroundColor: Colors.red.shade600,
        foregroundColor: Colors.white,
        centerTitle: true,
        elevation: 2,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.green.shade50, Colors.grey.shade100],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      childAspectRatio: crossAxisCount == 1 ? 3.5 : 3.0,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                    ),
                    itemCount: videos.length,
                    itemBuilder: (context, index) {
                      final item = videos[index];
                      final String title = item['title'] as String;
                      final String path = item['videoPath'] as String;
                      final int startAt = (item['startAt'] ?? 0) as int;
                      final int? endAt = item['endAt'] as int?;
                      final String belt = _beltForPoomsae(title);
                      final Color accent = _colorForBelt(belt);

                      return _VideoCard(
                        title: title,
                        beltLabel: belt,
                        accentColor: accent,
                        titleFontSize: titleFontSize,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => VideoScreen(
                                title: title,
                                videoPath: path,
                                startAt: startAt,
                                endAt: endAt,
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Détermine la ceinture à partir du titre du poomsae.
  /// - TAEGEUK1JANG, TAEGEUK2JANG => Jaune
  /// - TAEGEUK3JANG..5JANG => Bleu
  /// - TAEGEUK6JANG..7JANG => Rouge
  /// - TAEGEUK8JANG, KORYO, GEUMGANG => Noire
  String _beltForPoomsae(String title) {
    final up = title.toUpperCase().trim();

    if (up.startsWith('TAEGEUK')) {
      final n = _extractTaegeukNumber(up);
      if (n != null) {
        if (n <= 2) return 'Jaune';
        if (n >= 3 && n <= 5) return 'Bleu';
        if (n == 6 || n == 7) return 'Rouge';
        if (n == 8) return 'Noire';
      }
      // Valeur par défaut si parsing improbable
      return 'Noire';
    }

    // Poomsae supérieurs (ex: Koryo, Keumgang/Geumgang) => Noire
    if (up.startsWith('KORYO') ||
        up.startsWith('GEUMGANG') ||
        up.startsWith('KEUMGANG')) {
      return 'Noire';
    }

    return 'Noire';
  }

  /// Extrait le numéro dans "TAEGEUKxJANG"
  int? _extractTaegeukNumber(String upTitle) {
    // Cherche un chiffre entre "TAEGEUK" et "JANG"
    final reg = RegExp(r'TAEGEUK\s*([1-8])\s*JANG');
    final m = reg.firstMatch(upTitle);
    if (m != null) {
      return int.tryParse(m.group(1)!);
    }
    // Fallback: essaie de détecter un chiffre isolé
    final regAlt = RegExp(r'([1-8])');
    final mAlt = regAlt.firstMatch(upTitle);
    if (mAlt != null) {
      return int.tryParse(mAlt.group(1)!);
    }
    return null;
  }

  /// Couleur par ceinture
  Color _colorForBelt(String belt) {
    switch (belt) {
      case 'Jaune':
        return Colors.amber.shade600;
      case 'Bleu':
        return Colors.blue.shade600;
      case 'Rouge':
        return Colors.red.shade600;
      case 'Noire':
        return Colors.grey.shade900;
      default:
        return Colors.teal.shade600;
    }
  }
}

class _VideoCard extends StatelessWidget {
  final String title;
  final String beltLabel;
  final Color accentColor;
  final double titleFontSize;
  final VoidCallback onTap;

  const _VideoCard({
    required this.title,
    required this.beltLabel,
    required this.accentColor,
    required this.titleFontSize,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: Colors.grey.shade300, width: 1),
        ),
        child: Row(
          children: [
            // Bande couleur à gauche
            Container(
              width: 10,
              decoration: BoxDecoration(
                color: accentColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  bottomLeft: Radius.circular(16),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                child: Row(
                  children: [
                    // Pastille couleur
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: accentColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: textTheme.bodyMedium?.copyWith(
                              fontSize: titleFontSize,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Ceinture : $beltLabel',
                            style: textTheme.bodySmall?.copyWith(
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 16,
                      color: Colors.black38,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
