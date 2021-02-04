import 'package:flutter/material.dart';
import 'package:khoaluan/constants/home/constants.dart';
import 'package:khoaluan/services/auth_service.dart';

class Setting extends StatelessWidget {
  AuthService _auth = new AuthService();
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 10.0, left: 10.0),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(100.0),
                      child: Image.asset(
                        "assets/images/photo.jpeg",
                        width: 70.0,
                        height: 70.0,
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(width: 8.0),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("machuytu@gmail.com"),
                        SizedBox(height: 5.0),
                        Text("Mạc Huy Tú"),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                width: double.infinity,
                height: 1000.0,
                child: Stack(
                  children: [
                    Positioned(
                      top: 20.0,
                      left: 0.0,
                      right: 20.0,
                      bottom: 0.0,
                      child: Container(
                        decoration: BoxDecoration(
                          color: kGreenColor,
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(40.0)),
                        ),
                      ),
                    ),
                    ButtonTheme(
                      height: 50,
                      minWidth: 100,
                      child: RaisedButton(
                        onPressed: () {
                          _auth.logout();
                          Navigator.pushNamedAndRemoveUntil(context, "/login",
                              (Route<dynamic> route) => false);
                        },
                        child: Text("Đăng xuất"),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
