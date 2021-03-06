import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:math' as math;

import 'package:khoaluan/constants/home/constants.dart';
import 'package:khoaluan/constants/home/picker_dart.dart';
import 'package:khoaluan/data/fitness.dart';
import 'package:khoaluan/models/user.dart';
import 'package:khoaluan/screens/test.dart';
import 'package:khoaluan/services/auth_service.dart';
import 'package:khoaluan/services/user_service.dart';
import 'package:khoaluan/widgets/custom_list_tile.dart';
import 'package:khoaluan/widgets/exercise_card.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:camera/camera.dart';
import 'package:firebase_database/firebase_database.dart';

class Home extends StatefulWidget {
  final List<CameraDescription> cameras;
  const Home({
    this.cameras,
  });

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  AuthService _auth = new AuthService();
  UserService user = new UserService();
  User _user = new User();
  String userId;

  Future<User> getUser() async {
    _user = await user.getUser(_auth);
    userId = _user.uid;
    return _user;
  }

  showPickerArray(BuildContext context) {
    new Picker(
        adapter: PickerDataAdapter<String>(
          pickerdata: new JsonDecoder().convert(pickerModeFitness),
          isArray: true,
        ),
        hideHeader: false,
        onConfirm: (Picker picker, List value) async {
          _user = await user.getUser(_auth);
          setState(() {
            if (value.toString() == "[0]") {
              user.updateUser(_user.uid, 'fitness_mode', 1);
            } else if (value.toString() == "[1]") {
              user.updateUser(_user.uid, 'fitness_mode', 2);
            } else {
              user.updateUser(_user.uid, 'fitness_mode', 3);
            }
          });
        }).showModal(context);
  }

  @override
  Widget build(BuildContext context) {
    double lol;
    return FutureBuilder(
        future: getUser(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: 10.0),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 18.0),
                      child: Row(
                        children: [
                          Container(
                            width: 50.0,
                            height: 50.0,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                image: AssetImage("assets/images/photo.jpeg"),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Spacer(),
                          GestureDetector(
                            onTap: () {
                              showPickerArray(context);
                            },
                            child: Row(
                              children: [
                                Text(
                                    _user.fitnessMode == 1
                                        ? "Get Fit"
                                        : _user.fitnessMode == 2
                                            ? "Workout"
                                            : "Gain Muscle",
                                    style: kTitleStyle),
                                Transform(
                                  alignment: Alignment.center,
                                  transform: Matrix4.rotationY(math.pi),
                                  child: SvgPicture.asset(
                                    "assets/images/muscle.svg",
                                    width: 35,
                                    color: _user.fitnessMode == 1
                                        ? kGreenColor
                                        : _user.fitnessMode == 2
                                            ? Colors.yellow
                                            : Colors.red,
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: 10.0),
                    Padding(
                      padding: const EdgeInsets.only(right: 5.0),
                      child: CustomListTile(
                        title: Text(_user.name, style: kTitleStyle),
                        subtitle: Text("You have new 12 notification",
                            style: kSubtitleStyle),
                        trailing: Image.asset(
                          "assets/images/notification.png",
                          width: 25.0,
                        ),
                      ),
                    ),
                    SizedBox(height: 10.0),
                    CustomListTile(
                      title: Text("Các bài tập cho bạn", style: kTitleStyle),
                      trailing: SvgPicture.asset(
                        "assets/images/fire.svg",
                        width: 35,
                      ),
                    ),
                    SizedBox(height: 10.0),
                    Container(
                      width: double.infinity,
                      height: 150.0,
                      margin: EdgeInsets.only(left: 18.0),
                      child: ListView.builder(
                        itemCount: fitnessData.length,
                        scrollDirection: Axis.horizontal,
                        physics: BouncingScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return ExerciseCard(
                              fitnessData: fitnessData[index],
                              cameras: widget.cameras);
                        },
                      ),
                    ),
                    SizedBox(height: 10.0),
                    Container(
                      width: double.infinity,
                      height: 410.0,
                      child: Stack(
                        children: [
                          Positioned(
                            top: 0.0,
                            left: 20.0,
                            right: 0.0,
                            bottom: 0.0,
                            child: Container(
                              decoration: BoxDecoration(
                                color: kGreenColor,
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(40.0)),
                              ),
                            ),
                          ),
                          Positioned(
                            left: 0.0,
                            top: 10.0,
                            right: 0.0,
                            bottom: 0.0,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                // horizontal: 20.0,
                                vertical: 25.0,
                              ),
                              decoration: BoxDecoration(
                                color: kIndigoColor,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(40.0),
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 25),
                                    child: Text("Cường độ tập luyện",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold)),
                                  ),
                                  SizedBox(height: 10.0),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 10),
                                        child: Container(
                                          height: 300,
                                          width: 200,
                                          child: Test(),
                                        ),
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text.rich(
                                            TextSpan(
                                              children: [
                                                TextSpan(
                                                  text: 'Top: ',
                                                  style: TextStyle(
                                                      fontSize: 20,
                                                      color: Colors.white),
                                                ),
                                                TextSpan(
                                                  text: 'Need more',
                                                  style: TextStyle(
                                                    fontSize: 20,
                                                    color: kGreenColor,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(height: 20.0),
                                          Text.rich(
                                            TextSpan(
                                              children: [
                                                TextSpan(
                                                  text: 'Middle: ',
                                                  style: TextStyle(
                                                      fontSize: 20,
                                                      color: Colors.white),
                                                ),
                                                TextSpan(
                                                  text: 'Good',
                                                  style: TextStyle(
                                                    fontSize: 20,
                                                    color: Colors.yellow,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(height: 20.0),
                                          Text.rich(
                                            TextSpan(
                                              children: [
                                                TextSpan(
                                                  text: 'Bottom: ',
                                                  style: TextStyle(
                                                      fontSize: 20,
                                                      color: Colors.white),
                                                ),
                                                TextSpan(
                                                  text: 'Need relax',
                                                  style: TextStyle(
                                                    fontSize: 20,
                                                    color: Colors.red,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
          return Center(child: CircularProgressIndicator());
        });
  }
}
