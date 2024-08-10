import 'package:analysis_options_generator/src/internal/equatable.dart';
import 'package:analysis_options_generator/src/internal/types.dart';
import 'package:meta/meta.dart';

@immutable
final class RuleModel extends Equatable {
  final String name;
  final String description;
  final List<String> sets;
  final String sinceDartSdk;
  final String state;

  const RuleModel({
    required this.name,
    required this.description,
    required this.sets,
    required this.sinceDartSdk,
    required this.state,
  });

  factory RuleModel.fromJson(JsonObject json) => RuleModel(
        name: json['name'] as String,
        description:
            (json['description'] as String).replaceAll(RegExp(r'\s\s+'), ' '),
        sets: (json['sets'] as List<dynamic>).cast<String>(),
        sinceDartSdk: json['sinceDartSdk'] as String,
        state: json['state'] as String,
      );

  @override
  List<Object?> get props => [
        name,
        description,
        List<String>.from(sets),
        sinceDartSdk,
        state,
      ];
}
