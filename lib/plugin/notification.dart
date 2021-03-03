import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import '../main.dart';

class NotificationScreen extends StatefulWidget {
  NotificationScreen({Key key}) : super(key: key);

  @override
  _NotificationState createState() => _NotificationState();
}

class _NotificationState extends State<NotificationScreen> {
  @override
  void initState() {
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation("Asia/Ho_Chi_Minh"));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Column(
            children: [
              RaisedButton(
                onPressed: () async {
                  await _showNotification();
                },
                child: Text("push notification"),
              ),
              RaisedButton(
                onPressed: () async {
                  await _scheduleDailyTenAMNotification();
                },
                child: Text("push notification timezone"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _scheduleDailyTenAMNotification() async {
    await flutterLocalNotificationsPlugin.zonedSchedule(
        0,
        'scheduled title',
        'scheduled body',
        _nextInstanceOfDaily(0, 0),
        const NotificationDetails(
            android: AndroidNotificationDetails('your channel id',
                'your channel name', 'your channel description')),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time);
  }

  tz.TZDateTime _nextInstanceOfDaily(int hour, int minute) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);

    tz.TZDateTime scheduledDate =
        tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }

  Future<void> _showNotification() async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
            'your channel id', 'your channel name', 'your channel description',
            importance: Importance.max,
            priority: Priority.high,
            ticker: 'ticker');
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
        0, 'plain title', 'plain body', platformChannelSpecifics,
        payload: 'x');
  }
}
