import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:patient_app/screens/shared/shared.dart';

import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class BluetoothExample2Page extends StatefulWidget {
  const BluetoothExample2Page({super.key});

  @override
  State<BluetoothExample2Page> createState() => _BluetoothExamplePage2State();
}

class _BluetoothExamplePage2State extends State<BluetoothExample2Page> {
  List<BluetoothDevice> _systemDevices = [];
  List<ScanResult> _scanResults = [];
  bool _isScanning = false;
  late StreamSubscription<List<ScanResult>> _scanResultsSubscription;
  late StreamSubscription<bool> _isScanningSubscription;
  @override
  void initState() {
    super.initState();
    _scanResults.clear();
    print(FlutterBluePlus.connectedDevices.length);
    if (FlutterBluePlus.connectedDevices.length > 0) {
      discoverServices(FlutterBluePlus.connectedDevices[0]);
    } else {}
    startScanning();
  }

  void onConnectPressed(ScanResult result) {
    result.device.connect().then((value) async {
      print(result.device.isConnected);
      discoverServices(result.device);
    }).catchError((e) {});
  }

  void startScanning() async {
    _scanResultsSubscription = FlutterBluePlus.scanResults.listen((results) {
      _scanResults = results
          .where((element) => element.device.advName.length > 5)
          .toList();

      if (mounted) {
        setState(() {});
      }
    }, onError: (e) {});

    _isScanningSubscription = FlutterBluePlus.isScanning.listen((state) {
      _isScanning = state;
      if (mounted) {
        setState(() {});
      }
    });
  }

  Future onScanPressed() async {
    try {
      _systemDevices = await FlutterBluePlus.systemDevices;
    } catch (e) {}
    try {
      await FlutterBluePlus.startScan(timeout: const Duration(seconds: 15));
    } catch (e) {}
    if (mounted) {
      setState(() {});
    }
  }

  Future onStopPressed() async {
    try {
      FlutterBluePlus.stopScan();
    } catch (e) {}
  }

  Future onRefresh() {
    if (_isScanning == false) {
      FlutterBluePlus.startScan(timeout: const Duration(seconds: 15));
    }
    if (mounted) {
      setState(() {});
    }
    return Future.delayed(Duration(milliseconds: 500));
  }

  Widget buildScanButton(BuildContext context) {
    if (FlutterBluePlus.isScanningNow) {
      return FloatingActionButton(
        child: const Icon(Icons.stop),
        onPressed: onStopPressed,
        backgroundColor: Colors.red,
      );
    } else {
      return FloatingActionButton(
          child: const Text("SCAN"), onPressed: onScanPressed);
    }
  }

  List<BluetoothService>? services;
  void discoverServices(BluetoothDevice device) async {
    List<BluetoothService> discoveredServices = await device.discoverServices();
    setState(() {
      services = discoveredServices;
    });
    for (BluetoothService service in discoveredServices) {
      for (BluetoothCharacteristic characteristic in service.characteristics) {
        // Replace with your characteristic's UUID
        if (characteristic.properties.read) {
          readCharacteristic(characteristic);
          print("object");
          break;
        }
      }
    }
  }

  String readValue = "No data read";
  void readCharacteristic(BluetoothCharacteristic characteristic) async {
    await characteristic.setNotifyValue(true);

    List<int> value = await characteristic.read();
    setState(() {
      print('Pure value: $value');
      readValue = parseCharacteristicValue(value);
    });
    print('Characteristic value: $readValue'); /* */
  }

  String parseCharacteristicValue(List<int> value) {
    // Example: Convert raw bytes to a UTF-8 string
    try {
      return utf8.decode(value);
    } catch (e) {
      print("Error decoding UTF-8: $e");
      return "Error decoding value";
    }

    // Example: Convert raw bytes to integer
    // Assuming value represents a single integer
    //  int intValue = value.fold(0, (a, b) => (a << 8) + b);
    //return intValue.toString();

    // Example: Convert raw bytes to float
    // If the value represents a float, e.g., temperature data
    // var floatValue = ByteData.sublistView(Uint8List.fromList(value))
    //   .getFloat32(0, Endian.little);
    //return floatValue.toString();

    // Custom parsing logic based on your device's protocol
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: leading("bluethoot example", context),
      body: SafeArea(
        // Wrap your body with SafeArea
        child: SingleChildScrollView(
          child: ListView.builder(
            physics: const ScrollPhysics(),
            shrinkWrap: true,
            itemCount: _scanResults.length,
            itemBuilder: (BuildContext context, int index) {
              return (_scanResults.length - 1) - index > -1
                  ? ElevatedButton(
                      child: Text(_scanResults[index]
                          .advertisementData
                          .advName
                          .toString()
                          .trim()),
                      onPressed: () {
                        onConnectPressed(_scanResults[index]);
                      },
                    )
                  : null;
            },
          ),
        ),
      ),
      floatingActionButton: buildScanButton(context),
      ////bottomNavigationBar: BottomNavigatorBar(selectedIndex: 3),
    );
  }
}
