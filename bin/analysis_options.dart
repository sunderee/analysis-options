import 'package:analysis_options/cli.dart';
import 'package:analysis_options/services/api_service.dart';
import 'package:analysis_options/services/yaml_service.dart';

Future<void> main(List<String> arguments) async {
  final parsedArguments = parseArguments(arguments);
  final analysisRules = await fetchAnalysisRules();

  await writeAnalysisFile(
    parsedArguments.filePath,
    parsedArguments.style,
    analysisRules,
  );
}
