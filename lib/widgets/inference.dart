import 'dart:math';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:khoaluan/models/exercise.dart';
import 'package:khoaluan/models/daily_exercise.dart';
import 'package:khoaluan/screens/camera.dart';
import 'package:khoaluan/services/practice_service.dart';
import 'package:khoaluan/services/daily_exercise_service.dart';
import 'package:tflite/tflite.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';

class InferencePage extends StatefulWidget {
  final List<CameraDescription> cameras;
  final DailyExercise dailyExercise;
  final Exercise exercise;

  const InferencePage(this.cameras, {this.dailyExercise, this.exercise});

  @override
  _InferencePageState createState() => _InferencePageState();
}

class _InferencePageState extends State<InferencePage> {
  final practiceService = PracticeService();
  final dailyExerciseService = DailyExerciseService();
  final flutterTts = FlutterTts();
  final now = DateTime.now();

  Map<String, List<double>> inputArr;
  List<dynamic> recognitions;
  bool midCount;
  bool isCorrectPosture;
  double screenH;
  double screenW;
  int imageHeight;
  int imageWidth;
  int previewH;
  int previewW;
  int count;
  DailyExercise dailyExercise;

  Exercise get exercise =>
      (dailyExercise == null) ? widget.exercise : dailyExercise.exercise;

  Color get getCounterColor => (isCorrectPosture) ? Colors.green : Colors.red;

  Color get getImageColor =>
      (isCorrectPosture) ? Colors.transparent : Colors.black.withOpacity(0.5);

  String get countStr => (dailyExercise == null)
      ? '$count'
      : '${dailyExercise.count} / ${dailyExercise.max}';

  String get assetName {
    String name;

    if (exercise.id == 3 || exercise.id == 4)
      name = 'lie_pose';
    else if (exercise.id == 1)
      name = 'push_up_pose';
    else
      name = 'stand_pose';

    return 'assets/poses/$name.png';
  }

