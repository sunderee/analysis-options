#!/usr/bin/env bash
rm -rf .dart_tool
rm pubspec.lock analysis-options

dart pub get
dart compile exe --output=analysis-options bin/analysis_options.dart