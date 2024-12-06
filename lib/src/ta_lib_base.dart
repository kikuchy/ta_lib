import 'dart:ffi';
import 'dart:io';
import 'package:ffi/ffi.dart';
import 'package:path/path.dart' as path;

import 'package:ta_lib/src/generated_bindings.dart';

class TaLib {
  late final NativeLibrary _nativeBindings;

  TaLib() {
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

  /// All Moving Average
  List<double> ma(
    int startIdx,
    int endIdx,
    List<double> real, {
    int? timePeriod,
    MaType maType = MaType.sma,
  }) {
    return using((arena) {
      final inReal = arena<Double>(real.length);
      for (var i = 0; i < real.length; i++) {
        inReal[i] = real[i];
      }
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
    int startIdx,
    int endIdx,
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
