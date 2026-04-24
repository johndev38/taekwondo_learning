import 'dart:convert';

/// État de progression d'un utilisateur pour l'app Taekwondo Knowledge.
///
/// - currentBeltId : identifiant de la ceinture courante (ex. "8K", "6K", ...)
/// - completedItems : map ceinture -> ensemble d'items cochés
///   (ex. { "8K": {"positions:ap_seogi", "poomsae:taegeuk1"} })
/// - favorites : ensemble d'identifiants favoris (termes, questions, techniques)
/// - lastActivity : dernier écran consulté (pour la carte « Continuer »)
class UserProgress {
  final String currentBeltId;
  final Map<String, Set<String>> completedItems;
  final Set<String> favorites;
  final String? lastActivityId;
  final String? lastActivityLabel;

  const UserProgress({
    this.currentBeltId = 'none',
    this.completedItems = const {},
    this.favorites = const {},
    this.lastActivityId,
    this.lastActivityLabel,
  });

  UserProgress copyWith({
    String? currentBeltId,
    Map<String, Set<String>>? completedItems,
    Set<String>? favorites,
    String? lastActivityId,
    String? lastActivityLabel,
  }) {
    return UserProgress(
      currentBeltId: currentBeltId ?? this.currentBeltId,
      completedItems: completedItems ?? this.completedItems,
      favorites: favorites ?? this.favorites,
      lastActivityId: lastActivityId ?? this.lastActivityId,
      lastActivityLabel: lastActivityLabel ?? this.lastActivityLabel,
    );
  }

  Map<String, dynamic> toJson() => {
        'currentBeltId': currentBeltId,
        'completedItems':
            completedItems.map((k, v) => MapEntry(k, v.toList())),
        'favorites': favorites.toList(),
        'lastActivityId': lastActivityId,
        'lastActivityLabel': lastActivityLabel,
      };

  factory UserProgress.fromJson(Map<String, dynamic> json) {
    final raw = (json['completedItems'] as Map?) ?? const {};
    final completed = <String, Set<String>>{};
    raw.forEach((k, v) {
      completed[k.toString()] =
          ((v as List?) ?? const []).map((e) => e.toString()).toSet();
    });
    return UserProgress(
      currentBeltId: (json['currentBeltId'] ?? 'none').toString(),
      completedItems: completed,
      favorites: ((json['favorites'] as List?) ?? const [])
          .map((e) => e.toString())
          .toSet(),
      lastActivityId: json['lastActivityId'] as String?,
      lastActivityLabel: json['lastActivityLabel'] as String?,
    );
  }

  String serialize() => jsonEncode(toJson());

  factory UserProgress.deserialize(String raw) {
    try {
      return UserProgress.fromJson(
          jsonDecode(raw) as Map<String, dynamic>);
    } catch (_) {
      return const UserProgress();
    }
  }
}
