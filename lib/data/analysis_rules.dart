final class AnalysisRules {
  static bool _listEquals(List<String> a, List<String> b) {
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }

  final String name;
  final String description;
  final List<String> categories;
  final String state;
  final List<String> incompatible;
  final List<String> sets;

  const AnalysisRules({
    required this.name,
    required this.description,
    required this.categories,
    required this.state,
    required this.incompatible,
    required this.sets,
  });

  factory AnalysisRules.fromJson(Map<String, dynamic> json) {
    return AnalysisRules(
      name: json['name'] as String,
      description: json['description'] as String,
      categories: (json['categories'] as List<dynamic>).cast<String>(),
      state: json['state'] as String,
      incompatible: (json['incompatible'] as List<dynamic>).cast<String>(),
      sets: (json['sets'] as List<dynamic>).cast<String>(),
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is AnalysisRules &&
            runtimeType == other.runtimeType &&
            name == other.name &&
            description == other.description &&
            _listEquals(categories, other.categories) &&
            state == other.state &&
            _listEquals(incompatible, other.incompatible) &&
            _listEquals(sets, other.sets);
  }

  @override
  int get hashCode =>
      name.hashCode ^
      description.hashCode ^
      categories.hashCode ^
      state.hashCode ^
      incompatible.hashCode ^
      sets.hashCode;
}
