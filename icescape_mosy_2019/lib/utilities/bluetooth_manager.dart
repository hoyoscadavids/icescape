import 'dart:async';
import 'dart:convert';

import 'package:flutter_blue/flutter_blue.dart';

class BluetoothManager {
  FlutterBlue _flutterBlue = FlutterBlue.instance;

  StreamSubscription _scanSubscription;
  Map<DeviceIdentifier, ScanResult> scanResults = new Map();
  bool isScanning = false;

  StreamSubscription _stateSubscription;
  BluetoothState state = BluetoothState.unknown;

  BluetoothDevice device;
  bool get isConnected => (device != null);
  StreamSubscription deviceConnection;
  StreamSubscription deviceStateSubscription;
  List<BluetoothService> services = new List();
  Map<Guid, StreamSubscription> valueChangedSubscriptions = {};
  BluetoothDeviceState deviceState = BluetoothDeviceState.disconnected;
  BluetoothCharacteristic _sendCharacteristic;

  Future<bool> doneConnecting;

  Future<void> initialize() async{
    _flutterBlue.state.then((s) {
      state = s;
    });
    // Subscribe to state changes
    _stateSubscription = _flutterBlue.onStateChanged().listen((s) {
      state = s;
    });
  }

  Future<void> scanAndConnect() async{
    _scanSubscription = _flutterBlue
        .scan(
      timeout: const Duration(seconds: 5),
    )
        .listen((scanResult) {
      scanResults[scanResult.device.id] = scanResult;
      if (scanResult.device.name == "icescape") {
         _connect(scanResult.device);
      }
    }, onDone: _stopScan);
    isScanning = true;
  }

  void _stopScan() {
    _scanSubscription?.cancel();
    _scanSubscription = null;
    isScanning = false;
  }

  Future<void> _connect(BluetoothDevice d) async {
    device = d;
    // Connect to device
    deviceConnection = _flutterBlue
        .connect(device, timeout: const Duration(seconds: 4))
        .listen(
          null,
          onDone: _disconnect,
        );

    device.state.then((s) {
      deviceState = s;
    });

    deviceStateSubscription = device.onStateChanged().listen((s) {
      deviceState = s;
      if (s == BluetoothDeviceState.connected) {
        device.discoverServices().then((s) {
          services = s;
          BluetoothService sendService = services.firstWhere((element) =>
              element.uuid == Guid("0000ffe0-0000-1000-8000-00805f9b34fb"));
          _sendCharacteristic = sendService.characteristics.firstWhere(
              (characteristic) =>
                  characteristic.uuid ==
                  Guid("0000ffe1-0000-1000-8000-00805f9b34fb"));
        });
      }
    });
  }

  void _disconnect() {
    valueChangedSubscriptions.forEach((uuid, sub) => sub.cancel());
    valueChangedSubscriptions.clear();
    deviceStateSubscription?.cancel();
    deviceStateSubscription = null;
    deviceConnection?.cancel();
    deviceConnection = null;
    device = null;
  }

  Future<void> write(String text) async {
    device.writeCharacteristic(_sendCharacteristic, utf8.encode(text),
        type: CharacteristicWriteType.withoutResponse);
  }
}