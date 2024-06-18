import 'dart:async';

import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:patient_app/main.dart';
import 'package:patient_app/model/questionnaire-group.dart';
import 'package:patient_app/screens/shared/shared.dart';
import 'package:patient_app/shared/toast.dart';
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
    try {
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
    } catch (e) {
      loading = false;
      showToast("Device connection error");
      print(e);
    }
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
        loading = true;
        if (_timer == null || _timer?.isActive == false) checkListenEnd();
        listData = [];
        setState(() {});
        discoverServices(device);
        break;
      case DeviceConnectionState.disconnecting:
        _timer?.cancel();
        deviceConnected = false;
        break;
      case DeviceConnectionState.disconnected:
        deviceConnected = false;
        break;
    }
    setState(() {});
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

  var listData = [];
  bool loading = true;
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
      _parseBloodPressureData(data);
    }, onError: (error) {
      print('Error subscribing to characteristic: $error');
    });
  }

  num systolic = 0;
  num diastolic = 0;
  num pulse = 0;
  String date = "";
  num index = 0;
  _parseBloodPressureData(List<int> data) {
    setState(() {
      sec = 1;
    });
    if (data.length < 19) return "Invalid data length";
    Shared sh = Shared();
    systolic = sh.parseIeee16BitSFloat(data[1], data[2]);

    diastolic = sh.parseIeee16BitSFloat(data[3], data[4]);
    pulse = sh.parseIeee16BitSFloat(data[14], data[15]);

    String year = sh.parseIeee16BitSFloat(data[7], data[8]).toString();
    year = year.toString().substring(0, year.indexOf("."));
    String month = data[9].toString();
    if (month.toString().length == 1) month = '0${month}';
    String day = data[10].toString();
    if (day.toString().length == 1) day = '0${day}';
    String hour = data[11].toString();
    if (hour.toString().length == 1) hour = '0${hour}';
    String minute = data[12].toString();
    if (minute.toString().length == 1) minute = '0${minute}';
    date = "${day}/${month}/${year} ${hour}:${minute}";

    if (listData.where((a) => a['date'] == date).length == 0) {
      var p = {
        "index": index,
        "systolic": systolic,
        "diastolic": diastolic,
        "pulse": pulse,
        "date": date
      };
      listData.add(p);
      listData.sort((a, b) => b['index'] - a['index']);
      index++;
      // if (listData.length > 10) listData = listData.getRange(0, 5).toList();
    }
    setState(() {});
  }

  int sec = 1;
  Timer? _timer;
  checkListenEnd() {
    const duration = const Duration(seconds: 1);
    _timer = Timer.periodic(
      duration,
      (Timer timer) {
        if (sec >= 2) {
          timer?.cancel();
          checkMeasurements();
        }
        sec++;
        setState(() {});
      },
    );
  }

  checkMeasurements() {
    var requestParams = [];

    listData.forEach((value) {
      var p = {
        "systolic": value['systolic'],
        "diastolic": value['diastolic'],
        "pulse": value['pulse'],
        "date": sh.formatDateTimeToRequest(value['date'])
      };
      requestParams.add(p);
    });

    apis.checkmeasurements(requestParams).then((value) {
      listData.forEach((ld) {
        var v = value
            .where((x) => x['date'] == sh.formatDateTimeToRequest(ld['date']))
            .toList();
        if (v.length > 0) ld['isExist'] = v[0]['isExist'];
      });
      setState(() {});
    }, onError: (err) {
      sh.redirectPatient(err, context);
    });
  }

  bool sendDataLoader = false;
  bool alreadySaved = false;
  saveData() {
    var requestParams = [];

    listData.forEach((value) {
      var p = {
        "systolic": value['systolic'],
        "diastolic": value['diastolic'],
        "pulse": value['pulse'],
        "date": sh.formatDateTimeToRequest(value['date'])
      };
      requestParams.add(p);
    });

    setState(() {
      sendDataLoader = true;
    });
    apis.setbeurervalues(requestParams).then((value) {
      setState(() {
        sendDataLoader = false;
        alreadySaved = true;
        this.listData.forEach((ld) {
          ld['isExist'] = true;
        });
        print(this.listData);
      });
      Timer.periodic(Duration(seconds: 1), (Timer timer) {
        if (timer.tick == 3) {
          timer?.cancel();
          alreadySaved = false;
        }
        sec++;
        setState(() {});
      });
    }, onError: (err) {
      setState(() {
        sendDataLoader = true;
      });
      sh.redirectPatient(err, context);
    });
  }

  @override
  Widget build(BuildContext context) {
    Shared sh = new Shared();
    return Scaffold(
      appBar: leadingSubpage(sh.getLanguageResource("blood_pressure"), context),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.only(bottom: 80),
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
              child: Column(
                children: [
                  if (!deviceConnected)
                    Text(sh.getLanguageResource("device_is_waiting"))
                  else if (_timer?.isActive == true)
                    CircularProgressIndicator()
                  else if (_timer?.isActive == false)
                    for (var d in listData)
                      Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15))),
                          width: double.infinity,
                          padding: EdgeInsets.all(20),
                          margin: EdgeInsets.only(left: 20, right: 20, top: 15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  Text(
                                    sh.getLanguageResource("blood_pressure"),
                                    style: labelText,
                                  ),
                                  Spacer(),
                                  Text(
                                    "${d['systolic']} / ${d['diastolic']} mmHg",
                                    style: valueTag,
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 2,
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
                                    "${d['pulse']} BPM",
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
                                    "${d['date']}",
                                    style: valueTag,
                                  ),
                                ],
                              ),
                              if (d['isExist'] != null && d['isExist'])
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.check),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(sh.getLanguageResource(
                                        "measurement_already_saved"))
                                  ],
                                )
                            ],
                          ))
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton:
          (_timer?.isActive == false && listData.length > 0 && deviceConnected)
              ? ElevatedButton(
                  onPressed: () {
                    if (!sendDataLoader) saveData();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: alreadySaved ? Colors.green : Colors.blue,
                  ),
                  child: !sendDataLoader
                      ? Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (alreadySaved)
                              Icon(Icons.check)
                            else
                              Icon(Icons.cloud_done),
                            SizedBox(
                              width: 10,
                            ),
                            if (alreadySaved)
                              Text(sh.getLanguageResource("successfully_saved"))
                            else
                              Text(sh.getLanguageResource("save"))
                          ],
                        )
                      : SizedBox(
                          child: Center(
                              child: CircularProgressIndicator(
                            color: Colors.white,
                          )),
                          height: 20.0,
                          width: 20.0,
                        ),
                )
              : null,
    );
  }
}
