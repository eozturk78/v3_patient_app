import 'dart:math';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

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
}

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
    _events = _generateMockEvents();
  }

  Map<DateTime, List<CalendarEvent>> _generateMockEvents() {
    final eventType1 = EventType('Doctor Appointment', Colors.blue);
    final eventType2 = EventType('Online Meeting', Colors.green);
    final eventType3 = EventType('File Upload Logs', Colors.orange);

    final events = <DateTime, List<CalendarEvent>>{};
    final now = DateTime.now();
    final random = Random();

    for (int i = 0; i < 30; i++) {
      final date = DateTime(now.year, now.month, now.day + i); // Truncate time part
      events[date] = [
        CalendarEvent(
          'Event ${i + 1} - Type 1',
          'Description for Event ${i + 1}',
          date.add(Duration(hours: 8)),
          eventType1,
        ),
        CalendarEvent(
          'Event ${i + 1} - Type 2',
          'Description for Event ${i + 1}',
          date.add(Duration(hours: 12)),
          eventType2,
        ),
        CalendarEvent(
          'Event ${i + 1} - Type 3',
          'Description for Event ${i + 1}',
          date.add(Duration(hours: 16)),
          eventType3,
        ),
      ];
    }

    return events;
  }

  List<CalendarEvent> _getEventsForSelectedDay(DateTime selectedDay, Map<DateTime, List<CalendarEvent>> events) {
    final eventsForSelectedDay = events.entries
        .where((entry) => isSameDay(entry.key, selectedDay))
        .expand((entry) => entry.value)
        .toList();
    return eventsForSelectedDay;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Event Calendar'),
      ),
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
            eventLoader: (day) {
              return _events[day] ?? [];
            },
            onFormatChanged: (format) {
              setState(() {
                _calendarFormat = format;
              });
            },
            calendarFormat: _calendarFormat,
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

  List<EventType> _getEventTypes() {
    return [
      EventType('Doctor Appointment', Colors.blue),
      EventType('Online Meeting', Colors.green),
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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isExpanded = !_isExpanded;
        });
      },
      child: Container(
        padding: EdgeInsets.all(8),
        color: widget.event.eventType.color.withOpacity(0.2),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${widget.event.dateTime.hour}:${widget.event.dateTime.minute}',
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
              Container(
                padding: EdgeInsets.symmetric(vertical: 8),
                color: Colors.white,
                child: Text(widget.event.description),
              ),
          ],
        ),
      ),
    );
  }
}
