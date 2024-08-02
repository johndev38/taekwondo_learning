import 'dart:convert'; // Ce package Dart est utilisé pour convertir les données JSON en objets Dart.
import 'package:flutter/material.dart'; // Ce package Flutter est utilisé pour créer l'interface utilisateur.
import 'package:flutter/services.dart' show rootBundle; // Ce package Flutter est utilisé pour charger des fichiers depuis les assets de l'application.
import 'package:youtube_player_flutter/youtube_player_flutter.dart'; // Ce package Flutter permet d'intégrer des vidéos YouTube dans votre application.

// Le point d'entrée de l'application Flutter.
// La fonction `main` appelle la fonction `runApp` qui fait tourner l'application Flutter.
void main() {
  runApp(MyApp()); // `MyApp` est le widget racine de l'application.
}

// `MyApp` est un widget sans état (StatelessWidget) qui définit la structure de base de l'application.
class MyApp extends StatelessWidget {
  // La méthode `build` est appelée pour construire l'interface utilisateur de ce widget.
  @override
  Widget build(BuildContext context) {
    // `MaterialApp` est un widget qui enveloppe l'application entière et définit des éléments comme le thème, les routes, etc.
    return MaterialApp(
      title: 'Taekwondo QCM App', // Titre de l'application
      theme: ThemeData(
        primarySwatch: Colors.blue, // Définition de la couleur principale de l'application
      ),
      home: HomeScreen(), // L'écran d'accueil de l'application est défini ici.
    );
  }
}

// `HomeScreen` est le widget qui représente l'écran d'accueil de l'application.
// C'est un widget sans état car son contenu ne change pas dynamiquement.
class HomeScreen extends StatelessWidget {
  // La méthode `build` décrit comment construire l'interface utilisateur de cet écran.
  @override
  Widget build(BuildContext context) {
    return Scaffold( // `Scaffold` est un widget Flutter qui fournit une structure de base pour une page (barre d'applications, corps, etc.).
      body: Stack( // `Stack` permet de superposer plusieurs widgets les uns sur les autres.
        fit: StackFit.expand, // Fait en sorte que tous les widgets enfants s'étendent pour remplir l'espace disponible.
        children: [
          // `Image.asset` est utilisé pour afficher une image provenant des assets de l'application.
          Image.asset(
            'assets/images/background.PNG', // Chemin de l'image dans le dossier assets.
            fit: BoxFit.cover, // L'image couvre toute la surface disponible.
          ),
          Center( // `Center` permet de centrer son contenu.
            child: Column( // `Column` organise les widgets enfants en une colonne verticale.
              mainAxisAlignment: MainAxisAlignment.center, // Aligne les widgets enfants au centre de la colonne.
              children: [
                ElevatedButton(
                  // `onPressed` est une fonction callback appelée lorsqu'on appuie sur le bouton.
                  onPressed: () {
                    // `Navigator.push` permet de naviguer vers un nouvel écran en ajoutant celui-ci à la pile de navigation.
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => VideoListScreen()), // Navigue vers l'écran qui liste les vidéos.
                    );
                  },
                  child: Text('Regarder les vidéos'), // Texte affiché sur le bouton.
                ),
                SizedBox(height: 20), // `SizedBox` ajoute un espace vide de 20 pixels entre les widgets.
                ElevatedButton(
                  onPressed: () {
                    // Navigue vers l'écran de sélection de la ceinture pour passer le QCM.
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => BeltSelectionScreen()),
                    );
                  },
                  child: Text('Passer les QCM'), // Texte affiché sur le bouton.
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// `BeltSelectionScreen` permet à l'utilisateur de choisir une ceinture pour passer le QCM correspondant.
// C'est un widget sans état car son contenu ne change pas dynamiquement.
class BeltSelectionScreen extends StatelessWidget {
  // `belts` est une liste de chaînes de caractères représentant les ceintures disponibles.
  final List<String> belts = [
    'Blanche',
    'Jaune',
    'Bleue',
    'Noire',
  ];

  // La méthode `build` décrit comment construire l'interface utilisateur de cet écran.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar( // `AppBar` est une barre d'application en haut de l'écran.
        title: Text('Sélectionner la ceinture'), // Titre affiché dans la barre d'application.
      ),
      body: ListView.builder( // `ListView.builder` est utilisé pour construire dynamiquement une liste de widgets.
        itemCount: belts.length, // Le nombre d'éléments dans la liste est égal au nombre de ceintures.
        itemBuilder: (context, index) {
          // `ListTile` est un widget qui représente une ligne d'une liste.
          return ListTile(
            title: Text('Ceinture ${belts[index]}'), // Affiche le nom de la ceinture.
            onTap: () {
              // Lorsque l'utilisateur appuie sur une ceinture, il est redirigé vers le QCM de cette ceinture.
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => QuizGameScreen(belt: belts[index]), // Passe la ceinture sélectionnée au widget QuizGameScreen.
                ),
              );
            },
          );
        },
      ),
    );
  }
}

