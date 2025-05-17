import 'dart:io';

import 'package:analysis_options/data/analysis_rules.dart';
import 'package:analysis_options/data/style.dart';
import 'package:analysis_options/services/yaml_service.dart';
import 'package:test/test.dart';

void main() {
  group('writeAnalysisFile', () {
    late String tempFilePath;
    late Directory tempDir;

    setUp(() {
      tempDir = Directory.systemTemp.createTempSync();
      tempFilePath = '${tempDir.path}/analysis_options.yaml';
    });

    tearDown(() {
      tempDir.deleteSync(recursive: true);
    });

    test('should write core style configuration correctly', () async {
      final rules = [
        AnalysisRules(
          name: 'test_rule',
          description: 'Test rule description',
          sets: ['core'],
          state: 'stable',
          incompatible: [],
          categories: ['style'],
        ),
      ];

      await writeAnalysisFile(tempFilePath, Style.core, rules);

      final content = await File(tempFilePath).readAsString();
      final lines = content.split('\n');

      expect(lines, contains('include: package:lints/core.yaml'));
      expect(lines, contains('  enable-experiment: []'));
      expect(lines, contains('    strict-casts: true'));
      expect(lines, contains('    strict-inference: true'));
      expect(lines, contains('    strict-raw-types: true'));
      expect(lines, contains('    test_rule: error'));
      expect(lines, contains('    - test_rule'));
    });

    test('should write recommended style configuration correctly', () async {
      final rules = [
        AnalysisRules(
          name: 'test_rule',
          description: 'Test rule description',
          sets: ['recommended'],
          state: 'stable',
          incompatible: [],
          categories: ['style'],
        ),
      ];

      await writeAnalysisFile(tempFilePath, Style.recommended, rules);

      final content = await File(tempFilePath).readAsString();
      final lines = content.split('\n');

      expect(lines, contains('include: package:lints/recommended.yaml'));
      expect(lines, contains('    test_rule: error'));
      expect(lines, contains('    - test_rule'));
    });

    test('should write flutter style configuration correctly', () async {
      final rules = [
        AnalysisRules(
          name: 'test_rule',
          description: 'Test rule description',
          sets: ['flutter'],
          state: 'stable',
          incompatible: [],
          categories: ['style'],
        ),
      ];

      await writeAnalysisFile(tempFilePath, Style.flutter, rules);

      final content = await File(tempFilePath).readAsString();
      final lines = content.split('\n');

      expect(lines, contains('include: package:flutter_lints/flutter.yaml'));
      expect(lines, contains('    test_rule: error'));
      expect(lines, contains('    - test_rule'));
    });

    test('should handle unstable rules correctly', () async {
      final rules = [
        AnalysisRules(
          name: 'test_rule',
          description: 'Test rule description',
          sets: ['core'],
          state: 'unstable',
          incompatible: [],
          categories: ['style'],
        ),
      ];

      await writeAnalysisFile(tempFilePath, Style.core, rules);

      final content = await File(tempFilePath).readAsString();
      final lines = content.split('\n');

      expect(lines, contains('    # test_rule: error'));
      expect(lines, contains('    # - test_rule'));
      expect(lines, contains('    # State: unstable'));
    });

    test('should handle incompatible rules correctly', () async {
      final rules = [
        AnalysisRules(
          name: 'test_rule',
          description: 'Test rule description',
          sets: ['core'],
          state: 'stable',
          incompatible: ['other_rule'],
          categories: ['style'],
        ),
      ];

      await writeAnalysisFile(tempFilePath, Style.core, rules);

      final content = await File(tempFilePath).readAsString();
      final lines = content.split('\n');

      expect(lines, contains('    # Incompatible with [other_rule]'));
    });

    test('should handle rules not in the selected style set', () async {
      final rules = [
        AnalysisRules(
          name: 'test_rule',
          description: 'Test rule description',
          sets: ['recommended'], // Not in core
          state: 'stable',
          incompatible: [],
          categories: ['style'],
        ),
      ];

      await writeAnalysisFile(tempFilePath, Style.core, rules);

      final content = await File(tempFilePath).readAsString();
      final lines = content.split('\n');

      expect(lines, contains('    # test_rule: error'));
      expect(lines, contains('    # - test_rule'));
    });

    test('should handle multiple rules correctly', () async {
      final rules = [
        AnalysisRules(
          name: 'rule1',
          description: 'First rule',
          sets: ['core'],
          state: 'stable',
          incompatible: [],
          categories: ['style'],
        ),
        AnalysisRules(
          name: 'rule2',
          description: 'Second rule',
          sets: ['core'],
          state: 'stable',
          incompatible: [],
          categories: ['style'],
        ),
      ];

      await writeAnalysisFile(tempFilePath, Style.core, rules);

      final content = await File(tempFilePath).readAsString();
      final lines = content.split('\n');

      expect(lines, contains('    rule1: error'));
      expect(lines, contains('    rule2: error'));
      expect(lines, contains('    - rule1'));
      expect(lines, contains('    - rule2'));
    });

    test('should handle rules with multiple categories', () async {
      final rules = [
        AnalysisRules(
          name: 'test_rule',
          description: 'Test rule description',
          sets: ['core'],
          state: 'stable',
          incompatible: [],
          categories: ['style', 'error', 'performance'],
        ),
      ];

      await writeAnalysisFile(tempFilePath, Style.core, rules);

      final content = await File(tempFilePath).readAsString();
      final lines = content.split('\n');

      expect(lines, contains('    # Categories: [style, error, performance]'));
    });
  });
}
