import 'package:flutter/material.dart';
import 'video_screen.dart';

class VideoListScreen extends StatelessWidget {
  final List<Map<String, String>> videos = [
    {'title': 'TAEGEUK1JANG', 'url': 'https://www.youtube.com/watch?v=WhkjRruCBTo&t=86s'},
    {'title': 'TAEGEUK2JANG', 'url': 'https://www.youtube.com/watch?v=tGlrUplKHh8&t=86s'},
    {'title': 'TAEGEUK3JANG', 'url': 'https://www.youtube.com/watch?v=ksSqKt0UkWo&t=76s'},
    {'title': 'TAEGEUK4JANG', 'url': 'https://www.youtube.com/watch?v=Lt917gacJho&t=95s'},
    {'title': 'TAEGEUK5JANG', 'url': 'https://www.youtube.com/watch?v=ksSqKt0UkWo&t=76s'},
    {'title': 'TAEGEUK6JANG', 'url': 'https://www.youtube.com/watch?v=jcBwWo4wN7c&t=60s'},
    {'title': 'TAEGEUK7JANG', 'url': 'https://www.youtube.com/watch?v=6FUM1p6qqhQ&t=65s'},
    {'title': 'TAEGEUK7JANG', 'url': 'https://www.youtube.com/watch?v=Gr_Je2ZkgkI&t=70s'},
    {'title': 'TAEGEUKJANG', 'url': 'https://www.youtube.com/watch?v=Gr_Je2ZkgkI&t=70s'},
    {'title': 'KORYO', 'url': 'https://www.youtube.com/watch?v=mGa60JDtWmg&t=52s'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("YouTube Video List"),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        itemCount: videos.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(videos[index]['title']!),
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
          );
        },
      ),
    );
  }
}
