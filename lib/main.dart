import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Taekwondo QCM App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),
    );
  }
}


class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/background.PNG',  // Remplacez par le nom de votre image
            fit: BoxFit.cover,
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => VideoListScreen()),
                    );
                  },
                  child: Text('Regarder les vidéos'),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => BeltSelectionScreen()),
                    );
                  },
                  child: Text('Passer les QCM'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class BeltSelectionScreen extends StatelessWidget {
  final List<String> belts = [
    'Blanche',
    'Jaune',
    'Bleue',
    'Noire',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sélectionner la ceinture'),
      ),
      body: ListView.builder(
        itemCount: belts.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('Ceinture ${belts[index]}'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => QuizScreen(belt: belts[index]),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class QuizScreen extends StatefulWidget {
  final String belt;

  QuizScreen({required this.belt});

  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  List<dynamic> questions = [];

  @override
  void initState() {
    super.initState();
    loadQuestions();
  }

  Future<void> loadQuestions() async {
    final String response = await rootBundle.loadString('assets/questions.json');
    final data = await json.decode(response);
    setState(() {
      questions = data[widget.belt];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QCM Ceinture ${widget.belt}'),
      ),
      body: ListView.builder(
        itemCount: questions.length,
        itemBuilder: (context, index) {
          final question = questions[index];
          return ListTile(
            title: Text(question['question']),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => QuestionScreen(
                    question: question['question'],
                    options: List<String>.from(question['options']),
                    correctAnswer: question['correctAnswer'],
                    image: question['image'],
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

class QuestionScreen extends StatelessWidget {
  final String question;
  final List<String> options;
  final String correctAnswer;
  final String image;

  QuestionScreen({
    required this.question,
    required this.options,
    required this.correctAnswer,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QCM'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (image.isNotEmpty) Image.asset(image),
            SizedBox(height: 20),
            Text(
              question,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            ...options.map((option) => ListTile(
              title: Text(option),
              onTap: () {
                String message;
                if (option == correctAnswer) {
                  message = 'Bonne réponse !';
                } else {
                  message = 'Mauvaise réponse. La bonne réponse est : $correctAnswer';
                }
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Résultat'),
                      content: Text(message),
                      actions: [
                        TextButton(
                          child: Text('OK'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  },
                );
              },
            )),
          ],
        ),
      ),
    );
  }
}

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
    {'title': 'KORYO', 'url': 'https://www.youtube.com/watch?v=Gr_Je2ZkgkI&t=50s'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("YouTube Video List"),
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
