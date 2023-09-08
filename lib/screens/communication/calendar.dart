import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:flutter_svg/svg.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../apis/apis.dart';
import '../shared/shared.dart';

Apis apis = Apis();

class EventType {
  final String title;
  final Color color;
  final SvgPicture icon;

  EventType(this.title, this.color, this.icon);
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
      eventTypeMap[json['event_type']] ?? EventType('Default', Colors.grey, SvgPicture.asset("assets/images/info.svg", height: 40,)),
    );
  }
}

// Map event titles to their corresponding EventType
final Map<String, EventType> eventTypeMap = {
  'Sprechstunde vor Ort': EventType('Sprechstunde vor Ort', Colors.pink, SvgPicture.asset("assets/images/calendar_sprech_vor_ort.svg", height: 40,)),
  'Videosprechstunde': EventType('Videosprechstunde', Colors.lightBlueAccent, SvgPicture.asset("assets/images/calendar_video.svg", height: 40,)),
  'Dokumente': EventType('Dokumente', Colors.orange, SvgPicture.asset("assets/images/calendar_dokumente.svg", height: 40,)),
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
        _events.addAll(_convertToCalendarEvents(events));
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
          Padding(padding: EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
            child:
            Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    color: Colors.white),
                child:
                Column(
                  children: [
                    TableCalendar(
                      calendarStyle: CalendarStyle(
                        // Other style properties...
                        defaultTextStyle: TextStyle(
                            fontWeight: FontWeight.w600
                        ),
                      ),
                      firstDay: DateTime.now().subtract(Duration(days: 365)),
                      lastDay: DateTime.now().add(Duration(days: 365)),
                      locale: 'DE',
                      availableCalendarFormats: const {CalendarFormat.month : 'Monat',},
                      pageJumpingEnabled: true,
                      startingDayOfWeek: StartingDayOfWeek.monday,
                      focusedDay: _selectedDay,
                      rowHeight: 47,
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
                        todayBuilder: (context, date, _) {
                          return Container(
                            margin: const EdgeInsets.all(2.0),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Color.fromARGB(255, 162, 28, 52), // Filled indicator color for today
                              borderRadius: BorderRadius.circular(10.0), // Rounded corners
                            ),
                            child: Text(
                              date.day.toString(),
                              style: TextStyle(
                                color: Colors.white, // Text color
                                fontWeight: FontWeight.bold, // Optional: Add bold text style
                              ),
                            ),
                          );
                        },
                        selectedBuilder: (context, date, events) {
                          return Container(
                            margin: const EdgeInsets.all(3.0),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Color.fromARGB(255, 162, 28, 52), // Border color
                                width: 1.0, // Border width
                              ),
                              borderRadius: BorderRadius.circular(12.0), // Adjust border radius for rounded corners
                            ),
                            child: Text(
                              date.day.toString(),
                              style: TextStyle(
                                color: Colors.black, // Text color
                                fontWeight: FontWeight.w900, // Optional: Add bold text style
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Legend(_getEventTypes()),
                  ],
                )
            ),
          ),
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
        crossAxisAlignment: CrossAxisAlignment.end,
        children: eventMarkers
            .map((eventType) => _buildMarkerIndicator(eventType))
            .map((marker) => Transform.translate(
          offset: Offset(0, -8.6), // Move the event marker points higher
          child: marker,
        ))
            .toList(),
      );
    }
    return SizedBox.shrink();
  }


  Widget _buildMarkerIndicator(EventType eventType) {
    return Container(
      width: 5,
      height: 5,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: eventType.color,
      ),
    );
  }

  List<EventType> _getEventTypes() {
    return [
      EventType('Sprechstunde vor Ort', Colors.pink, SvgPicture.asset("assets/images/calendar_sprech_vor_ort.svg", height: 40,)),
      EventType('Videosprechstunde', Colors.lightBlueAccent, SvgPicture.asset("assets/images/calendar_video.svg", height: 40,)),
      EventType('Dokumente', Colors.orange, SvgPicture.asset("assets/images/calendar_dokumente.svg", height: 40,)),
    ];
  }
}

class Legend extends StatelessWidget {
  final List<EventType> eventTypes;

  Legend(this.eventTypes);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: eventTypes
            .map((eventType) => Row(
          children: [
            ClipOval(
              child: Container(
                width: 10,
                height: 10,
                color: eventType.color,
              ),
            ),
            SizedBox(width: 2),
            Text(eventType.title, style: TextStyle(fontSize: 11),
            ),SizedBox(width: 2),
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
              'Veranstaltungen am ${selectedDay.day.toString().padLeft(2,"0")}.${selectedDay.month.toString().padLeft(2,"0")}.${selectedDay.year}',
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
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10)
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 7,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        margin: EdgeInsets.only(top: 5, bottom: 12.0, right: 15, left: 15),
        padding: EdgeInsets.all(8),
        //color: widget.event.eventType.color.withOpacity(0.99),
        //color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                widget.event.eventType.icon,
                SizedBox(width: 10.0,),
                Expanded(child:
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.event.eventType.title, style: TextStyle(color: Colors.grey),
                    ),
                    Text(
                      widget.event.title,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '${widget.event.dateTime.hour.toString().padLeft(2,"0")}:${widget.event.dateTime.minute.toString().padLeft(2,"0") + " Uhr"}',
                      style: TextStyle(color: Colors.black),
                    ),
                  ],
                ),
                ),
              ],
            ),
            if (_isExpanded)
              GestureDetector(
                onTap: _copyDescriptionToClipboard,
                child: Container(
                  margin: EdgeInsets.only(top: 5.0),
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 5),
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