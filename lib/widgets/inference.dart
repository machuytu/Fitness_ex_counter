import 'dart:math';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:khoaluan/models/exercise.dart';
import 'package:khoaluan/models/workout.dart';
import 'package:khoaluan/screens/camera.dart';
import 'package:khoaluan/services/practice_service.dart';
import 'package:khoaluan/services/workout_service.dart';
import 'package:tflite/tflite.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';

class InferencePage extends StatefulWidget {
  final List<CameraDescription> cameras;
  final Workout workout;
  final Exercise exercise;

  const InferencePage(this.cameras, {this.workout, this.exercise});

  @override
  _InferencePageState createState() => _InferencePageState();
}

class _InferencePageState extends State<InferencePage> {
  final _practiceService = PracticeService();
  final _workoutService = WorkoutService();
  final _flutterTts = FlutterTts();
  final _now = DateTime.now();

  Map<String, List<double>> _inputArr;
  List<dynamic> _recognitions;
  bool _midCount;
  bool _isCorrectPosture;
  double _lowerRange;
  double _upperRange;
  double _screenH;
  double _screenW;
  int _imageHeight;
  int _imageWidth;
  int _previewH;
  int _previewW;
  int _count;
  Workout _workout;

  Exercise get _exercise =>
      (_workout == null) ? widget.exercise : _workout.exercise;

  Color get _getCounterColor => (_isCorrectPosture) ? Colors.green : Colors.red;

  Color get _getImageColor =>
      (_isCorrectPosture) ? Colors.transparent : Colors.black.withOpacity(0.5);

  String get _countStr =>
      (_workout == null) ? '$_count' : '${_workout.count} / ${_workout.max}';

  String get _assetName {
    String name;
    switch (_exercise.id) {
      case 3:
        name = 'lie_pose';
        break;
      case 1:
        name = 'push_up_pose';
        break;
      default:
        name = 'stand_pose';
        break;
    }
    return 'assets/poses/$name.png';
  }

  @override
  void initState() {
    _loadModel();
    _workout = widget.workout;
    _inputArr = Map<String, List<double>>();
    _midCount = false;
    _isCorrectPosture = false;
    _screenH = Get.height;
    _screenW = Get.width;
    _imageHeight = 0;
    _imageWidth = 0;
    _count = 0;
    _flutterTts.speak("Your Workout Has Started");
    _setRangeBasedOnModel();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_workout == null) {
          _practiceService.addPractice(_exercise.id, _count, _now);
        } else {
          _workoutService.setWorkout(_workout);
          Get.back<Workout>(result: _workout);
        }
        return true;
      },
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
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: Container(
          height: 85,
          width: 85,
          child: FloatingActionButton(
            backgroundColor: _getCounterColor,
            onPressed: () {},
            child: Text(
              _countStr,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 22,
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

  List<Widget> _renderHelperBlobs() {
    List<Widget> listToReturn = <Widget>[];
    if (_exercise.id != 3) {
      listToReturn.add(_createPositionedBlobs(5, 40, 0, _upperRange));
      listToReturn.add(_createPositionedBlobs(5, 40, 0, _lowerRange));
    } else {
      listToReturn.add(_createPositionedBlobs(40, 5, _upperRange, 0));
      listToReturn.add(_createPositionedBlobs(40, 5, _lowerRange, 0));
    }
    return listToReturn;
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
    setState(() {
      if (_workout == null) {
        _count++;
        _flutterTts.speak(_count.toString());
      } else {
        _workout.increaseCount(
          onCount: (value) {
            _flutterTts.speak(value.toString());
          },
          onMax: () {
            _flutterTts.speak("Change exercise!");
            _setRangeBasedOnModel();
          },
          onDone: () {
            _flutterTts.speak("Your workout done!");
            Get.back<Workout>(result: _workout);
          },
        );
      }
    });
  }

  void _setMidCount(bool f) {
    //when _midCount is activated
    if (f && !_midCount) {
      _flutterTts.speak("Perfect!");
    }
    setState(() {
      _midCount = f;
    });
  }

  void _setRangeBasedOnModel() {
    final h = _screenH * 0.8 - 5;
    final w = _screenW - 5;

    switch (_exercise.id) {
      case 0:
        _upperRange = h * 0.35;
        _lowerRange = h * 0.75;
        break;
      case 1:
        _upperRange = h * 0.45;
        _lowerRange = h * 0.65;
        break;
      case 2:
        _upperRange = h * 0.35;
        _lowerRange = h * 0.90;
        break;
      case 3:
        _upperRange = w * 0.30;
        _lowerRange = w * 0.70;
        break;
      default:
        break;
    }
  }

  //region Core
  bool _postureAccordingToExercise(Map<String, List<double>> poses) {
    switch (_exercise.id) {
      case 0:
        return poses['leftShoulder'][1] < _upperRange &&
            poses['rightShoulder'][1] < _upperRange &&
            poses['leftHip'][1] < _lowerRange &&
            poses['rightHip'][1] < _lowerRange;
        break;
      case 1:
        return poses['leftShoulder'][1] > _upperRange &&
            poses['rightShoulder'][1] > _upperRange &&
            poses['leftShoulder'][1] < _lowerRange &&
            poses['rightShoulder'][1] < _lowerRange;
        break;
      case 2:
        return poses['leftShoulder'][1] < _upperRange &&
            poses['rightShoulder'][1] < _upperRange;
        break;
      case 3:
        return poses['rightShoulder'][0] > _upperRange &&
            poses['rightShoulder'][0] < _lowerRange;
        break;
      default:
        return false;
        break;
    }
  }

  bool _midPostureExercise(Map<String, List<double>> poses) {
    switch (_exercise.id) {
      case 0:
        return poses['leftShoulder'][1] > _upperRange &&
            poses['rightShoulder'][1] > _upperRange;
        break;
      case 1:
        return poses['leftShoulder'][1] > _lowerRange &&
            poses['rightShoulder'][1] > _lowerRange;
        break;
      case 2:
        return poses['leftShoulder'][1] > _upperRange &&
            poses['rightShoulder'][1] > _upperRange &&
            (poses['leftKnee'][1] > _lowerRange ||
                poses['rightKnee'][1] > _lowerRange) &&
            (poses['leftKnee'][1] < _lowerRange ||
                poses['rightKnee'][1] < _lowerRange);
        break;
      case 3:
        return poses['rightShoulder'][0] < _upperRange;
        break;
      default:
        return false;
        break;
    }
  }

  void _checkCorrectPosture(Map<String, List<double>> poses) {
    if (_isCorrectPosture != _postureAccordingToExercise(poses)) {
      setState(() {
        _isCorrectPosture = _postureAccordingToExercise(poses);
      });
    }
    // if (_postureAccordingToExercise(poses)) {
    //   if (!_isCorrectPosture) {
    //     setState(() {
    //       _isCorrectPosture = true;
    //     });
    //   }
    // } else {
    //   if (_isCorrectPosture) {
    //     setState(() {
    //       _isCorrectPosture = false;
    //     });
    //   }
    // }
  }

  void _countingLogic(Map<String, List<double>> poses) {
    if (poses != null) {
      //check posture before beginning count
      if (_isCorrectPosture && _midPostureExercise(poses)) {
        _setMidCount(true);
      }
      if (_midCount && _postureAccordingToExercise(poses)) {
        _increaseCount();
        _setMidCount(false);
      }
      //check the posture when not in _midCount
      if (!_midCount) {
        _checkCorrectPosture(poses);
      }
    }
  }

  //endregion

}
