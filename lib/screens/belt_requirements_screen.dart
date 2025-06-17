import 'package:flutter/material.dart';
import '../models/belt_requirement.dart';

class BeltRequirementsScreen extends StatefulWidget {
  const BeltRequirementsScreen({Key? key}) : super(key: key);

  @override
  State<BeltRequirementsScreen> createState() => _BeltRequirementsScreenState();
}

class _BeltRequirementsScreenState extends State<BeltRequirementsScreen> {
  List<String> beltTransitions = [];
  String? selectedBeltTransition;
  Map<String, dynamic>? selectedBeltData;
  Map<String, dynamic> allBeltData = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadBeltRequirements();
  }

  Future<void> _loadBeltRequirements() async {
    try {
      final data = await BeltRequirement.loadBeltRequirements();
      final keupProgression = data['keup_progression'] as Map<String, dynamic>;

      setState(() {
        allBeltData = keupProgression;
        beltTransitions = keupProgression.keys.toList();
        // Sélectionner la première transition par défaut
        if (beltTransitions.isNotEmpty) {
          selectedBeltTransition = beltTransitions.first;
          selectedBeltData = keupProgression[selectedBeltTransition];
        }
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur lors du chargement: $e')),
        );
      }
    }
  }

  String _getBeltDisplayName(String transitionKey) {
    try {
      final beltData = allBeltData[transitionKey] as Map<String, dynamic>?;
      return beltData?['belt_name'] as String? ?? transitionKey;
    } catch (e) {
      return transitionKey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Passage de Ceinture'),
        backgroundColor: Colors.red,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : beltTransitions.isEmpty
              ? const Center(child: Text('Aucune donnée disponible'))
              : Column(
                  children: [
                    // Section de sélection de ceinture
                    Container(
                      width: double.infinity,
                      color: Colors.red.shade50,
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Sélectionner la transition de ceinture :',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                            ),
                          ),
                          const SizedBox(height: 12),
                          // Dropdown pour sélectionner la ceinture
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.red),
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.white,
                            ),
                            child: DropdownButton<String>(
                              value: selectedBeltTransition,
                              isExpanded: true,
                              underline: Container(),
                              hint: const Text('Choisir une ceinture'),
                              items: beltTransitions.map((String transition) {
                                final displayName =
                                    _getBeltDisplayName(transition);
                                return DropdownMenuItem<String>(
                                  value: transition,
                                  child: Text(
                                    displayName,
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                if (newValue != null) {
                                  setState(() {
                                    selectedBeltTransition = newValue;
                                    // Recharger les données pour la nouvelle sélection
                                    _loadSelectedBeltData();
                                  });
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Section d'affichage des informations
                    Expanded(
                      child: selectedBeltData != null
                          ? _buildBeltRequirementsContent()
                          : const Center(
                              child: Text('Sélectionnez une ceinture')),
                    ),
                  ],
                ),
    );
  }

  Future<void> _loadSelectedBeltData() async {
    if (selectedBeltTransition == null) return;

    try {
      final data = await BeltRequirement.loadBeltRequirements();
      final keupProgression = data['keup_progression'] as Map<String, dynamic>;

      setState(() {
        selectedBeltData = keupProgression[selectedBeltTransition];
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur lors du chargement: $e')),
        );
      }
    }
  }

  Widget _buildBeltRequirementsContent() {
    if (selectedBeltData == null) return Container();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Titre de la ceinture
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              selectedBeltData!['belt_name'] ?? 'Passage de ceinture',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 20),

          // Positions
          if (selectedBeltData!['positions'] != null)
            _buildSection('Positions', selectedBeltData!['positions']),

          // Frappes membres supérieurs
          if (selectedBeltData!['upper_limb_strikes'] != null)
            _buildSection('Frappes membres supérieurs',
                selectedBeltData!['upper_limb_strikes']),

          // Frappes membres inférieurs
          if (selectedBeltData!['lower_limb_strikes'] != null)
            _buildSection('Frappes membres inférieurs',
                selectedBeltData!['lower_limb_strikes']),

          // Blocages
          if (selectedBeltData!['blocks'] != null)
            _buildSection('Blocages', selectedBeltData!['blocks']),

          // Déplacements
          if (selectedBeltData!['movements'] != null) _buildMovementsSection(),

          // Poomsae
          if (selectedBeltData!['poomsae'] != null) _buildPoomsaeSection(),

          // Kibons (pour les ceintures rouges uniquement)
          if (selectedBeltData!['kibons'] != null) _buildKibonsSection(),

          // Hanbon Kyeurogui (pour les ceintures rouges uniquement)
          if (selectedBeltData!['hanbon_kyeurogui'] != null)
            _buildHanbonSection(),

          // Kyeurogui (pour les ceintures rouges uniquement)
          if (selectedBeltData!['kyeurogui'] != null) _buildKyeuraguiSection(),

          // Ho Shin Soul (pour les ceintures rouges uniquement)
          if (selectedBeltData!['ho_shin_soul'] != null)
            _buildHoShinSoulSection(),

          // Théorie
          if (selectedBeltData!['theory'] != null) _buildTheorySection(),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<dynamic> items) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.red.shade100,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              ),
            ),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.red.shade200),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(8),
                bottomRight: Radius.circular(8),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: items
                  .map((item) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('• ',
                                style: TextStyle(color: Colors.red)),
                            Expanded(child: Text(item.toString())),
                          ],
                        ),
                      ))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMovementsSection() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.red.shade100,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              ),
            ),
            child: const Text(
              'Déplacements',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.red.shade200),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(8),
                bottomRight: Radius.circular(8),
              ),
            ),
            child: Text(selectedBeltData!['movements'].toString()),
          ),
        ],
      ),
    );
  }

  Widget _buildPoomsaeSection() {
    final poomsae = selectedBeltData!['poomsae'] as Map<String, dynamic>;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue.shade100,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              ),
            ),
            child: const Text(
              'POOMSAE',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.blue.shade200),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(8),
                bottomRight: Radius.circular(8),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Poomsae: ${poomsae['name']}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                if (poomsae['evaluation'] != null) ...[
                  const Text('Évaluation:'),
                  const SizedBox(height: 4),
                  ...(poomsae['evaluation'] as Map<String, dynamic>)
                      .entries
                      .map(
                        (entry) => Padding(
                          padding: const EdgeInsets.only(left: 16, top: 2),
                          child: Text('• ${entry.key}: ${entry.value}'),
                        ),
                      ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKibonsSection() {
    final kibons = selectedBeltData!['kibons'] as Map<String, dynamic>;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.green.shade100,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              ),
            ),
            child: const Text(
              'KIBONS',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.green.shade200),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(8),
                bottomRight: Radius.circular(8),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Frappes de précision
                Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        kibons['precision_strikes']['description'],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: Colors.green,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(kibons['precision_strikes']['requirements']),
                      const SizedBox(height: 4),
                      Text(
                        kibons['precision_strikes']['note'],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                ),

                // Enchaînements
                Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        kibons['combinations']['description'],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: Colors.green,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(kibons['combinations']['requirements']),
                      const SizedBox(height: 4),
                      Text(
                        kibons['combinations']['note'],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                ),

                // Critères d'évaluation
                const Text('Critères évalués:',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                ...(kibons['evaluation']['criteria'] as List).map(
                  (criteria) => Padding(
                    padding: const EdgeInsets.only(left: 16, top: 2),
                    child: Text('• $criteria'),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Note totale: /${kibons['evaluation']['total']}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHanbonSection() {
    final hanbon =
        selectedBeltData!['hanbon_kyeurogui'] as Map<String, dynamic>;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.purple.shade100,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              ),
            ),
            child: const Text(
              'HANBON KYEUROGUI',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.purple,
              ),
            ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.purple.shade200),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(8),
                bottomRight: Radius.circular(8),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Description du niveau
                if (hanbon['description'] != null) ...[
                  Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.purple.shade50,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      hanbon['description'],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Colors.purple,
                      ),
                    ),
                  ),
                ],

                const Text('Exigences:',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(hanbon['requirements']),

                const SizedBox(height: 12),
                const Text('Critères évalués:',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(
                    '• Respect du protocole du hanbon: /${hanbon['evaluation']['respect_protocole']}'),
                Text(
                    '• Précision riposte: /${hanbon['evaluation']['precision_riposte']}'),
                Text(
                    '• Respect mouvements demandés: /${hanbon['evaluation']['respect_mouvements']}'),

                const SizedBox(height: 8),
                Text(
                  'Note totale: /${hanbon['evaluation']['total']}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.purple,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKyeuraguiSection() {
    final kyeurogui = selectedBeltData!['kyeurogui'] as Map<String, dynamic>;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.orange.shade100,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              ),
            ),
            child: const Text(
              'KYEUROGUI (COMBAT)',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.orange,
              ),
            ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.orange.shade200),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(8),
                bottomRight: Radius.circular(8),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Rounds: ${kyeurogui['rounds']}'),
                const SizedBox(height: 8),
                Text('Note totale: /${kyeurogui['evaluation']['total']}'),
                const SizedBox(height: 8),
                ...(kyeurogui['evaluation'] as Map<String, dynamic>)
                    .entries
                    .where((entry) => entry.key != 'total')
                    .map((entry) {
                  final competence = entry.value as Map<String, dynamic>;
                  return Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.orange.shade50,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          competence['theme'],
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(competence['instructions']),
                        Text('Points: /${competence['points']}'),
                      ],
                    ),
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHoShinSoulSection() {
    final hoShinSoul =
        selectedBeltData!['ho_shin_soul'] as Map<String, dynamic>;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.teal.shade100,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              ),
            ),
            child: const Text(
              'HO SHIN SOUL',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.teal,
              ),
            ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.teal.shade200),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(8),
                bottomRight: Radius.circular(8),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Exigences:',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                Text(hoShinSoul['requirements']),
                const SizedBox(height: 8),
                Text('Note totale: /${hoShinSoul['evaluation']['total']}'),
                const SizedBox(height: 4),
                Text(
                    '• Réactivité: /${hoShinSoul['evaluation']['reactivity']}'),
                Text('• Dégagement: /${hoShinSoul['evaluation']['release']}'),
                Text(
                    '• Qualité de la riposte: /${hoShinSoul['evaluation']['counter_attack']}'),
                Text(
                    '• Contrôle et mise au sol: /${hoShinSoul['evaluation']['control_ground']}'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTheorySection() {
    final theory = selectedBeltData!['theory'];

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.indigo.shade100,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              ),
            ),
            child: const Text(
              'THÉORIE',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.indigo,
              ),
            ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.indigo.shade200),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(8),
                bottomRight: Radius.circular(8),
              ),
            ),
            child: theory is List
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: (theory as List)
                        .map(
                          (item) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 2),
                            child: Text('• $item'),
                          ),
                        )
                        .toList(),
                  )
                : Text(theory.toString()),
          ),
        ],
      ),
    );
  }
}
