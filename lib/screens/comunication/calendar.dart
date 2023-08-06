import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../apis/apis.dart';
import '../shared/shared.dart';

Apis apis = Apis();

class EventType {
  final String title;
  final Color color;

  EventType(this.title, this.color);
}

class CalendarEvent {
  final String title;
  final String description;
  final DateTime dateTime;
  final EventType eventType;

  CalendarEvent(this.title, this.description, this.dateTime, this.eventType);

  factory CalendarEvent.fromJson(Map<String, dynamic> json) {
    return CalendarEvent(
      json['event_title'] as String,
      json['event_description'] as String,
      DateTime.parse(json['event_date'] as String),
      eventTypeMap[json['event_type']] ?? EventType('Default', Colors.grey),
    );
  }
}

// Map event titles to their corresponding EventType
final Map<String, EventType> eventTypeMap = {
  'Doctor Appointment': EventType('Doctor Appointment', Colors.red),
  'Online Meeting': EventType('Online Meeting', Colors.blue),
  'File Logs': EventType('File Logs', Colors.orange),
  // Add more mappings as needed for other event titles
};

class CalendarScreen extends StatefulWidget {
  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  Map<DateTime, List<CalendarEvent>> _events = {};
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _selectedDay = DateTime.now();

  @override
  void initState() {
    super.initState();
    _fetchPatientCalendarEventsFromBackend();
    _fetchPatientOnlineMeetingEventsFromBackend();
    _fetchPatientFileEventsFromBackend();
  }

  Future<void> _fetchPatientCalendarEventsFromBackend() async {

    //final apiUrl = '$apis.baseUrl/getPatientCalendarEvents';
    final response = await apis.getPatientCalendarEvents();

    if (response.statusCode == 200) {
      final eventsData = json.decode(response.body);
      final events = List<Map<String, dynamic>>.from(eventsData);
      setState(() {
        _events = _convertToCalendarEvents(events);
        //print(_events);
      });
    } else {
      // Handle error if fetching events fails
      print('Failed to fetch events from the backend');
    }
  }

  Future<void> _fetchPatientOnlineMeetingEventsFromBackend() async {

    //final apiUrl = '$apis.baseUrl/getPatientCalendarEvents';
    final response = await apis.getPatientOnlineMeetingEvents();

    if (response.statusCode == 200) {
      final eventsData = json.decode(response.body);
      final events = List<Map<String, dynamic>>.from(eventsData);
      setState(() {
        _events.addAll(_convertToCalendarEvents(events));
        print(_events);
      });
    } else {
      // Handle error if fetching events fails
      print('Failed to fetch events from the backend');
    }
  }

  Future<void> _fetchPatientFileEventsFromBackend() async {

    //final apiUrl = '$apis.baseUrl/getPatientCalendarEvents';
    final response = await apis.getPatientFileEvents();

    if (response.statusCode == 200) {
      final eventsData = json.decode(response.body);
      final events = List<Map<String, dynamic>>.from(eventsData);
      setState(() {
        _events.addAll(_convertToCalendarEvents(events));
        print(_events);
      });
    } else {
      // Handle error if fetching events fails
      print('Failed to fetch events from the backend');
    }
  }

  Map<DateTime, List<CalendarEvent>> _convertToCalendarEvents(List<Map<String, dynamic>> events) {
    final calendarEvents = <DateTime, List<CalendarEvent>>{};
    for (var event in events) {
      final calendarEvent = CalendarEvent.fromJson(event);
      final date = DateTime(calendarEvent.dateTime.year, calendarEvent.dateTime.month, calendarEvent.dateTime.day);
      calendarEvents[date] = calendarEvents[date] ?? [];
      calendarEvents[date]!.add(calendarEvent);
    }
    return calendarEvents;
  }

  List<CalendarEvent> _getEventsForSelectedDay(DateTime selectedDay, Map<DateTime, List<CalendarEvent>> events) {
    final eventsForSelectedDay = events[DateTime(selectedDay.year,selectedDay.month,selectedDay.day)] ?? [];
    //print(eventsForSelectedDay);
    return eventsForSelectedDay;

  }

