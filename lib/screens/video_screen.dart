import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart'; // Package pour intégrer les vidéos YouTube

class VideoScreen extends StatefulWidget {
  final String title;
  final String videoUrl;

  VideoScreen({required this.title, required this.videoUrl});

  @override
  _VideoScreenState createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();

    final Uri uri = Uri.parse(widget.videoUrl);
    final String videoId = YoutubePlayer.convertUrlToId(widget.videoUrl)!;
    final int startAt = int.tryParse(uri.queryParameters['t']?.replaceAll('s', '') ?? '0') ?? 0;

    _controller = YoutubePlayerController(
      initialVideoId: videoId,
      flags: YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
        startAt: startAt,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: YoutubePlayer(
        controller: _controller,
        showVideoProgressIndicator: true,
        progressIndicatorColor: Colors.blueAccent,
      ),
    );
  }
}
