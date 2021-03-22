import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';

class Notification {
  int idNotification;
  Future<void> scheduleDailyNotification(String title, String message, int hour,
      int minute, List<int> listDaily) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getInt("idNotification") == null) {
      prefs.setInt("idNotification", 0);
      idNotification = 0;
    } else {
      idNotification = prefs.getInt("idNotification") + 1;
    }

    await flutterLocalNotificationsPlugin.zonedSchedule(
        idNotification,
        title,
        message,
        nextInstanceOfTime(hour: hour, minute: minute, listDaily: listDaily),
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

  tz.TZDateTime nextInstanceOfTime(
      {int hour, int minute, List<int> listDaily}) {
    tz.TZDateTime scheduledDate = _nextInstanceOfDaily(hour, minute);
    if (listDaily != null) {
      for (int i = 0; i < listDaily.length; i++) {
        while (scheduledDate.weekday != listDaily[i]) {
          scheduledDate = scheduledDate.add(const Duration(days: 1));
        }
      }
    }

    return scheduledDate;
  }
}
