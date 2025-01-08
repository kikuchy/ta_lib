<!-- 
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/tools/pub/writing-package-pages). 

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/to/develop-packages). 
-->

Dart wrapper of [TA-Lib](https://ta-lib.org/).

## Warning

This package is not yet stable.

Almost all functions are not implemented. See [Roadmap](Roadmap.md).

## Getting started

```
dart pub add ta_lib
```

### Warning

Linux users need to copy pre-compiled so file or build the ta-lib library from source, and put
the binary file in the `ta-lib` directory.

## Usage

You can call TA-Lib functions from `TaLib` class.
About functions, see [function list of TA-Lib](https://ta-lib.org/functions/).

```dart
final taLib = TaLib();
final result = taLib.ma(1, 4, [1, 2, 3, 4, 5], maType: MaType.sma, timePeriod: 3);
print(result); // [2.0, 3.0, 4.0]
```

