import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:math' as math;

import 'package:khoaluan/constants/home/constants.dart';
import 'package:khoaluan/constants/home/picker_dart.dart';
import 'package:khoaluan/data/fitness.dart';
import 'package:khoaluan/models/user.dart';
import 'package:khoaluan/screens/body_part_widget.dart';
import 'package:khoaluan/services/auth_service.dart';
import 'package:khoaluan/services/practice_service.dart';
import 'package:khoaluan/services/user_service.dart';
import 'package:khoaluan/widgets/custom_list_tile.dart';
import 'package:khoaluan/widgets/exercise_card.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:camera/camera.dart';

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
  List<double> listMainPart = [];
  String userId;
  final PracticeService _practiceService = PracticeService();
  DateTime now = DateTime.now();

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
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getUser(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
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
                                    image:
                                        AssetImage("assets/images/photo.jpeg"),
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
                          padding: const EdgeInsets.only(left: 18.0),
                          child: Text(_user.name, style: kTitleStyle),
                        ),
                        SizedBox(height: 10.0),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15.0),
                            child: Image(
                                fit: BoxFit.cover,
                                image:
                                    AssetImage("assets/images/start_list.png")),
                          ),
                        ),
                        SizedBox(height: 10.0),
                        CustomListTile(
                          title:
                              Text("Các bài tập cho bạn", style: kTitleStyle),
                          trailing: SvgPicture.asset(
                            "assets/images/fire.svg",
                            width: 35,
                          ),
                        ),
                        SizedBox(height: 10.0),
                        Container(
                          width: double.infinity,
                          height: 145.0,
                          margin: EdgeInsets.only(left: 18.0),
                          child: ListView.builder(
                            itemCount: fitnessData.length,
                            scrollDirection: Axis.horizontal,
                            physics: BouncingScrollPhysics(),
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return ExerciseCard(
                                  exerciseid: index, cameras: widget.cameras);
                            },
                          ),
                        ),
                        SizedBox(height: 10.0),
                      ],
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 40.0),
                      child: Stack(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: kGreenColor,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(40.0)),
                            ),
                          ),
                          Container(
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
                                Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: FutureBuilder(
                                    future:
                                        _practiceService.getPracticeByDate(now),
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        listMainPart = _practiceService
                                            .getBodyMainPartKcal(snapshot.data);
                                        return Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              height: 300,
                                              width: 200,
                                              child: BodyPartWidget(
                                                getBodyPartKcal:
                                                    _practiceService
                                                        .getBodyPartKcal(
                                                            snapshot.data),
                                              ),
                                            ),
                                            Expanded(
                                              child: Column(
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
                                                              color:
                                                                  Colors.white),
                                                        ),
                                                        textSpanWidget(
                                                            listMainPart[0]),
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
                                                              color:
                                                                  Colors.white),
                                                        ),
                                                        textSpanWidget(
                                                            listMainPart[1]),
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
                                                              color:
                                                                  Colors.white),
                                                        ),
                                                        textSpanWidget(
                                                            listMainPart[2]),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        );
                                      }
                                      return CircularProgressIndicator();
                                    },
                                  ),
                                ),
                              ],
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
        return Center(child: CircularProgressIndicator());
      },
    );
  }

  TextSpan textSpanWidget(double mainPartValue) {
    if (0 < mainPartValue && mainPartValue <= 50) {
      return TextSpan(
        text: 'Good',
        style: TextStyle(
          fontSize: 20,
          color: Colors.yellow,
        ),
      );
    } else if (50 < mainPartValue && mainPartValue <= 100) {
      return TextSpan(
        text: 'Need relax',
        style: TextStyle(
          fontSize: 20,
          color: Colors.red,
        ),
      );
    } else {
      return TextSpan(
        text: 'Need more',
        style: TextStyle(
          fontSize: 20,
          color: kGreenColor,
        ),
      );
    }
  }
}