  Map<DateTime, List<EventType>> _getEventMarkers(Map<DateTime, List<CalendarEvent>> events) {
    final eventMarkers = <DateTime, List<EventType>>{};
    events.forEach((day, events) {
      final eventTypeList = events.map((event) => event.eventType).toList();
      final uniqueEventTypes = eventTypeList.toSet().toList();
      eventMarkers[day] = uniqueEventTypes;
    });
    return eventMarkers;
  }


  @override
  Widget build(BuildContext context) {
    final key = GlobalObjectKey<ExpandableFabState>(context);
    return Scaffold(
      appBar: leadingSubpage('Kalender', context),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.now().subtract(Duration(days: 365)),
            lastDay: DateTime.now().add(Duration(days: 365)),
            focusedDay: _selectedDay,
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay, day);
            },
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
              });
            },
            calendarFormat: _calendarFormat,
            onFormatChanged: (format) {
              setState(() {
                _calendarFormat = format;
              });
            },
            calendarBuilders: CalendarBuilders(
              markerBuilder: _buildMarkers,
            ),
          ),
          Legend(_getEventTypes()),
          Expanded(
            child: EventList(
              selectedDay: _selectedDay,
              events: _getEventsForSelectedDay(_selectedDay, _events),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMarkers(BuildContext context, DateTime date, List<dynamic> events) {
    final eventMarkers = _getEventMarkers(_events)[DateTime(date.year, date.month, date.day)];
    if (eventMarkers != null && eventMarkers.isNotEmpty) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: eventMarkers.map((eventType) => _buildMarkerIndicator(eventType)).toList(),
      );
    }
    return SizedBox.shrink();
  }


  Widget _buildMarkerIndicator(EventType eventType) {
    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: eventType.color,
      ),
    );
  }

  List<EventType> _getEventTypes() {
    return [
      EventType('Doctor Appointment', Colors.red),
      EventType('Online Meeting', Colors.blue),
      EventType('File Logs', Colors.orange),
    ];
  }
}

class Legend extends StatelessWidget {
  final List<EventType> eventTypes;

  Legend(this.eventTypes);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: eventTypes
            .map((eventType) => Row(
          children: [
            Container(
              width: 12,
              height: 12,
              color: eventType.color,
            ),
            SizedBox(width: 5),
            Text(eventType.title),
          ],
        ))
            .toList(),
      ),
    );
  }
}

class EventList extends StatelessWidget {
  final DateTime selectedDay;
  final List<CalendarEvent> events;

  EventList({required this.selectedDay, required this.events});

  @override
  Widget build(BuildContext context) {
    //print('Events for selected day: ${events.length}');
    //print('EventList widget rebuilt for selected day: ${selectedDay.day}/${selectedDay.month}/${selectedDay.year}');
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Events on ${selectedDay.day}/${selectedDay.month}/${selectedDay.year}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          if (events.isNotEmpty) ...events.map((event) => EventListItem(event)).toList(),
        ],
      ),
    );
  }
}

class EventListItem extends StatefulWidget {
  final CalendarEvent event;

  EventListItem(this.event);

  @override
  _EventListItemState createState() => _EventListItemState();
}

class _EventListItemState extends State<EventListItem> {
  bool _isExpanded = false;

  void _copyDescriptionToClipboard() {
    Clipboard.setData(ClipboardData(text: widget.event.description))
        .then((value) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Description copied to clipboard!'),
      duration: Duration(seconds: 2),
    )));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isExpanded = !_isExpanded;
        });
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 2.0),
        padding: EdgeInsets.all(8),
        color: widget.event.eventType.color.withOpacity(0.99),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${widget.event.dateTime.hour.toString().padLeft(2,"0")}:${widget.event.dateTime.minute.toString().padLeft(2,"0")}',
                  style: TextStyle(color: Colors.white),
                ),
                Expanded(
                  child: Text(
                    widget.event.title,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
            if (_isExpanded)
              GestureDetector(
                onTap: _copyDescriptionToClipboard,
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  color: Colors.white,
                  child: Text(widget.event.description),
                ),
              ),
          ],
        ),
      ),
    );
  }
}