import 'dart:async';
import 'dart:convert';

import 'package:flutter_blue/flutter_blue.dart';

class BluetoothManager {
  final FlutterBlue _flutterBlue = FlutterBlue.instance;
  StreamSubscription<BluetoothDeviceState> _connection;
  BluetoothDevice _device;
  BluetoothService _sendStringService;
  BluetoothCharacteristic _sendCharacteristic;
  bool _connected = false;

  Future<void> initialize() async {
    _flutterBlue
        .scan(
      timeout: const Duration(seconds: 5),
    )
        .listen((scanResult) {
      if (scanResult.device.name == "icescape" && !_connected) {
        _connect(scanResult.device).then((_) {
          _connected = true;
          _device = scanResult.device;
          scanResult.device.discoverServices().then((services) {
            _sendStringService = services.singleWhere((service) =>
                service.uuid.toString() ==
                "0000ffe0-0000-1000-8000-00805f9b34fb");
            _sendCharacteristic = _sendStringService.characteristics.singleWhere(
                (characteristic) =>
                    characteristic.uuid.toString() ==
                    "0000ffe0-0000-1000-8000-00805f9b34fb");
            print(services.toString());
          });
        });
      }
    });
  }

  Future<void> _connect(BluetoothDevice device) async {
    _connection = _flutterBlue.connect(device).listen((data) {
      if (data == BluetoothDeviceState.connected) {
        print("Device is Connected");
      }
    });
  }

  Future<void> write(String text) async {
    _device.writeCharacteristic(_sendCharacteristic, utf8.encode(text),
        type: CharacteristicWriteType.withoutResponse);
  }

  Future<void> disconnect() async {
    _connection.cancel();
  }
}
