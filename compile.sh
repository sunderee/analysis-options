#!/usr/bin/env bash
rm -rf .dart_tool
rm pubspec.lock

dart pub get
dart compile exe --output=analysis-options bin/analysis_options_generator.dart