import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_progress.dart';

/// Service de persistance de la progression utilisateur via shared_preferences.
class UserProgressService {
  static const _key = 'user_progress_v1';

  Future<UserProgress> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw == null || raw.isEmpty) {
      return const UserProgress();
    }
    return UserProgress.deserialize(raw);
  }

  Future<void> save(UserProgress progress) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, progress.serialize());
  }

  Future<void> reset() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}
