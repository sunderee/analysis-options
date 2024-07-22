import 'dart:io';

import 'package:analysis_options_generator/src/downloader.dart';
import 'package:analysis_options_generator/src/logger.dart';
import 'package:analysis_options_generator/src/parser.dart';
import 'package:args/args.dart';

final Downloader _downloader = Downloader();
final Parser _parser = Parser();

Future<void> execute(List<String> arguments) async {
  final parser = ArgParser()
    ..addOption(
      'path',
      abbr: 'p',
      valueHelp: 'Absolute path to the analysis_options.yaml file',
      mandatory: true,
    )
    ..addOption(
      'style',
      abbr: 's',
      valueHelp: 'Which style set to use',
      allowed: ['core', 'recommended', 'flutter'],
      mandatory: true,
    )
    ..addFlag(
      'help',
      abbr: 'h',
      help: 'Show the usage syntax.',
    );

  try {
    final results = parser.parse(arguments);
    if (results.wasParsed('help')) {
      print(parser.usage);
      exit(0);
    }

    Logger.debug('Downloading rules...');
    final rules = await _downloader.downloadRuleModels();

    Logger.debug('Parsing rules for ${results['style']}');
    final parsedResults = _parser.parse(
      rules,
      results['style'] as String,
    );

    Logger.debug('Writing to file ${results['path']}');
    await _parser.writeToFile(
      results['path'] as String,
      parsedResults,
    );

    Logger.success('Done!');
  } on FormatException catch (error) {
    Logger.error(error.message);

    exit(1);
  }
}
