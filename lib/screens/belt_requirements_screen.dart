import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/belt_requirement.dart';
import '../notifiers/belt_notifier.dart';

class BeltRequirementsScreen extends StatefulWidget {
  const BeltRequirementsScreen({super.key});

  @override
  _BeltRequirementsScreenState createState() => _BeltRequirementsScreenState();
}

class _BeltRequirementsScreenState extends State<BeltRequirementsScreen>
    with TickerProviderStateMixin {
  Map<String, dynamic>? beltRequirements;
  Map<String, dynamic>? selectedBeltData;
  String? selectedTransition;
  bool isLoading = true;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );
    _loadBeltRequirements();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Auto-sélectionner la transition de ceinture basée sur la ceinture actuelle
    final beltNotifier = Provider.of<BeltNotifier>(context, listen: false);
    if (beltNotifier.currentBelt != null && beltRequirements != null) {
      final transitionKey =
          beltNotifier.getBeltTransitionKey(beltNotifier.currentBelt);
      if (transitionKey != null &&
          beltRequirements!['keup_progression'][transitionKey] != null) {
        setState(() {
          selectedTransition = transitionKey;
          selectedBeltData =
              beltRequirements!['keup_progression'][transitionKey];
        });
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _loadBeltRequirements() async {
    try {
      final requirements = await BeltRequirement.loadBeltRequirements();
      if (mounted) {
        setState(() {
          beltRequirements = requirements;
          isLoading = false;
        });
        _animationController.forward();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur lors du chargement: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final beltNotifier = Provider.of<BeltNotifier>(context);
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Header moderne avec gradient
          SliverAppBar(
            expandedHeight: 200,
            floating: false,
            pinned: true,
            elevation: 0,
            backgroundColor: Colors.transparent,
            flexibleSpace: FlexibleSpaceBar(
              title: const Text(
                'Passage de Ceinture',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.amber.shade700,
                      Colors.orange.shade600,
                      Colors.red.shade500,
                    ],
                  ),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.2),
                  ),
                ),
              ),
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),

          // Contenu principal
          if (isLoading)
            SliverFillRemaining(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      valueColor:
                          AlwaysStoppedAnimation<Color>(Colors.orange.shade600),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Chargement des exigences...',
                      style: TextStyle(
                        fontSize: 16,
                        color: Theme.of(context).textTheme.bodyMedium?.color,
                      ),
                    ),
                  ],
                ),
              ),
            )
          else if (beltRequirements == null)
            SliverFillRemaining(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Colors.red.shade400,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Erreur de chargement',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).textTheme.headlineSmall?.color,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Impossible de charger les exigences de ceinture',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Theme.of(context).textTheme.bodyMedium?.color,
                      ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: () {
                        setState(() => isLoading = true);
                        _loadBeltRequirements();
                      },
                      icon: const Icon(Icons.refresh),
                      label: const Text('Réessayer'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange.shade600,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 12),
                      ),
                    ),
                  ],
                ),
              ),
            )
          else ...[
            SliverToBoxAdapter(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Padding(
                  padding: EdgeInsets.all(screenWidth * 0.04),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Sélecteur de transition moderne
                      _buildModernSelector(),
                      const SizedBox(height: 16),
                      // Affichage des données de progression
                      if (selectedBeltData != null) ...[
                        _buildProgressionCard(),
                        const SizedBox(height: 16),
                      ]
                    ],
                  ),
                ),
              ),
            ),
            if (selectedBeltData != null)
              SliverPadding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
                sliver: SliverToBoxAdapter(
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: _buildRequirementsContent(),
                  ),
                ),
              )
            else
              SliverToBoxAdapter(
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: Padding(
                    padding: EdgeInsets.all(screenWidth * 0.04),
                    child: _buildEmptyState(),
                  ),
                ),
              ),
            // Espace final pour éviter les débordements
            const SliverToBoxAdapter(
              child: SizedBox(height: 50),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildModernSelector() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.shade50, Colors.purple.shade50],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.blue.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.blue.shade600,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.emoji_events,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Choisissez votre objectif',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.blue.shade200),
            ),
            child: DropdownButton<String>(
              value: selectedTransition,
              hint: const Text(
                'Sélectionnez une progression de ceinture',
                style: TextStyle(color: Colors.grey),
              ),
              isExpanded: true,
              underline: Container(),
              icon: const Icon(Icons.keyboard_arrow_down),
              items: beltRequirements!['keup_progression']
                  .entries
                  .map<DropdownMenuItem<String>>((entry) {
                final transition = entry.value as Map<String, dynamic>;
                return DropdownMenuItem<String>(
                  value: entry.key,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      children: [
                        Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            color: _getTransitionColor(entry.key),
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            transition['belt_name'] ?? 'Transition inconnue',
                            style: const TextStyle(fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    selectedTransition = newValue;
                    selectedBeltData =
                        beltRequirements!['keup_progression'][newValue];
                  });
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressionCard() {
    if (selectedBeltData == null) return Container();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.orange.shade100, Colors.red.shade100],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.orange.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.orange.shade600,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.trending_up,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  selectedBeltData!['belt_name'] ?? 'Progression',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.8),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text(
              'Cette section contient toutes les exigences pour réussir votre passage de ceinture selon les standards officiels FFTDA.',
              style: TextStyle(
                fontSize: 14,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(40),
      child: Column(
        children: [
          Icon(
            Icons.emoji_events,
            size: 80,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            'Commencez votre préparation',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).textTheme.headlineSmall?.color,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Sélectionnez une progression de ceinture pour voir les exigences détaillées',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Theme.of(context).textTheme.bodyMedium?.color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRequirementsContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Positions
        if (selectedBeltData!['positions'] != null)
          _buildSection('Positions', selectedBeltData!['positions'],
              Icons.accessibility, Colors.blue.shade600),

        // Frappes membres supérieurs
        if (selectedBeltData!['upper_limb_strikes'] != null)
          _buildSection(
              'Frappes membres supérieurs',
              selectedBeltData!['upper_limb_strikes'],
              Icons.front_hand,
              Colors.red.shade600),

        // Frappes membres inférieurs
        if (selectedBeltData!['lower_limb_strikes'] != null)
          _buildSection(
              'Frappes membres inférieurs',
              selectedBeltData!['lower_limb_strikes'],
              Icons.sports_martial_arts,
              Colors.orange.shade600),

        // Blocages
        if (selectedBeltData!['blocks'] != null)
          _buildSection('Blocages', selectedBeltData!['blocks'], Icons.shield,
              Colors.purple.shade600),

        // Déplacements
        if (selectedBeltData!['movements'] != null) _buildMovementsSection(),

        // Poomsae
        if (selectedBeltData!['poomsae'] != null) _buildPoomsaeSection(),

        // Hanbon Kyeurogui
        if (selectedBeltData!['hanbon_kyeurogui'] != null)
          _buildHanbonSection(),

        // Kibons
        if (selectedBeltData!['kibons'] != null) _buildKibonsSection(),

        // Kyeurogui
        if (selectedBeltData!['kyeurogui'] != null) _buildKyeuraguiSection(),

        // Ho Shin Soul
        if (selectedBeltData!['ho_shin_soul'] != null)
          _buildHoShinSoulSection(),

        // Théorie
        if (selectedBeltData!['theory'] != null) _buildTheorySection(),
      ],
    );
  }

  Widget _buildSection(
      String title, dynamic content, IconData icon, Color color) {
    List<String> items = [];
    if (content is List) {
      items = content.cast<String>();
    } else if (content is String) {
      items = [content];
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Material(
        borderRadius: BorderRadius.circular(12),
        elevation: 2,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color.withOpacity(0.3)),
          ),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(icon, color: color, size: 20),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        title.toUpperCase(),
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: color,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: items
                      .map((item) => Padding(
                            padding: const EdgeInsets.only(bottom: 6),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 5,
                                  height: 5,
                                  margin:
                                      const EdgeInsets.only(top: 6, right: 8),
                                  decoration: BoxDecoration(
                                    color: color,
                                    borderRadius: BorderRadius.circular(3),
                                  ),
                                ),
                                Expanded(child: Text(item)),
                              ],
                            ),
                          ))
                      .toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMovementsSection() {
    return _buildSection('Déplacements', selectedBeltData!['movements'],
        Icons.directions_walk, Colors.teal.shade600);
  }

  Widget _buildPoomsaeSection() {
    final poomsae = selectedBeltData!['poomsae'] as Map<String, dynamic>;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Material(
        borderRadius: BorderRadius.circular(12),
        elevation: 2,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.indigo.withOpacity(0.3)),
          ),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.indigo.withOpacity(0.1),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(Icons.self_improvement,
                        color: Colors.indigo.shade600, size: 24),
                    const SizedBox(width: 12),
                    Text(
                      'POOMSAE',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.indigo.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.indigo.shade50,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.star,
                              color: Colors.indigo.shade600, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            poomsae['name'],
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.indigo.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (poomsae['evaluation'] != null) ...[
                      const SizedBox(height: 16),
                      Text(
                        'Critères d\'évaluation:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade700,
                        ),
                      ),
                      const SizedBox(height: 8),
                      ...(poomsae['evaluation'] as Map<String, dynamic>)
                          .entries
                          .map(
                            (entry) => Container(
                              margin: const EdgeInsets.only(bottom: 4),
                              child: Row(
                                children: [
                                  Container(
                                    width: 4,
                                    height: 4,
                                    decoration: BoxDecoration(
                                      color: Colors.indigo.shade600,
                                      borderRadius: BorderRadius.circular(2),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Text('${entry.key}: '),
                                  Text(
                                    '${entry.value}',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                            ),
                          ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildKibonsSection() {
    final kibons = selectedBeltData!['kibons'] as Map<String, dynamic>;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Material(
        borderRadius: BorderRadius.circular(12),
        elevation: 2,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.green.withOpacity(0.3)),
          ),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(Icons.sports_gymnastics,
                        color: Colors.green.shade600, size: 24),
                    const SizedBox(width: 12),
                    Text(
                      'KIBONS',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.green.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Frappes de précision
                    Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.green.shade50,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.gps_fixed,
                                  color: Colors.green.shade600, size: 18),
                              const SizedBox(width: 8),
                              Text(
                                kibons['precision_strikes']['description'],
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green.shade600,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(kibons['precision_strikes']['requirements']),
                          const SizedBox(height: 4),
                          Text(
                            kibons['precision_strikes']['note'],
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.green.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Enchaînements
                    Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.green.shade50,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.repeat,
                                  color: Colors.green.shade600, size: 18),
                              const SizedBox(width: 8),
                              Text(
                                kibons['combinations']['description'],
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green.shade600,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(kibons['combinations']['requirements']),
                          const SizedBox(height: 4),
                          Text(
                            kibons['combinations']['note'],
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.green.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Note totale
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.green.shade50,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Note totale: /${kibons['evaluation']['total']}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.green.shade600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Critères évalués:',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.grey.shade700,
                            ),
                          ),
                          const SizedBox(height: 4),
                          ...(kibons['evaluation']['criteria'] as List).map(
                            (criteria) => Text('• $criteria'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHanbonSection() {
    final hanbon =
        selectedBeltData!['hanbon_kyeurogui'] as Map<String, dynamic>;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Material(
        borderRadius: BorderRadius.circular(12),
        elevation: 2,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.purple.withOpacity(0.3)),
          ),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.purple.withOpacity(0.1),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(Icons.sports_martial_arts,
                        color: Colors.purple.shade600, size: 24),
                    const SizedBox(width: 12),
                    Text(
                      'HANBON KYEUROGUI',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.purple.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (hanbon['description'] != null) ...[
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.purple.shade50,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.info,
                                color: Colors.purple.shade600, size: 20),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                hanbon['description'],
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.purple.shade600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                    ],
                    Text(
                      'Exigences:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(hanbon['requirements']),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.purple.shade50,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Note totale: /${hanbon['evaluation']['total']}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.purple.shade600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                              '• Respect du protocole: /${hanbon['evaluation']['respect_protocole']}'),
                          Text(
                              '• Précision riposte: /${hanbon['evaluation']['precision_riposte']}'),
                          Text(
                              '• Respect mouvements: /${hanbon['evaluation']['respect_mouvements']}'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildKyeuraguiSection() {
    final kyeurogui = selectedBeltData!['kyeurogui'] as Map<String, dynamic>;
    List<String> content = [
      'Rounds: ${kyeurogui['rounds']}',
      'Note totale: /${kyeurogui['evaluation']['total']}'
    ];

    // Ajouter les détails d'évaluation
    (kyeurogui['evaluation'] as Map<String, dynamic>)
        .entries
        .where((entry) => entry.key != 'total')
        .forEach((entry) {
      final competence = entry.value as Map<String, dynamic>;
      content.add(
          '${competence['theme']}: ${competence['instructions']} (${competence['points']} pts)');
    });

    return _buildSection('Kyeurogui (Combat)', content, Icons.sports_kabaddi,
        Colors.deepOrange.shade600);
  }

  Widget _buildHoShinSoulSection() {
    final hoShinSoul =
        selectedBeltData!['ho_shin_soul'] as Map<String, dynamic>;
    List<String> content = [
      hoShinSoul['requirements'],
      'Note totale: /${hoShinSoul['evaluation']['total']}',
      'Réactivité: /${hoShinSoul['evaluation']['reactivity']}',
      'Dégagement: /${hoShinSoul['evaluation']['release']}',
      'Qualité riposte: /${hoShinSoul['evaluation']['counter_attack']}',
      'Contrôle et mise au sol: /${hoShinSoul['evaluation']['control_ground']}',
    ];

    return _buildSection(
        'Ho Shin Soul', content, Icons.security, Colors.cyan.shade600);
  }

  Widget _buildTheorySection() {
    return _buildSection('Théorie', selectedBeltData!['theory'], Icons.book,
        Colors.brown.shade600);
  }

  Color _getTransitionColor(String transition) {
    if (transition.contains('10_to_9') ||
        transition.contains('9_to_8') ||
        transition.contains('8_to_7')) {
      return Colors.yellow.shade600;
    } else if (transition.contains('7_to_6') ||
        transition.contains('6_to_5') ||
        transition.contains('5_to_4')) {
      return Colors.blue.shade600;
    } else if (transition.contains('4_to_3') ||
        transition.contains('3_to_2') ||
        transition.contains('2_to_1')) {
      return Colors.red.shade600;
    }
    return Colors.grey.shade600;
  }
}
