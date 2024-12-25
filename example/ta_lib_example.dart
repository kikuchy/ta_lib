import 'package:ta_lib/ta_lib.dart';

void main() {
  final taLib = TaLib();
  final result = taLib.ma([1, 2, 3, 4, 5], maType: MaType.sma, timePeriod: 3);
  print(result);
}