  @override
  void initState() {
    loadModel();
    dailyExercise = widget.dailyExercise;
    inputArr = Map<String, List<double>>();
    midCount = false;
    isCorrectPosture = false;
    screenH = Get.height;
    screenW = Get.width;
    imageHeight = 0;
    imageWidth = 0;
    count = 0;
    if (dailyExercise == null) {
      flutterTts.speak("Your exercise has started");
    } else {
      flutterTts.speak("Your daily exercise has started");
    }
    // _setRangeBasedOnModel();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<bool> onWillPop() {
    if (dailyExercise == null) {
      practiceService.addPractice(exercise.id, count, now);
    } else {
      dailyExerciseService.setDailyExercise(dailyExercise);
      Get.back<DailyExercise>(result: dailyExercise);
    }
    return Future.value(true);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillPop,
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.black,
            centerTitle: true,
            title: Text(exercise.name),
          ),
          body: Stack(
            children: <Widget>[
              Camera(
                cameras: widget.cameras,
                setRecognitions: setRecognitions,
              ),
              Center(
                child: Image.asset(
                  assetName,
                  color: getImageColor,
                ),
              ),
              Stack(children: renderHelperBlobs()),
              Stack(children: renderKeypoints()),
            ],
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          floatingActionButton: Container(
            height: 100,
            width: 100,
            child: FloatingActionButton(
              backgroundColor: getCounterColor,
              onPressed: () {},
              child: Text(
                countStr,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 30,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Positioned createPositionedBlobs(double h, double w, double x, double y) {
    return Positioned(
      height: h,
      width: w,
      left: x,
      top: y,
      child: Container(color: getCounterColor),
    );
  }

  List<Widget> renderHelperBlobs() {
    List<Widget> listToReturn = <Widget>[];
    if (exercise.id != 3 && exercise.id != 4) {
      listToReturn.add(createPositionedBlobs(5, 40, 0, exercise.upperRange));
      listToReturn.add(createPositionedBlobs(5, 40, 0, exercise.lowerRange));
    } else {
      listToReturn.add(createPositionedBlobs(40, 5, exercise.upperRange, 0));
      listToReturn.add(createPositionedBlobs(40, 5, exercise.lowerRange, 0));
    }
    return listToReturn;
  }

  List<Widget> renderKeypoints() {
    var lists = <Widget>[];
    recognitions?.forEach((re) {
      var list = re["keypoints"].values.map<Widget>((k) {
        var _x = k["x"];
        var _y = k["y"];
        var scaleW, scaleH, x, y;

        if (screenH / screenW > previewH / previewW) {
          scaleW = screenH / previewH * previewW;
          scaleH = screenH;
          var difW = (scaleW - screenW) / scaleW;
          x = (_x - difW / 2) * scaleW;
          y = _y * scaleH;
        } else {
          scaleH = screenW / previewW * previewH;
          scaleW = screenW;
          var difH = (scaleH - screenH) / scaleH;
          x = _x * scaleW;
          y = (_y - difH / 2) * scaleH;
        }

        inputArr[k['part']] = [x, y];

        // To solve mirror problem on front camera
        if (x > 320) {
          var temp = x - 320;
          x = 320 - temp;
        } else {
          var temp = 320 - x;
          x = 320 + temp;
        }
        return Positioned(
            left: x - 250,
            top: y - 50,
            child: Container(
              width: 5,
              height: 5,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Color.fromRGBO(37, 213, 253, 1.0),
              ),
            ));
      }).toList();

      countingLogic(inputArr);

      inputArr.clear();
      lists..addAll(list);
    });
    return lists;
  }

  void loadModel() async {
    await Tflite.loadModel(
      model: 'assets/models/posenet_mv1_075_float_from_checkpoints.tflite',
      numThreads: 5, // defaults to 1
      isAsset: true,
      useGpuDelegate: true,
    );
  }

  void setRecognitions(
    List<dynamic> recognitions,
    int imageHeight,
    int imageWidth,
  ) {
    if (!mounted) {
      return;
    }
    setState(() {
      this.recognitions = recognitions;
      this.imageHeight = imageHeight;
      this.imageWidth = imageWidth;
      this.previewH = max(this.imageHeight, this.imageWidth);
      this.previewW = min(this.imageHeight, this.imageWidth);
    });
  }

  void increaseCount() {
    if (dailyExercise == null) {
      setState(() {
        count++;
      });
      flutterTts.speak(count.toString());
    } else {
      dailyExercise.increaseCount(
        onCount: (value) {
          flutterTts.speak(value.toString());
          setState(() {});
        },
        onMax: () {
          flutterTts.speak("Change exercise");
          // _setRangeBasedOnModel();
          setState(() {});
        },
        onDone: () {
          flutterTts.speak("Your daily exercise done");
          Get.back<DailyExercise>(result: dailyExercise);
        },
      );
    }
  }

  void setMidCount(bool f) {
    //when midCount is activated
    if (f && !midCount) {
      flutterTts.speak("Perfect");
    }
    setState(() {
      midCount = f;
    });
  }

  bool posture(Map<String, List<double>> poses) {
    var upper = exercise.upperRange;
    var lower = exercise.lowerRange;
    var result = false;

    if (exercise.id == 0) {
      result = poses['leftShoulder'][1] < upper &&
          poses['rightShoulder'][1] < upper &&
          poses['leftHip'][1] < lower &&
          poses['rightHip'][1] < lower;
    } else if (exercise.id == 1) {
      result = poses['leftShoulder'][1] > upper &&
          poses['rightShoulder'][1] > upper &&
          poses['leftShoulder'][1] < lower &&
          poses['rightShoulder'][1] < lower;
    } else if (exercise.id == 2) {
      result =
          poses['leftShoulder'][1] < upper && poses['rightShoulder'][1] < upper;
    } else if (exercise.id == 3) {
      result = poses['rightShoulder'][0] > upper &&
          poses['rightShoulder'][0] < lower;
    } else if (exercise.id == 4) {
      result = poses['rightShoulder'][0] > upper &&
          poses['rightShoulder'][0] < lower;
    }
    return result;
  }

  bool midPosture(Map<String, List<double>> poses) {
    var upper = exercise.upperRange;
    var lower = exercise.lowerRange;
    var result = false;

    if (exercise.id == 0) {
      result =
          poses['leftShoulder'][1] > upper && poses['rightShoulder'][1] > upper;
    } else if (exercise.id == 1) {
      result =
          poses['leftShoulder'][1] > lower && poses['rightShoulder'][1] > lower;
    } else if (exercise.id == 2) {
      result = poses['leftShoulder'][1] > upper &&
          poses['rightShoulder'][1] > upper &&
          (poses['leftKnee'][1] > lower || poses['rightKnee'][1] > lower) &&
          (poses['leftKnee'][1] < lower || poses['rightKnee'][1] < lower);
    } else if (exercise.id == 3) {
      result = poses['rightShoulder'][0] < upper;
    } else if (exercise.id == 4) {
      result = poses['rightHip'][0] > lower;
    }
    return result;
  }

  void checkCorrectPosture(Map<String, List<double>> poses) {
    if (posture(poses)) {
      if (!isCorrectPosture) {
        setState(() {
          isCorrectPosture = true;
        });
      }
    } else {
      if (isCorrectPosture) {
        setState(() {
          isCorrectPosture = false;
        });
      }
    }
  }

  void countingLogic(Map<String, List<double>> poses) {
    if (poses != null) {
      if (isCorrectPosture && midPosture(poses)) {
        setMidCount(true);
      }
      if (midCount && posture(poses)) {
        increaseCount();
        setMidCount(false);
      }
      //check the posture when not in midCount
      if (!midCount) {
        checkCorrectPosture(poses);
      }
    }
  }
}
