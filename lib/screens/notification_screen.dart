import 'package:flutter/material.dart';
import 'package:khoaluan/constants/home/constants.dart';
import 'package:khoaluan/constants/home/style.dart';
import 'package:get/get.dart';
import 'package:flutter/cupertino.dart';
import 'package:khoaluan/utils/time_ago.dart';
import 'package:khoaluan/widgets/notification_view.dart';
import 'package:intl/intl.dart';

class NotificationScreen extends StatefulWidget {
  NotificationScreen({Key key}) : super(key: key);

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  DateTime before = new DateTime.now().subtract(Duration(hours: -1));
  DateFormat dateFormat = DateFormat("dd-MM-yyyy h:mma");
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: deepBlueColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => Get.back(),
                      child: Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(width: 5),
                    Text(
                      "Thông báo",
                      style: white25Bold,
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Lịch thông báo", style: white22Regular),
                    Container(
                      height: 40,
                      width: 60,
                      decoration: BoxDecoration(
                          color: kIndigoColor,
                          borderRadius: BorderRadius.circular(20)),
                      child: Center(
                          child: Text(
                        "Tạo",
                        style: white16Regular,
                      )),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                NotificationView(),
                SizedBox(height: 10),
                NotificationView(),
                SizedBox(height: 10),
                NotificationView(),
                SizedBox(height: 40),
                Text("Lịch sử thông báo", style: white22Regular),
                Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.0)),
                  width: double.infinity,
                  height: 70,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Icon(Icons.notifications),
                        Text(
                            TimeAgo.timeAgoSinceDate(dateFormat.format(before)),
                            style: TextStyle(fontSize: 16)),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
