import 'dart:io';

import 'package:analysis_options/cli.dart';
import 'package:analysis_options/data/style.dart';
import 'package:test/test.dart';

void main() {
  group('parseArguments', () {
    late String tempFilePath;
    late Directory tempDir;

    setUp(() {
      tempDir = Directory.systemTemp.createTempSync();
      tempFilePath = '${tempDir.path}/analysis_options.yaml';
      File(tempFilePath).createSync();
    });

    tearDown(() {
      tempDir.deleteSync(recursive: true);
    });

    test('should parse valid arguments correctly', () {
      final args = ['--path', tempFilePath, '--style', 'core'];
      final result = parseArguments(args);

      expect(result.filePath, equals(tempFilePath));
      expect(result.style, equals(Style.core));
    });

    test('should handle short form arguments', () {
      final args = ['-p', tempFilePath, '-s', 'core'];
      final result = parseArguments(args);

      expect(result.filePath, equals(tempFilePath));
      expect(result.style, equals(Style.core));
    });

    test('should throw error for non-existent file', () {
      final args = ['--path', '/non/existent/path.yaml', '--style', 'core'];

      expect(() => parseArguments(args), throwsA(isA<CliException>()));
    });

    test('should throw error for invalid style', () {
      final args = ['--path', tempFilePath, '--style', 'invalid_style'];

      expect(() => parseArguments(args), throwsA(isA<CliException>()));
    });

    test('should throw error when required arguments are missing', () {
      final args = ['--path', tempFilePath];

      expect(() => parseArguments(args), throwsA(isA<CliException>()));
    });

    test('should handle help flag', () {
      final args = ['--help'];
      final result = parseArguments(args);

      expect(result.filePath, equals(''));
      expect(result.style, equals(Style.core));
    });

    test('should handle all valid styles', () {
      for (final style in Style.values) {
        final args = ['--path', tempFilePath, '--style', style.name];
        final result = parseArguments(args);

        expect(result.style, equals(style));
      }
    });
  });
}
