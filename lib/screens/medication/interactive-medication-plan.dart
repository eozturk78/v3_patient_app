import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:patient_app/apis/apis.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import '../../shared/shared.dart';
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
  Timer? _debounceTimer; // Initialize _debounceTimer here
  Shared sh = Shared();

  @override
  void initState() {
    super.initState();

    sh.openPopUp(context, 'interactive-medication-plan');
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    if (_debounceTimer != null && _debounceTimer!.isActive) {
      _debounceTimer!.cancel();
    }
    _tabController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: leadingSubpage(
          sh.getLanguageResource("inteactive_medication_plan"), context),
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
                    padding: const EdgeInsets.fromLTRB(16, 5, 16, 18),
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
                            _buildTab(sh.getLanguageResource("morning_mp"),
                                Icons.wb_sunny),
                            _buildTab(sh.getLanguageResource("noon_mp"),
                                Icons.brightness_medium),
                            _buildTab(sh.getLanguageResource("evening_mp"),
                                Icons.wb_twilight),
                            _buildTab(sh.getLanguageResource("night_mp"),
                                Icons.nightlight_round_sharp),
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
          sh.getLanguageResource("your_medication_for"),
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
      child: FutureBuilder<dynamic>(
        future: api
            .fetchMedicationPlansOfDay(
              DateFormat('yyyy-MM-dd').format(_selectedDate),
            )
            .onError((error, stackTrace) => sh.redirectPatient(error, context)),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            dynamic data = snapshot.data;

            if (data != null && data.toString() != "[]") {
              if (data is Map<String, dynamic>) {
                return TabBarView(
                  controller: _tabController,
                  children: [
                    _buildMedicationList(data, 10),
                    _buildMedicationList(data, 20),
                    _buildMedicationList(data, 30),
                    _buildMedicationList(data, 40),
                  ],
                );
              } else if (data is List<dynamic>) {
                // Handle the case where data is a list (if needed)
                return Text(data.toString());
              }
            }

            return ListTile(
              title: Text(
                sh.getLanguageResource(
                    "not_drug_data_is_available_for_this_data"),
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildMedicationList(Map<String, dynamic> data, int time) {
    List<Widget> medicationWidgets = [];

    // Get the corresponding dose key based on the time of day
    String doseKey = _getDoseKey(time);

    data.forEach((String treatmentId, dynamic treatmentData) {
      Map<String, dynamic> doses = treatmentData['doses'] ?? {};
      DateTime archivedat = DateTime.parse(treatmentData['archivedat']);
      String mpversion = treatmentData['version'];

      // Get the corresponding dose value based on the time of day
      dynamic doseValue = doses[doseKey];

      if (doseValue is String) {
        medicationWidgets.add(
          ExpansionTile(
            backgroundColor: Colors.white,
            initiallyExpanded: true,
            maintainState: true,
            title: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                '${sh.getLanguageResource("treatment_id")}: $treatmentId',
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
                '${sh.getLanguageResource("medication_date")}: ${DateFormat('dd.MM.yyyy').format(archivedat)} Version: $mpversion',
                style: TextStyle(
                  color: Colors.black45,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            children: <Widget>[
              if (doseValue.trim().isNotEmpty)
                ListTile(
                  title: Text(
                    doseValue.replaceAll('\\n', '\n'),
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black87,
                    ),
                  ),
                )
              else
                ListTile(
                  title: Text(
                    sh.getLanguageResource(
                        "there_is_no_medicine_for_this_meal"),
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ),
            ],
          ),
        );
      }
    });

    return Column(
      children: [
        if (time == 10) Text(sh.getLanguageResource("mornings")),
        if (time == 20) Text(sh.getLanguageResource("noons")),
        if (time == 30) Text(sh.getLanguageResource("evenings")),
        if (time == 40) Text(sh.getLanguageResource("nights")),
        Text(
          "*${DateFormat('dd.MM.yyyy').format(_selectedDate)}",
        ),
        if (medicationWidgets.isNotEmpty)
          Column(
            children: medicationWidgets,
          )
        else
          Text(
            sh.getLanguageResource("not_drug_data_is_available_for_this_data"),
          ),
      ],
    );
  }

  String _getDoseKey(int time) {
    switch (time) {
      case 10:
        return 'doseearly';
      case 20:
        return 'dosenoon';
      case 30:
        return 'doseafternoon';
      case 40:
        return 'doseevening';
      default:
        return '';
    }
  }

// function to avoid request flood
  void Function(DateTime) _debounce(
      void Function(DateTime) func, Duration duration) {
    return (DateTime dateTime) {
      if (_debounceTimer != null && _debounceTimer!.isActive) {
        _debounceTimer!.cancel();
      }
      _debounceTimer = Timer(duration, () {
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
