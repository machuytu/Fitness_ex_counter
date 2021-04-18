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

  Exercise get _exercise => _workout?.exercise ?? widget.exercise;
  Workout _workout;

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
    if (_workout != null) {
      _workoutService.setWorkout(_workout);
    } else {
      _practiceService.addPractice(
        _exercise.id,
        _count,
        _now,
      );
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            child: Image(
              image: AssetImage(_assetName()),
              color: Colors.black.withOpacity(_isCorrectPosture ? 0.0 : 0.5),
              colorBlendMode: BlendMode.dstIn,
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
          backgroundColor: getCounterColor(),
          onPressed: () {},
          child: Text(
            _workout != null
                ? '${_workout.count} / ${_workout.max}'
                : '$_count',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 22,
            ),
          ),
        ),
      ),
    );
  }

  String _assetName() {
    String name = (_exercise.id == 3)
        ? 'lie_pose'
        : ((_exercise.id == 1) ? 'push_up_pose' : 'stand_pose');

    return 'assets/poses/$name.png';
  }

  void _increaseCount() {
    if (_workout != null) {
      _workout.increaseCount(
        fnCount: (value) {
          _flutterTts.speak(value.toString());
          setState(() {});
        },
        fnMax: () {
          _flutterTts.speak("Change exercise!");
          _setRangeBasedOnModel();
          setState(() {});
        },
        fnDone: () {
          _flutterTts.speak("Your workout done!");
          Get.back();
        },
      );
    } else {
      setState(() {
        _count++;
      });
      _flutterTts.speak(_count.toString());
    }
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

  Color getCounterColor() {
    if (_isCorrectPosture) {
      return Colors.green;
    } else {
      return Colors.red;
    }
  }

  Positioned _createPositionedBlobs(double h, double w, double x, double y) {
    return Positioned(
      height: h,
      width: w,
      left: x,
      top: y,
      child: Container(
        color: getCounterColor(),
      ),
    );
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

  void _setRangeBasedOnModel() {
    double h = _screenH * 0.8;
    double w = _screenW * 0.8;
    if (_exercise.id == 0) {
      _upperRange = h * 0.30; // pixel get on screen
      _lowerRange = h * 0.60;
    } else if (_exercise.id == 1) {
      _upperRange = h * 0.45;
      _lowerRange = h * 0.65;
    } else if (_exercise.id == 2) {
      _upperRange = h * 0.30;
      _lowerRange = h * 0.85;
    } else if (_exercise.id == 3) {
      _upperRange = w * 0.50;
      _lowerRange = w * 1.00;
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
        return null;
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
        return null;
        break;
    }
  }

  void _checkCorrectPosture(Map<String, List<double>> poses) {
    if (_postureAccordingToExercise(poses)) {
      if (!_isCorrectPosture) {
        setState(() {
          _isCorrectPosture = true;
        });
      }
    } else {
      if (_isCorrectPosture) {
        setState(() {
          _isCorrectPosture = false;
        });
      }
    }
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
              width: 8,
              height: 8,
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

  void _loadModel() async {
    await Tflite.loadModel(
      model: 'assets/models/posenet_mv1_075_float_from_checkpoints.tflite',
      numThreads: 5, // defaults to 1
      isAsset: true,
      useGpuDelegate: true,
    );
  }
}
