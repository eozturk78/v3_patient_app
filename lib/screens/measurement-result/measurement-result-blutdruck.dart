import 'dart:async';

import 'package:flutter/material.dart';
import 'package:patient_app/colors/colors.dart';
import 'package:patient_app/screens/shared/list-box.dart';
import 'package:patient_app/screens/shared/shared.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../shared/bottom-menu.dart';

class MeasurementResultPage extends StatefulWidget {
  const MeasurementResultPage({super.key});

  @override
  State<MeasurementResultPage> createState() => _MeasurementResultPageState();
}

class _MeasurementResultPageState extends State<MeasurementResultPage> {
  @override
  void initState() {
    super.initState();
    dataS = dataSWeek;
    dataD = dataDWeek;
    dataPulse = dataPulseWeek;
  }

  int periodType = 10; // 10 week, 20 month, 30 year

  List<_SalesData> dataSYear = [
    _SalesData('07.01.2023', 106),
    _SalesData('08.01.2023', 110),
    _SalesData('09.01.2023', 111),
    _SalesData('10.01.2023', 122),
    _SalesData('11.01.2023', 120),
    _SalesData('23.02.2023', 116),
    _SalesData('24.02.2023', 104),
    _SalesData('25.02.2023', 113),
    _SalesData('26.02.2023', 110),
    _SalesData('27.02.2023', 108),
    _SalesData('01.03.2023', 124),
    _SalesData('03.03.2023', 110),
    _SalesData('05.03.2023', 116),
    _SalesData('10.03.2023', 115),
    _SalesData('25.03.2023', 112),
    _SalesData('18.03.2023', 116),
    _SalesData('03.04.2023', 120),
    _SalesData('06.04.2023', 119),
    _SalesData('12.04.2023', 124),
    _SalesData('16.04.2023', 122),
    _SalesData('20.04.2023', 116),
    _SalesData('01.05.2023', 127),
    _SalesData('05.05.2023', 109),
    _SalesData('08.05.2023', 116),
    _SalesData('15.05.2023', 119),
    _SalesData('03.06.2023', 127),
    _SalesData('10.06.2023', 124),
    _SalesData('12.06.2023', 110),
    _SalesData('23.06.2023', 122),
    _SalesData('20.06.2023', 139),
    _SalesData('26.06.2023', 124),
  ];
  List<_SalesData> dataDYear = [
    _SalesData('07.01.2023', 75),
    _SalesData('08.01.2023', 70),
    _SalesData('09.01.2023', 68),
    _SalesData('10.01.2023', 72),
    _SalesData('11.01.2023', 75),
    _SalesData('23.02.2023', 67),
    _SalesData('24.02.2023', 65),
    _SalesData('25.02.2023', 61),
    _SalesData('26.02.2023', 57),
    _SalesData('27.02.2023', 55),
    _SalesData('01.03.2023', 75),
    _SalesData('03.03.2023', 79),
    _SalesData('05.03.2023', 65),
    _SalesData('10.03.2023', 72),
    _SalesData('25.03.2023', 70),
    _SalesData('18.03.2023', 72),
    _SalesData('03.04.2023', 77),
    _SalesData('06.04.2023', 80),
    _SalesData('12.04.2023', 85),
    _SalesData('16.04.2023', 72),
    _SalesData('20.04.2023', 75),
    _SalesData('01.05.2023', 79),
    _SalesData('05.05.2023', 80),
    _SalesData('08.05.2023', 82),
    _SalesData('15.05.2023', 70),
    _SalesData('03.06.2023', 75),
    _SalesData('10.06.2023', 96),
    _SalesData('12.06.2023', 73),
    _SalesData('23.06.2023', 88),
    _SalesData('20.06.2023', 80),
    _SalesData('26.06.2023', 82),
  ];
  List<_SalesData> dataPulseYear = [
    _SalesData('07.01.2023', 71),
    _SalesData('08.01.2023', 59),
    _SalesData('09.01.2023', 64),
    _SalesData('10.01.2023', 77),
    _SalesData('11.01.2023', 75),
    _SalesData('23.02.2023', 72),
    _SalesData('24.02.2023', 85),
    _SalesData('25.02.2023', 66),
    _SalesData('26.02.2023', 61),
    _SalesData('27.02.2023', 63),
    _SalesData('01.03.2023', 82),
    _SalesData('03.03.2023', 80),
    _SalesData('05.03.2023', 65),
    _SalesData('10.03.2023', 72),
    _SalesData('25.03.2023', 70),
    _SalesData('18.03.2023', 72),
    _SalesData('03.04.2023', 65),
    _SalesData('06.04.2023', 62),
    _SalesData('12.04.2023', 64),
    _SalesData('16.04.2023', 63),
    _SalesData('20.04.2023', 59),
    _SalesData('01.05.2023', 68),
    _SalesData('05.05.2023', 70),
    _SalesData('08.05.2023', 62),
    _SalesData('15.05.2023', 65),
    _SalesData('03.06.2023', 55),
    _SalesData('10.06.2023', 96),
    _SalesData('12.06.2023', 53),
    _SalesData('23.06.2023', 67),
    _SalesData('20.06.2023', 57),
    _SalesData('26.06.2023', 55),
  ];

