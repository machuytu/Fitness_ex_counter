import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:khoaluan/models/notification_model.dart';
import 'package:khoaluan/services/notification_service.dart';
import 'package:khoaluan/plugin/notification.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

// ignore: must_be_immutable
class NotificationView extends StatefulWidget {
  final int hour;
  final int minute;
  final bool lights;
  final NotificationModel notification;
  NotificationView(
      {this.lights, this.hour, this.minute, key, this.notification})
      : super(key: key);

  @override
  _NotificationViewState createState() => _NotificationViewState();
}

class _NotificationViewState extends State<NotificationView> {
  NotificationService notificationService = new NotificationService();
  NotificationPlugin notificationPlugin = new NotificationPlugin();
  @override
  Widget build(BuildContext context) {
    bool lights = widget.notification.isOn;
    return Column(
      children: [
        SizedBox(height: 10),
        Slidable(
          actionPane: SlidableDrawerActionPane(),
          actionExtentRatio: 0.25,
          secondaryActions: [
            IconSlideAction(
              caption: 'Delete',
              color: Colors.red,
              icon: Icons.delete,
              onTap: () {},
            ),
          ],
          child: Container(
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(10.0)),
            width: double.infinity,
            height: 70,
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                      "${widget.notification.hour}:${widget.notification.minute}",
                      style: TextStyle(fontSize: 30)),
                  CupertinoSwitch(
                    value: lights,
                    onChanged: (bool value) {
                      setState(() {
                        print(value);
                        lights = value;
                        widget.notification.isOn = value;
                        if (value == true) {
                          notificationService.updateNotification(
                            widget.notification.id,
                            widget.notification.idNotification,
                            widget.notification.title,
                            widget.notification.message,
                            widget.notification.hour,
                            widget.notification.minute,
                            widget.notification.listDaily,
                            true,
                          );
                          notificationPlugin.updateScheduleDailyNotification(
                            widget.notification.idNotification,
                            widget.notification.title,
                            widget.notification.message,
                            widget.notification.hour,
                            widget.notification.minute,
                            widget.notification.listDaily,
                          );
                        } else {
                          notificationService.updateNotification(
                            widget.notification.id,
                            widget.notification.idNotification,
                            widget.notification.title,
                            widget.notification.message,
                            widget.notification.hour,
                            widget.notification.minute,
                            widget.notification.listDaily,
                            false,
                          );
                          notificationPlugin.deleteScheduleDailyNotification(
                              widget.notification.idNotification);
                        }
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
