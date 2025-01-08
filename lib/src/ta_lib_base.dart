import 'dart:ffi';
import 'dart:io';
import 'package:ffi/ffi.dart';
import 'package:path/path.dart' as path;

import 'package:ta_lib/src/generated_bindings.dart';

class TaLib {
  static TaLib? _instance;
  late final NativeLibrary _nativeBindings;

  factory TaLib() {
    return TaLib._instance ??= TaLib._();
  }

  TaLib._() {
    var libraryPath =
        path.join(Directory.current.path, 'ta-lib', 'libta-lib.0.6.0.so');
    if (Platform.isMacOS) {
      libraryPath =
          path.join(Directory.current.path, 'ta-lib', 'libta-lib.0.6.0.dylib');
    } else if (Platform.isWindows) {
      libraryPath = path.join(
          Directory.current.path, 'ta-lib', 'Debug', 'ta-lib.0.6.0.dll');
    }
    final dylib = DynamicLibrary.open(libraryPath);
    _nativeBindings = NativeLibrary(dylib);
    _nativeBindings.TA_Initialize();
  }

  /// Average True Range
  List<double> atr(
    List<double> high,
    List<double> low,
    List<double> close, {
    int? timePeriod,
  }) {
    return using((arena) {
      final inHigh = arena<Double>(high.length);
      for (var i = 0; i < high.length; i++) {
        inHigh[i] = high[i];
      }

      final inLow = arena<Double>(low.length);
      for (var i = 0; i < low.length; i++) {
        inLow[i] = low[i];
      }

      final inClose = arena<Double>(close.length);
      for (var i = 0; i < close.length; i++) {
        inClose[i] = close[i];
      }

      final startIdx = 0;
      final endIdx = close.length - 1;
      final outBegIdx = arena<Int32>(1);
      final outNBElement = arena<Int32>(1);
      final outReal = arena<Double>(endIdx - startIdx + 1);
      final retCode = _nativeBindings.TA_ATR(
        startIdx,
        endIdx,
        inHigh,
        inLow,
        inClose,
        timePeriod ?? TA_INTEGER_DEFAULT,
        outBegIdx,
        outNBElement,
        outReal,
      );
      if (retCode != TA_RetCode.TA_SUCCESS) {
        throw TaLibException(retCode);
      }
      return outReal.asTypedList(outNBElement.value).toList();
    }, malloc);
  }

  // Bollinger Bands
  ({List<double> upperBand, List<double> middleBand, List<double> lowerBand})
      bbands(
    List<double> real, {
    int? timePeriod,
    double? nbDevUp,
    double? nbDevDn,
    MaType maType = MaType.sma,
  }) {
    return using((arena) {
      final inReal = arena<Double>(real.length);
      for (var i = 0; i < real.length; i++) {
        inReal[i] = real[i];
      }
      final startIdx = 0;
      final endIdx = real.length - 1;
      final outBegIdx = arena<Int32>(1);
      final outNBElement = arena<Int32>(1);
      final outRealUpperBand = arena<Double>(endIdx - startIdx + 1);
      final outRealMiddleBand = arena<Double>(endIdx - startIdx + 1);
      final outRealLowerBand = arena<Double>(endIdx - startIdx + 1);
      final retCode = _nativeBindings.TA_BBANDS(
          startIdx,
          endIdx,
          inReal,
          timePeriod ?? TA_INTEGER_DEFAULT,
          nbDevUp ?? TA_REAL_DEFAULT,
          nbDevDn ?? TA_REAL_DEFAULT,
          maType.toNative(),
          outBegIdx,
          outNBElement,
          outRealUpperBand,
          outRealMiddleBand,
          outRealLowerBand);
      if (retCode != TA_RetCode.TA_SUCCESS) {
        throw TaLibException(retCode);
      }
      return (
        upperBand: outRealUpperBand.asTypedList(outNBElement.value).toList(),
        middleBand: outRealMiddleBand.asTypedList(outNBElement.value).toList(),
        lowerBand: outRealLowerBand.asTypedList(outNBElement.value).toList(),
      );
    }, malloc);
  }

  /// All Moving Average
  List<double> ma(
    List<double> real, {
    int? timePeriod,
    MaType maType = MaType.sma,
  }) {
    return using((arena) {
      final inReal = arena<Double>(real.length);
      for (var i = 0; i < real.length; i++) {
        inReal[i] = real[i];
      }
      final startIdx = 0;
      final endIdx = real.length - 1;
      final outBegIdx = arena<Int32>(1);
      final outNBElement = arena<Int32>(1);
      final outReal = arena<Double>(endIdx - startIdx + 1);
      final retCode = _nativeBindings.TA_MA(
          startIdx,
          endIdx,
          inReal,
          timePeriod ?? TA_INTEGER_DEFAULT,
          maType.toNative(),
          outBegIdx,
          outNBElement,
          outReal);
      if (retCode != TA_RetCode.TA_SUCCESS) {
        throw TaLibException(retCode);
      }
      return outReal.asTypedList(outNBElement.value).toList();
    }, malloc);
  }

