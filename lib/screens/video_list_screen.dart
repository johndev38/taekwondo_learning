import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../notifiers/belt_notifier.dart';
import 'video_screen.dart';

class VideoListScreen extends StatefulWidget {
  final String? selectedBelt;

  const VideoListScreen({super.key, this.selectedBelt});

  @override
  _VideoListScreenState createState() => _VideoListScreenState();
}

class _VideoListScreenState extends State<VideoListScreen> {
  final List<Map<String, dynamic>> videos = [
    {
      'title': 'TAEGEUK1JANG',
      'videoPath': 'assets/videos/TAEGEUK1JANG.mp4',
      'startAt': 86, // Début en secondes
      'endAt': 186, // Fin en secondes (ajustez selon vos besoins)
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
  void initState() {
    super.initState();
    // Plus de navigation automatique - on reste sur la liste avec la recommandation en évidence
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final beltNotifier = Provider.of<BeltNotifier>(context);
    final currentBelt = widget.selectedBelt ?? beltNotifier.currentBelt;
    final recommendedPoomsae = currentBelt != null
        ? beltNotifier.getPoomsaeForBelt(currentBelt)
        : null;

    final double titleFontSize = screenWidth > 800
        ? 18
        : screenWidth > 600
            ? 16
            : 14;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Poomsae"),
        backgroundColor: Colors.red.shade600,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Bandeau de recommandation si une ceinture est sélectionnée
          if (recommendedPoomsae != null)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.amber.shade100, Colors.orange.shade100],
                ),
                border: Border(
                  bottom: BorderSide(color: Colors.orange.shade200),
                ),
              ),
              
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
                      videos[index]['title'] == recommendedPoomsae;

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
                                color: Colors.orange.shade400, width: 2)
                            : BorderSide.none,
                      ),
                      color: isRecommended
                          ? Colors.orange.shade50
                          : Colors.grey[50],
                      child: Container(
                        decoration: isRecommended
                            ? BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.orange.shade50,
                                    Colors.amber.shade50
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
                                      color: Colors.orange.shade600, size: 20),
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
                                          ? Colors.orange.shade700
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
