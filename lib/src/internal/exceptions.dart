import 'package:analysis_options_generator/src/internal/equatable.dart';

sealed class GlobalException extends Equatable implements Exception {
  const GlobalException._();
}

final class DownloaderException extends GlobalException {
  final int statusCode;
  final String rawBody;

  const DownloaderException(this.statusCode, this.rawBody) : super._();

  @override
  List<Object?> get props => [statusCode, rawBody];
}
