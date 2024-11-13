import 'package:flutter/material.dart';
import 'video_screen.dart';

class HanbanListScreen extends StatelessWidget {
  final List<Map<String, String>> videos = [
    {
      'title': 'Ceinture jaune',
      'url': 'https://www.youtube.com/watch?v=rfAxpm8Txeg&list=PLXRipegTJj_hVaAYodUbaP5VkxsiPUY_V&index=1'
    },
    {
      'title': 'Ceinture bleu',
      'url': 'https://www.youtube.com/watch?v=9XWVc8xbEHk&list=PLXRipegTJj_hVaAYodUbaP5VkxsiPUY_V&index=2'
    },
    {
      'title': 'Ceinture rouge',
      'url': 'https://www.youtube.com/watch?v=2j1xnHPVE8Q&list=PLXRipegTJj_hVaAYodUbaP5VkxsiPUY_V&index=3'
    },
  ];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final double titleFontSize = screenWidth > 800
        ? 18
        : screenWidth > 600
        ? 16
        : 14; // Ajustement de la taille de police pour les écrans plus petits

    return Scaffold(
      appBar: AppBar(
        title: Text("Hanbon Kyurugui"),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: screenWidth > 600 ? 2 : 1,
            childAspectRatio: 4.5, // Ratio élevé pour réduire la hauteur
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: videos.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => VideoScreen(
                      title: videos[index]['title']!,
                      videoUrl: videos[index]['url']!,
                    ),
                  ),
                );
              },
              child: Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                color: Colors.grey[50],
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                    child: Text(
                      videos[index]['title']!,
                      style: TextStyle(
                        fontSize: titleFontSize,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
