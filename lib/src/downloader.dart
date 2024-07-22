import 'dart:convert';
import 'dart:io';

import 'package:analysis_options_generator/src/internal/exceptions.dart';
import 'package:analysis_options_generator/src/internal/types.dart';
import 'package:analysis_options_generator/src/models.dart';
import 'package:collection/collection.dart';

final class Downloader {
  static final _allLinterRulesURL = Uri.https(
    'raw.githubusercontent.com',
    'dart-lang/site-www/main/src/_data/linter_rules.json',
  );

  final HttpClient _client;

  Downloader() : _client = HttpClient();

  Future<List<RuleModel>> downloadRuleModels() async {
    final request = await _client.getUrl(_allLinterRulesURL)
      ..headers.add(HttpHeaders.acceptHeader, ContentType.json.toString());

    final response = await request.close();
    final body = await response
        .transform(Utf8Decoder(allowMalformed: true))
        .reduce((previous, current) => previous + current);

    if (response.statusCode >= 300) {
      throw DownloaderException(response.statusCode, body);
    }

    return (jsonDecode(body) as List<dynamic>)
        .cast<JsonObject>()
        .map((item) => RuleModel.fromJson(item))
        .sorted((first, second) => first.name.compareTo(second.name))
        .where((item) =>
            item.sinceDartSdk != 'Unreleased' &&
            !item.sinceDartSdk.contains('-wip') &&
            item.state != 'removed' &&
            item.state != 'internal')
        .toList();
  }
}
