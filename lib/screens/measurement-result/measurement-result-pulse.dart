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

class MeasurementResultPulsePage extends StatefulWidget {
  const MeasurementResultPulsePage({super.key});

  @override
  State<MeasurementResultPulsePage> createState() =>
      _MeasurementResultPulsePageState();
}

class _MeasurementResultPulsePageState
    extends State<MeasurementResultPulsePage> {
  Apis apis = Apis();
  Shared sh = Shared();
  DateTime today = DateTime.now();
  @override
  void initState() {
    super.initState();
    today = today.add(const Duration(days: -8));
    onGetMeasurementList(today, 'pulse');
  }

  onGetMeasurementList(DateTime date, String bp) {
    List<_SalesData> dataFrom = [];
    apis.getMeasurementList(date, bp).then((value) {
      var results = value['results'] as List;
      results.sort((a, b) => a['timestamp'].compareTo(b['timestamp']));
      for (var result in results) {
        var measurementDate = DateTime.parse(result['timestamp']);
        // ignore: unrelated_type_equality_checks
        if ((date.compareTo(measurementDate) < 0) &&
            (measurementDate.compareTo(DateTime.now()) < 0)) {
          var timestamp = sh.formatDate(result['timestamp']);
          var value = result['measurement']['value'];
          dataFrom.add(_SalesData(timestamp, value));
        }
      }
      setState(() {
        data = dataFrom;
        setFillThreshold();
      });
    });
  }

  setFillThreshold() {
    redHigh = [];
    redLow = [];
    yellowHigh = [];
    yellowLow = [];
    data.forEach((element) {
      redHigh.add(_SalesData(element.year, 120));
      redLow.add(_SalesData(element.year, 40));
      yellowHigh.add(_SalesData(element.year, 100));
      yellowLow.add(_SalesData(element.year, 60));
    });
  }

  int periodType = 10; // 10 week, 20 month, 30 year

  List<_SalesData> data = [];

  List<_SalesData> redHigh = [];
  List<_SalesData> redLow = [];
  List<_SalesData> yellowHigh = [];
  List<_SalesData> yellowLow = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: leadingSubpage('Herzfrequenz', context),
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
                          data = [];
                          onGetMeasurementList(d, 'pulse');
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
                          data = [];
                          onGetMeasurementList(d, 'pulse');
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
                          data = [];
                          onGetMeasurementList(d, 'pulse');
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
                primaryXAxis: CategoryAxis(),
                // Chart title
                title: ChartTitle(text: ''),
                // Enable legend
                legend: Legend(isVisible: false),
                // Enable tooltip
                tooltipBehavior: TooltipBehavior(enable: true),
                series: <ChartSeries<_SalesData, String>>[
                  LineSeries<_SalesData, String>(
                      dataSource: redHigh,
                      color: Colors.red,
                      xValueMapper: (_SalesData sales, _) => sales.year,
                      yValueMapper: (_SalesData sales, _) => sales.sales,
                      name: 'Herzfrequenz',
                      // Enable data label
                      dataLabelSettings:
                          const DataLabelSettings(isVisible: false)),
                  LineSeries<_SalesData, String>(
                      dataSource: yellowHigh,
                      color: Colors.amber,
                      xValueMapper: (_SalesData sales, _) => sales.year,
                      yValueMapper: (_SalesData sales, _) => sales.sales,
                      name: 'Herzfrequenz',
                      // Enable data label
                      dataLabelSettings:
                          const DataLabelSettings(isVisible: false)),
                  LineSeries<_SalesData, String>(
                      dataSource: yellowLow,
                      color: Colors.amber,
                      xValueMapper: (_SalesData sales, _) => sales.year,
                      yValueMapper: (_SalesData sales, _) => sales.sales,
                      name: 'Herzfrequenz',
                      // Enable data label
                      dataLabelSettings:
                          const DataLabelSettings(isVisible: false)),
                  LineSeries<_SalesData, String>(
                      dataSource: data,
                      color: Colors.blue[900],
                      xValueMapper: (_SalesData sales, _) => sales.year,
                      yValueMapper: (_SalesData sales, _) => sales.sales,
                      name: 'Herzfrequenz',
                      // Enable data label
                      dataLabelSettings:
                          const DataLabelSettings(isVisible: false)),
                  LineSeries<_SalesData, String>(
                      dataSource: redLow,
                      color: Colors.red,
                      xValueMapper: (_SalesData sales, _) => sales.year,
                      yValueMapper: (_SalesData sales, _) => sales.sales,
                      name: 'Herzfrequenz',
                      // Enable data label
                      dataLabelSettings:
                          const DataLabelSettings(isVisible: false)),
                ],
              ),
              Row(
                children: [
                  CustomSubTotal(null, "Gestern", "66.2 %", null, null),
                  Spacer(),
                  CustomSubTotal(null, "Heute", "66.2 bpm", null, null),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                  "Die Herzfrequenz ist ein wichtiger Indikator für die Aktivität des Herzens und spielt eine zentrale Rolle bei der Beurteilung der kardiovaskulären Gesundheit. Die Herzfrequenz bezieht sich auf die Anzahl der Herzschläge pro Minute. Sie gibt an, wie oft sich das Herz zusammenzieht und Blut durch den Körper pumpt. Die Herzfrequenz kann variieren und wird von verschiedenen Faktoren beeinflusst, einschließlich körperlicher Aktivität, emotionaler Zustand, Alter und allgemeiner Gesundheitszustand."),
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
                      Navigator.of(context).pushNamed('/pulse-description');
                    },
                    child: Text(
                      "Mehr Informationen über die Einstufung Ihrer Messwerte",
                      style: TextStyle(
                          overflow: TextOverflow.ellipsis,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue),
                    ),
                  ),
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
  _SalesData(this.year, this.sales);

  final String year;
  final double sales;
}
