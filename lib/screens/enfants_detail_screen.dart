import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class EnfantsDetailScreen extends StatefulWidget {
  final String fileName;
  final String title;
  final Color beltColor;

  const EnfantsDetailScreen({
    super.key,
    required this.fileName,
    required this.title,
    required this.beltColor,
  });

  @override
  State<EnfantsDetailScreen> createState() =>
      _EnfantsDetailScreenState();
}

class _EnfantsDetailScreenState
    extends State<EnfantsDetailScreen> {
  Map<String, dynamic>? _data;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final raw = await rootBundle
        .loadString('assets/enfants/${widget.fileName}');
    final data = jsonDecode(raw) as Map<String, dynamic>;
    setState(() {
      _data = data;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F2F5),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                  color: widget.beltColor))
          : CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverAppBar(
                  expandedHeight: 180,
                  pinned: true,
                  backgroundColor: widget.beltColor,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  leading: IconButton(
                    icon: const Icon(
                        Icons.arrow_back_ios_rounded,
                        size: 20),
                    onPressed: () => Navigator.pop(context),
                  ),
                  flexibleSpace: FlexibleSpaceBar(
                    collapseMode: CollapseMode.pin,
                    titlePadding:
                        const EdgeInsets.fromLTRB(56, 0, 20, 14),
                    title: Text(
                      widget.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        fontSize: 14,
                      ),
                    ),
                    background: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            widget.beltColor,
                            widget.beltColor.withOpacity(0.7),
                          ],
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(
                            24, 80, 24, 60),
                        child: Column(
                          mainAxisAlignment:
                              MainAxisAlignment.end,
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            if (_data?['summary'] != null)
                              Text(
                                _data!['summary'] as String,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.white
                                      .withOpacity(0.85),
                                  height: 1.5,
                                ),
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.all(20),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      ..._buildSections(),
                      const SizedBox(height: 20),
                    ]),
                  ),
                ),
              ],
            ),
    );
  }

  List<Widget> _buildSections() {
    if (_data == null) return [];
    final sections = <Widget>[];

    void add(String title, IconData icon, Widget content) {
      sections.add(_SectionCard(
        title: title,
        icon: icon,
        accentColor: widget.beltColor,
        child: content,
      ));
      sections.add(const SizedBox(height: 12));
    }

    if (_data!['positions'] != null) {
      add('Positions', Icons.accessibility_rounded,
          _buildTechWidget(
              _data!['positions'] as Map<String, dynamic>));
    }
    if (_data!['blocks'] != null) {
      add('Blocages', Icons.shield_rounded,
          _buildTechWidget(
              _data!['blocks'] as Map<String, dynamic>));
    }
    if (_data!['attacks'] != null) {
      add('Frappes membres supérieurs',
          Icons.front_hand_rounded,
          _buildTechWidget(
              _data!['attacks'] as Map<String, dynamic>));
    }
    if (_data!['kicks'] != null) {
      add('Coups de pied',
          Icons.sports_martial_arts_rounded,
          _buildTechWidget(
              _data!['kicks'] as Map<String, dynamic>));
    }
    if (_data!['poomsae'] != null) {
      add('Poomsae', Icons.self_improvement_rounded,
          _buildPoomsaeWidget(
              _data!['poomsae'] as Map<String, dynamic>));
    }
    if (_data!['applicationPoomsae'] != null) {
      final ap =
          _data!['applicationPoomsae'] as Map<String, dynamic>;
      add(
        ap['label'] as String? ?? 'Application Poomsae',
        Icons.repeat_rounded,
        _buildList(
            (ap['objectives'] as List).cast<String>()),
      );
    }
    if (_data!['stepSparring'] != null) {
      final ss =
          _data!['stepSparring'] as Map<String, dynamic>;
      add(
        ss['label'] as String? ?? 'Kyeurougi',
        Icons.swap_horiz_rounded,
        _buildList(
            (ss['objectives'] as List).cast<String>()),
      );
    }
    if (_data!['selfDefense'] != null) {
      final sd =
          _data!['selfDefense'] as Map<String, dynamic>;
      add(
        sd['label'] as String? ?? 'Hoshinsul',
        Icons.security_rounded,
        _buildList(
            (sd['objectives'] as List).cast<String>()),
      );
    }
    if (_data!['combat'] != null) {
      add('Combat', Icons.sports_kabaddi_rounded,
          _buildTechWidget(
              _data!['combat'] as Map<String, dynamic>));
    }
    if (_data!['moralCode'] != null) {
      add(
        'Code moral',
        Icons.favorite_rounded,
        _buildChips(
            (_data!['moralCode'] as List).cast<String>()),
      );
    }
    if (_data!['citizenshipBadge'] != null) {
      add('Badge citoyen', Icons.emoji_events_rounded,
          _buildCitizenWidget(_data!['citizenshipBadge']
              as Map<String, dynamic>));
    }

    return sections;
  }

  // ── Sections techniques avec termes + objectifs + coaching ──

  Widget _buildTechWidget(Map<String, dynamic> data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (data['referenceTerms'] != null) ...[
          _sublabel('Termes de référence'),
          const SizedBox(height: 6),
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: (data['referenceTerms'] as List)
                .map((t) => _TermChip(
                      label: t as String,
                      color: widget.beltColor,
                    ))
                .toList(),
          ),
          const SizedBox(height: 12),
        ],
        if (data['objectives'] != null) ...[
          _sublabel('Objectifs'),
          const SizedBox(height: 6),
          _buildList(
              (data['objectives'] as List).cast<String>()),
        ],
        if (data['coachingPoints'] != null) ...[
          const SizedBox(height: 10),
          _sublabel('Points de coaching'),
          const SizedBox(height: 6),
          _buildList(
            (data['coachingPoints'] as List).cast<String>(),
            bulletColor: Colors.orange.shade700,
            textColor: Colors.orange.shade900,
            italic: true,
          ),
        ],
      ],
    );
  }

  Widget _buildPoomsaeWidget(Map<String, dynamic> data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (data['referenceTerms'] != null) ...[
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: (data['referenceTerms'] as List)
                .map((t) => _TermChip(
                      label: t as String,
                      color: widget.beltColor,
                    ))
                .toList(),
          ),
          const SizedBox(height: 10),
        ],
        if (data['theme'] != null) ...[
          Container(
            padding: const EdgeInsets.symmetric(
                horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.amber.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                  color: Colors.amber.withOpacity(0.4)),
            ),
            child: Row(
              children: [
                const Icon(Icons.lightbulb_rounded,
                    size: 16, color: Colors.amber),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Thème : ${data['theme']}',
                    style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
        ],
        if (data['objectives'] != null)
          _buildList(
              (data['objectives'] as List).cast<String>()),
      ],
    );
  }

  Widget _buildList(
    List<String> items, {
    Color? bulletColor,
    Color? textColor,
    bool italic = false,
  }) {
    final bc = bulletColor ?? widget.beltColor;
    final tc = textColor ?? const Color(0xFF37474F);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: items
          .map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 5),
                child: Row(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      margin: const EdgeInsets.only(
                          top: 6, right: 8),
                      decoration: BoxDecoration(
                        color: bc,
                        shape: BoxShape.circle,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        item,
                        style: TextStyle(
                          fontSize: 13,
                          color: tc,
                          fontStyle: italic
                              ? FontStyle.italic
                              : FontStyle.normal,
                        ),
                      ),
                    ),
                  ],
                ),
              ))
          .toList(),
    );
  }

  Widget _buildChips(List<String> items) {
    return Wrap(
      spacing: 8,
      runSpacing: 6,
      children: items
          .map((item) => Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: widget.beltColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                      color:
                          widget.beltColor.withOpacity(0.3)),
                ),
                child: Text(
                  item,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: widget.beltColor,
                  ),
                ),
              ))
          .toList(),
    );
  }

  Widget _buildCitizenWidget(Map<String, dynamic> data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          data['name'] as String,
          style: const TextStyle(
              fontSize: 15, fontWeight: FontWeight.w800),
        ),
        if (data['pedagogicalFocus'] != null) ...[
          const SizedBox(height: 6),
          Text(
            data['pedagogicalFocus'] as String,
            style: TextStyle(
                fontSize: 13, color: Colors.grey.shade700),
          ),
        ],
        if (data['valueAxis'] != null) ...[
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: (data['valueAxis'] as List)
                .map((v) => Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.amber.withOpacity(0.15),
                        borderRadius:
                            BorderRadius.circular(8),
                        border: Border.all(
                            color:
                                Colors.amber.withOpacity(0.3)),
                      ),
                      child: Text(
                        v as String,
                        style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600),
                      ),
                    ))
                .toList(),
          ),
        ],
      ],
    );
  }

  Widget _sublabel(String text) => Text(
        text.toUpperCase(),
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: widget.beltColor,
          letterSpacing: 1.2,
        ),
      );
}

// ── Widgets partagés ──

class _SectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color accentColor;
  final Widget child;

  const _SectionCard({
    required this.title,
    required this.icon,
    required this.accentColor,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(14),
      elevation: 2,
      shadowColor: Colors.black.withOpacity(0.07),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: accentColor.withOpacity(0.08),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(14),
                  topRight: Radius.circular(14),
                ),
              ),
              child: Row(
                children: [
                  Icon(icon, color: accentColor, size: 20),
                  const SizedBox(width: 10),
                  Text(
                    title.toUpperCase(),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      color: accentColor,
                      letterSpacing: 1,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: child,
            ),
          ],
        ),
      ),
    );
  }
}

class _TermChip extends StatelessWidget {
  final String label;
  final Color color;

  const _TermChip({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.35)),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: color,
        ),
      ),
    );
  }
}