  List<_SalesData> dataSMonth = [
    _SalesData('26.03.2023', 113),
    _SalesData('28.03.2023', 112),
    _SalesData('31.03.2023', 108),
    _SalesData('09.04.2023', 115),
    _SalesData('09.04.2023', 111),
    _SalesData('09.04.2023', 122),
    _SalesData('23.04.2023', 119),
    _SalesData('01.05.2023', 108),
    _SalesData('08.05.2023', 122),
    _SalesData('09.05.2023', 124),
    _SalesData('03.06.2023', 108),
    _SalesData('10.06.2023', 124),
    _SalesData('12.06.2023', 124),
    _SalesData('23.06.2023', 152),
    _SalesData('26.06.2023', 110),
  ];
  List<_SalesData> dataDMonth = [
    _SalesData('26.03.2023', 83),
    _SalesData('28.03.2023', 79),
    _SalesData('31.03.2023', 81),
    _SalesData('09.04.2023', 83),
    _SalesData('09.04.2023', 75),
    _SalesData('09.04.2023', 71),
    _SalesData('23.04.2023', 78),
    _SalesData('01.05.2023', 81),
    _SalesData('08.05.2023', 78),
    _SalesData('09.05.2023', 81),
    _SalesData('03.06.2023', 80),
    _SalesData('10.06.2023', 78),
    _SalesData('12.06.2023', 91),
    _SalesData('23.06.2023', 67),
    _SalesData('26.06.2023', 73),
  ];
  List<_SalesData> dataPulseMonth = [
    _SalesData('26.03.2023', 93),
    _SalesData('28.03.2023', 77),
    _SalesData('31.03.2023', 94),
    _SalesData('09.04.2023', 84),
    _SalesData('09.04.2023', 73),
    _SalesData('09.04.2023', 75),
    _SalesData('23.04.2023', 78),
    _SalesData('01.05.2023', 61),
    _SalesData('08.05.2023', 64),
    _SalesData('09.05.2023', 75),
    _SalesData('03.06.2023', 80),
    _SalesData('10.06.2023', 60),
    _SalesData('12.06.2023', 56),
    _SalesData('23.06.2023', 64),
    _SalesData('26.06.2023', 55),
  ];

  List<_SalesData> dataSWeek = [
    _SalesData('19.06.2023', 118),
    _SalesData('20.06.2023', 120),
    _SalesData('21.06.2023', 125),
    _SalesData('22.06.2023', 127),
    _SalesData('23.06.2023', 139),
    _SalesData('24.06.2023', 146),
    _SalesData('25.06.2023', 116),
    _SalesData('26.06.2023', 124),
  ];
  List<_SalesData> dataDWeek = [
    _SalesData('19.06.2023', 74),
    _SalesData('20.06.2023', 80),
    _SalesData('21.06.2023', 78),
    _SalesData('22.06.2023', 80),
    _SalesData('23.06.2023', 78),
    _SalesData('24.06.2023', 91),
    _SalesData('25.06.2023', 67),
    _SalesData('26.06.2023', 73),
  ];
  List<_SalesData> dataPulseWeek = [
    _SalesData('19.06.2023', 58),
    _SalesData('20.06.2023', 67),
    _SalesData('21.06.2023', 55),
    _SalesData('22.06.2023', 60),
    _SalesData('23.06.2023', 60),
    _SalesData('24.06.2023', 57),
    _SalesData('25.06.2023', 55),
    _SalesData('26.06.2023', 55),
  ];

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
                          dataS = dataSWeek;
                          dataD = dataDWeek;
                          dataPulse = dataPulseWeek;
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
                          dataS = dataSMonth;
                          dataD = dataDMonth;
                          dataPulse = dataPulseMonth;
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
                          dataS = dataSYear;
                          dataD = dataDYear;
                          dataPulse = dataPulseYear;
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
                      dataSource: dataS,
                      xValueMapper: (_SalesData sales, _) => sales.year,
                      yValueMapper: (_SalesData sales, _) => sales.sales,
                      name: 'Systolischer',
                      // Enable data label
                      dataLabelSettings:
                          const DataLabelSettings(isVisible: false)),
                  LineSeries<_SalesData, String>(
                      dataSource: dataD,
                      xValueMapper: (_SalesData sales, _) => sales.year,
                      yValueMapper: (_SalesData sales, _) => sales.sales,
                      name: 'Diastolischer',
                      // Enable data label
                      dataLabelSettings:
                          const DataLabelSettings(isVisible: false)),
                  LineSeries<_SalesData, String>(
                      dataSource: dataPulse,
                      xValueMapper: (_SalesData sales, _) => sales.year,
                      yValueMapper: (_SalesData sales, _) => sales.sales,
                      name: 'Pulse',
                      // Enable data label
                      dataLabelSettings:
                          const DataLabelSettings(isVisible: false))
                ],
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(40),
                  primary: mainButtonColor,
                ),
                onPressed: () {},
                child: const Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.thermostat_outlined),
                    Text("Blutdruckmessung durchführen ")
                  ],
                ),
              ),
              const Row(
                children: [
                  CustomListComponent(
                      null, "Gestern", "122/84 mmHg", null, null),
                  Spacer(),
                  CustomListComponent(null, "Heute", "112/82 mmHg", null, null),
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
  _SalesData(this.year, this.sales);

  final String year;
  final double sales;
}
