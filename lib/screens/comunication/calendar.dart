import 'dart:async';

import 'package:flutter/material.dart';
import 'package:patient_app/screens/shared/shared.dart';
import 'package:table_calendar/table_calendar.dart';

import '../shared/bottom-menu.dart';
import '../shared/message-text-bubble.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: leadingSubpage('Kalendar!', context),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2010, 10, 16),
            lastDay: DateTime.utc(2030, 3, 14),
            focusedDay: DateTime.now(),
            locale: 'en_US',
          )
        ],
      ), // This trailing comma makes auto-formatting nicer for build methods.
      bottomNavigationBar: BottomNavigatorBar(1),
    );
  }
}
