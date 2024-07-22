import 'package:analysis_options_generator/src/downloader.dart';
import 'package:test/test.dart';

void main() {
  group('Downloader', () {
    final downloader = Downloader();

    test('should download all linter rules', () async {
      final result = await downloader.downloadRuleModels();
      expect(result, isNotEmpty);
    });
  });
}
