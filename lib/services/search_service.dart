import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

enum SearchResultType { term, question, beltRequirement, technique, rule }

class SearchResult {
  final String title;
  final String? subtitle;
  final SearchResultType type;
  final String? sourceBelt;
  final String? rawContent;

  SearchResult({
    required this.title,
    required this.type,
    this.subtitle,
    this.sourceBelt,
    this.rawContent,
  });

  String get typeLabel {
    switch (type) {
      case SearchResultType.term:
        return 'Terme';
      case SearchResultType.question:
        return 'Question';
      case SearchResultType.beltRequirement:
        return 'Critère';
      case SearchResultType.technique:
        return 'Technique';
      case SearchResultType.rule:
        return 'Règle';
    }
  }
}

/// Indexe tous les JSON de l'app et permet une recherche textuelle globale.
class SearchService {
  static final SearchService _instance = SearchService._();
  factory SearchService() => _instance;
  SearchService._();

  final List<SearchResult> _index = [];
  bool _built = false;

  List<SearchResult> get all => List.unmodifiable(_index);

  Future<void> buildIndex() async {
    if (_built) return;
    _index.clear();

    await _indexTerms();
    await _indexQuestions();
    await _indexReferenceOfficielle();
    await _indexRules();

    _built = true;
  }

  Future<void> _indexTerms() async {
    try {
      final raw = await rootBundle.loadString('assets/terms.json');
      final data = jsonDecode(raw);
      if (data is List) {
        for (final item in data) {
          if (item is Map) {
            final fr = item['french']?.toString() ??
                item['fr']?.toString() ??
                item['traduction']?.toString() ??
                '';
            final ko = item['korean']?.toString() ??
                item['ko']?.toString() ??
                item['terme']?.toString() ??
                '';
            if (fr.isEmpty && ko.isEmpty) continue;
            _index.add(SearchResult(
              title: ko.isNotEmpty ? ko : fr,
              subtitle: ko.isNotEmpty && fr.isNotEmpty ? fr : null,
              type: SearchResultType.term,
              rawContent: '$fr $ko',
            ));
          }
        }
      }
    } catch (_) {
      // Asset absent ou format inattendu : on ignore.
    }
  }

  Future<void> _indexQuestions() async {
    const files = [
      'assets/questions_jaune.json',
      'assets/questions_jaune_barrette1.json',
      'assets/questions_jaune_barrette2.json',
      'assets/questions_bleu.json',
      'assets/questions_bleu_barrette1.json',
      'assets/questions_bleu_barrette2.json',
      'assets/questions_rouge.json',
      'assets/questions_rouge_barrette1.json',
      'assets/questions_rouge_barrette2.json',
      'assets/questions_noire.json',
      'assets/questions_module_b_2eme_dan.json',
      'assets/questions_module_b_3eme_dan_partie1.json',
      'assets/questions_module_b_3eme_dan_partie2.json',
    ];
    for (final f in files) {
      try {
        final raw = await rootBundle.loadString(f);
        final data = jsonDecode(raw);
        if (data is List) {
          for (final item in data) {
            if (item is Map) {
              final q = item['question']?.toString() ?? '';
              if (q.isEmpty) continue;
              final belt = _beltFromAssetPath(f);
              _index.add(SearchResult(
                title: q,
                subtitle: belt,
                sourceBelt: belt,
                type: SearchResultType.question,
                rawContent: q,
              ));
            }
          }
        }
      } catch (_) {
        // ignore
      }
    }
  }

  Future<void> _indexReferenceOfficielle() async {
    try {
      final raw =
          await rootBundle.loadString('assets/reference_officielle.json');
      final data = jsonDecode(raw);
      void walk(dynamic node) {
        if (node is Map) {
          final nom = node['nom'] ?? node['name'] ?? node['title'];
          if (nom != null) {
            _index.add(SearchResult(
              title: nom.toString(),
              subtitle: node['traduction']?.toString() ??
                  node['description']?.toString(),
              type: SearchResultType.technique,
              rawContent: node.values.map((e) => e.toString()).join(' '),
            ));
          }
          for (final v in node.values) {
            walk(v);
          }
        } else if (node is List) {
          for (final e in node) {
            walk(e);
          }
        }
      }

      walk(data);
    } catch (_) {
      // ignore
    }
  }

  Future<void> _indexRules() async {
    try {
      final raw = await rootBundle.loadString('assets/rules.json');
      final data = jsonDecode(raw);
      void walk(dynamic node, {String? parentTitle}) {
        if (node is Map) {
          final title = node['title']?.toString() ??
              node['titre']?.toString() ??
              parentTitle;
          final content = node['content']?.toString() ??
              node['description']?.toString() ??
              '';
          if ((title ?? '').isNotEmpty && content.isNotEmpty) {
            _index.add(SearchResult(
              title: title!,
              subtitle: content.length > 80
                  ? '${content.substring(0, 77)}...'
                  : content,
              type: SearchResultType.rule,
              rawContent: '$title $content',
            ));
          }
          for (final v in node.values) {
            walk(v, parentTitle: title);
          }
        } else if (node is List) {
          for (final e in node) {
            walk(e, parentTitle: parentTitle);
          }
        }
      }

      walk(data);
    } catch (_) {
      // ignore
    }
  }

  String? _beltFromAssetPath(String path) {
    if (path.contains('jaune_barrette1')) return 'Jaune barrette 1';
    if (path.contains('jaune_barrette2')) return 'Jaune barrette 2';
    if (path.contains('jaune')) return 'Jaune';
    if (path.contains('bleu_barrette1')) return 'Bleu barrette 1';
    if (path.contains('bleu_barrette2')) return 'Bleu barrette 2';
    if (path.contains('bleu')) return 'Bleu';
    if (path.contains('rouge_barrette1')) return 'Rouge barrette 1';
    if (path.contains('rouge_barrette2')) return 'Rouge barrette 2';
    if (path.contains('rouge')) return 'Rouge';
    if (path.contains('noire')) return 'Noire';
    if (path.contains('module_b_2eme')) return 'Module B - 2ème Dan';
    if (path.contains('module_b_3eme_dan_partie1')) {
      return 'Module B - 3ème Dan partie 1';
    }
    if (path.contains('module_b_3eme_dan_partie2')) {
      return 'Module B - 3ème Dan partie 2';
    }
    return null;
  }

  List<SearchResult> search(String query, {SearchResultType? filter}) {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return [];
    final results = _index.where((r) {
      if (filter != null && r.type != filter) return false;
      final hay = '${r.title} ${r.subtitle ?? ''} ${r.rawContent ?? ''}'
          .toLowerCase();
      return hay.contains(q);
    }).toList();
    results.sort((a, b) {
      final at = a.title.toLowerCase().startsWith(q) ? 0 : 1;
      final bt = b.title.toLowerCase().startsWith(q) ? 0 : 1;
      return at.compareTo(bt);
    });
    return results.take(100).toList();
  }
}
