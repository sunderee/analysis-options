import 'dart:io';

import 'package:analysis_options/data/analysis_rules.dart';
import 'package:analysis_options/data/style.dart';

Future<void> writeAnalysisFile(
  String filePath,
  Style style,
  Iterable<AnalysisRules> rules,
) async {
  final buffer = StringBuffer();

  // Imports and strict type checks
  buffer.writeln(_importFromStyle(style));
  buffer.write('\n');
  _strictTypeChecks(buffer);

  // Analyzer errors
  _analyzerErrors(style, rules, buffer);

  // Linter rules
  _linterRules(style, rules, buffer);

  // Write to file
  await File(filePath).writeAsString(buffer.toString());
}

String _importFromStyle(Style style) => switch (style) {
  Style.core => 'include: package:lints/core.yaml',
  Style.recommended => 'include: package:lints/recommended.yaml',
  Style.flutter => 'include: package:flutter_lints/flutter.yaml',
};

void _strictTypeChecks(StringBuffer buffer) {
  buffer.writeln('analyzer:');
  buffer.writeln('  enable-experiment: []');
  buffer.writeln('  language:');
  buffer.writeln('    strict-casts: true');
  buffer.writeln('    strict-inference: true');
  buffer.writeln('    strict-raw-types: true');
}

void _analyzerErrors(
  Style style,
  Iterable<AnalysisRules> rules,
  StringBuffer buffer,
) {
  buffer.writeln('  errors:');
  for (final rule in rules) {
    final line =
        rule.sets.contains(style.name) && rule.state == 'stable'
            ? '    ${rule.name}: error'
            : '    # ${rule.name}: error';
    buffer.writeln(line);
  }

  buffer.write('\n');
}

void _linterRules(
  Style style,
  Iterable<AnalysisRules> rules,
  StringBuffer buffer,
) {
  buffer.writeln('linter:');
  buffer.writeln('  rules:');

  for (final rule in rules) {
    final isEnabled = rule.sets.contains(style.name);
    final isStable = rule.state == 'stable';
    final descriptionLine = '    # ${rule.description.replaceAll('\n', ' ')}';
    buffer.writeln(descriptionLine);

    if (rule.incompatible.isNotEmpty) {
      final incompatibleLine = '    # Incompatible with ${rule.incompatible}';
      buffer.writeln(incompatibleLine);
    }

    if (!isStable) {
      final stateLine = '    # State: ${rule.state}';
      buffer.writeln(stateLine);
    }

    if (rule.categories.isNotEmpty) {
      final categoriesLine = '    # Categories: ${rule.categories}';
      buffer.writeln(categoriesLine);
    }

    final ruleLine =
        isEnabled && isStable ? '    - ${rule.name}' : '    # - ${rule.name}';
    buffer.writeln(ruleLine);
    buffer.write('\n');
  }
}
