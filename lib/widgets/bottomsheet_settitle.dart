import 'package:flutter/material.dart';
import 'package:khoaluan/constants/home/constants.dart';
import 'package:khoaluan/models/daily.dart';

class BottomsheetSetTitle extends StatefulWidget {
  final BuildContext context;
  BottomsheetSetTitle({Key key, this.context}) : super(key: key);

  @override
  _BottomsheetNotificationState createState() =>
      _BottomsheetNotificationState();
}

class _BottomsheetNotificationState extends State<BottomsheetSetTitle> {
  String title = "Báo thức";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: deepBlueColor,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('Nhãn', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(widget.context, title);
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
              child: TextFormField(
                onSaved: (newValue) {
                  Navigator.pop(widget.context, title);
                },
                onChanged: (value) {
                  title = value;
                },
                autofocus: true,
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
