import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:patient_app/shared/shared.dart';
import 'package:permission_handler/permission_handler.dart';

class BluetoothExamplePage extends StatefulWidget {
  @override
  _BluetoothExamplePageState createState() => _BluetoothExamplePageState();
}

class _BluetoothExamplePageState extends State<BluetoothExamplePage> {
  final flutterReactiveBle = FlutterReactiveBle();
  late StreamSubscription<DiscoveredDevice> _scanSubscription;
  late StreamSubscription<ConnectionStateUpdate> _connectionSubscription;
  List<DiscoveredDevice> _devices = [];
  String? _bloodPressureData;

  static const String BLOOD_PRESSURE_SERVICE_UUID =
      "00001810-0000-1000-8000-00805f9b34fb";
  static const String BLOOD_PRESSURE_MEASUREMENT_UUID =
      "00002a35-0000-1000-8000-00805f9b34fb";

  @override
  void initState() {
    super.initState();
    _checkPermissions().then((_) => _startScan());
  }

  Future<void> _checkPermissions() async {
    if (await Permission.location.isDenied) {
      await Permission.location.request();
    }
  }

  DiscoveredDevice? _bm96;
  void _startScan() {
    _scanSubscription =
        flutterReactiveBle.scanForDevices(withServices: []).listen((device) {
      setState(() {
        final existingIndex = _devices.indexWhere((d) => d.id == device.id);
        if (existingIndex >= 0) {
          _devices[existingIndex] = device;
        } else {
          _devices.add(device);
        }
      });
    }, onError: (e) {
      print('Error occurred while scanning: $e');
    });
  }

  @override
  void dispose() {
    _scanSubscription.cancel();
    _connectionSubscription?.cancel();
    super.dispose();
  }

  void connectToDevice(DiscoveredDevice device) {
    _connectionSubscription = flutterReactiveBle
        .connectToDevice(
      id: device.id,
      servicesWithCharacteristicsToDiscover: {
        Uuid.parse(BLOOD_PRESSURE_SERVICE_UUID): [
          Uuid.parse(BLOOD_PRESSURE_MEASUREMENT_UUID)
        ]
      },
      connectionTimeout: const Duration(seconds: 5),
    )
        .listen((connectionState) {
      _handleConnectionState(device, connectionState);
    }, onError: (e) {
      print('Connection error: $e');
    });
  }

  void _handleConnectionState(
      DiscoveredDevice device, ConnectionStateUpdate connectionState) {
    switch (connectionState.connectionState) {
      case DeviceConnectionState.connecting:
        print('Connecting to ${device.name}');
        break;
      case DeviceConnectionState.connected:
        print('Connected to ${device.name}');
        discoverServices(device);
        break;
      case DeviceConnectionState.disconnecting:
        print('Disconnecting from ${device.name}');
        break;
      case DeviceConnectionState.disconnected:
        print('Disconnected from ${device.name}');
        break;
    }
  }

  void discoverServices(DiscoveredDevice device) async {
    final services = await flutterReactiveBle.discoverServices(device.id);
    for (var service in services) {
      if (service.serviceId == Uuid.parse(BLOOD_PRESSURE_SERVICE_UUID)) {
        for (var characteristic in service.characteristics) {
          if (characteristic.characteristicId ==
              Uuid.parse(BLOOD_PRESSURE_MEASUREMENT_UUID)) {
            subscribeToCharacteristic(device.id, characteristic);
          }
        }
      }
    }
  }

  void subscribeToCharacteristic(
      String deviceId, DiscoveredCharacteristic characteristic) {
    final characteristicSubscription = flutterReactiveBle
        .subscribeToCharacteristic(
      QualifiedCharacteristic(
        serviceId: characteristic.serviceId,
        characteristicId: characteristic.characteristicId,
        deviceId: deviceId,
      ),
    )
        .listen((data) {
      setState(() {
        _bloodPressureData = _parseBloodPressureData(data);
      });
    }, onError: (error) {
      print('Error subscribing to characteristic: $error');
    });
  }

  String _parseBloodPressureData(List<int> data) {
    if (data.length < 19) return "Invalid data length";
    Shared sh = Shared();
    num systolic = sh.parseIeee16BitSFloat(data[1], data[2]);

    num diastolic = sh.parseIeee16BitSFloat(data[3], data[4]);
    num pulse = sh.parseIeee16BitSFloat(data[14], data[15]);

    num year = sh.parseIeee16BitSFloat(data[7], data[8]);
    int month = data[9];
    int day = data[10];
    int hour = data[11];
    int minute = data[12];
    int second = data[13];

    print(
        "Systolic: $systolic mmHg, Diastolic: $diastolic mmHg, Pulse: $pulse BPM\n"
        "Date: $year-$month-$day, Time: $hour:$minute:$second");
    return "Systolic: $systolic mmHg, Diastolic: $diastolic mmHg, Pulse: $pulse BPM\n"
        "Date: $year-$month-$day, Time: $hour:$minute:$second";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bluetooth Example'),
      ),
      body: Column(
        children: [
          ElevatedButton(
              onPressed: () {
                connectToDevice(_bm96!);
              },
              child: Text("connect to bm96")),
          Expanded(
            child: ListView.builder(
              itemCount: _devices.length,
              itemBuilder: (context, index) {
                final device = _devices[index];
                return ListTile(
                  title: Text(device.name),
                  subtitle: Text(device.id),
                  onTap: () {
                    connectToDevice(device);
                  },
                );
              },
            ),
          ),
          if (_bloodPressureData != null)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                _bloodPressureData!,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
        ],
      ),
    );
  }
}
