import 'package:flutter/material.dart';
import '../../services/search_service.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final SearchService _service = SearchService();
  final TextEditingController _controller = TextEditingController();
  List<SearchResult> _results = [];
  SearchResultType? _filter;
  bool _initialized = false;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    await _service.buildIndex();
    if (!mounted) return;
    setState(() {
      _initialized = true;
      _loading = false;
    });
  }

  void _onSearch(String q) {
    setState(() {
      _results = _service.search(q, filter: _filter);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A1628),
        foregroundColor: Colors.white,
        elevation: 0,
        title: TextField(
          controller: _controller,
          autofocus: true,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            hintText: 'Rechercher un terme, une question…',
            hintStyle: TextStyle(color: Colors.white54),
            border: InputBorder.none,
          ),
          onChanged: _onSearch,
        ),
        actions: [
          if (_controller.text.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.close_rounded),
              onPressed: () {
                _controller.clear();
                _onSearch('');
              },
            ),
        ],
      ),
      body: Column(
        children: [
          _FilterBar(
            current: _filter,
            onChanged: (f) {
              setState(() => _filter = f);
              _onSearch(_controller.text);
            },
          ),
          if (_loading)
            const Expanded(
                child: Center(child: CircularProgressIndicator()))
          else
            Expanded(
              child: _results.isEmpty
                  ? Center(
                      child: Text(
                        _controller.text.isEmpty
                            ? 'Tapez pour rechercher dans tout le contenu.'
                            : 'Aucun résultat.',
                        style: TextStyle(color: Colors.grey.shade600),
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.all(12),
                      itemCount: _results.length,
                      separatorBuilder: (_, __) =>
                          const SizedBox(height: 8),
                      itemBuilder: (_, i) {
                        final r = _results[i];
                        return Material(
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.white,
                          elevation: 1,
                          child: ListTile(
                            leading: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: _typeColor(r.type).withOpacity(0.15),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Icon(_typeIcon(r.type),
                                  color: _typeColor(r.type), size: 20),
                            ),
                            title: Text(
                              r.title,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 14,
                              ),
                            ),
                            subtitle: Text(
                              '${r.typeLabel}${r.subtitle != null ? ' · ${r.subtitle}' : ''}',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade700,
                              ),
                            ),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                          ),
                        );
                      },
                    ),
            ),
          if (!_loading && _initialized)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                '${_service.all.length} éléments indexés',
                style: TextStyle(color: Colors.grey.shade600, fontSize: 11),
              ),
            ),
        ],
      ),
    );
  }

  Color _typeColor(SearchResultType t) {
    switch (t) {
      case SearchResultType.term:
        return const Color(0xFF00695C);
      case SearchResultType.question:
        return const Color(0xFF1565C0);
      case SearchResultType.beltRequirement:
        return const Color(0xFFB8860B);
      case SearchResultType.technique:
        return const Color(0xFF4A148C);
      case SearchResultType.rule:
        return const Color(0xFF283593);
    }
  }

  IconData _typeIcon(SearchResultType t) {
    switch (t) {
      case SearchResultType.term:
        return Icons.translate_rounded;
      case SearchResultType.question:
        return Icons.help_rounded;
      case SearchResultType.beltRequirement:
        return Icons.workspace_premium_rounded;
      case SearchResultType.technique:
        return Icons.sports_martial_arts_rounded;
      case SearchResultType.rule:
        return Icons.gavel_rounded;
    }
  }
}

class _FilterBar extends StatelessWidget {
  final SearchResultType? current;
  final ValueChanged<SearchResultType?> onChanged;

  const _FilterBar({required this.current, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final filters = <(String, SearchResultType?)>[
      ('Tout', null),
      ('Termes', SearchResultType.term),
      ('Questions', SearchResultType.question),
      ('Techniques', SearchResultType.technique),
      ('Règles', SearchResultType.rule),
    ];
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: filters.map((f) {
            final selected = current == f.$2;
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: ChoiceChip(
                selected: selected,
                label: Text(f.$1),
                onSelected: (_) => onChanged(f.$2),
                selectedColor: const Color(0xFFCC1122),
                labelStyle: TextStyle(
                  color: selected ? Colors.white : const Color(0xFF37474F),
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
                backgroundColor: const Color(0xFFF5F7FA),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
