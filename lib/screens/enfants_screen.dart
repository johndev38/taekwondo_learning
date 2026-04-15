import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'enfants_detail_screen.dart';

class EnfantsScreen extends StatefulWidget {
  const EnfantsScreen({super.key});

  @override
  State<EnfantsScreen> createState() => _EnfantsScreenState();
}

class _EnfantsScreenState extends State<EnfantsScreen> {
  static const Color _navyDark = Color(0xFF0A1628);
  static const Color _accentRed = Color(0xFFCC1122);

  List<Map<String, dynamic>> _belts = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadIndex();
  }

  Future<void> _loadIndex() async {
    final raw =
        await rootBundle.loadString('assets/enfants/index.json');
    final data = jsonDecode(raw) as Map<String, dynamic>;
    setState(() {
      _belts =
          (data['collection'] as List).cast<Map<String, dynamic>>();
      _isLoading = false;
    });
  }

  Color _beltColor(String beltColor) {
    switch (beltColor) {
      case 'orange':
      case 'orange/verte':
        return const Color(0xFFE65100);
      case 'verte':
      case 'verte/violette':
        return const Color(0xFF2E7D32);
      case 'violette':
      case 'violette/bleue':
        return const Color(0xFF6A1B9A);
      case 'bleue':
        return const Color(0xFF1565C0);
      default:
        return const Color(0xFF546E7A);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFFF0F2F5),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            expandedHeight: screenHeight * 0.22,
            pinned: true,
            backgroundColor: _navyDark,
            foregroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
              icon:
                  const Icon(Icons.arrow_back_ios_rounded, size: 20),
              onPressed: () => Navigator.pop(context),
            ),
            flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.pin,
              titlePadding:
                  const EdgeInsets.fromLTRB(56, 0, 20, 14),
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF0A1628), Color(0xFF1A1040)],
                  ),
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.fromLTRB(24, 56, 24, 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'ENFANTS',
                        style: TextStyle(
                          fontSize: 34,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                          letterSpacing: 5,
                        ),
                      ),
                      Row(
                        children: [
                          Container(
                              width: 32,
                              height: 2.5,
                              color: _accentRed),
                          const SizedBox(width: 8),
                          Text(
                            'PROGRESSION PAR CEINTURE',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w400,
                              color: Colors.white.withOpacity(0.6),
                              letterSpacing: 3,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Sélectionnez votre niveau de ceinture',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.white.withOpacity(0.5),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          if (_isLoading)
            const SliverFillRemaining(
              child: Center(child: CircularProgressIndicator()),
            )
          else
            SliverPadding(
              padding:
                  const EdgeInsets.fromLTRB(20, 20, 20, 32),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final belt = _belts[index];
                    final color =
                        _beltColor(belt['beltColor'] as String);
                    return _BeltCard(
                      title: belt['title'] as String,
                      keup: belt['keup'] as int,
                      beltColor: color,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => EnfantsDetailScreen(
                            fileName: belt['file'] as String,
                            title: belt['title'] as String,
                            beltColor: color,
                          ),
                        ),
                      ),
                    );
                  },
                  childCount: _belts.length,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _BeltCard extends StatelessWidget {
  final String title;
  final int keup;
  final Color beltColor;
  final VoidCallback onTap;

  const _BeltCard({
    required this.title,
    required this.keup,
    required this.beltColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: Material(
        borderRadius: BorderRadius.circular(14),
        elevation: 2,
        shadowColor: Colors.black.withOpacity(0.1),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          child: Container(
            height: 66,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: beltColor.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 5,
                  decoration: BoxDecoration(
                    color: beltColor,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(14),
                      bottomLeft: Radius.circular(14),
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: beltColor.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(
                      '${keup}K',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: beltColor,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF0A1628),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(right: 10),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: beltColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '${keup}e keup',
                    style: TextStyle(
                      fontSize: 11,
                      color: beltColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(right: 12),
                  child: Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 13,
                    color: Color(0xFFBBBBBB),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
