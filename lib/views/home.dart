import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:math' as math;
import 'package:khoaluan/constants/home/constants.dart';
import 'package:khoaluan/constants/home/picker_dart.dart';
import 'package:khoaluan/data/exercise_data.dart';
import 'package:get/get.dart';
import 'package:khoaluan/main.dart';
import 'package:khoaluan/models/exercise.dart';
import 'package:khoaluan/models/user.dart';
import 'package:khoaluan/models/workout.dart';
import 'package:khoaluan/screens/body_part_widget.dart';
import 'package:khoaluan/services/auth_service.dart';
import 'package:khoaluan/services/practice_service.dart';
import 'package:khoaluan/services/user_service.dart';
import 'package:khoaluan/services/workout_service.dart';
import 'package:khoaluan/widgets/custom_list_tile.dart';
import 'package:khoaluan/widgets/exercise_card.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:camera/camera.dart';
import 'package:khoaluan/widgets/inference_workout.dart';

class Home extends StatefulWidget {
  final List<CameraDescription> cameras;
  const Home({this.cameras});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _authService = AuthService();
  final _userService = UserService();
  final _practiceService = PracticeService();
  final _workoutService = WorkoutService();
  final now = DateTime.now();
  List<double> listMainPart = [];
  User _user = new User();
  Workout _workout;

  List<int> getListMaxCount(int weight, int bmr, List<Exercise> exercises) {
    // var burnKcal = ((bmr / exercises.length) * (1 / 3));
    return exercises
        .map((e) =>
            ((bmr / exercises.length) * (1 / 3)) ~/ (e.coefficient * weight))
        .toList();
  }

  showPickerArray(BuildContext context) {
    new Picker(
        adapter: PickerDataAdapter<String>(
          pickerdata: new JsonDecoder().convert(pickerModeFitness),
          isArray: true,
        ),
        hideHeader: false,
        onConfirm: (Picker picker, List value) async {
          setState(() {
            if (value.toString() == "[0]") {
              _userService.updateUser(_user.uid, 'fitness_mode', 1);
            } else if (value.toString() == "[1]") {
              _userService.updateUser(_user.uid, 'fitness_mode', 2);
            } else {
              _userService.updateUser(_user.uid, 'fitness_mode', 3);
            }
          });
        }).showModal(context);
  }

  @override
  void initState() {
    getUser();
    getWorkout();
    super.initState();
  }

  Future<User> getUser() async {
    _user = await _userService.getUser(_authService);
    return _user;
  }

  void getWorkout() async {
    _workout = await _workoutService.getWorkoutByDate(now);
    setState(() {});
    print(_workout);
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
                            child: InkWell(
                              onTap: () async {
                                if (_workout == null) {
                                  Get.to(InferenceWorkoutPage(
                                          cameras,
                                          Workout(
                                              listExerciseId: [0, 1],
                                              listMax: [3, 3],
                                              start: DateTime.now())))
                                      .then((value) => getWorkout());
                                  getWorkout();
                                } else if (!_workout.isDone) {
                                  Get.to(InferenceWorkoutPage(
                                          cameras, _workout))
                                      .then((value) => getWorkout());
                                }
                              },
                              child: Image(
                                  fit: BoxFit.cover,
                                  image: AssetImage(_workout?.isDone == true
                                      ? "assets/images/Workout_done.png"
                                      : "assets/images/Workout.png")),
                            ),
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
