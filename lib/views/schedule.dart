import 'package:flutter/material.dart';
import 'package:khoaluan/constants/home/constants.dart';
import 'package:khoaluan/models/practice.dart';
import 'package:khoaluan/services/practice_service.dart';
import 'package:table_calendar/table_calendar.dart';

class Schedule extends StatefulWidget {
  @override
  _ScheduleState createState() => _ScheduleState();
}

class _ScheduleState extends State<Schedule> with TickerProviderStateMixin {
  Map<DateTime, List> _events;
  List<Practice> _selectedEvents;
  AnimationController _animationController;
  CalendarController _calendarController;
  PracticeService _practiceService = new PracticeService();

  @override
  void initState() {
    super.initState();
    final _selectedDay = DateTime.now();
    DateTime now = DateTime.now();
    _practiceService.getPracticeByDate(now).then((value) {
      _selectedEvents = value;
    });
    _calendarController = CalendarController();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _calendarController.dispose();
    super.dispose();
  }

  void _onVisibleDaysChanged(
      DateTime first, DateTime last, CalendarFormat format) {
    print('CALLBACK: _onVisibleDaysChanged');
  }

  void _onCalendarCreated(
      DateTime first, DateTime last, CalendarFormat format) {
    print('CALLBACK: _onCalendarCreated');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          color: deepBlueColor,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              // Switch out 2 lines below to play with TableCalendar's settings
              _buildTableCalendar(),
              const SizedBox(height: 8.0),
              Expanded(child: _buildEventList()),
            ],
          ),
        ),
      ),
    );
  }

  // Simple TableCalendar configuration (using Styles)
  Widget _buildTableCalendar() {
    return TableCalendar(
      calendarController: _calendarController,
      // events: _events,
      startingDayOfWeek: StartingDayOfWeek.monday,
      calendarStyle: CalendarStyle(
        weekdayStyle: TextStyle().copyWith(color: Colors.white, fontSize: 15.0),
        eventDayStyle:
            TextStyle().copyWith(color: Colors.white, fontSize: 15.0),
        weekendStyle: TextStyle().copyWith(color: kGreenColor, fontSize: 15.0),
        selectedColor: Colors.deepOrange[400],
        todayColor: Colors.deepOrange[200],
        markersColor: Colors.white,
        outsideDaysVisible: false,
      ),
      daysOfWeekStyle: DaysOfWeekStyle(
        weekdayStyle: TextStyle().copyWith(color: Colors.white, fontSize: 15.0),
        weekendStyle: TextStyle().copyWith(color: kGreenColor, fontSize: 15.0),
      ),
      headerStyle: HeaderStyle(
        leftChevronIcon: Icon(Icons.chevron_left, color: Colors.white),
        rightChevronIcon: Icon(Icons.chevron_right, color: Colors.white),
        titleTextStyle:
            TextStyle().copyWith(color: Colors.white, fontSize: 15.0),
        formatButtonTextStyle:
            TextStyle().copyWith(color: Colors.white, fontSize: 15.0),
        formatButtonDecoration: BoxDecoration(
          color: Colors.deepOrange[400],
          borderRadius: BorderRadius.circular(16.0),
        ),
      ),
      onDaySelected: (day, events, holidays) async {
        List<Practice> value = await _practiceService.getPracticeByDate(day);
        setState(() {
          _selectedEvents = value;
        });
      },
      onVisibleDaysChanged: _onVisibleDaysChanged,
      onCalendarCreated: _onCalendarCreated,
    );
  }

  Widget _buildEventList() {
    return _selectedEvents != null
        ? ListView(
            children: _selectedEvents
                .map(
                  (event) => Container(
                    decoration: BoxDecoration(
                        border: Border.all(width: 0.8),
                        borderRadius: BorderRadius.circular(12.0),
                        color: Colors.white),
                    margin: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 4.0),
                    child: ListTile(
                      title: Text(event.getExerciseName()),
                      onTap: () => print('$event tapped!'),
                    ),
                  ),
                )
                .toList(),
          )
        : Container();
  }
}
