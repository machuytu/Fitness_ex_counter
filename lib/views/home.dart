import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:math' as math;
import 'package:khoaluan/constants/home/constants.dart';
import 'package:khoaluan/constants/home/picker_dart.dart';
import 'package:khoaluan/data/exercise_data.dart';
import 'package:get/get.dart';
import 'package:khoaluan/main.dart';
import 'package:khoaluan/models/user.dart';
import 'package:khoaluan/models/daily_exercise.dart';
import 'package:khoaluan/screens/body_part_widget.dart';
import 'package:khoaluan/services/practice_service.dart';
import 'package:khoaluan/services/user_service.dart';
import 'package:khoaluan/services/daily_exercise_service.dart';
import 'package:khoaluan/widgets/custom_list_tile.dart';
import 'package:khoaluan/widgets/exercise_card.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:camera/camera.dart';
import 'package:khoaluan/widgets/inference.dart';

class Home extends StatefulWidget {
  final List<CameraDescription> cameras;
  const Home({this.cameras});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _userService = UserService();
  final _practiceService = PracticeService();
  final _dailyExerciseService = DailyExerciseService();
  final _now = DateTime.now();
  var _user = User();
  var _dailyExercise = DailyExercise();
  List<double> listMainPart = [];

  showPickerArray(BuildContext context) {
    new Picker(
        adapter: PickerDataAdapter<String>(
          pickerdata: new JsonDecoder().convert(pickerModeFitness),
          isArray: true,
        ),
        hideHeader: false,
        onConfirm: (Picker picker, List<int> value) {
          setState(() {
            _userService.updateUser('fitnessMode', value[0] + 1);
          });
        }).showModal(context);
  }

  Future<User> getUser() async {
    _user = await _userService.getUser();
    return _user;
  }

  Future<void> getDailyExercise(
      {@required int weight, @required int bmr}) async {
    // // for test
    _dailyExercise =
        (await _dailyExerciseService.getDailyExerciseByDate(_now)) ??
            DailyExercise();

    // for release
    // _dailyExercise = (await _dailyExerciseService.getDailyExerciseByDate(_now)) ??
    //     DailyExercise(weight: weight, bmr:  bmr);

    print(_dailyExercise);
  }

  @override
  void initState() {
    getUser().then(
        (value) => getDailyExercise(weight: value?.weight, bmr: value?.bmr));
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
                        const SizedBox(height: 10.0),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 18.0),
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
                                                ? "DailyExercise"
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
                        const SizedBox(height: 10.0),
                        Padding(
                          padding: const EdgeInsets.only(left: 18.0),
                          child: Text(_user.name, style: kTitleStyle),
                        ),
                        const SizedBox(height: 10.0),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15.0),
                            child: InkWell(
                              onTap: () {
                                if (_dailyExercise.isDone) {
                                  _dailyExercise.start = DateTime.now();
                                  Get.to<DailyExercise>(InferencePage(
                                    cameras,
                                    dailyExercise: _dailyExercise,
                                  )).then((value) {
                                    print('inference value $value');
                                    setState(() {
                                      _dailyExercise = value;
                                    });
                                  }).catchError((err) {
                                    print('inference err $err');
                                  });
                                }
                              },
                              child: Image(
                                  fit: BoxFit.cover,
                                  image: AssetImage((_dailyExercise.isDone)
                                      ? "assets/images/DailyExercise_done.png"
                                      : "assets/images/DailyExercise.png")),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10.0),
                        CustomListTile(
                          title:
                              Text("Các bài tập cho bạn", style: kTitleStyle),
                          trailing: SvgPicture.asset(
                            "assets/images/fire.svg",
                            width: 35,
                          ),
                        ),
                        const SizedBox(height: 10.0),
                        Container(
                          width: double.infinity,
                          height: 145.0,
                          margin: const EdgeInsets.only(left: 18.0),
                          child: ListView.builder(
                            itemCount: exercises.length,
                            scrollDirection: Axis.horizontal,
                            physics: BouncingScrollPhysics(),
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return ExerciseCard(
                                exercise: exercises[index],
                                cameras: widget.cameras,
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 10.0),
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
                            padding: const EdgeInsets.symmetric(
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
                                const SizedBox(height: 10.0),
                                Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: FutureBuilder(
                                    future: _practiceService
                                        .getPracticeByDate(_now),
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
                                                  mainPartWidget(0),
                                                  const SizedBox(height: 20.0),
                                                  mainPartWidget(1),
                                                  const SizedBox(height: 20.0),
                                                  mainPartWidget(2),
                                                ],
                                              ),
                                            ),
                                          ],
                                        );
                                      }
                                      return Center(
                                          child: CircularProgressIndicator());
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

  Widget mainPartWidget(int mainPartIndex) {
    Color color;
    String text;

    final mainPartValue = listMainPart[mainPartIndex];

    if (0 <= mainPartValue && mainPartValue <= 50) {
      text = 'Need more';
      color = kGreenColor;
    } else if (50 < mainPartValue && mainPartValue <= 100) {
      text = 'Good';
      color = Colors.yellow;
    } else if (mainPartValue > 100) {
      text = 'Need relax';
      color = Colors.red;
    }

    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: (mainPartIndex == 0)
                ? 'Top: '
                : (mainPartIndex == 1)
                    ? 'Middle: '
                    : 'Bottom: ',
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
          TextSpan(
            text: text,
            style: TextStyle(
              fontSize: 20,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  // TextSpan textSpanWidget(int mainPartIndex) {
  //   final mainPartValue =
  //       listMainPart[mainPartIndex] + _dailyExercise.getMainPartKcal[mainPartIndex];
  //   if (0 < mainPartValue && mainPartValue <= 50) {
  //     return TextSpan(
  //       text: 'Good',
  //       style: TextStyle(
  //         fontSize: 20,
  //         color: Colors.yellow,
  //       ),
  //     );
  //   } else if (50 < mainPartValue && mainPartValue <= 100) {
  //     return TextSpan(
  //       text: 'Need relax',
  //       style: TextStyle(
  //         fontSize: 20,
  //         color: Colors.red,
  //       ),
  //     );
  //   } else {
  //     return TextSpan(
  //       text: 'Need more',
  //       style: TextStyle(
  //         fontSize: 20,
  //         color: kGreenColor,
  //       ),
  //     );
  //   }
  // }
}
