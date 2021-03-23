import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

// ignore: must_be_immutable
class NotificationView extends StatefulWidget {
  final int hour;
  final int minute;
  final bool lights;
  NotificationView({this.lights, this.hour, this.minute, key})
      : super(key: key);

  @override
  _NotificationViewState createState() => _NotificationViewState();
}

class _NotificationViewState extends State<NotificationView> {
  @override
  Widget build(BuildContext context) {
    bool lights = widget.lights;
    return Column(
      children: [
        SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(10.0)),
          width: double.infinity,
          height: 70,
          child: Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("${widget.hour}:${widget.minute}",
                    style: TextStyle(fontSize: 30)),
                CupertinoSwitch(
                  value: lights,
                  onChanged: (bool value) {
                    setState(() {
                      lights = value;
                    });
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
