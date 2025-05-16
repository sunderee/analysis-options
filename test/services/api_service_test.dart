import 'package:analysis_options/services/api_service.dart';
import 'package:test/test.dart';

void main() {
  group('fetchAnalysisRules', () {
    test('should fetch analysis rules from the API', () async {
      final result = await fetchAnalysisRules();
      expect(result, isNotEmpty);
    });
  });
}
