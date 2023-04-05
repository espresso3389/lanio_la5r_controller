# lanio-la5r

Controller for [LA-5T2S](http://www.lineeye.co.jp/html/product_LA-5T2S.html).

```dart
Future<void> main() async {
  // Set your own device's IP
  final lanio = Lanio(address: '192.168.10.91', port: 10003);

  // Show device info.
  final info = await lanio.deviceInfo;
  print(info);

  // Set DO1,DO2
  await lanio.setPins([true, true]);

  // Show pin states
  final pins = await lanio.pins;
  print('DO1: ${pins[0]}');
  print('DO2: ${pins[1]}');
  print('DO3: ${pins[2]}');
  print('DO4: ${pins[3]}');
  print('DO5: ${pins[4]}');
}
```

- [API Reference](https://pub.dev/documentation/lanio_la5r_controller/latest/)
- [pub.dev](https://pub.dev/packages/lanio_la5r_controller)
- [GitHub](https://github.com/espresso3389/lanio_la5r_controller)
