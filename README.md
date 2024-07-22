# Analysis Options Generator

Dart-based CLI tool for automatically populating analysis_options.yaml file with all the available linting rules
described by the [official documentation](https://dart.dev/tools/linter-rules).

**Motivation**: although VSCode has superb auto-complete functionality through Dart/Flutter plugins, newly generated
Dart/Flutter projects are missing analysis options file with pre-populated linting rules and their explanations (similar
to how TypeScript does it with `tsconfig.json`). As a result, many developers don't configure their linter following
best practices, and manual configuration takes time.

This is an opinionated generator and will set the severity to every enabled rule to `error`.

## Usage

To compile into an executable, run `compile.sh`;

For usage of the executable, use `-h/--help`:

```
% ./analysis-options --help                                                     
-p, --path=<Absolute path to the analysis_options.yaml file> (mandatory)    
-s, --style=<Which style set to use> (mandatory)                            [core, recommended, flutter]
-h, --[no-]help                                                             Show the usage syntax.
```
