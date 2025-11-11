import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';

class VideoScreen extends StatefulWidget {
  final String title;
  final String videoPath;
  final int startAt;
  final int? endAt;

  const VideoScreen({
    super.key,
    required this.title,
    required this.videoPath,
    this.startAt = 0,
    this.endAt,
  });

  @override
  _VideoScreenState createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  late VideoPlayerController _controller;
  bool _isPlayerReady = false;

  @override
  void initState() {
    super.initState();

    // Mode plein écran immersif : cache la barre de statut + barre de navigation
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.immersiveSticky,
    );

    _initializePlayer();
  }

  void _initializePlayer() async {
    _controller = VideoPlayerController.asset(widget.videoPath);
    await _controller.initialize();
    _controller.addListener(_listener);

    setState(() {
      _isPlayerReady = true;
    });

    // Si startAt > 0, aller directement au timestamp
    if (widget.startAt > 0) {
      _controller.seekTo(Duration(seconds: widget.startAt));
    }
  }

  void _listener() {
    // Gestion de endAt
    if (widget.endAt != null &&
        _controller.value.position.inSeconds >= widget.endAt!) {
      _controller.pause();
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.red.shade600,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Lecteur vidéo local
          Expanded(
            child: Stack(
              children: [
                Center(
                  child: _isPlayerReady
                      ? AspectRatio(
                          aspectRatio: _controller.value.aspectRatio,
                          child: VideoPlayer(_controller),
                        )
                      : Container(
                          color: Colors.black,
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const CircularProgressIndicator(
                                  color: Colors.red,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'Chargement de ${widget.title}...',
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        ),
                ),
                // Contrôles de lecture
                if (_isPlayerReady)
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      color: Colors.black54,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: Row(
                        children: [
                          IconButton(
                            icon: Icon(
                              _controller.value.isPlaying
                                  ? Icons.pause
                                  : Icons.play_arrow,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              setState(() {
                                _controller.value.isPlaying
                                    ? _controller.pause()
                                    : _controller.play();
                              });
                            },
                          ),
                          Expanded(
                            child: VideoProgressIndicator(
                              _controller,
                              allowScrubbing: true,
                              colors: VideoProgressColors(
                                playedColor: Colors.red,
                                bufferedColor: Colors.red.shade200,
                                backgroundColor: Colors.grey,
                              ),
                            ),
                          ),
                          Text(
                            '${_controller.value.position.inMinutes}:${(_controller.value.position.inSeconds % 60).toString().padLeft(2, '0')} / '
                            '${_controller.value.duration.inMinutes}:${(_controller.value.duration.inSeconds % 60).toString().padLeft(2, '0')}',
                            style: const TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();

    // Rétablir l’UI système quand on quitte l’écran vidéo
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.edgeToEdge, // ou SystemUiMode.manual avec overlays
    );

    super.dispose();
  }
}
