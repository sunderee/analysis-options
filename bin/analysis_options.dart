import 'package:analysis_options/data/style.dart';
import 'package:analysis_options/services/api_service.dart';
import 'package:analysis_options/services/yaml_service.dart';

Future<void> main(List<String> arguments) async {
  final analysisRules = await fetchAnalysisRules();

  await writeAnalysisFile(
    '/Users/peteraleksanderbizjak/Documents/private/tooling/analysis_options/analysis_options.yaml',
    Style.recommended,
    analysisRules,
  );
}
