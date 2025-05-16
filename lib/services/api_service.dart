import 'dart:convert';
import 'dart:io';

import 'package:analysis_options/data/analysis_rules.dart';

Future<Iterable<AnalysisRules>> fetchAnalysisRules() async {
  final httpClient = HttpClient();
  final url = Uri.https(
    'raw.githubusercontent.com',
    'dart-lang/site-www/main/src/_data/linter_rules.json',
  );

  final request = await httpClient.getUrl(url)
    ..headers.contentType = ContentType.json;
  final response = await request.close();
  httpClient.close();

  final body = await response.transform(Utf8Decoder()).join('');
  return (jsonDecode(body) as List<dynamic>).cast<Map<String, dynamic>>().map(
    AnalysisRules.fromJson,
  );
}
