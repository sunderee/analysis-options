import 'package:analysis_options/cli.dart';
import 'package:analysis_options/logger.dart';
import 'package:analysis_options/services/api_service.dart';
import 'package:analysis_options/services/yaml_service.dart';

Future<void> main(List<String> arguments) async {
  final parsedArguments = parseArguments(arguments);

  Logger.debug('Fetching analysis rules...');
  final analysisRules = await fetchAnalysisRules();

  Logger.debug('Writing to analysis_options.yaml...');
  await writeAnalysisFile(
    parsedArguments.filePath,
    parsedArguments.style,
    analysisRules,
  );

  Logger.success('Done!');
}
