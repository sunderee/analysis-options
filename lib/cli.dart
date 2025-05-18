import 'dart:io';

import 'package:analysis_options/data/style.dart';
import 'package:analysis_options/logger.dart';
import 'package:args/args.dart';

typedef ParsedArguments = ({String filePath, Style style});

class CliException implements Exception {
  final String message;

  CliException(this.message);

  @override
  String toString() => 'CliException: $message';
}

ParsedArguments parseArguments(List<String> arguments) {
  final parser = ArgParser();
  parser.addOption(
    'path',
    abbr: 'p',
    mandatory: true,
    help: 'Absolute path to the analysis_options.yaml file',
  );
  parser.addOption(
    'style',
    abbr: 's',
    mandatory: true,
    allowed: Style.values.map((item) => item.name),
    help: 'Which style set to use',
  );
  parser.addFlag('help', abbr: 'h', help: 'Show the usage syntax.');

  try {
    final result = parser.parse(arguments);
    if (result.wasParsed('help')) {
      print(parser.usage);
      // Return an empty result with a special marker for help
      return (filePath: '', style: Style.core);
    }

    String filePath = '';
    Style styleToUse = Style.core;
    if (result.wasParsed('path')) {
      final path = result['path'] as String;
      if (File(path).existsSync()) {
        filePath = path;
      } else {
        Logger.error('File does not exist');
        throw CliException('File does not exist');
      }
    } else {
      throw CliException(parser.usage);
    }

    if (result.wasParsed('style')) {
      final style = result['style'] as String;
      if (Style.values.map((item) => item.name).contains(style)) {
        styleToUse = Style.values.firstWhere((item) => item.name == style);
      } else {
        throw CliException('Invalid style: $style');
      }
    } else {
      throw CliException(parser.usage);
    }

    return (filePath: filePath, style: styleToUse);
  } on ArgParserException catch (error) {
    Logger.error(error.toString());
    throw CliException(error.toString());
  }
}
