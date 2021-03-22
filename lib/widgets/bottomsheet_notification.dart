import 'package:flutter/material.dart';
import 'package:khoaluan/constants/home/constants.dart';
import 'package:khoaluan/models/daily.dart';
import 'package:khoaluan/models/notification_model.dart';
import 'package:khoaluan/plugin/notification.dart';
import 'package:khoaluan/services/notification_service.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'bottomsheet_set_day.dart';
import 'bottomsheet_settitle.dart';
import 'package:intl/intl.dart';

class BottomsheetNotification extends StatefulWidget {
  BottomsheetNotification({Key key}) : super(key: key);

  @override
  _BottomsheetNotificationState createState() =>
      _BottomsheetNotificationState();
}

class _BottomsheetNotificationState extends State<BottomsheetNotification> {
  bool repeat = false;
  Daily daily = Daily();
  String title = "Báo thức";
  String message = "Báo thức";
  DateFormat dateFormat = DateFormat("dd-MM-yyyy");
  NotificationService notificationService = new NotificationService();

  int hour = DateTime.now().hour;
  int minute = DateTime.now().minute;
  NotificationPlugin notification = NotificationPlugin();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: deepBlueColor,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('Thêm Thông Báo', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () {
              notification.scheduleDailyNotification(
                  title, message, hour, minute, daily.getListDay());
              notificationService.addNotification(
                  title, message, hour, minute, daily.getListDay());
            },
            child: Text("Lưu", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: Container(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: GestureDetector(
                onTap: () {
                  DatePicker.showTimePicker(context, showTitleActions: true,
                      onConfirm: (date) {
                    setState(() {
                      hour = date.hour;
                      minute = date.minute;
                    });
                  }, currentTime: DateTime.now(), locale: LocaleType.vi);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Thời gian",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                    Container(
                      width: 60,
                      height: 30,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.orange),
                          color: Colors.transparent),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("$hour",
                              style: TextStyle(
                                  color: Colors.orange, fontSize: 20)),
                          Text(":",
                              style: TextStyle(
                                  color: Colors.orange, fontSize: 20)),
                          Text("$minute",
                              style: TextStyle(
                                  color: Colors.orange, fontSize: 20)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              height: 60,
              width: double.infinity,
              decoration: BoxDecoration(
                color: kIndigoColor,
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Các ngày",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    GestureDetector(
                      onTap: () {
                        showMaterialModalBottomSheet(
                          context: context,
                          builder: (context) =>
                              BottomsheetSetDay(context: context),
                        ).then((value) {
                          setState(() {
                            daily = value;
                          });
                        });
                      },
                      child: Text(
                        daily.getString(),
                        style: TextStyle(color: Colors.grey, fontSize: 20),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              height: 60,
              width: double.infinity,
              decoration: BoxDecoration(
                color: kIndigoColor,
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Nhãn",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    GestureDetector(
                      onTap: () {
                        showMaterialModalBottomSheet(
                          context: context,
                          builder: (context) =>
                              BottomsheetSetTitle(context: context),
                        ).then((value) {
                          if (value != null) {
                            setState(() {
                              title = value;
                            });
                          }
                        });
                      },
                      child: Text(
                        title,
                        style: TextStyle(color: Colors.grey, fontSize: 20),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              height: 60,
              width: double.infinity,
              decoration: BoxDecoration(
                color: kIndigoColor,
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Nội dung",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    GestureDetector(
                      onTap: () {
                        showMaterialModalBottomSheet(
                          context: context,
                          builder: (context) =>
                              BottomsheetSetTitle(context: context),
                        ).then((value) {
                          if (value != null) {
                            setState(() {
                              message = value;
                            });
                          }
                        });
                      },
                      child: Text(
                        title,
                        style: TextStyle(color: Colors.grey, fontSize: 20),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
