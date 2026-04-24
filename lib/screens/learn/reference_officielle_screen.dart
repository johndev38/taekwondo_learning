import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

// ─── Modèles ─────────────────────────────────────────────────

class _Position {
  final int numero;
  final String nom;
  final String description;
  final String niveauDan;

  _Position({
    required this.numero,
    required this.nom,
    required this.description,
    required this.niveauDan,
  });

  factory _Position.fromJson(Map<String, dynamic> j) => _Position(
        numero: j['numero'] as int,
        nom: j['nom'] as String,
        description: j['description'] as String,
        niveauDan: j['niveau_dan'] as String,
      );
}

class _Technique {
  final int? numero;
  final String nom;
  final String description;
  final String niveauDan;

  _Technique({
    this.numero,
    required this.nom,
    required this.description,
    required this.niveauDan,
  });

  factory _Technique.fromJson(Map<String, dynamic> j) => _Technique(
        numero: j['numero'] as int?,
        nom: j['nom'] as String,
        description: j['description'] as String,
        niveauDan: j['niveau_dan'] as String,
      );
}

class _LexiqueEntry {
  final String coreen;
  final String francais;

  _LexiqueEntry({required this.coreen, required this.francais});

  factory _LexiqueEntry.fromJson(Map<String, dynamic> j) => _LexiqueEntry(
        coreen: j['coreen'] as String,
        francais: j['francais'] as String,
      );
}

class _Chiffre {
  final String cardinal;
  final int valeur;
  final String ordinal;
  final String ordinalLabel;

  _Chiffre({
    required this.cardinal,
    required this.valeur,
    required this.ordinal,
    required this.ordinalLabel,
  });

  factory _Chiffre.fromJson(Map<String, dynamic> j) => _Chiffre(
        cardinal: j['cardinal'] as String,
        valeur: j['valeur'] as int,
        ordinal: j['ordinal'] as String,
        ordinalLabel: j['ordinal_label'] as String,
      );
}

// ─── Écran principal ──────────────────────────────────────────

class ReferenceOfficielleScreen extends StatefulWidget {
  const ReferenceOfficielleScreen({super.key});

  @override
  State<ReferenceOfficielleScreen> createState() =>
      _ReferenceOfficielleScreenState();
}

