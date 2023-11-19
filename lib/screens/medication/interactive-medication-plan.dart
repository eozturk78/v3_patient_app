import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../shared/shared.dart';

class InteractiveMedicationPlanPage extends StatefulWidget {
  const InteractiveMedicationPlanPage({Key? key}) : super(key: key);

  @override
  _InteractiveMedicationPlanPageState createState() =>
      _InteractiveMedicationPlanPageState();
}

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
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Ihre Medikamente für:',
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(width: 8),
                        InkWell(
                          onTap: () {
                            _selectDate(context);
                          },
                          child: Row(
                            children: [
                              Icon(Icons.calendar_today),
                              SizedBox(width: 8),
                              Text(
                                '${_selectedDate.day}.${_selectedDate.month}.${_selectedDate.year}',
                                style: TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
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
                        // Wrap TabBarView with Expanded
                        Container(
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
                        ),
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

  Widget _buildMedicationList(String time) {
    // Replace this with your actual data fetching logic
    List<String> medications = ['Medication A', 'Medication B'];

    return
      Column(
        children: [
          Text(time),
      Text("*" + _selectedDate.day.toString() + "." + _selectedDate.month.toString() + "." +_selectedDate.year.toString()),
      Flexible(child:
      ListView.builder(
      itemCount: medications.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(medications[index]),
          // Add more details if needed
        );
      },
    )),
      ]);
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showCupertinoModalPopup(
      context: context,
      builder: (context) {
        return Container(
          height: 200,
          child: CupertinoDatePicker(
            mode: CupertinoDatePickerMode.date,
            initialDateTime: _selectedDate,
            onDateTimeChanged: (dateTime) {
              setState(() {
                _selectedDate = dateTime;
              });
            },
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
