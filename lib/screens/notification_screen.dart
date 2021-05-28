import 'package:flutter/material.dart';
import 'package:khoaluan/constants/home/constants.dart';
import 'package:khoaluan/constants/home/style.dart';
import 'package:get/get.dart';
import 'package:flutter/cupertino.dart';
import 'package:khoaluan/models/notification_model.dart';
import 'package:khoaluan/services/notification_service.dart';
import 'package:khoaluan/utils/time_ago.dart';
import 'package:khoaluan/widgets/bottomsheet_notification.dart';
import 'package:khoaluan/widgets/notification_view.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class NotificationScreen extends StatefulWidget {
  NotificationScreen({Key key}) : super(key: key);

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  DateTime before = new DateTime.now().subtract(Duration(hours: -1));
  DateFormat dateFormat = DateFormat("dd-MM-yyyy h:mma");
  NotificationService notificationService = new NotificationService();
  NotificationView notificationView;

  Widget currentPage;
  void callback(Widget nextPage) {
    setState(() {
      this.currentPage = nextPage;
    });
  }

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
                    GestureDetector(
                      onTap: () {
                        showMaterialModalBottomSheet(
                          context: context,
                          builder: (context) => BottomsheetNotification(context: context),
                        ).then((value) {
                          print('return');
                          setState(() {});
                        });
                      },
                      child: Container(
                        height: 40,
                        width: 60,
                        decoration: BoxDecoration(color: kIndigoColor, borderRadius: BorderRadius.circular(20)),
                        child: Center(
                            child: Text(
                          "Tạo",
                          style: white16Regular,
                        )),
                      ),
                    ),
                  ],
                ),
                FutureBuilder(
                    future: notificationService.getNotification(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        List<NotificationModel> list = snapshot.data;
                        if (list != null) {
                          return ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: list.length,
                            itemBuilder: (context, index) {
                              return NotificationView(
                                notification: list[index],
                                callback: this.callback,
                              );
                            },
                          );
                        } else {
                          return Container();
                        }
                      }
                      return CircularProgressIndicator();
                    }),
                SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
