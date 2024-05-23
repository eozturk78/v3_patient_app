import 'dart:async';

import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:patient_app/main.dart';
import 'package:patient_app/model/questionnaire-group.dart';
import 'package:patient_app/screens/shared/shared.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:responsive_framework/responsive_breakpoints.dart';
import 'package:responsive_framework/responsive_value.dart';
import '../../apis/apis.dart';
import '../../shared/shared.dart';

import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';

class BluetoothBloodPressurePage extends StatefulWidget {
  const BluetoothBloodPressurePage({super.key});

  @override
  State<BluetoothBloodPressurePage> createState() =>
      _BluetoothBloodPressurePageState();
}

class _BluetoothBloodPressurePageState
    extends State<BluetoothBloodPressurePage> {
  Apis apis = Apis();
  List<QuestionnaireGroup> questionnaireGroups = [];
  bool isStarted = true;
  PDFDocument? document;
  String? imageUrl;
  bool isPdf = false;
  Shared sh = Shared();

  final flutterReactiveBle = FlutterReactiveBle();
  late StreamSubscription<DiscoveredDevice> _scanSubscription;
  late StreamSubscription<ConnectionStateUpdate> _connectionSubscription;
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

  void _startScan() {
    _scanSubscription =
        flutterReactiveBle.scanForDevices(withServices: []).listen((device) {
      if (device.name == "BM96") {
        setState(() {});
        connectToDevice(device);
      }
    }, onError: (e) {
      print('Error occurred while scanning: $e');
    });
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

  bool deviceConnected = false;
  void _handleConnectionState(
      DiscoveredDevice device, ConnectionStateUpdate connectionState) {
    switch (connectionState.connectionState) {
      case DeviceConnectionState.connecting:
        deviceConnected = false;
        break;
      case DeviceConnectionState.connected:
        deviceConnected = true;
        discoverServices(device);
        break;
      case DeviceConnectionState.disconnecting:
        deviceConnected = false;
        break;
      case DeviceConnectionState.disconnected:
        deviceConnected = false;
        break;
    }
    setState(() {});
  }

  void discoverServices(DiscoveredDevice device) async {
    checkListenEnd();
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
        _parseBloodPressureData(data);
      });
    }, onError: (error) {
      print('Error subscribing to characteristic: $error');
    });
  }

  bool loading = true;
  int sec = 1;
  checkListenEnd() {
    loading = true;
    setState(() {});
    sec = 1;
    const duration = const Duration(seconds: 1);
    Timer.periodic(
      duration,
      (Timer timer) {
        if (sec == 3) {
          setState(() {
            loading = false;
            timer.cancel();
          });
        }

        sec++;
      },
    );
  }

  num systolic = 0;
  num diastolic = 0;
  num pulse = 0;
  String date = "";
  _parseBloodPressureData(List<int> data) {
    if (data.length < 19) return "Invalid data length";
    Shared sh = Shared();
    systolic = sh.parseIeee16BitSFloat(data[1], data[2]);

    diastolic = sh.parseIeee16BitSFloat(data[3], data[4]);
    pulse = sh.parseIeee16BitSFloat(data[14], data[15]);

    String year = sh.parseIeee16BitSFloat(data[7], data[8]).toString();
    year = year.toString().substring(0, year.indexOf("."));
    int month = data[9];
    int day = data[10];
    int hour = data[11];
    int minute = data[12];
    date = "${day}/${month}/${year} ${hour}:${minute}";
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Shared sh = new Shared();
    return Scaffold(
      appBar: leadingSubpage(sh.getLanguageResource("blood_pressure"), context),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width *
                ResponsiveValue(
                  context,
                  defaultValue: 1,
                  conditionalValues: [
                    Condition.largerThan(
                      //Tablet
                      name: MOBILE,
                      value: 0.7,
                    ),
                  ],
                ).value!,
            child: Center(
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(15))),
                width: double.infinity,
                padding: EdgeInsets.all(20),
                margin: EdgeInsets.only(left: 20, right: 20, top: 30),
                child: Column(
                  children: [
                    if (!deviceConnected)
                      Text(sh.getLanguageResource("device_is_waiting")),
                    if (loading) CircularProgressIndicator(),
                    if (deviceConnected && !loading)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(sh.getLanguageResource("your_last_bp_below")),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Text(
                                sh.getLanguageResource("systolic"),
                                style: labelText,
                              ),
                              Spacer(),
                              Text(
                                "${systolic} mmHg",
                                style: valueTag,
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 2,
                          ),
                          Row(
                            children: [
                              Text(
                                sh.getLanguageResource("diastolic"),
                                style: labelText,
                              ),
                              Spacer(),
                              Text(
                                "${diastolic} mmHg",
                                style: valueTag,
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 2,
                          ),
                          Row(
                            children: [
                              Text(
                                sh.getLanguageResource("pulse"),
                                style: labelText,
                              ),
                              Spacer(),
                              Text(
                                "${pulse} BPM",
                                style: valueTag,
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 2,
                          ),
                          Row(
                            children: [
                              Text(
                                sh.getLanguageResource("date"),
                                style: labelText,
                              ),
                              Spacer(),
                              Text(
                                "${date}",
                                style: valueTag,
                              ),
                            ],
                          ),
                        ],
                      )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
