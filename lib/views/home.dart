import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:math' as math;
import 'package:khoaluan/constants/home/constants.dart';
import 'package:khoaluan/constants/home/picker_dart.dart';
import 'package:khoaluan/data/exercise_data.dart';
import 'package:get/get.dart';
import 'package:khoaluan/main.dart';
import 'package:khoaluan/models/daily_exercise.dart';
import 'package:khoaluan/models/user.dart';
import 'package:khoaluan/screens/body_part_widget.dart';
import 'package:khoaluan/services/auth_service.dart';
import 'package:khoaluan/services/daily_exercise_service.dart';
import 'package:khoaluan/services/image_service.dart';
import 'package:khoaluan/services/practice_service.dart';
import 'package:khoaluan/services/user_service.dart';
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
  final authService = AuthService();
  final userService = UserService();
  final practiceService = PracticeService();
  final dailyExerciseService = DailyExerciseService();
  final imageService = ImageService();
  final now = DateTime.now();
  List<double> listMainPart = [];
  User user = User();
  DailyExercise dailyExercise = DailyExercise();

  showPickerArray(BuildContext context) {
    new Picker(
        adapter: PickerDataAdapter<String>(
          pickerdata: new JsonDecoder().convert(pickerModeFitness),
          isArray: true,
        ),
        hideHeader: false,
        onConfirm: (Picker picker, List<int> value) {
          setState(() {
            userService.updateUser('fitnessMode', value[0] + 1);
          });
        }).showModal(context);
  }

  Future<User> getUser() async {
    user = await userService.getUser();
    Weight.weight = user.weight;
    await getDailyExercise(weight: user?.weight, bmr: user?.bmr);
    return user;
  }

  Future<void> getDailyExercise({
    @required int weight,
    @required int bmr,
  }) async {
    // // for test
    dailyExercise = (await dailyExerciseService.getDailyExerciseByDate(now)) ?? DailyExercise();

    // for release
    // dailyExercise = (await dailyExerciseService.getDailyExerciseByDate(now)) ??
    //     DailyExercise(weight: weight, bmr:  bmr);

    print(dailyExercise);
  }

  String get getDailyExerciseImg => (dailyExercise.isDone) ? 'assets/images/DailyExercise_done.png' : 'assets/images/DailyExercise.png';

  String get getfitnessStr {
    if (user.fitnessMode == 1) {
      return 'Get Fit';
    }
    if (user.fitnessMode == 2) {
      return 'Daily Exercise';
    }
    return 'Gain Muscle';
  }

  Color get getfitnessColor {
    if (user.fitnessMode == 1) {
      return kGreenColor;
    } else if (user.fitnessMode == 2) {
      return Colors.yellow;
    }
    return Colors.red;
  }

  Widget mainPartWidget(int mainPartIndex) {
    Color color;
    String text;
    String mainPartString;

    final mainPartValue = listMainPart[mainPartIndex];

    if (0 <= mainPartValue && mainPartValue <= 50) {
      text = 'Need more';
      color = kGreenColor;
    } else if (50 < mainPartValue && mainPartValue <= 200) {
      text = 'Good';
      color = Colors.yellow;
    } else if (mainPartValue > 200) {
      text = 'Need relax';
      color = Colors.red;
    }

    if (mainPartIndex == 0) {
      mainPartString = 'Top: ';
    } else if (mainPartIndex == 1) {
      mainPartString = 'Middle: ';
    } else {
      mainPartString = 'Bottom: ';
    }

    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: mainPartString,
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
                              FutureBuilder(
                                  future: imageService.getImage(context, authService.getUser().uid),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState == ConnectionState.done) {
                                      return ClipOval(
                                        child: Image.network(
                                          snapshot.data,
                                          height: 50,
                                          width: 50,
                                          fit: BoxFit.cover,
                                        ),
                                      );
                                    }

                                    // if (snapshot.connectionState ==
                                    //     ConnectionState.waiting)
                                    //   return Center(
                                    //       child: CircularProgressIndicator());
                                    return Center(child: CircularProgressIndicator());
                                  }),
                              Spacer(),
                              GestureDetector(
                                onTap: () {
                                  showPickerArray(context);
                                },
                                child: Row(
                                  children: [
                                    Text(getfitnessStr, style: kTitleStyle),
                                    Transform(
                                      alignment: Alignment.center,
                                      transform: Matrix4.rotationY(math.pi),
                                      child: SvgPicture.asset(
                                        "assets/images/muscle.svg",
                                        width: 35,
                                        color: getfitnessColor,
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
                          child: Text(user.name, style: kTitleStyle),
                        ),
                        const SizedBox(height: 10.0),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15.0),
                            child: InkWell(
                              onTap: () {
                                if (!dailyExercise.isDone) {
                                  dailyExercise.start = DateTime.now();
                                  Get.to<DailyExercise>(InferencePage(
                                    widget.cameras,
                                    dailyExercise: dailyExercise,
                                  )).then((value) {
                                    print('inference value $value');
                                    setState(() {
                                      dailyExercise = value;
                                    });
                                  }).catchError((err) {
                                    print('inference err $err');
                                  });
                                }
                              },
                              child: Image(fit: BoxFit.cover, image: AssetImage(getDailyExerciseImg)),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10.0),
                        CustomListTile(
                          title: Text("Các bài tập cho bạn", style: kTitleStyle),
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
                              borderRadius: BorderRadius.only(topLeft: Radius.circular(40.0)),
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
                                  child: Text("Cường độ tập luyện", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                                ),
                                const SizedBox(height: 10.0),
                                Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: FutureBuilder(
                                    future: practiceService.getPracticeByDate(now),
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        listMainPart = practiceService.getBodyMainPartKcal(snapshot.data);
                                        return Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              height: 300,
                                              width: 200,
                                              child: BodyPartWidget(
                                                getBodyPartKcal: practiceService.getBodyPartKcal(snapshot.data),
                                              ),
                                            ),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
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
                                      return Center(child: CircularProgressIndicator());
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
}
