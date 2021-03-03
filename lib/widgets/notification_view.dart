import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class NotificationView extends StatefulWidget {
  final int hour;
  final int minute;
  NotificationView({this.hour, this.minute, key}) : super(key: key);

  @override
  _NotificationViewState createState() => _NotificationViewState();
}

class _NotificationViewState extends State<NotificationView> {
  bool _lights = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10.0)),
      width: double.infinity,
      height: 70,
      child: Padding(
        padding: const EdgeInsets.only(left: 8.0, right: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("10:00", style: TextStyle(fontSize: 30)),
            CupertinoSwitch(
              value: _lights,
              onChanged: (bool value) {
                setState(() {
                  _lights = value;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
