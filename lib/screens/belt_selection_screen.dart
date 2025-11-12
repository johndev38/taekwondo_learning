import 'package:flutter/material.dart';
import 'question_type_selection_screen.dart';

class BeltSelectionScreen extends StatelessWidget {
  final List<Map<String, String>> belts = const [
    {'name': 'Jaune (9e keup)', 'file': 'questions_jaune.json'},
    {
      'name': 'Jaune 1ère barrette (8e keup)',
      'file': 'questions_jaune_barrette1.json'
    },
    {
      'name': 'Jaune 2ème barrette (7e keup)',
      'file': 'questions_jaune_barrette2.json'
    },
    {'name': 'Bleu (6e keup)', 'file': 'questions_bleu.json'},
    {
      'name': 'Bleu 1ère barrette (5e keup)',
      'file': 'questions_bleu_barrette1.json'
    },
    {
      'name': 'Bleu 2ème barrette (4e keup)',
      'file': 'questions_bleu_barrette2.json'
    },
    {'name': 'Rouge (3e keup)', 'file': 'questions_rouge.json'},
    {
      'name': 'Rouge 1ère barrette (2e keup)',
      'file': 'questions_rouge_barrette1.json'
    },
    {'name': 'Noire (1e keup)', 'file': 'questions_noire.json'},
  ];

  BeltSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    final double titleFontSize = screenWidth > 800
        ? 18
        : screenWidth > 600
            ? 16
            : 14;

    final int crossAxisCount = screenWidth > 800
        ? 3
        : screenWidth > 600
            ? 2
            : 1;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Kibon - QCM par ceinture'),
        backgroundColor: Colors.green.shade600,
        foregroundColor: Colors.white,
        centerTitle: true,
        elevation: 2,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.green.shade50,
              Colors.grey.shade100,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
                child: _HeaderSection(),
              ),
              Expanded(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      childAspectRatio: crossAxisCount == 1 ? 3.5 : 3.0,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                    ),
                    itemCount: belts.length,
                    itemBuilder: (context, index) {
                      final belt = belts[index];
                      final String name = belt['name']!;
                      final Color beltColor = _getBeltColor(name);

                      return _BeltCard(
                        beltName: name,
                        beltColor: beltColor,
                        titleFontSize: titleFontSize,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => QuestionTypeSelectionScreen(
                                belt: name,
                                beltIndex: index,
                                belts: belts,
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Color _getBeltColor(String beltName) {
    if (beltName.startsWith('Jaune')) {
      return Colors.amber.shade600;
    } else if (beltName.startsWith('Bleu')) {
      return Colors.blue.shade600;
    } else if (beltName.startsWith('Rouge')) {
      return Colors.red.shade600;
    } else if (beltName.startsWith('Noire')) {
      return Colors.grey.shade900;
    }
    return Colors.teal.shade600;
  }
}

class _HeaderSection extends StatelessWidget {
  const _HeaderSection();

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Choisissez une ceinture',
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              "Répondez aux questions de chaque niveau. "
              "Sélectionnez une ceinture pour commencer.",
              style: textTheme.bodyMedium?.copyWith(
                color: Colors.grey[700],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BeltCard extends StatelessWidget {
  final String beltName;
  final Color beltColor;
  final double titleFontSize;
  final VoidCallback onTap;

  const _BeltCard({
    required this.beltName,
    required this.beltColor,
    required this.titleFontSize,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: Colors.grey.shade300,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            // Bande couleur à gauche
            Container(
              width: 10,
              decoration: BoxDecoration(
                color: beltColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  bottomLeft: Radius.circular(16),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                child: Row(
                  children: [
                    // Pastille couleur
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: beltColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            beltName,
                            style: textTheme.bodyMedium?.copyWith(
                              fontSize: titleFontSize,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 16,
                      color: Colors.black38,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
