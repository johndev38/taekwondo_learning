import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

// ─── Modèles ─────────────────────────────────────────────────

class _HistorySection {
  final String title;
  final String? subtitle;
  final String? content;
  final List<_TimelineEvent>? timeline;

  _HistorySection({
    required this.title,
    this.subtitle,
    this.content,
    this.timeline,
  });

  bool get isTimeline => timeline != null && timeline!.isNotEmpty;

  factory _HistorySection.fromJson(Map<String, dynamic> j) {
    List<_TimelineEvent>? tl;
    if (j['timeline'] != null) {
      tl = (j['timeline'] as List)
          .map((e) => _TimelineEvent.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    return _HistorySection(
      title: j['title'] as String,
      subtitle: j['subtitle'] as String?,
      content: j['content'] as String?,
      timeline: tl,
    );
  }
}

class _TimelineEvent {
  final String year;
  final String event;

  _TimelineEvent({required this.year, required this.event});

  factory _TimelineEvent.fromJson(Map<String, dynamic> j) => _TimelineEvent(
        year: j['year'] as String,
        event: j['event'] as String,
      );
}

// ─── Écran ────────────────────────────────────────────────────

class TaekwondoHistoryScreen extends StatefulWidget {
  final String assetPath;
  final String title;
  final String headerTitle;
  final String headerSubtitle;
  final Color headerGradientEnd;
  final IconData headerIcon;

  const TaekwondoHistoryScreen({
    super.key,
    this.assetPath = 'assets/history.json',
    this.title = 'HISTOIRE',
    this.headerTitle = 'Origines & évolution',
    this.headerSubtitle = 'Du Taekkyeon aux JO de Paris 2024',
    this.headerGradientEnd = const Color(0xFF870000),
    this.headerIcon = Icons.history_edu_rounded,
  });

  /// Constructeur pratique pour l'historique fédéral FFTDA.
  const TaekwondoHistoryScreen.federal({super.key})
      : assetPath = 'assets/history_federal.json',
        title = 'HISTOIRE FÉDÉRALE',
        headerTitle = 'FFTDA — grandes dates',
        headerSubtitle = 'Chronologie du Taekwondo en France',
        headerGradientEnd = const Color(0xFF0D47A1),
        headerIcon = Icons.flag_rounded;

  @override
  TaekwondoHistoryScreenState createState() => TaekwondoHistoryScreenState();
}

class TaekwondoHistoryScreenState extends State<TaekwondoHistoryScreen> {
  List<_HistorySection> _sections = [];
  bool _isLoading = true;

  static const Color _navyDark = Color(0xFF0A1628);
  static const Color _redAccent = Color(0xFFCC1122);

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    final raw = await rootBundle.loadString(widget.assetPath);
    final data = json.decode(raw) as Map<String, dynamic>;
    setState(() {
      _sections = (data['history'] as List)
          .map((e) => _HistorySection.fromJson(e as Map<String, dynamic>))
          .toList();
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                _buildHeader(context),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 24, 16, 40),
                    child: Column(
                      children: _sections
                          .map((s) => _buildSectionCard(context, s))
                          .toList(),
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  // ── Header ───────────────────────────────────────────────────

  Widget _buildHeader(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      expandedHeight: 170,
      backgroundColor: _navyDark,
      foregroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_rounded, size: 20),
        onPressed: () => Navigator.pop(context),
      ),
      flexibleSpace: FlexibleSpaceBar(
        collapseMode: CollapseMode.pin,
        titlePadding: const EdgeInsets.fromLTRB(56, 0, 20, 14),
        title: Text(
          widget.title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w900,
            fontSize: 18,
            letterSpacing: 3,
          ),
        ),
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [const Color(0xFF0A1628), widget.headerGradientEnd],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 56, 24, 48),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                        color: Colors.white.withOpacity(0.25), width: 1.5),
                  ),
                  child: Icon(widget.headerIcon,
                      color: Colors.white, size: 28),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.headerTitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                            fontSize: 14),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        widget.headerSubtitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: Colors.white.withOpacity(0.6),
                            fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ── Section card ─────────────────────────────────────────────

  Widget _buildSectionCard(BuildContext context, _HistorySection section) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: section.isTimeline
          ? _buildTimelineCard(section)
          : _buildTextCard(context, section),
    );
  }

  // ── Carte texte (sections existantes) ───────────────────────

  Widget _buildTextCard(BuildContext context, _HistorySection section) {
    return Card(
      elevation: 4,
      shadowColor: Colors.black.withOpacity(0.12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 4,
                  height: 22,
                  decoration: BoxDecoration(
                    color: _redAccent,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    section.title,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF1A2340),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Text(
              section.content ?? '',
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF37474F),
                height: 1.6,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Carte timeline (historique fédéral) ──────────────────────

  Widget _buildTimelineCard(_HistorySection section) {
    return Card(
      elevation: 4,
      shadowColor: Colors.black.withOpacity(0.12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      clipBehavior: Clip.antiAlias,
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          initiallyExpanded: true,
          tilePadding: const EdgeInsets.fromLTRB(20, 8, 16, 8),
          childrenPadding: EdgeInsets.zero,
          leading: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFCC1122), Color(0xFF870000)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.flag_rounded, color: Colors.white, size: 22),
          ),
          title: Text(
            section.title,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: Color(0xFF1A2340),
            ),
          ),
          subtitle: section.subtitle != null
              ? Text(
                  section.subtitle!,
                  style: const TextStyle(
                      fontSize: 11, color: Color(0xFF78909C)),
                )
              : Text(
                  '${section.timeline!.length} événements',
                  style: const TextStyle(
                      fontSize: 11, color: Color(0xFF78909C)),
                ),
          iconColor: _redAccent,
          collapsedIconColor: _redAccent,
          children: [
            const Divider(height: 1, indent: 16, endIndent: 16),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
              child: Column(
                children: section.timeline!
                    .asMap()
                    .entries
                    .map((entry) =>
                        _buildTimelineItem(entry.value, entry.key,
                            section.timeline!.length))
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimelineItem(
      _TimelineEvent item, int index, int total) {
    final bool isLast = index == total - 1;
    final bool isRecent = int.tryParse(item.year) != null &&
        int.parse(item.year) >= 2000;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── Colonne gauche : année + fil ──
          SizedBox(
            width: 58,
            child: Column(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                  decoration: BoxDecoration(
                    color: isRecent
                        ? _redAccent
                        : const Color(0xFF0A1628),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    item.year,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                ),
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 2,
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      color: Colors.grey.withOpacity(0.2),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          // ── Colonne droite : contenu ──
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.event,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF37474F),
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
