import 'dart:math';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:khoaluan/data/exercise_data.dart';
import 'package:khoaluan/models/exercise.dart';
import 'package:khoaluan/screens/camera.dart';
import 'package:khoaluan/models/bndbox.dart';
import 'package:khoaluan/services/practice_service.dart';
import 'package:tflite/tflite.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';

class InferencePage extends StatefulWidget {
  final List<CameraDescription> cameras;
  final List<Exercise> exercises;
  final int max;

  const InferencePage({this.cameras, this.exercises, this.max});

  @override
  _InferencePageState createState() => _InferencePageState();
}

class _InferencePageState extends State<InferencePage> {
  final _practiceService = PracticeService();
  final _flutterTts = FlutterTts();
  final _startTime = DateTime.now();

  Map<String, List<double>> _inputArr;
  List<dynamic> _recognitions;
  List<Exercise> _exercises;
  bool _midCount;
  bool _isCorrectPosture;
  double _lowerRange;
  double _upperRange;
  double _screenH;
  double _screenW;
  int _imageHeight;
  int _imageWidth;
  int _counter;
  int _previewH;
  int _previewW;
  int _ind;
  int _max;

  @override
  void initState() {
    loadModel();
    _inputArr = Map<String, List<double>>();
    _exercises = widget.exercises;
    _max = widget.max;
    _midCount = false;
    _isCorrectPosture = false;
    _screenH = Get.height;
    _screenW = Get.width;
    _imageHeight = 0;
    _imageWidth = 0;
    _counter = 0;
    _ind = 0;
    _flutterTts.speak("Your Workout Has Started");
    setRangeBasedOnModel();
    super.initState();
  }

