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
  final _practiceService = PracticeService();
  final _dailyExerciseService = DailyExerciseService();
  final _flutterTts = FlutterTts();
  final _now = DateTime.now();

  Map<String, List<double>> _inputArr;
  List<dynamic> _recognitions;
  bool _midCount;
  bool _isCorrectPosture;
  double _screenH;
  double _screenW;
  int _imageHeight;
  int _imageWidth;
  int _previewH;
  int _previewW;
  int _count;
  DailyExercise _dailyExercise;

  Exercise get _exercise =>
      (_dailyExercise == null) ? widget.exercise : _dailyExercise.exercise;

  Color get _getCounterColor => (_isCorrectPosture) ? Colors.green : Colors.red;

  Color get _getImageColor =>
      (_isCorrectPosture) ? Colors.transparent : Colors.black.withOpacity(0.5);

  String get _countStr => (_dailyExercise == null)
      ? '$_count'
      : '${_dailyExercise.count} / ${_dailyExercise.max}';

  String get _assetName {
    String name;

    if (_exercise.id == 3)
      name = 'lie_pose';
    else if (_exercise.id == 1)
      name = 'push_up_pose';
    else
      name = 'stand_pose';

    return 'assets/poses/$name.png';
  }

  @override
  void initState() {
    _loadModel();
    _dailyExercise = widget.dailyExercise;
    _inputArr = Map<String, List<double>>();
    _midCount = false;
    _isCorrectPosture = false;
    _screenH = Get.height;
    _screenW = Get.width;
    _imageHeight = 0;
    _imageWidth = 0;
    _count = 0;
    if (_dailyExercise == null) {
      _flutterTts.speak("Your exercise has started");
    } else {
      _flutterTts.speak("Your daily exercise has started");
    }
    // _setRangeBasedOnModel();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<bool> onWillPop() {
    if (_dailyExercise == null) {
      _practiceService.addPractice(_exercise.id, _count, _now);
    } else {
      _dailyExerciseService.setDailyExercise(_dailyExercise);
      Get.back<DailyExercise>(result: _dailyExercise);
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
            title: Text(_exercise.name),
          ),
          body: Stack(
            children: <Widget>[
              Camera(
                cameras: widget.cameras,
                setRecognitions: _setRecognitions,
              ),
              Center(
                child: Image.asset(
                  _assetName,
                  color: _getImageColor,
                ),
              ),
              Stack(children: _renderHelperBlobs()),
              Stack(children: _renderKeypoints()),
            ],
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          floatingActionButton: Container(
            height: 100,
            width: 100,
            child: FloatingActionButton(
              backgroundColor: _getCounterColor,
              onPressed: () {},
              child: Text(
                _countStr,
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

  Positioned _createPositionedBlobs(double h, double w, double x, double y) {
    return Positioned(
      height: h,
      width: w,
      left: x,
      top: y,
      child: Container(color: _getCounterColor),
    );
  }

  List<Widget> _renderHelperBlobs() {
    List<Widget> listToReturn = <Widget>[];
    if (_exercise.id != 3) {
      listToReturn.add(_createPositionedBlobs(5, 40, 0, _exercise.upperRange));
      listToReturn.add(_createPositionedBlobs(5, 40, 0, _exercise.lowerRange));
    } else {
      listToReturn.add(_createPositionedBlobs(40, 5, _exercise.upperRange, 0));
      listToReturn.add(_createPositionedBlobs(40, 5, _exercise.lowerRange, 0));
    }
    return listToReturn;
  }

  List<Widget> _renderKeypoints() {
    var lists = <Widget>[];
    _recognitions?.forEach((re) {
      var list = re["keypoints"].values.map<Widget>((k) {
        var _x = k["x"];
        var _y = k["y"];
        var scaleW, scaleH, x, y;

        if (_screenH / _screenW > _previewH / _previewW) {
          scaleW = _screenH / _previewH * _previewW;
          scaleH = _screenH;
          var difW = (scaleW - _screenW) / scaleW;
          x = (_x - difW / 2) * scaleW;
          y = _y * scaleH;
        } else {
          scaleH = _screenW / _previewW * _previewH;
          scaleW = _screenW;
          var difH = (scaleH - _screenH) / scaleH;
          x = _x * scaleW;
          y = (_y - difH / 2) * scaleH;
        }

        _inputArr[k['part']] = [x, y];

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

      _countingLogic(_inputArr);

      _inputArr.clear();
      lists..addAll(list);
    });
    return lists;
  }

  void _loadModel() async {
    await Tflite.loadModel(
      model: 'assets/models/posenet_mv1_075_float_from_checkpoints.tflite',
      numThreads: 5, // defaults to 1
      isAsset: true,
      useGpuDelegate: true,
    );
  }

  void _setRecognitions(recognitions, imageHeight, imageWidth) {
    if (!mounted) {
      return;
    }
    setState(() {
      _recognitions = recognitions;
      _imageHeight = imageHeight;
      _imageWidth = imageWidth;
      _previewH = max(_imageHeight, _imageWidth);
      _previewW = min(_imageHeight, _imageWidth);
    });
  }

  void _increaseCount() {
    if (_dailyExercise == null) {
      setState(() {
        _count++;
      });
      _flutterTts.speak(_count.toString());
    } else {
      _dailyExercise.increaseCount(
        onCount: (value) {
          _flutterTts.speak(value.toString());
          setState(() {});
        },
        onMax: () {
          _flutterTts.speak("Change exercise");
          // _setRangeBasedOnModel();
          setState(() {});
        },
        onDone: () {
          _flutterTts.speak("Your daily exercise done");
          Get.back<DailyExercise>(result: _dailyExercise);
        },
      );
    }
  }

  void _setMidCount(bool f) {
    //when _midCount is activated
    if (f && !_midCount) {
      _flutterTts.speak("Perfect");
    }
    setState(() {
      _midCount = f;
    });
  }

  void _countingLogic(Map<String, List<double>> poses) {
    if (poses != null) {
      var posture = _exercise.posture(poses);
      var midPosture = _exercise.midPosture(poses);
      //check posture before beginning count
      if (_isCorrectPosture && midPosture) {
        _setMidCount(true);
      }
      if (_midCount && posture) {
        _increaseCount();
        _setMidCount(false);
      }
      //check the posture when not in _midCount
      if (!_midCount) {
        if (_isCorrectPosture != posture) {
          setState(() {
            _isCorrectPosture = posture;
          });
        }
        // _checkCorrectPosture(poses);
      }
    }
  }
}
