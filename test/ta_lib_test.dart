import 'package:ta_lib/ta_lib.dart';
import 'package:test/test.dart';

void main() {
  group('A group of tests', () {
    final taLib = TaLib();

    // setUp(() {
    //   // Additional setup goes here.
    // });

    test('First Test', () {
      expect(taLib.ma(1, 4, [1, 2, 3, 4, 5], maType: MaType.ema, timePeriod: 3),
          [2, 3, 4]);
    });
  });
}
