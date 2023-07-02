import 'dart:async';

import 'package:flutter/material.dart';
import 'package:patient_app/colors/colors.dart';
import 'package:patient_app/screens/shared/list-box.dart';
import 'package:patient_app/screens/shared/shared.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../shared/bottom-menu.dart';
import '../shared/sub-total.dart';

class MeasurementResultWeightPage extends StatefulWidget {
  const MeasurementResultWeightPage({super.key});

  @override
  State<MeasurementResultWeightPage> createState() =>
      _MeasurementResultWeightPageState();
}

class _MeasurementResultWeightPageState
    extends State<MeasurementResultWeightPage> {
  @override
  void initState() {
    super.initState();
    data = dataWeek;
    setFillThreshold();
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

  List<_SalesData> redHigh = [];
  List<_SalesData> redLow = [];
  List<_SalesData> yellowHigh = [];
  List<_SalesData> yellowLow = [];

  int periodType = 10; // 10 week, 20 month, 30 year

  List<_SalesData> dataYear = [
    _SalesData('07.01.2023', 97),
    _SalesData('08.01.2023', 97.4),
    _SalesData('09.01.2023', 97),
    _SalesData('10.01.2023', 97.2),
    _SalesData('11.01.2023', 97),
    _SalesData('23.02.2023', 97.5),
    _SalesData('24.02.2023', 97.8),
    _SalesData('25.02.2023', 97.9),
    _SalesData('26.02.2023', 98),
    _SalesData('27.02.2023', 98),
    _SalesData('01.03.2023', 96),
    _SalesData('03.03.2023', 96.2),
    _SalesData('05.03.2023', 97),
    _SalesData('10.03.2023', 97.2),
    _SalesData('25.03.2023', 97),
    _SalesData('26.03.2023', 99.5),
    _SalesData('28.03.2023', 100),
    _SalesData('31.03.2023', 101),
    _SalesData('09.04.2023', 103),
    _SalesData('09.04.2023', 104),
    _SalesData('09.04.2023', 103.2),
    _SalesData('23.04.2023', 103),
    _SalesData('01.05.2023', 103.5),
    _SalesData('08.05.2023', 103),
    _SalesData('09.05.2023', 103),
    _SalesData('19.06.2023', 102.5),
    _SalesData('20.06.2023', 103.5),
    _SalesData('21.06.2023', 103.3),
    _SalesData('22.06.2023', 103.3),
    _SalesData('23.06.2023', 104),
    _SalesData('24.06.2023', 103.5),
    _SalesData('25.06.2023', 102.6),
    _SalesData('26.06.2023', 102.2),
  ];

  List<_SalesData> dataMonth = [
    _SalesData('26.03.2023', 99.5),
    _SalesData('28.03.2023', 100),
    _SalesData('31.03.2023', 101),
    _SalesData('09.04.2023', 103),
    _SalesData('09.04.2023', 104),
    _SalesData('09.04.2023', 103.2),
    _SalesData('23.04.2023', 103),
    _SalesData('01.05.2023', 103.5),
    _SalesData('08.05.2023', 103),
    _SalesData('09.05.2023', 103),
    _SalesData('19.06.2023', 102.5),
    _SalesData('20.06.2023', 103.5),
    _SalesData('21.06.2023', 103.3),
    _SalesData('22.06.2023', 103.3),
    _SalesData('23.06.2023', 104),
    _SalesData('24.06.2023', 103.5),
    _SalesData('25.06.2023', 102.6),
    _SalesData('26.06.2023', 102.2),
  ];

  List<_SalesData> dataWeek = [
    _SalesData('19.06.2023', 102.5),
    _SalesData('20.06.2023', 103.5),
    _SalesData('21.06.2023', 103.3),
    _SalesData('22.06.2023', 103.3),
    _SalesData('23.06.2023', 104),
    _SalesData('24.06.2023', 103.5),
    _SalesData('25.06.2023', 102.6),
    _SalesData('26.06.2023', 102.2),
  ];

  List<_SalesData> data = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: leadingSubpage('Gewicht', context),
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
                          data = dataWeek;
                          setFillThreshold();
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
                          data = dataMonth;
                          setFillThreshold();
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
                          data = dataYear;
                          setFillThreshold();
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
                      name: 'Gewicht',
                      // Enable data label
                      dataLabelSettings:
                          const DataLabelSettings(isVisible: false)),
                  LineSeries<_SalesData, String>(
                      dataSource: yellowHigh,
                      color: Colors.amber,
                      xValueMapper: (_SalesData sales, _) => sales.year,
                      yValueMapper: (_SalesData sales, _) => sales.sales,
                      name: 'Gewicht',
                      // Enable data label
                      dataLabelSettings:
                          const DataLabelSettings(isVisible: false)),
                  LineSeries<_SalesData, String>(
                      dataSource: yellowLow,
                      color: Colors.amber,
                      xValueMapper: (_SalesData sales, _) => sales.year,
                      yValueMapper: (_SalesData sales, _) => sales.sales,
                      name: 'Gewicht',
                      // Enable data label
                      dataLabelSettings:
                          const DataLabelSettings(isVisible: false)),
                  LineSeries<_SalesData, String>(
                      dataSource: data,
                      color: Colors.blue[900],
                      xValueMapper: (_SalesData sales, _) => sales.year,
                      yValueMapper: (_SalesData sales, _) => sales.sales,
                      name: 'Gewicht',
                      // Enable data label
                      dataLabelSettings:
                          const DataLabelSettings(isVisible: false)),
                  LineSeries<_SalesData, String>(
                      dataSource: redLow,
                      color: Colors.red,
                      xValueMapper: (_SalesData sales, _) => sales.year,
                      yValueMapper: (_SalesData sales, _) => sales.sales,
                      name: 'Gewicht',
                      // Enable data label
                      dataLabelSettings:
                          const DataLabelSettings(isVisible: false)),
                ],
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(40),
                  primary: mainButtonColor,
                ),
                onPressed: () {
                  Navigator.of(context).pushNamed("/questionnaire-1");
                },
                child: const Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.thermostat_outlined),
                    Text("Messung durchführen")
                  ],
                ),
              ),
              const Row(
                children: [
                  CustomSubTotal(null, "Gestern", "103.2 KG", null, null),
                  Spacer(),
                  CustomSubTotal(null, "Heute", "103 KG", null, null),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              const Text(
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
                      Navigator.of(context).pushNamed('/weight-description');
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
