import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:synchronized/extension.dart';

/// Controller for [LA-5T2S](http://www.lineeye.co.jp/html/product_LA-5T2S.html)
class Lanio {
  final dynamic address;
  final int port;

  Lanio({required this.address, required this.port});

  /// Send a command directly.
  Future<Uint8List> send(List<int> cmd) => synchronized(() async {
        final s = await RawSocket.connect(address, port);
        final c = Completer<Uint8List>();
        final pub = s.listen((event) {
          if (event == RawSocketEvent.read) {
            c.complete(s.read());
          }
        });
        s.write(cmd);
        final result = await c.future;
        await s.close();
        pub.cancel();
        return result;
      });

  LanioDeviceInfo? _devInfo;

  /// Get device info.
  Future<LanioDeviceInfo> get deviceInfo async {
    if (_devInfo != null) return _devInfo!;
    final data = await send([0x55, 0x55]);
    return _devInfo = LanioDeviceInfo((data[0] >> 4) & 7, ~data[0] & 15);
  }

  /// Get array of PIN states (5 elements for `DO1,DO2,DO2,DO4,DO5`).
  Future<List<bool>> get pins async {
    final data = await send([0xe0]);
    return [
      data[1] & 1 != 0,
      (data[1] >> 1) & 1 != 0,
      (data[1] >> 2) & 1 != 0,
      (data[1] >> 2) & 1 != 0,
      (data[1] >> 2) & 1 != 0,
    ];
  }

  /// Set PIN states. [pins] should be the PIN states, in order of `DO1,DO2,DO2,DO4,DO5`.
  /// It can be less than 5 elements and then the omitted PINS are set to `false`.
  Future<void> setPins(List<bool> pins) async {
    var b = 0;
    var mask = 1;
    for (int i = 0; i < pins.length; i++) {
      if (pins[i]) b |= mask;
      mask <<= 1;
    }
    await send([0xf0, b]);
  }
}

class LanioDeviceInfo {
  final int modelId;
  final int unitId;
  LanioDeviceInfo(this.modelId, this.unitId);

  String get model => models[modelId];

  // Model ID
  // https://www.lineeye.co.jp/pdf/LANIO_J43.pdf#page=85
  static const models = [
    'LA-2R3P-P', // 000
    'LA-3R2P', // 001
    'LA-7P-A' // 010
        'LA-5R', // 011
    'LA-5T2S', // 100
    'LA-5P-P', // 101
    'LA-3R3P-P', // 110
  ];

  @override
  String toString() {
    return '{Model=$model, UnitID=$unitId}';
  }
}
