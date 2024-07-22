import 'dart:io';

import 'package:analysis_options_generator/src/models.dart';

final class Parser {
  String parse(List<RuleModel> rules, String style) {
    final buffer = StringBuffer();

    // Import statement
    final importStatement = switch (style) {
      'core' => 'include: package:lints/core.yaml',
      'recommended' => 'include: package:lints/recommended.yaml',
      'flutter' => 'include: package:flutter_lints/flutter.yaml',
      _ => 'include: package:lints/core.yaml',
    };
    buffer.writeln(importStatement);
    buffer.write('\n');

    // Analyzer section
    buffer.writeln('analyzer:');
    buffer.writeln('  exclude: ["build/**"]');
    buffer.writeln('  language:');
    buffer.writeln('    strict-casts: true');
    buffer.writeln('    strict-inference: true');
    buffer.writeln('    strict-raw-types: true');
    buffer.writeln('  errors:');

    // Overall errors section
    for (final rule in rules) {
      if (rule.sets.contains(style)) {
        buffer.writeln('    ${rule.name}: error');
      } else {
        buffer.writeln('    # ${rule.name}: error');
      }
    }

    // Linter section
    buffer.write('\n');
    buffer.writeln('linter:');
    buffer.writeln('  rules:');
    for (final rule in rules) {
      buffer.writeln('    # ${rule.description}');

      if (rule.sets.contains(style)) {
        buffer.writeln('    - ${rule.name}');
      } else {
        buffer.writeln('    # - ${rule.name}');
      }
      buffer.write('\n');
    }

    return buffer.toString();
  }

  Future<void> writeToFile(String absolutePath, String contents) async {
    await File(absolutePath).writeAsString(contents);
  }
}
