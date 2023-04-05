import 'package:lanio_la5r_test/lanio_la5r_test.dart';

Future<void> main() async {
  final lanio = Lanio(address: '192.168.10.91', port: 10003);
  final info = await lanio.deviceInfo;
  print(info);

  await lanio.setPins([true, true]);

  final pins = await lanio.pins;
  print('DI1: ${pins[0]}');
  print('DI2: ${pins[1]}');
  print('DI3: ${pins[2]}');
  print('DI4: ${pins[3]}');
  print('DI5: ${pins[4]}');
}
