import 'dart:io';

import 'package:analysis_options/data/style.dart';
import 'package:analysis_options/logger.dart';
import 'package:args/args.dart';

typedef ParsedArguments = ({String filePath, Style style});

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
  );
  parser.addFlag('help', abbr: 'h', help: 'Show the usage syntax.');

  try {
    final result = parser.parse(arguments);
    if (result.wasParsed('help')) {
      print(parser.usage);
      exit(0);
    }

    String filePath = '';
    Style styleToUse = Style.core;
    if (result.wasParsed('path')) {
      final path = result['path'] as String;
      if (File(path).existsSync()) {
        filePath = path;
      } else {
        Logger.error('File does not exist');
        exit(1);
      }
    } else {
      print(parser.usage);
      exit(1);
    }

    if (result.wasParsed('style')) {
      final style = result['style'] as String;
      if (Style.values.map((item) => item.name).contains(style)) {
        styleToUse = Style.values.firstWhere((item) => item.name == style);
      }
    } else {
      print(parser.usage);
      exit(1);
    }

    return (filePath: filePath, style: styleToUse);
  } catch (error) {
    Logger.error(error.toString());
    exit(1);
  }
}
