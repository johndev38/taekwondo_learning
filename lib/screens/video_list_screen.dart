import 'package:flutter/material.dart';
import 'video_screen.dart';

class VideoListScreen extends StatelessWidget {
  final List<Map<String, String>> videos = [
    {'title': 'TAEGEUK1JANG', 'url': 'https://www.youtube.com/watch?v=WhkjRruCBTo&t=86s'},
    {'title': 'TAEGEUK2JANG', 'url': 'https://www.youtube.com/watch?v=tGlrUplKHh8&t=70s'},
    {'title': 'TAEGEUK3JANG', 'url': 'https://www.youtube.com/watch?v=ksSqKt0UkWo&t=76s'},
    {'title': 'TAEGEUK4JANG', 'url': 'https://www.youtube.com/watch?v=Lt917gacJho&t=95s'},
    {'title': 'TAEGEUK5JANG', 'url': 'https://www.youtube.com/watch?v=ksSqKt0UkWo&t=76s'},
    {'title': 'TAEGEUK6JANG', 'url': 'https://www.youtube.com/watch?v=jcBwWo4wN7c&t=60s'},
    {'title': 'TAEGEUK7JANG', 'url': 'https://www.youtube.com/watch?v=6FUM1p6qqhQ&t=65s'},
    {'title': 'TAEGEUK8JANG', 'url': 'https://www.youtube.com/watch?v=Gr_Je2ZkgkI&t=70s'},
    {'title': 'KORYO', 'url': 'https://www.youtube.com/watch?v=mGa60JDtWmg&t=53s'},
    {'title': 'GEUMGANG', 'url': 'https://www.youtube.com/watch?v=CRGVSOmaQaY&t=78s'},
  ];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final double titleFontSize = screenWidth > 800 ? 18 : screenWidth > 600 ? 16 : 14;

    return Scaffold(
      appBar: AppBar(
        title: Text("YouTube Video List"),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: screenWidth > 600 ? 2 : 1,
            childAspectRatio: 4.5, // Hauteur réduite des cartes
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