// `QuizGameScreen` gère le QCM pour la ceinture sélectionnée.
// C'est un widget avec état (StatefulWidget) car son contenu change dynamiquement (questions, score, etc.).
class QuizGameScreen extends StatefulWidget {
  // La ceinture sélectionnée est passée à ce widget via le constructeur.
  final String belt;

  QuizGameScreen({required this.belt});

  // `createState` crée l'état associé à ce widget.
  @override
  _QuizGameScreenState createState() => _QuizGameScreenState();
}

// L'état associé à `QuizGameScreen` est géré par `_QuizGameScreenState`.
class _QuizGameScreenState extends State<QuizGameScreen> {
  List<dynamic> questions = []; // Liste des questions pour la ceinture sélectionnée.
  int currentQuestionIndex = 0; // Index de la question actuelle dans la liste des questions.
  int score = 0; // Score de l'utilisateur.
  bool isGameOver = false; // Indique si le jeu est terminé.

  // `initState` est appelé une seule fois lorsque l'état est initialisé.
  @override
  void initState() {
    super.initState();
    loadQuestions(); // Charge les questions lors de l'initialisation de l'état.
  }

  // `loadQuestions` est une fonction asynchrone qui charge les questions depuis un fichier JSON.
  Future<void> loadQuestions() async {
    final String response = await rootBundle.loadString('assets/questions.json'); // Charge le fichier JSON en tant que chaîne de caractères.
    final data = await json.decode(response); // Décode la chaîne JSON en un objet Dart (généralement une carte ou une liste).

    setState(() {
      questions = data[widget.belt].take(10).toList(); // Prend les 10 premières questions de la ceinture sélectionnée.

      if (questions.length < 10) {
        // Si le fichier JSON ne contient pas assez de questions, une exception est lancée.
        throw Exception("Not enough questions for the selected belt in the JSON file.");
      }
    });
  }

  // `checkAnswer` vérifie si la réponse sélectionnée par l'utilisateur est correcte.
  void checkAnswer(String selectedAnswer) {
    if (questions[currentQuestionIndex]['correctAnswer'] == selectedAnswer) {
      score++; // Augmente le score si la réponse est correcte.
    }

    if (currentQuestionIndex < questions.length - 1) {
      setState(() {
        currentQuestionIndex++; // Passe à la question suivante.
      });
    } else {
      setState(() {
        isGameOver = true; // Le jeu est terminé après avoir répondu à toutes les questions.
      });
    }
  }

  // La méthode `build` construit l'interface utilisateur pour ce widget.
  @override
  Widget build(BuildContext context) {
    if (isGameOver) {
      // Si le jeu est terminé, afficher un écran de fin de jeu avec le score final.
      return Scaffold(
        body: Center( // `Center` centre le contenu sur l'écran.
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Affiche un message en fonction du score de l'utilisateur.
              Text(
                score >= 8 ? 'Vous avez gagné !' : 'Vous avez perdu.',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20), // Espace entre les widgets.
              Text(
                'Votre score: $score/10',
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Permet à l'utilisateur de recommencer le jeu.
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => HomeScreen()), // Retourne à l'écran d'accueil.
                  );
                },
                child: Text('Recommencer'),
              ),
            ],
          ),
        ),
      );
    } else if (questions.isEmpty) {
      // Si les questions sont en cours de chargement, afficher un indicateur de progression.
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(), // Affiche un cercle de progression pendant le chargement.
        ),
      );
    } else {
      // Affiche la question actuelle avec les options de réponse.
      return Scaffold(
        appBar: AppBar( // Barre d'application avec le numéro de la question actuelle.
          title: Text('Question ${currentQuestionIndex + 1}/10'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0), // Ajoute un padding autour du contenu.
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, // Aligne les éléments au début de la colonne.
            children: [
              // Si une image est associée à la question, elle est affichée ici.
              if (questions[currentQuestionIndex]['image'] != null)
                Image.asset(questions[currentQuestionIndex]['image']),
              SizedBox(height: 20), // Espace entre l'image et la question.
              Text(
                questions[currentQuestionIndex]['question'], // Affiche la question.
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              // Génère une liste d'options de réponse.
              ...questions[currentQuestionIndex]['options']
                  .map<Widget>(
                    (option) => ListTile(
                  title: Text(option), // Affiche chaque option.
                  onTap: () => checkAnswer(option), // Vérifie la réponse lorsque l'utilisateur clique sur une option.
                ),
              )
                  .toList(),
            ],
          ),
        ),
      );
    }
  }
}

// `VideoListScreen` affiche une liste de vidéos Taekwondo disponibles.
// C'est un widget sans état car son contenu ne change pas dynamiquement.
class VideoListScreen extends StatelessWidget {
  // Liste de vidéos YouTube avec leurs titres et URLs.
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

