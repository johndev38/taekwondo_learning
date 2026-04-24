import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../notifiers/belt_notifier.dart';
import 'video_screen.dart';

class HanbanListScreen extends StatefulWidget {
  final String? selectedBelt;

  const HanbanListScreen({super.key, this.selectedBelt});

  @override
  State<HanbanListScreen> createState() => _HanbanListScreenState();
}

class _HanbanListScreenState extends State<HanbanListScreen> {
  final List<Map<String, dynamic>> videos = [
    {
      'title': 'Ceinture jaune',
      'videoPath': 'assets/videos/CEINTURE_JAUNE.mp4',
      'startAt': 0,
      'endAt': null, // Laissez la vidéo complète ou ajustez selon besoin
    },
    {
      'title': 'Ceinture bleu',
      'videoPath': 'assets/videos/CEINTURE_BLEU.mp4',
      'startAt': 0,
      'endAt': null,
    },
    {
      'title': 'Ceinture rouge',
      'videoPath': 'assets/videos/CEINTURE_ROUGE.mp4',
      'startAt': 0,
      'endAt': null,
    },
  ];

  @override
  void initState() {
    super.initState();
    // Plus de navigation automatique - on reste sur la liste avec la recommandation en évidence
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final beltNotifier = Provider.of<BeltNotifier>(context);
    final currentBelt = widget.selectedBelt ?? beltNotifier.currentBelt;
    final recommendedHanbon =
        currentBelt != null ? beltNotifier.getHanbonForBelt(currentBelt) : null;

    final double titleFontSize = screenWidth > 800
        ? 18
        : screenWidth > 600
            ? 16
            : 14;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Hanbon Kyeurogui"),
        backgroundColor: Colors.purple.shade600,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Bandeau de recommandation si une ceinture est sélectionnée
          if (recommendedHanbon != null)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.purple.shade100, Colors.pink.shade100],
                ),
                border: Border(
                  bottom: BorderSide(color: Colors.purple.shade200),
                ),
              ),
              child: Row(
                children: [
                  Icon(Icons.star, color: Colors.purple.shade600, size: 24),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Recommandé pour votre ceinture',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.purple.shade700,
                          ),
                        ),
                        Text(
                          '$currentBelt → $recommendedHanbon',
                          style: TextStyle(
                            color: Colors.purple.shade600,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

          // Liste des vidéos
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: screenWidth > 600 ? 2 : 1,
                  childAspectRatio: 4.5,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemCount: videos.length,
                itemBuilder: (context, index) {
                  final isRecommended =
                      videos[index]['title'] == recommendedHanbon;

                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => VideoScreen(
                            title: videos[index]['title']!,
                            videoPath: videos[index]['videoPath']!,
                            startAt: videos[index]['startAt'] ?? 0,
                            endAt: videos[index]['endAt'],
                          ),
                        ),
                      );
                    },
                    child: Card(
                      elevation: isRecommended ? 8 : 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: isRecommended
                            ? BorderSide(
                                color: Colors.purple.shade400, width: 2)
                            : BorderSide.none,
                      ),
                      color: isRecommended
                          ? Colors.purple.shade50
                          : Colors.grey[50],
                      child: Container(
                        decoration: isRecommended
                            ? BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.purple.shade50,
                                    Colors.pink.shade50
                                  ],
                                ),
                              )
                            : null,
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 12.0, horizontal: 16.0),
                            child: Row(
                              children: [
                                if (isRecommended) ...[
                                  Icon(Icons.star,
                                      color: Colors.purple.shade600, size: 20),
                                  const SizedBox(width: 8),
                                ],
                                Expanded(
                                  child: Text(
                                    videos[index]['title']!,
                                    style: TextStyle(
                                      fontSize: titleFontSize,
                                      fontWeight: isRecommended
                                          ? FontWeight.bold
                                          : FontWeight.w500,
                                      color: isRecommended
                                          ? Colors.purple.shade700
                                          : Colors.black87,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
