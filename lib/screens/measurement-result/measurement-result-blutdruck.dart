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
      for (var result in results) {
        var timestamp = sh.formatDate(result['timestamp']);
        if (bp == 'blood_pressure') {
          var systolic = result['measurement']['systolic'];
          data1.add(_SalesData(timestamp, systolic));
          var diastolic = result['measurement']['diastolic'];
          data2.add(_SalesData(timestamp, diastolic));
          print(sh.formatDate(DateTime.now().toString()) +
              "==" +
              sh.formatDate(result['timestamp']));
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
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(color: Colors.white),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            periodType = 10;
                            var d =
                                DateTime.now().add(const Duration(days: -8));

                            dataD = [];
                            dataS = [];
                            dataPulse = [];
                            onGetMeasurementList(d, 'blood_pressure');
                          });
                        },
                        child: Container(
                          decoration: periodType == 10
                              ? BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(2),
                                      bottomLeft: Radius.circular(2)),
                                  color: mainButtonColor)
                              : BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(color: mainButtonColor),
                                ),
                          height: 35,
                          child: Center(
                            child: Text(
                              "1 Woche",
                              style: TextStyle(
                                  color: periodType == 10
                                      ? Colors.white
                                      : mainButtonColor),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () async {
                          setState(() {
                            periodType = 20;
                            var d =
                                DateTime.now().add(const Duration(days: -91));

                            dataD = [];
                            dataS = [];
                            dataPulse = [];
                            onGetMeasurementList(d, 'blood_pressure');
                          });
                        },
                        child: Container(
                          decoration: periodType == 20
                              ? BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(2),
                                      bottomLeft: Radius.circular(2)),
                                  color: mainButtonColor)
                              : BoxDecoration(
                                  color: Colors.white,
                                  border: Border(
                                      bottom:
                                          BorderSide(color: mainButtonColor),
                                      top: BorderSide(color: mainButtonColor)),
                                ),
                          height: 35,
                          child: Center(
                            child: Text(
                              "3 Monate",
                              style: TextStyle(
                                  color: periodType == 20
                                      ? Colors.white
                                      : mainButtonColor),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
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
                        child: Container(
                          decoration: periodType == 30
                              ? BoxDecoration(
                                  color: mainButtonColor,
                                  border: Border.all(color: mainButtonColor),
                                )
                              : BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(color: mainButtonColor),
                                ),
                          height: 35,
                          child: Center(
                            child: Text(
                              "1 Jahr",
                              style: TextStyle(
                                  color: periodType == 30
                                      ? Colors.white
                                      : mainButtonColor),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                      Expanded(
                        child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: mainButtonColor),
                            ),
                            height: 45,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "Gestern",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  "$yesterdayValue mmHg",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ],
                            )),
                      ),
                      Expanded(
                        child: Container(
                            decoration: BoxDecoration(
                              color: mainButtonColor,
                              border: Border(
                                  right: BorderSide(color: mainButtonColor),
                                  top: BorderSide(color: mainButtonColor),
                                  bottom: BorderSide(color: mainButtonColor)),
                            ),
                            height: 45,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "Heute",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                                Text(
                                  "$todayValue mmHg",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                              ],
                            )),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Blutdruck",
                    style: TextStyle(
                      fontSize: 24,
                      color: mainButtonColor,
                      fontWeight: FontWeight.bold,
                    ),
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
                          Navigator.of(context)
                              .pushNamed('/blutdruck-description');
                        },
                        child: Text(
                          "Mehr Informationen über die Einstufung Ihrer Messwerte",
                          style: TextStyle(
                              overflow: TextOverflow.ellipsis,
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue),
                        ),
                      )
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigatorBar(selectedIndex: 0),
    );
  }
}

class _SalesData {
  _SalesData(this.date, this.sales);

  final String date;
  final double sales;
}