  // La méthode `build` décrit comment construire l'interface utilisateur de cet écran.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar( // Barre d'application avec un titre.
        title: Text("YouTube Video List"),
      ),
      body: ListView.builder( // Crée une liste défilante de vidéos.
        itemCount: videos.length, // Nombre d'éléments dans la liste est égal au nombre de vidéos.
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(videos[index]['title']!), // Affiche le titre de la vidéo.
            onTap: () {
              // Lorsque l'utilisateur clique sur une vidéo, il est redirigé vers l'écran de lecture de cette vidéo.
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => VideoScreen(
                    title: videos[index]['title']!, // Passe le titre de la vidéo au widget VideoScreen.
                    videoUrl: videos[index]['url']!, // Passe l'URL de la vidéo au widget VideoScreen.
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

// `VideoScreen` joue la vidéo YouTube sélectionnée.
// C'est un widget avec état car il doit gérer l'état du lecteur vidéo.
class VideoScreen extends StatefulWidget {
  final String title; // Le titre de la vidéo à afficher.
  final String videoUrl; // L'URL de la vidéo YouTube.

  VideoScreen({required this.title, required this.videoUrl});

  // `createState` crée l'état associé à ce widget.
  @override
  _VideoScreenState createState() => _VideoScreenState();
}

// L'état associé à `VideoScreen` est géré par `_VideoScreenState`.
class _VideoScreenState extends State<VideoScreen> {
  late YoutubePlayerController _controller; // Contrôleur pour gérer le lecteur YouTube.

  // `initState` est appelé une seule fois lorsque l'état est initialisé.
  @override
  void initState() {
    super.initState();

    // Parse l'URL de la vidéo pour obtenir l'ID de la vidéo et le moment où elle doit commencer.
    final Uri uri = Uri.parse(widget.videoUrl);
    final String videoId = YoutubePlayer.convertUrlToId(widget.videoUrl)!; // Extrait l'ID de la vidéo YouTube.
    final int startAt = int.tryParse(uri.queryParameters['t']?.replaceAll('s', '') ?? '0') ?? 0; // Extrait le temps de démarrage à partir de l'URL.

    // Initialise le contrôleur avec l'ID de la vidéo et les options de lecture.
    _controller = YoutubePlayerController(
      initialVideoId: videoId,
      flags: YoutubePlayerFlags(
        autoPlay: true, // La vidéo commence automatiquement.
        mute: false, // Le son est activé par défaut.
        startAt: startAt, // La vidéo commence à partir du temps spécifié dans l'URL.
      ),
    );
  }

  // `dispose` est appelé lorsque le widget est supprimé, pour libérer les ressources.
  @override
  void dispose() {
    _controller.dispose(); // Libère les ressources du contrôleur vidéo.
    super.dispose();
  }

  // La méthode `build` construit l'interface utilisateur pour ce widget.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title), // Affiche le titre de la vidéo dans la barre d'application.
      ),
      body: YoutubePlayer(
        controller: _controller, // Utilise le contrôleur pour gérer le lecteur vidéo.
        showVideoProgressIndicator: true, // Affiche un indicateur de progression sous la vidéo.
        progressIndicatorColor: Colors.blueAccent, // Définit la couleur de l'indicateur de progression.
      ),
    );
  }
}

// `QuestionScreen` affiche une question spécifique du QCM.
// C'est un widget sans état car il n'a pas besoin de gérer des changements d'état.
class QuestionScreen extends StatelessWidget {
  final String question; // La question à afficher.
  final List<String> options; // Les options de réponse.
  final String correctAnswer; // La réponse correcte.
  final String image; // L'image associée à la question.

  QuestionScreen({
    required this.question,
    required this.options,
    required this.correctAnswer,
    required this.image,
  });

  // La méthode `build` construit l'interface utilisateur pour ce widget.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QCM'), // Titre de la barre d'application.
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0), // Ajoute un padding autour du contenu.
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // Aligne les éléments au début de la colonne.
          children: [
            if (image.isNotEmpty) Image.asset(image), // Affiche l'image si elle est fournie.
            SizedBox(height: 20), // Espace entre l'image et la question.
            Text(
              question, // Affiche la question.
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            ...options.map((option) => ListTile(
              title: Text(option), // Affiche chaque option de réponse.
              onTap: () {
                // Détermine si l'utilisateur a sélectionné la bonne réponse.
                String message;
                if (option == correctAnswer) {
                  message = 'Bonne réponse !';
                } else {
                  message = 'Mauvaise réponse. La bonne réponse est : $correctAnswer';
                }
                // Affiche une boîte de dialogue avec le résultat.
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Résultat'), // Titre de la boîte de dialogue.
                      content: Text(message), // Contenu de la boîte de dialogue.
                      actions: [
                        TextButton(
                          child: Text('OK'),
                          onPressed: () {
                            Navigator.of(context).pop(); // Ferme la boîte de dialogue.
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
