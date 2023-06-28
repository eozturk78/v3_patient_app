import 'dart:async';

import 'package:flutter/material.dart';
import 'package:patient_app/colors/colors.dart';
import 'package:patient_app/screens/shared/list-box.dart';
import 'package:patient_app/screens/shared/shared.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../shared/bottom-menu.dart';

class MeasurementResultSaturationPage extends StatefulWidget {
  const MeasurementResultSaturationPage({super.key});

  @override
  State<MeasurementResultSaturationPage> createState() =>
      _MeasurementResultSaturationPageState();
}

class _MeasurementResultSaturationPageState
    extends State<MeasurementResultSaturationPage> {
  @override
  void initState() {
    super.initState();
    data = dataWeek;
  }

  int periodType = 10; // 10 week, 20 month, 30 year

  List<_SalesData> dataYear = [
    _SalesData('07.01.2023', 96),
    _SalesData('08.01.2023', 95),
    _SalesData('09.01.2023', 99),
    _SalesData('10.01.2023', 98),
    _SalesData('11.01.2023', 99),
    _SalesData('23.02.2023', 96),
    _SalesData('24.02.2023', 96),
    _SalesData('25.02.2023', 96),
    _SalesData('26.02.2023', 95),
    _SalesData('27.02.2023', 99),
    _SalesData('01.03.2023', 98),
    _SalesData('03.03.2023', 99),
    _SalesData('05.03.2023', 94),
    _SalesData('10.03.2023', 98),
    _SalesData('25.03.2023', 99),
    _SalesData('18.03.2023', 97),
    _SalesData('03.04.2023', 95),
    _SalesData('06.04.2023', 99),
    _SalesData('12.04.2023', 98),
    _SalesData('16.04.2023', 99),
    _SalesData('20.04.2023', 98),
    _SalesData('01.05.2023', 97),
    _SalesData('05.05.2023', 99),
    _SalesData('08.05.2023', 97),
    _SalesData('15.05.2023', 98),
    _SalesData('03.06.2023', 99),
    _SalesData('10.06.2023', 96),
    _SalesData('12.06.2023', 99),
    _SalesData('23.06.2023', 97),
    _SalesData('20.06.2023', 98),
    _SalesData('26.06.2023', 99),
  ];

  List<_SalesData> dataMonth = [
    _SalesData('26.03.2023', 96),
    _SalesData('28.03.2023', 98),
    _SalesData('31.03.2023', 99),
    _SalesData('09.04.2023', 97),
    _SalesData('09.04.2023', 99),
    _SalesData('09.04.2023', 96),
    _SalesData('23.04.2023', 96),
    _SalesData('01.05.2023', 95),
    _SalesData('08.05.2023', 98),
    _SalesData('09.05.2023', 99),
    _SalesData('03.06.2023', 99),
    _SalesData('10.06.2023', 97),
    _SalesData('12.06.2023', 98),
    _SalesData('23.06.2023', 99),
    _SalesData('26.06.2023', 96),
  ];

  List<_SalesData> dataWeek = [
    _SalesData('19.06.2023', 96),
    _SalesData('20.06.2023', 97),
    _SalesData('21.06.2023', 95),
    _SalesData('22.06.2023', 99),
    _SalesData('23.06.2023', 97),
    _SalesData('24.06.2023', 96),
    _SalesData('25.06.2023', 99),
    _SalesData('26.06.2023', 98),
  ];

  List<_SalesData> data = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: leadingSubpage('Sauerstoffsättigung', context),
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
                      dataSource: data,
                      xValueMapper: (_SalesData sales, _) => sales.year,
                      yValueMapper: (_SalesData sales, _) => sales.sales,
                      name: 'Sauerstoffsättigung',
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
                  CustomListComponent(null, "Gestern", "96 %", null, null),
                  Spacer(),
                  CustomListComponent(null, "Heute", "97 %", null, null),
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
              const Row(
                children: [
                  Icon(
                    Icons.info,
                    color: Color.fromARGB(255, 0, 90, 47),
                  ),
                  Text(
                    "Mehr Informationen über die Einstufung Ihrer Messwerte",
                    style: TextStyle(
                        overflow: TextOverflow.ellipsis,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue),
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
