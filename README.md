# reflectable-injector

Merges `reflectable` and `injector` libraries into a decent dependency injection library for dart and flutter.
Library's source is in `lib` and `scripts` directories.

Demo terminal app is in `example` directory.

## Requirements
Dart v2.10 or newer

## Running
```shell script
  pub get
  ./scripts/generate-reflectable.sh
  dart ./example/main.dart
```

## Usage
Usage with both standard and *lazy* dependencies is shown in bin/main.dart file

## Generating main.reflectable.dart
Since flutter and dart2native don't dart:mirrors, required metadata cannot be extracted using dart:mirrors.
Use `./scripts/generate-reflectable.sh` script to generate `bin/main.reflectable.dart` to generate the metadata as
alternative to using dart:mirrors.
