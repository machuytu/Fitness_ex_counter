import 'package:flutter/material.dart';
import 'package:khoaluan/constants/home/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:khoaluan/services/auth_service.dart';
import 'package:khoaluan/services/image_service.dart';

class Setting extends StatefulWidget {
  @override
  _SettingState createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  ImageService imageService = new ImageService();
  AuthService _auth = new AuthService();
  String imageUrl;
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
                padding: const EdgeInsets.only(right: 10.0, left: 10.0, top: 10.0),
                child: Row(
                  children: [
                    FutureBuilder(
                        future: imageService.getImage(context, _auth.getUser().uid),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.done) {
                            imageUrl = snapshot.data;
                            return ClipRRect(
                              borderRadius: BorderRadius.circular(100.0),
                              child: Image.network(
                                snapshot.data,
                                width: 70.0,
                                height: 70.0,
                                fit: BoxFit.cover,
                              ),
                            );
                          }

                          if (snapshot.connectionState == ConnectionState.waiting) return Center(child: CircularProgressIndicator());
                          return Center(child: CircularProgressIndicator());
                        }),
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
                height: size.height,
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
                          borderRadius: BorderRadius.only(topRight: Radius.circular(40.0)),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 40.0,
                      left: 0.0,
                      right: 30.0,
                      bottom: 0.0,
                      child: Container(
                        decoration: BoxDecoration(
                          color: kIndigoColor,
                          borderRadius: BorderRadius.only(topRight: Radius.circular(40.0)),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 50.0,
                      left: 5.0,
                      right: 40.0,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: GestureDetector(
                              onTap: () => Get.toNamed("/info_screen", arguments: imageUrl),
                              child: Container(
                                height: 50,
                                decoration: BoxDecoration(
                                  color: deepBlueColor,
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: Center(
                                  child: Text(
                                    "Thông tin cá nhân",
                                    style: TextStyle(color: kGreyColor, fontSize: 20),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: GestureDetector(
                              onTap: () => Get.toNamed("/notification"),
                              child: Container(
                                height: 50,
                                decoration: BoxDecoration(
                                  color: deepBlueColor,
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: Center(
                                  child: Text(
                                    "Thông báo",
                                    style: TextStyle(color: kGreyColor, fontSize: 20),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              AuthService _auth = new AuthService();
                              _auth.logout();
                              Navigator.pushNamedAndRemoveUntil(context, "/login", (Route<dynamic> route) => false);
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                height: 50,
                                decoration: BoxDecoration(
                                  color: deepBlueColor,
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: Center(
                                  child: Text(
                                    "Đăng xuất",
                                    style: TextStyle(color: kGreyColor, fontSize: 20),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
