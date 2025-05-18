import 'dart:io';

import 'package:analysis_options/cli.dart';
import 'package:analysis_options/logger.dart';
import 'package:analysis_options/services/api_service.dart';
import 'package:analysis_options/services/yaml_service.dart';

Future<void> main(List<String> arguments) async {
  try {
    final parsedArguments = parseArguments(arguments);

    // If help was requested, just exit normally
    if (arguments.contains('-h') || arguments.contains('--help')) {
      exit(0);
    }

    Logger.debug('Fetching analysis rules...');
    final analysisRules = await fetchAnalysisRules();

    Logger.debug('Writing to analysis_options.yaml...');
    await writeAnalysisFile(
      parsedArguments.filePath,
      parsedArguments.style,
      analysisRules,
    );

    Logger.success('Done!');
  } on CliException catch (e) {
    print(e);
    exit(1);
  }
}