  ({List<double> macd, List<double> macdSignal, List<double> macdHist}) macd(
    List<double> real, {
    int? fastPeriod,
    int? slowPeriod,
    int? signalPeriod,
  }) {
    return using((arena) {
      final inReal = arena<Double>(real.length);
      for (var i = 0; i < real.length; i++) {
        inReal[i] = real[i];
      }
      final startIdx = 0;
      final endIdx = real.length - 1;
      final outBegIdx = arena<Int32>(1);
      final outNBElement = arena<Int32>(1);
      final outMACD = arena<Double>(endIdx - startIdx + 1);
      final outMACDSignal = arena<Double>(endIdx - startIdx + 1);
      final outMACDHist = arena<Double>(endIdx - startIdx + 1);
      final retCode = _nativeBindings.TA_MACD(
        startIdx,
        endIdx,
        inReal,
        fastPeriod ?? TA_INTEGER_DEFAULT,
        slowPeriod ?? TA_INTEGER_DEFAULT,
        signalPeriod ?? TA_INTEGER_DEFAULT,
        outBegIdx,
        outNBElement,
        outMACD,
        outMACDSignal,
        outMACDHist,
      );
      if (retCode != TA_RetCode.TA_SUCCESS) {
        throw TaLibException(retCode);
      }
      print(outNBElement.value);
      return (
        macd: outMACD.asTypedList(outNBElement.value).toList(),
        macdSignal: outMACDSignal.asTypedList(outNBElement.value).toList(),
        macdHist: outMACDHist.asTypedList(outNBElement.value).toList(),
      );
    });
  }

  /// Relative Strength Index
  List<double> rsi(
    List<double> real, {
    int? timePeriod,
  }) {
    return using((arena) {
      final inReal = arena<Double>(real.length);
      for (var i = 0; i < real.length; i++) {
        inReal[i] = real[i];
      }
      final startIdx = 0;
      final endIdx = real.length - 1;
      final outBegIdx = arena<Int32>(1);
      final outNBElement = arena<Int32>(1);
      final outReal = arena<Double>(endIdx - startIdx + 1);
      final retCode = _nativeBindings.TA_RSI(
        startIdx,
        endIdx,
        inReal,
        timePeriod ?? TA_INTEGER_DEFAULT,
        outBegIdx,
        outNBElement,
        outReal,
      );
      if (retCode != TA_RetCode.TA_SUCCESS) {
        throw TaLibException(retCode);
      }
      return outReal.asTypedList(outNBElement.value).toList();
    });
  }

  List<double> trange(
    List<double> high,
    List<double> low,
    List<double> close,
  ) {
    return using((arena) {
      final inHigh = arena<Double>(high.length);
      for (var i = 0; i < high.length; i++) {
        inHigh[i] = high[i];
      }

      final inLow = arena<Double>(low.length);
      for (var i = 0; i < low.length; i++) {
        inLow[i] = low[i];
      }

      final inClose = arena<Double>(close.length);
      for (var i = 0; i < close.length; i++) {
        inClose[i] = close[i];
      }

      final startIdx = 0;
      final endIdx = close.length - 1;
      final outBegIdx = arena<Int32>(1);
      final outNBElement = arena<Int32>(1);
      final outReal = arena<Double>(endIdx - startIdx + 1);
      final retCode = _nativeBindings.TA_TRANGE(
        startIdx,
        endIdx,
        inHigh,
        inLow,
        inClose,
        outBegIdx,
        outNBElement,
        outReal,
      );
      if (retCode != TA_RetCode.TA_SUCCESS) {
        throw TaLibException(retCode);
      }
      return outReal.asTypedList(outNBElement.value).toList();
    });
  }
}

enum MaType {
  sma,
  ema,
  wma,
  dema,
  tema,
  trima,
  kama,
  mama,
  t3,
}

extension on MaType {
  TA_MAType toNative() => switch (this) {
        MaType.sma => TA_MAType.TA_MAType_SMA,
        MaType.ema => TA_MAType.TA_MAType_EMA,
        MaType.wma => TA_MAType.TA_MAType_WMA,
        MaType.dema => TA_MAType.TA_MAType_DEMA,
        MaType.tema => TA_MAType.TA_MAType_TEMA,
        MaType.trima => TA_MAType.TA_MAType_TRIMA,
        MaType.kama => TA_MAType.TA_MAType_KAMA,
        MaType.mama => TA_MAType.TA_MAType_MAMA,
        MaType.t3 => TA_MAType.TA_MAType_T3,
      };
}

class TaLibException implements Exception {
  final TA_RetCode code;
  TaLibException(this.code);

  @override
  String toString() {
    return 'TaLibException: $code';
  }
}
