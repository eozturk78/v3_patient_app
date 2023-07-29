import 'package:flutter/material.dart';
import 'package:patient_app/screens/shared/shared.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:patient_app/apis/apis.dart';
import '../../model/meeting.dart';
import '../../shared/toast.dart';
import '../shared/bottom-menu.dart';
//import '../shared/message-text-bubble.dart';

class Event {
  final String id;
  final String title;
  final DateTime date;
  final String link;

  Event({
    required this.id,
    required this.title,
    required this.date,
    required this.link,
  });
}

final kToday = DateTime.now();
final kFirstDay = DateTime(kToday.year, kToday.month - 3, kToday.day);
final kLastDay = DateTime(kToday.year, kToday.month + 3, kToday.day);

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  Apis apis = Apis();
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();

  Map<DateTime, List<Map<String, dynamic>>> _events = {};

  List<Meeting> meetingList = [];
  bool isStarted = true;
  Meeting? selectedMeeting;
  late final ValueNotifier<List<Event>> _selectedEvents;

  final RangeSelectionMode _rangeSelectionMode = RangeSelectionMode
      .toggledOff; // Can be toggled on/off by long pressing a date
  DateTime? _rangeStart;
  DateTime? _rangeEnd;

  @override
  void initState() {
    super.initState();
// Fetch events and update the _events map
    apis.fetchEvents().then((events) {
      setState(() {
        _events = { for (var event in events) DateTime.parse(event['date']) : [event] };
      });
    }).catchError((error) {
      //print('Error fetching events: $error');
      //showToast(error);
      throw Exception(error);
    });

    _selectedDay = _focusedDay;
  }

  /*
  getPatientMeetings() async {
    setState(() {
      isStarted = true;
    });
    apis.getPatientOnlineMeetings().then((value) {
      setState(() {
        isStarted = false;
        print(value);
        meetingList = (value as List).map((e) => Meeting.fromJson(e)).toList();
      });
    },
        onError: (err) => setState(() {
          print(err);
          isStarted = false;
        }));
  }
  */

  @override
  void dispose() {
    _selectedEvents.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: leadingSubpage('Kalendar!', context),
      body: Column(
        children: [
          TableCalendar(
            firstDay: kFirstDay,
            lastDay: kLastDay,
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            rangeStartDay: _rangeStart,
            rangeEndDay: _rangeEnd,
            calendarFormat: _calendarFormat,
            rangeSelectionMode: _rangeSelectionMode,
            startingDayOfWeek: StartingDayOfWeek.monday,
            calendarStyle: const CalendarStyle(
              // Use `CalendarStyle` to customize the UI
              outsideDaysVisible: false,
            ),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay; // update `_focusedDay` here as well
              });
            },

            onFormatChanged: (format) {
              if (_calendarFormat != format) {
                setState(() {
                  _calendarFormat = format;
                });
              }
            },
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
        eventLoader: (date) {
          return _events[date] ?? [];
        },
        calendarBuilders: CalendarBuilders(
          singleMarkerBuilder: (context, date, events) {
            return _buildEventMarker();
          },
          ),
        )
        ],
      ), // This trailing comma makes auto-formatting nicer for build methods.
      bottomNavigationBar: const BottomNavigatorBar(1),
    );
  }
  Widget _buildEventMarker() {
    // You can customize how the event indicator looks here
    return Container(
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.blue,
      ),
      width: 8,
      height: 8,
      // Add any other customization here, such as a number to indicate the number of events on that day
    );
  }

  // Function to group events by date
  Map<DateTime, List<Event>> groupEventsByDate(List<Event> events) {
    final Map<DateTime, List<Event>> groupedEvents = {};
    for (final event in events) {
      final eventDate = event.date;
      final key = DateTime(eventDate.year, eventDate.month, eventDate.day);
      if (groupedEvents.containsKey(key)) {
        groupedEvents[key]!.add(event);
      } else {
        groupedEvents[key] = [event];
      }
    }
    return groupedEvents;
  }
}
