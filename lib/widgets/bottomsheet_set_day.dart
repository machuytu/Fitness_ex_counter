import 'package:flutter/material.dart';
import 'package:khoaluan/constants/home/constants.dart';
import 'package:khoaluan/models/daily.dart';

class BottomsheetSetDay extends StatefulWidget {
  final BuildContext context;
  BottomsheetSetDay({Key key, this.context}) : super(key: key);

  @override
  _BottomsheetNotificationState createState() =>
      _BottomsheetNotificationState();
}

class _BottomsheetNotificationState extends State<BottomsheetSetDay> {
  Daily daily = new Daily();
  bool isMonday = false,
      isTuesday = false,
      isWednesday = false,
      isThursday = false,
      isFriday = false,
      isSaturday = false,
      isSunday = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: deepBlueColor,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('Lặp lại', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(widget.context, daily);
            },
            child: Text("Lưu", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: Container(
        child: Column(
          children: [
            Container(
              height: 60,
              width: double.infinity,
              color: kIndigoColor,
              child: CheckboxListTile(
                activeColor: Colors.orange,
                title: Text(
                  "Thứ 2",
                  style: TextStyle(color: Colors.white),
                ),
                value: isMonday,
                onChanged: (value) {
                  setState(() {
                    isMonday = value;
                    daily.isMonday = value;
                  });
                },
              ),
            ),
            Container(
              height: 60,
              width: double.infinity,
              color: kIndigoColor,
              child: CheckboxListTile(
                activeColor: Colors.orange,
                title: Text(
                  "Thứ 3",
                  style: TextStyle(color: Colors.white),
                ),
                value: isTuesday,
                onChanged: (value) {
                  setState(() {
                    isTuesday = value;
                    daily.isTuesday = value;
                  });
                },
              ),
            ),
            Container(
              height: 60,
              width: double.infinity,
              color: kIndigoColor,
              child: CheckboxListTile(
                activeColor: Colors.orange,
                title: Text(
                  "Thứ 4",
                  style: TextStyle(color: Colors.white),
                ),
                value: isWednesday,
                onChanged: (value) {
                  setState(() {
                    isWednesday = value;
                    daily.isWednesday = value;
                  });
                },
              ),
            ),
            Container(
              height: 60,
              width: double.infinity,
              color: kIndigoColor,
              child: CheckboxListTile(
                activeColor: Colors.orange,
                title: Text(
                  "Thứ 5",
                  style: TextStyle(color: Colors.white),
                ),
                value: isThursday,
                onChanged: (value) {
                  setState(() {
                    isThursday = value;
                    daily.isThursday = value;
                  });
                },
              ),
            ),
            Container(
              height: 60,
              width: double.infinity,
              color: kIndigoColor,
              child: CheckboxListTile(
                activeColor: Colors.orange,
                title: Text(
                  "Thứ 6",
                  style: TextStyle(color: Colors.white),
                ),
                value: isFriday,
                onChanged: (value) {
                  setState(() {
                    isFriday = value;
                    daily.isFriday = value;
                  });
                },
              ),
            ),
            Container(
              height: 60,
              width: double.infinity,
              color: kIndigoColor,
              child: CheckboxListTile(
                activeColor: Colors.orange,
                title: Text(
                  "Thứ 7",
                  style: TextStyle(color: Colors.white),
                ),
                value: isSaturday,
                onChanged: (value) {
                  setState(() {
                    isSaturday = value;
                    daily.isSaturday = value;
                  });
                },
              ),
            ),
            Container(
              height: 60,
              width: double.infinity,
              color: kIndigoColor,
              child: CheckboxListTile(
                activeColor: Colors.orange,
                title: Text(
                  "Chủ nhật",
                  style: TextStyle(color: Colors.white),
                ),
                value: isSunday,
                onChanged: (value) {
                  setState(() {
                    isSunday = value;
                    daily.isSunday = value;
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
