# Analysis Options

Dart-based CLI tool for automatically populating analysis_options.yaml file with all the available linting rules described by the [official documentation](https://dart.dev/tools/linter-rules).

## Usage

To compile into an executable, run `compile.sh`;

For usage of the executable, use `-h/--help`:

```
% ./analysis-options --help                                                     
-p, --path=<Absolute path to the analysis_options.yaml file> (mandatory)    
-s, --style=<Which style set to use> (mandatory)                            [core, recommended, flutter]
-h, --[no-]help                                                             Show the usage syntax.
```
