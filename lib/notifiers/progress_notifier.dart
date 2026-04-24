import 'package:flutter/foundation.dart';
import '../models/user_progress.dart';
import '../services/user_progress_service.dart';

/// Notifier ChangeNotifier encapsulant la progression utilisateur.
class ProgressNotifier extends ChangeNotifier {
  final UserProgressService _service = UserProgressService();
  UserProgress _progress = const UserProgress();
  bool _loaded = false;

  UserProgress get progress => _progress;
  bool get isLoaded => _loaded;
  String get currentBeltId => _progress.currentBeltId;
  Set<String> get favorites => _progress.favorites;

  Future<void> init() async {
    _progress = await _service.load();
    _loaded = true;
    notifyListeners();
  }

  Future<void> setCurrentBelt(String beltId) async {
    _progress = _progress.copyWith(currentBeltId: beltId);
    await _service.save(_progress);
    notifyListeners();
  }

  Future<void> toggleCompleted(String beltId, String itemId) async {
    final current = Map<String, Set<String>>.from(_progress.completedItems);
    final set = Set<String>.from(current[beltId] ?? <String>{});
    if (set.contains(itemId)) {
      set.remove(itemId);
    } else {
      set.add(itemId);
    }
    current[beltId] = set;
    _progress = _progress.copyWith(completedItems: current);
    await _service.save(_progress);
    notifyListeners();
  }

  bool isCompleted(String beltId, String itemId) {
    return _progress.completedItems[beltId]?.contains(itemId) ?? false;
  }

  int completedCount(String beltId) =>
      _progress.completedItems[beltId]?.length ?? 0;

  Future<void> toggleFavorite(String id) async {
    final favs = Set<String>.from(_progress.favorites);
    if (favs.contains(id)) {
      favs.remove(id);
    } else {
      favs.add(id);
    }
    _progress = _progress.copyWith(favorites: favs);
    await _service.save(_progress);
    notifyListeners();
  }

  bool isFavorite(String id) => _progress.favorites.contains(id);

  Future<void> setLastActivity(String id, String label) async {
    _progress = _progress.copyWith(
      lastActivityId: id,
      lastActivityLabel: label,
    );
    await _service.save(_progress);
    notifyListeners();
  }

  Future<void> reset() async {
    await _service.reset();
    _progress = const UserProgress();
    notifyListeners();
  }
}
