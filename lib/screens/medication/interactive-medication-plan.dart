import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:patient_app/apis/apis.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import '../shared/shared.dart';

Apis api = Apis();

class InteractiveMedicationPlanPage extends StatefulWidget {
  const InteractiveMedicationPlanPage({Key? key}) : super(key: key);

  @override
  _InteractiveMedicationPlanPageState createState() =>
      _InteractiveMedicationPlanPageState();
}

typedef Debounce = void Function(DateTime);

class _InteractiveMedicationPlanPageState
    extends State<InteractiveMedicationPlanPage>
    with SingleTickerProviderStateMixin {
  DateTime _selectedDate = DateTime.now();
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: leadingSubpage('Interactive Medication Plan', context),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: _buildDateSelection(),
                  ),
                  DefaultTabController(
                    length: 4,
                    child: Column(
                      children: [
                        TabBar(
                          labelColor: Color.fromARGB(255, 162, 28, 52),
                          controller: _tabController,
                          indicatorColor: Colors.black,
                          tabs: [
                            _buildTab('Morgens', Icons.wb_sunny),
                            _buildTab('Mittags', Icons.brightness_medium),
                            _buildTab('Abends', Icons.wb_twilight),
                            _buildTab('Nacht', Icons.nightlight_round_sharp),
                          ],
                        ),
                        SizedBox(height: 16),
                        _buildTabBarView(),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Tab _buildTab(String label, IconData icon) {
    return Tab(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon),
          SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildDateSelection() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          'Ihre Medikamente für:',
          style: TextStyle(fontSize: 16),
        ),
        SizedBox(width: 8),
        InkWell(
          onTap: () => _selectDate(context),
          child: Row(
            children: [
              Icon(Icons.calendar_today),
              SizedBox(width: 8),
              Text(
                '${DateFormat('dd.MM.yyyy').format(_selectedDate)}',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTabBarView() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      child: TabBarView(
        controller: _tabController,
        children: [
          _buildMedicationList('Morgens'),
          _buildMedicationList('Mittags'),
          _buildMedicationList('Abends'),
          _buildMedicationList('Nacht'),
        ],
      ),
    );
  }

  Widget _buildMedicationList(String time) {
    return FutureBuilder<dynamic>(
      future: api.fetchMedicationPlansOfDay(
        DateFormat('yyyy-MM-dd').format(_selectedDate),
      ),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SizedBox(
            child: Center(
                child: CircularProgressIndicator()
            ),
            height: 50.0,
            width: 50.0,
          );
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          dynamic data = snapshot.data;

          if (data != null && (data is Map<String, dynamic>)) {
            Map<String, dynamic> medications = data;

            return Column(
              children: [
                Text(time),
                Text(
                  "*${DateFormat('dd.MM.yyyy').format(_selectedDate)}",
                ),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: medications.length,
                  itemBuilder: (context, index) {
                    String treatmentId = medications.keys.elementAt(index);
                    Map<String, dynamic> doses = medications[treatmentId]['doses'] ?? {};
                    DateTime archivedat = DateTime.parse(medications[treatmentId]['archivedat']);
                    String mpversion = medications[treatmentId]['version'];

                    // Get the corresponding dose value based on the time of day
                    String doseKey = _getDoseKey(time);
                    dynamic doseValue = doses[doseKey];

                    if (doseValue is String) {
                      return ExpansionTile(
                        initiallyExpanded: true,
                        maintainState: true,
                        title: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Text(
                            'Treatment ID: $treatmentId',
                            style: TextStyle(
                              color: Color.fromARGB(255, 162, 28, 52),
                              fontSize: 16,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Text(
                            'Medication Date: ${DateFormat('dd.MM.yyyy').format(archivedat)} Version: $mpversion',
                            style: TextStyle(
                              color: Colors.black45,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        children: <Widget>[
                          ListTile(
                            title: Text(
                              doseValue.replaceAll('\\n', '\n'),
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                        ],
                      );
                    } else {
                      return SizedBox.shrink();
                    }
                  },
                ),
              ],
            );
          } else {
            return Text('No medication data available for the selected date');
          }
        }
      },
    );
  }

  String _getDoseKey(String time) {
    switch (time) {
      case 'Morgens':
        return 'doseearly';
      case 'Mittags':
        return 'dosenoon';
      case 'Abends':
        return 'doseafternoon';
      case 'Nacht':
        return 'doseevening';
      default:
        return '';
    }
  }

// function to avoid request flood
  Debounce _debounce(void Function(DateTime) func, Duration duration) {
    Timer? _timer;
    return (DateTime dateTime) {
      if (_timer != null && _timer!.isActive) {
        _timer!.cancel();
      }
      _timer = Timer(duration, () {
        func(dateTime);
      });
    };
  }

// debounce function onDateTimeChanged to avoid request flood
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showCupertinoModalPopup(
      context: context,
      builder: (context) {
        return Container(
          height: 200,
          child: CupertinoDatePicker(
            mode: CupertinoDatePickerMode.date,
            initialDateTime: _selectedDate,
            onDateTimeChanged: _debounce((DateTime dateTime) {
              setState(() {
                _selectedDate = dateTime;
              });
            }, Duration(milliseconds: 1850)),
          ),
        );
      },
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }
}
