import 'dart:async';

import 'package:flutter/material.dart';
import 'package:patient_app/colors/colors.dart';
import 'package:patient_app/screens/shared/list-box.dart';
import 'package:patient_app/screens/shared/shared.dart';
import 'package:patient_app/shared/shared.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../apis/apis.dart';
import '../shared/bottom-menu.dart';
import '../shared/sub-total.dart';

class MeasurementResultSaturationPage extends StatefulWidget {
  const MeasurementResultSaturationPage({super.key});

  @override
  State<MeasurementResultSaturationPage> createState() =>
      _MeasurementResultSaturationPageState();
}

class _MeasurementResultSaturationPageState
    extends State<MeasurementResultSaturationPage> {
  Apis apis = Apis();
  Shared sh = Shared();
  DateTime today = DateTime.now();
  String todayValue = "~", yesterdayValue = "~";
  @override
  void initState() {
    super.initState();
    today = today.add(const Duration(days: -8));
    onGetMeasurementList(today, 'saturation');
    sh.openPopUp(context, 'measurement-result-saturation');
  }

  onGetMeasurementList(DateTime date, String bp) {
    List<_SalesData> dataFrom = [];
    apis.getMeasurementList(date, bp).then(
      (value) {
        var results = value['results'] as List;
        for (var result in results) {
          var timestamp = sh.formatDate(result['timestamp']);
          var value = result['measurement']['value'];
          if (sh.formatDate(DateTime.now().toString()) ==
              sh.formatDate(result['timestamp'])) {
            todayValue = "$value";
          }
          if (sh.formatDate(
                  DateTime.now().add(Duration(days: -1)).toString()) ==
              sh.formatDate(result['timestamp'])) {
            yesterdayValue = "$value";
          }
          dataFrom.add(_SalesData(timestamp, value));
        }
        setState(() {
          data = dataFrom;
          setFillThreshold();
        });
      },
      onError: (err) {
        sh.redirectPatient(err, context);
      },
    );
  }

  setFillThreshold() {
    redHigh = [];
    redLow = [];
    yellowHigh = [];
    yellowLow = [];
    data.forEach((element) {
      yellowHigh.add(_SalesData(element.year, 100));
      yellowLow.add(_SalesData(element.year, 60));
    });
  }

  List<_SalesData> redHigh = [];
  List<_SalesData> redLow = [];
  List<_SalesData> yellowHigh = [];
  List<_SalesData> yellowLow = [];
  int periodType = 10; // 10 week, 20 month, 30 year

  List<_SalesData> data = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          leadingSubpage(sh.getLanguageResource("oxygen_saturation"), context),
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
                            onGetMeasurementList(d, 'saturation');
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
                              sh.getLanguageResource("one_week"),
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
                            onGetMeasurementList(d, 'saturation');
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
                              sh.getLanguageResource("three_months"),
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
                            onGetMeasurementList(d, 'saturation');
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
                              sh.getLanguageResource("one_year"),
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
                  const SizedBox(
                    height: 15,
                  ),
                  //Initialize the chart widget
                  SfCartesianChart(
                    primaryXAxis: CategoryAxis(isVisible: false),
                    // Chart title
                    title: ChartTitle(text: ''),
                    // Enable legend
                    legend: Legend(isVisible: false),
                    // Enable tooltip
                    tooltipBehavior: TooltipBehavior(enable: true),
                    series: <ChartSeries<_SalesData, String>>[
                      LineSeries<_SalesData, String>(
                          dataSource: yellowHigh,
                          color: Colors.amber,
                          xValueMapper: (_SalesData sales, _) => sales.year,
                          yValueMapper: (_SalesData sales, _) => sales.sales,
                          name: sh.getLanguageResource("oxygen_saturation"),
                          // Enable data label
                          dataLabelSettings:
                              const DataLabelSettings(isVisible: false)),
                      LineSeries<_SalesData, String>(
                          dataSource: yellowLow,
                          color: Colors.amber,
                          xValueMapper: (_SalesData sales, _) => sales.year,
                          yValueMapper: (_SalesData sales, _) => sales.sales,
                          name: sh.getLanguageResource("oxygen_saturation"),
                          // Enable data label
                          dataLabelSettings:
                              const DataLabelSettings(isVisible: false)),
                      LineSeries<_SalesData, String>(
                          dataSource: data,
                          color: Colors.blue[900],
                          xValueMapper: (_SalesData sales, _) => sales.year,
                          yValueMapper: (_SalesData sales, _) => sales.sales,
                          name: sh.getLanguageResource("oxygen_saturation"),
                          // Enable data label
                          dataLabelSettings:
                              const DataLabelSettings(isVisible: false)),
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
                                  sh.getLanguageResource("yesterday"),
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  "$yesterdayValue %",
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
                                  sh.getLanguageResource("today"),
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                                Text(
                                  "$todayValue %",
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
                    sh.getLanguageResource("oxygen_saturation"),
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
                    sh.getLanguageResource("oxygen_saturation_desc"),
                  ),
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
                              .pushNamed('/saturation-description');
                        },
                        child: Text(
                          sh.getLanguageResource("more_info"),
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
            )
          ],
        ),
      ),
      ////bottomNavigationBar: BottomNavigatorBar(selectedIndex: 0),
    );
  }
}

class _SalesData {
  _SalesData(this.year, this.sales);

  final String year;
  final double sales;
}