class _ReferenceOfficielleScreenState
    extends State<ReferenceOfficielleScreen> {
  static const Color _navyDark = Color(0xFF0A1628);

  bool _isLoading = true;
  List<_Position> _positions = [];
  List<_Technique> _blocages = [];
  List<_Technique> _attaques = [];
  List<_Technique> _piedGeneralites = [];
  List<_Technique> _piedModalites = [];
  List<_LexiqueEntry> _termes = [];
  List<_LexiqueEntry> _membresCo = [];
  List<_Chiffre> _chiffres = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final raw =
        await rootBundle.loadString('assets/reference_officielle.json');
    final data = json.decode(raw) as Map<String, dynamic>;

    final lex = data['lexique'] as Map<String, dynamic>;
    final pied = data['techniques_pieds'] as Map<String, dynamic>;

    setState(() {
      _positions = (data['positions'] as List)
          .map((e) => _Position.fromJson(e as Map<String, dynamic>))
          .toList();
      _blocages = (data['blocages'] as List)
          .map((e) => _Technique.fromJson(e as Map<String, dynamic>))
          .toList();
      _attaques = (data['attaques'] as List)
          .map((e) => _Technique.fromJson(e as Map<String, dynamic>))
          .toList();
      _piedGeneralites = (pied['generalites'] as List)
          .map((e) => _Technique.fromJson(e as Map<String, dynamic>))
          .toList();
      _piedModalites = (pied['modalites'] as List)
          .map((e) => _Technique.fromJson(e as Map<String, dynamic>))
          .toList();
      _termes = (lex['termes'] as List)
          .map((e) => _LexiqueEntry.fromJson(e as Map<String, dynamic>))
          .toList();
      _membresCo = (lex['membres_corps'] as List)
          .map((e) => _LexiqueEntry.fromJson(e as Map<String, dynamic>))
          .toList();
      _chiffres = (lex['chiffres'] as List)
          .map((e) => _Chiffre.fromJson(e as Map<String, dynamic>))
          .toList();
      _isLoading = false;
    });
  }

  // ── Regroupement par niveau Dan ──────────────────────────────

  Map<String, List<T>> _groupByDan<T>(
      List<T> items, String Function(T) niveauOf) {
    final map = <String, List<T>>{};
    for (final item in items) {
      final k = niveauOf(item);
      (map[k] ??= []).add(item);
    }
    return map;
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _sectionCard(
                          icon: Icons.sports_martial_arts_rounded,
                          title: 'Positions de base',
                          subtitle: '${_positions.length} positions officielles',
                          color: const Color(0xFF1B5E20),
                          child: _buildPositions(),
                        ),
                        const SizedBox(height: 16),
                        _sectionCard(
                          icon: Icons.sports_kabaddi_rounded,
                          title: 'Techniques de pied — Tchagui',
                          subtitle:
                              '${_piedGeneralites.length + _piedModalites.length} techniques',
                          color: const Color(0xFF4A148C),
                          child: _buildTechniquesPied(),
                        ),
                        const SizedBox(height: 16),
                        _sectionCard(
                          icon: Icons.shield_rounded,
                          title: 'Blocages — Maki',
                          subtitle: '${_blocages.length} blocages officiels',
                          color: const Color(0xFF0D47A1),
                          child: _buildTechniquesList(_blocages),
                        ),
                        const SizedBox(height: 16),
                        _sectionCard(
                          icon: Icons.bolt_rounded,
                          title: 'Attaques membres supérieurs',
                          subtitle: '${_attaques.length} techniques d\'attaque',
                          color: const Color(0xFFBF360C),
                          child: _buildTechniquesList(_attaques),
                        ),
                        const SizedBox(height: 16),
                        _sectionCard(
                          icon: Icons.menu_book_rounded,
                          title: 'Lexique officiel',
                          subtitle:
                              '${_termes.length + _membresCo.length} termes · ${_chiffres.length} chiffres',
                          color: const Color(0xFF004D40),
                          child: _buildLexique(),
                        ),
                      ],
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
        title: const Text(
          'RÉFÉRENCE OFFICIELLE',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w900,
            fontSize: 15,
            letterSpacing: 2,
          ),
        ),
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF0A1628), Color(0xFF1A0A2E)],
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
                  child: const Icon(Icons.library_books_rounded,
                      color: Colors.white, size: 28),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'FFTDA — Positions & Techniques',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          fontSize: 14,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Référentiel officiel Dan',
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

  Widget _sectionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required Widget child,
  }) {
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: Card(
        elevation: 4,
        shadowColor: Colors.black.withOpacity(0.15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        clipBehavior: Clip.antiAlias,
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          childrenPadding: EdgeInsets.zero,
          leading: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: Colors.white, size: 22),
          ),
          title: Text(
            title,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: color,
              letterSpacing: 0.2,
            ),
          ),
          subtitle: Text(
            subtitle,
            style: const TextStyle(fontSize: 11, color: Color(0xFF78909C)),
          ),
          iconColor: color,
          collapsedIconColor: color,
          children: [
            const Divider(height: 1, indent: 16, endIndent: 16),
            child,
          ],
        ),
      ),
    );
  }

  // ── Positions ────────────────────────────────────────────────

  Widget _buildPositions() {
    final grouped =
        _groupByDan(_positions, (p) => p.niveauDan);
    return Column(
      children: grouped.entries.map((entry) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _danHeader(entry.key),
            ...entry.value.map((pos) => _positionTile(pos)),
          ],
        );
      }).toList(),
    );
  }

  Widget _positionTile(_Position pos) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey.withOpacity(0.12)),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: const Color(0xFF1B5E20).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                '${pos.numero}',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1B5E20),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  pos.nom,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1A2340),
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  pos.description,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF546E7A),
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Techniques de pied ───────────────────────────────────────

  Widget _buildTechniquesPied() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
          child: Text(
            'GÉNÉRALITÉS',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w800,
              color: const Color(0xFF4A148C).withOpacity(0.7),
              letterSpacing: 1.5,
            ),
          ),
        ),
        ..._buildTechListItems(_piedGeneralites, const Color(0xFF4A148C)),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
          child: Text(
            'MODALITÉS D\'EXÉCUTION',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w800,
              color: const Color(0xFF4A148C).withOpacity(0.7),
              letterSpacing: 1.5,
            ),
          ),
        ),
        ..._buildTechListItems(_piedModalites, const Color(0xFF4A148C)),
      ],
    );
  }

  // ── Liste générique de techniques ───────────────────────────

  Widget _buildTechniquesList(List<_Technique> list) {
    final accentColor = list == _blocages
        ? const Color(0xFF0D47A1)
        : const Color(0xFFBF360C);
    final grouped = _groupByDan(list, (t) => t.niveauDan);
    return Column(
      children: grouped.entries.map((entry) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _danHeader(entry.key),
            ..._buildTechListItems(entry.value, accentColor),
          ],
        );
      }).toList(),
    );
  }

  List<Widget> _buildTechListItems(List<_Technique> list, Color accent) {
    return list.map((t) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Colors.grey.withOpacity(0.12)),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (t.numero != null) ...[
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: accent.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    '${t.numero}',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      color: accent,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    t.nom,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1A2340),
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    t.description,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF546E7A),
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }).toList();
  }

  // ── Lexique ──────────────────────────────────────────────────

  Widget _buildLexique() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _lexiqueSubSection('COMMANDEMENTS & VOCABULAIRE', _termes),
        _lexiqueSubSection('MEMBRES ET PARTIES DU CORPS', _membresCo),
        _chiffresSection(),
      ],
    );
  }

  Widget _lexiqueSubSection(String label, List<_LexiqueEntry> entries) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _danHeader(label),
        ...entries.map((e) {
          return Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Colors.grey.withOpacity(0.12)),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 5,
                  child: Text(
                    e.coreen,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1A2340),
                    ),
                  ),
                ),
                Expanded(
                  flex: 6,
                  child: Text(
                    e.francais,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF546E7A),
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _chiffresSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _danHeader('CHIFFRES'),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: const Color(0xFFF5F7FA),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.withOpacity(0.15)),
          ),
          child: Column(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFF004D40).withOpacity(0.08),
                  borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(12)),
                ),
                child: const Row(
                  children: [
                    Expanded(
                        flex: 3,
                        child: Text('Cardinal',
                            style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF004D40)))),
                    Expanded(
                        flex: 1,
                        child: Text('N°',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF004D40)))),
                    Expanded(
                        flex: 3,
                        child: Text('Ordinal',
                            style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF004D40)))),
                    Expanded(
                        flex: 2,
                        child: Text('Rang',
                            textAlign: TextAlign.right,
                            style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF004D40)))),
                  ],
                ),
              ),
              ..._chiffres.map((c) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 7),
                  decoration: BoxDecoration(
                    border: Border(
                        top: BorderSide(color: Colors.grey.withOpacity(0.12))),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                          flex: 3,
                          child: Text(c.cardinal,
                              style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF1A2340)))),
                      Expanded(
                          flex: 1,
                          child: Text('${c.valeur}',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  fontSize: 12, color: Color(0xFF78909C)))),
                      Expanded(
                          flex: 3,
                          child: Text(c.ordinal,
                              style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF1A2340)))),
                      Expanded(
                          flex: 2,
                          child: Text(c.ordinalLabel,
                              textAlign: TextAlign.right,
                              style: const TextStyle(
                                  fontSize: 11, color: Color(0xFF78909C)))),
                    ],
                  ),
                );
              }),
            ],
          ),
        ),
        const SizedBox(height: 12),
      ],
    );
  }

  // ── Helpers ──────────────────────────────────────────────────

  Widget _danHeader(String label) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
      color: const Color(0xFF0A1628).withOpacity(0.06),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w800,
          color: Color(0xFF37474F),
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}
