# Analysis Options

Dart-based CLI tool for automatically populating analysis_options.yaml file with all the available linting rules described by the [official documentation](https://dart.dev/tools/linter-rules).

## Installation

1. Clone the repository.
2. Run `compile.sh` to compile the executable.

## Usage

Run the executable with the following options:

```
$ ./analysis-options --help
-p, --path (mandatory)     Absolute path to the analysis_options.yaml file
-s, --style (mandatory)    Which style set to use
                           [core, recommended, flutter]
-h, --[no-]help            Show the usage syntax.
```

Example:

```
$ ./analysis-options --path /path/to/analysis_options.yaml --style core
```

## Testing

Run the tests with:

```
$ dart test
```
