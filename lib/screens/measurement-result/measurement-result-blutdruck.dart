import 'dart:async';

import 'package:flutter/material.dart';
import 'package:patient_app/apis/apis.dart';
import 'package:patient_app/colors/colors.dart';
import 'package:patient_app/screens/shared/list-box.dart';
import 'package:patient_app/screens/shared/shared.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../shared/shared.dart';
import '../shared/bottom-menu.dart';
import '../shared/sub-total.dart';

class MeasurementResultPage extends StatefulWidget {
  const MeasurementResultPage({super.key});

  @override
  State<MeasurementResultPage> createState() => _MeasurementResultPageState();
}

class _MeasurementResultPageState extends State<MeasurementResultPage> {
  Apis apis = Apis();
  Shared sh = Shared();
  DateTime today = DateTime.now();
  String todayValue = "~", yesterdayValue = "~";
  @override
  void initState() {
    super.initState();
    today = today.add(const Duration(days: -8));
    onGetMeasurementList(today, 'blood_pressure');
  }

  onGetMeasurementList(DateTime date, String bp) {
    List<_SalesData> data1 = [], data2 = [], data3 = [];
    apis.getMeasurementList(date, bp).then((value) {
      var results = value['results'] as List;
      results.sort((a, b) => a['timestamp'].compareTo(b['timestamp']));
      for (var result in results) {
        var measurementDate = DateTime.parse(result['timestamp']);
        // ignore: unrelated_type_equality_checks
        if ((date.compareTo(measurementDate) < 0) &&
            (measurementDate.compareTo(DateTime.now()) < 0)) {
          var timestamp = sh.formatDate(result['timestamp']);
          if (bp == 'blood_pressure') {
            var systolic = result['measurement']['systolic'];
            data1.add(_SalesData(timestamp, systolic));
            var diastolic = result['measurement']['diastolic'];
            data2.add(_SalesData(timestamp, diastolic));
            if (sh.formatDate(DateTime.now().toString()) ==
                sh.formatDate(result['timestamp'])) {
              todayValue = "$systolic/$diastolic";
            }
            if (sh.formatDate(
                    DateTime.now().add(Duration(days: -1)).toString()) ==
                sh.formatDate(result['timestamp'])) {
              yesterdayValue = "$systolic/$diastolic";
            }
          } else {
            var pulse = result['measurement']['value'];
            data3.add(_SalesData(timestamp, pulse));
          }
        }
      }
      setState(() {
        if (bp == 'blood_pressure') {
          dataS = data1;
          dataD = data2;
        } else {
          dataPulse = data3;

          if (dataS.length != dataPulse.length) {}
        }
      });
      if (bp == "blood_pressure") onGetMeasurementList(date, 'pulse');
    });
  }

  int periodType = 10; // 10 week, 20 month, 30 year
  List<_SalesData> dataS = [];
  List<_SalesData> dataD = [];
  List<_SalesData> dataPulse = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: leadingSubpage('Blutdruck', context),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              const Text(
                  "Hier haben Sie einen Überblick über die zeitliche Entwicklung Ihrer Werte"),
              const SizedBox(
                height: 15,
              ),
              Row(
                children: [
                  TextButton(
                      onPressed: () {
                        setState(() {
                          periodType = 10;
                          var d = DateTime.now().add(const Duration(days: -8));

                          dataD = [];
                          dataS = [];
                          dataPulse = [];
                          onGetMeasurementList(d, 'blood_pressure');
                        });
                      },
                      child: Text(
                        '1 Woche',
                        style: periodType == 10
                            ? selectedPeriod
                            : TextStyle(color: Colors.black),
                      )),
                  Spacer(),
                  TextButton(
                      onPressed: () {
                        setState(() {
                          periodType = 20;
                          var d = DateTime.now().add(const Duration(days: -91));

                          dataD = [];
                          dataS = [];
                          dataPulse = [];
                          onGetMeasurementList(d, 'blood_pressure');
                          // onGetMeasurementList(today, 'pulse');
                        });
                      },
                      child: Text(
                        '3 Monate',
                        style: periodType == 20
                            ? selectedPeriod
                            : TextStyle(color: Colors.black),
                      )),
                  Spacer(),
                  TextButton(
                      onPressed: () {
                        setState(() {
                          periodType = 30;
                          var d =
                              DateTime.now().add(const Duration(days: -366));

                          dataD = [];
                          dataS = [];
                          dataPulse = [];
                          onGetMeasurementList(d, 'blood_pressure');
                          //
                        });
                      },
                      child: Text(
                        '1 Jahr',
                        style: periodType == 30
                            ? selectedPeriod
                            : TextStyle(color: Colors.black),
                      )),
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              //Initialize the chart widget
              SfCartesianChart(
                primaryXAxis: CategoryAxis(arrangeByIndex: true),
                // Chart title
                title: ChartTitle(text: ''),
                // Enable legend
                legend: Legend(isVisible: false),
                // Enable tooltip
                tooltipBehavior: TooltipBehavior(enable: true),
                series: <ChartSeries<_SalesData, String>>[
                  LineSeries<_SalesData, String>(
                      dataSource: dataS,
                      xValueMapper: (_SalesData sales, _) =>
                          sales.date.toString(),
                      yValueMapper: (_SalesData sales, _) => sales.sales,
                      name: 'Systolischer',
                      // Enable data label
                      dataLabelSettings:
                          const DataLabelSettings(isVisible: false)),
                  LineSeries<_SalesData, String>(
                      dataSource: dataD,
                      xValueMapper: (_SalesData sales, _) =>
                          sales.date.toString(),
                      yValueMapper: (_SalesData sales, _) => sales.sales,
                      name: 'Diastolischer',
                      // Enable data label
                      dataLabelSettings:
                          const DataLabelSettings(isVisible: false)),
                  LineSeries<_SalesData, String>(
                      dataSource: dataPulse,
                      xValueMapper: (_SalesData sales, _) =>
                          sales.date.toString(),
                      yValueMapper: (_SalesData sales, _) => sales.sales,
                      name: 'Pulse',
                      // Enable data label
                      dataLabelSettings:
                          const DataLabelSettings(isVisible: false))
                ],
              ),
              Row(
                children: [
                  CustomSubTotal(
                      null, "Gestern", "$yesterdayValue mmHg", null, null),
                  Spacer(),
                  CustomSubTotal(null, "Heute", "$todayValue mmHg", null, null),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                  "Der Blutdruck ist der messbare Druck des Blutes in den Arterien, während es vom Herzen durch den Körper gepumpt wird. Ein gesunder Blutdruck ist ein wichtiger Teil der Gesundheitsvorsorge. Denn Bluthochdruck (Hypertonie) erhöht nachweislich das Risiko für ernsthafte Erkrankungen wie Herzinfarkt, Herzversagen, Schlaganfall und Nierenschäden."),
              SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Icon(
                    Icons.info,
                    color: Color.fromARGB(255, 0, 90, 47),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushNamed('/blutdruck-description');
                    },
                    child: Text(
                      "Mehr Informationen über die Einstufung Ihrer Messwerte",
                      style: TextStyle(
                          overflow: TextOverflow.ellipsis,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: const BottomNavigatorBar(0),
    );
  }
}

class _SalesData {
  _SalesData(this.date, this.sales);

  final String date;
  final double sales;
}
