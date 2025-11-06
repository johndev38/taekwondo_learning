import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../notifiers/belt_notifier.dart';
import 'term_learning_screen.dart';

class BeltSelectionForLeaningScreen extends StatefulWidget {
  final String? selectedBelt;

  const BeltSelectionForLeaningScreen({super.key, this.selectedBelt});

  @override
  _BeltSelectionForLeaningScreenState createState() =>
      _BeltSelectionForLeaningScreenState();
}

class _BeltSelectionForLeaningScreenState
    extends State<BeltSelectionForLeaningScreen> {
  final List<String> belts = [
    'Jaune (9e keup)',
    'Jaune 1ère barrette (8e keup)',
    'Jaune 2ème barrette (7e keup)',
    'Bleu (6e keup)',
    'Bleu 1ère barrette (5e keup)',
    'Bleu 2ème barrette (4e keup)',
    'Rouge (3e keup)',
    'Rouge 1ère barrette (2e keup)',
    'Noire (1e keup)',
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
    final recommendedKibon =
        currentBelt != null ? beltNotifier.getKibonForBelt(currentBelt) : null;

    final double titleFontSize = screenWidth > 800
        ? 18
        : screenWidth > 600
            ? 16
            : 14;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Kibon - Sélectionner la ceinture'),
        backgroundColor: Colors.green.shade600,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Bandeau de recommandation si une ceinture est sélectionnée
          if (recommendedKibon != null)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.green.shade100, Colors.teal.shade100],
                ),
                border: Border(
                  bottom: BorderSide(color: Colors.green.shade200),
                ),
              ),
              child: Row(
                children: [
                  Icon(Icons.star, color: Colors.green.shade600, size: 24),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Recommandé pour votre ceinture',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.green.shade700,
                          ),
                        ),
                        Text(
                          '$currentBelt → $recommendedKibon',
                          style: TextStyle(
                            color: Colors.green.shade600,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

          // Liste des ceintures
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: screenWidth > 600 ? 2 : 1,
                  childAspectRatio: 5,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemCount: belts.length,
                itemBuilder: (context, index) {
                  final isRecommended = belts[index] == recommendedKibon;

                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TermLearningScreen(
                            belt: belts[index],
                          ),
                        ),
                      );
                    },
                    child: Card(
                      elevation: isRecommended ? 8 : 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: isRecommended
                            ? BorderSide(color: Colors.green.shade400, width: 2)
                            : BorderSide.none,
                      ),
                      color: isRecommended
                          ? Colors.green.shade50
                          : Colors.grey[50],
                      child: Container(
                        decoration: isRecommended
                            ? BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.green.shade50,
                                    Colors.teal.shade50
                                  ],
                                ),
                              )
                            : null,
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 16.0),
                            child: Row(
                              children: [
                                if (isRecommended) ...[
                                  Icon(Icons.star,
                                      color: Colors.green.shade600, size: 20),
                                  const SizedBox(width: 8),
                                ],
                                Expanded(
                                  child: Text(
                                    belts[index],
                                    style: TextStyle(
                                      fontSize: titleFontSize,
                                      fontWeight: isRecommended
                                          ? FontWeight.bold
                                          : FontWeight.w500,
                                      color: isRecommended
                                          ? Colors.green.shade700
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