  @override
  void dispose() {
    if (exercises.length > 1) {}
    if (exercises.length == 1) {
      _practiceService.addPractice(
        _exercises[0].id,
        _counter,
        _startTime,
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
        title: Text(_exercises[_ind].name),
      ),
      body: Stack(
        children: [
          Stack(
            children: <Widget>[
              Camera(
                cameras: widget.cameras,
                setRecognitions: _setRecognitions,
              ),
              _isCorrectPosture == false
                  ? Center(
                      child: Image(
                        image: AssetImage(_assetName()),
                        color: Colors.black.withOpacity(0.5),
                        colorBlendMode: BlendMode.dstIn,
                      ),
                    )
                  : Container(),
              Stack(children: _renderHelperBlobs()),
              Stack(children: _renderKeypoints()),
//               BndBox(
//                 results: _recognitions ?? [],
//                 _previewH: max(_imageHeight, _imageWidth),
//                 _previewW: min(_imageHeight, _imageWidth),
//                 _screenH: screen.height,
//                 _screenW: screen.width,
//                 exerciseid: _exerciseid,
//                 width: screen.width * 0.8,
//                 height: screen.height * 0.8,
//               ),
//               Column(
//                 mainAxisAlignment: MainAxisAlignment.end,
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: <Widget>[
//                   Align(
//                     alignment: Alignment.center,
// //            child: LinearPercentIndicator(
// //              animation: true,
// //              lineHeight: 20.0,
// //              animationDuration: 500,
// //              animateFromLastPercent: true,
// //              percent: _counter,
// //              center: Text("${(_counter).toStringAsFixed(1)}"),
// //              linearStrokeCap: LinearStrokeCap.roundAll,
// //              progressColor: Colors.green,
// //            ),
//                     child: Container(
//                       padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
//                       height: 100,
//                       width: 100,
//                       child: FittedBox(
//                         child: FloatingActionButton(
//                           backgroundColor: getCounterColor(),
//                           onPressed: () {},
//                           child: Text(
//                             '$_counter',
//                             style: TextStyle(
//                                 fontWeight: FontWeight.bold,
//                                 color: Colors.white),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
            ],
          ),
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
            _max == null ? '$_counter' : '$_counter / $_max',
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
    String name = (_exercises[_ind].id == 3)
        ? 'lie_pose'
        : ((_exercises[_ind].id == 1) ? 'push_up_pose' : 'stand_pose');

    return 'assets/poses/$name.png';
  }

  void incrementCounter() {
    setState(() {
      _counter++;
      if (_max != null &&
          _max >= 0 &&
          _counter >= _max &&
          _ind < _exercises.length) {
        _ind++;
      }
    });

    _flutterTts.speak(_counter.toString());
  }

  void setMidCount(bool f) {
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
    if (_exercises[_ind].id != 3) {
      listToReturn.add(_createPositionedBlobs(5, 40, 0, _upperRange));
      listToReturn.add(_createPositionedBlobs(5, 40, 0, _lowerRange));
    } else {
      listToReturn.add(_createPositionedBlobs(40, 5, _upperRange, 0));
      listToReturn.add(_createPositionedBlobs(40, 5, _lowerRange, 0));
    }
    return listToReturn;
  }

  void setRangeBasedOnModel() {
    double h = _screenH * 0.8;
    double w = _screenW * 0.8;
    if (_exercises[_ind].id == 0) {
      _upperRange = h * 0.30; // pixel get on screen
      _lowerRange = h * 0.60;
    } else if (_exercises[_ind].id == 1) {
      _upperRange = h * 0.45;
      _lowerRange = h * 0.65;
    } else if (_exercises[_ind].id == 2) {
      _upperRange = h * 0.30;
      _lowerRange = h * 0.85;
    } else if (_exercises[_ind].id == 3) {
      _upperRange = w * 0.50;
      _lowerRange = w * 1.00;
    }
  }

  //region Core
  bool _postureAccordingToExercise(Map<String, List<double>> poses) {
    if (_exercises[_ind].id == 0) {
      return poses['leftShoulder'][1] < _upperRange &&
          poses['rightShoulder'][1] < _upperRange &&
          poses['leftHip'][1] < _lowerRange &&
          poses['rightHip'][1] < _lowerRange;
    }
    if (_exercises[_ind].id == 1) {
      return poses['leftShoulder'][1] > _upperRange &&
          poses['rightShoulder'][1] > _upperRange &&
          poses['leftShoulder'][1] < _lowerRange &&
          poses['rightShoulder'][1] < _lowerRange;
    }
    if (_exercises[_ind].id == 2) {
      return poses['leftShoulder'][1] < _upperRange &&
          poses['rightShoulder'][1] < _upperRange;
    }
    if (_exercises[_ind].id == 3) {
      return poses['rightShoulder'][0] > _upperRange &&
          poses['rightShoulder'][0] < _lowerRange;
    }
  }

  bool _midPostureExercise(Map<String, List<double>> poses) {
    if (_exercises[_ind].id == 0) {
      return poses['leftShoulder'][1] > _upperRange &&
          poses['rightShoulder'][1] > _upperRange;
    }
    if (_exercises[_ind].id == 1) {
      return poses['leftShoulder'][1] > _lowerRange &&
          poses['rightShoulder'][1] > _lowerRange;
    }
    if (_exercises[_ind].id == 2) {
      return poses['leftShoulder'][1] > _upperRange &&
          poses['rightShoulder'][1] > _upperRange &&
          (poses['leftKnee'][1] > _lowerRange ||
              poses['rightKnee'][1] > _lowerRange) &&
          (poses['leftKnee'][1] < _lowerRange ||
              poses['rightKnee'][1] < _lowerRange);
    }
    if (_exercises[_ind].id == 3) {
      return poses['rightShoulder'][0] < _upperRange;
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

  Future<void> _countingLogic(Map<String, List<double>> poses) async {
    if (poses != null) {
      //check posture before beginning count
      if (_isCorrectPosture && _midPostureExercise(poses)) {
        setMidCount(true);
      }
      if (_midCount && _postureAccordingToExercise(poses)) {
        incrementCounter();
        setMidCount(false);
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

  void loadModel() async {
    await Tflite.loadModel(
      model: 'assets/models/posenet_mv1_075_float_from_checkpoints.tflite',
      numThreads: 5, // defaults to 1
      isAsset: true,
      useGpuDelegate: true,
    );
  }
}
