import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:khoaluan/services/practice_service.dart';

class BndBox extends StatefulWidget {
  final List<dynamic> results;
  final int previewH;
  final int previewW;
  final double screenH;
  final double screenW;
  final int exerciseid;
  final double width;
  final double height;

  BndBox({
    this.results,
    this.previewH,
    this.previewW,
    this.screenH,
    this.screenW,
    this.width,
    this.height,
    this.exerciseid,
  });

  @override
  _BndBoxState createState() => _BndBoxState();
}

class _BndBoxState extends State<BndBox> {
  Map<String, List<double>> inputArr;
  int _counter;
  FlutterTts flutterTts;
  double lowerRange, upperRange;
  bool midCount, isCorrectPosture;
  PracticeService _practiceService;
  DateTime _startTime;

  void setRangeBasedOnModel() {
    if (widget.exerciseid == 0) {
      upperRange = widget.height * 0.30; // pixel get on screen
      lowerRange = widget.height * 0.60;
    } else if (widget.exerciseid == 1) {
      upperRange = widget.height * 0.45;
      lowerRange = widget.height * 0.65;
    } else if (widget.exerciseid == 2) {
      upperRange = widget.height * 0.30;
      lowerRange = widget.height * 0.85;
    } else if (widget.exerciseid == 3) {
      upperRange = widget.width * 0.50;
      lowerRange = widget.width * 1.00;
    }
  }

  @override
  void initState() {
    _practiceService = PracticeService();
    _startTime = DateTime.now();
    inputArr = new Map();
    _counter = 0;
    midCount = false;
    isCorrectPosture = false;
    setRangeBasedOnModel();
    flutterTts = new FlutterTts();
    flutterTts.speak("Your Workout Has Started");
    super.initState();
  }

  @override
  void dispose() {
    _practiceService.addPractice(
      widget.exerciseid,
      _counter,
      _startTime,
    );
    super.dispose();
  }

  void incrementCounter() {
    setState(() {
      _counter++;
    });
    flutterTts.speak(_counter.toString());
  }

  void setMidCount(bool f) {
    //when midcount is activated
    if (f && !midCount) {
      flutterTts.speak("Perfect!");
    }
    setState(() {
      midCount = f;
    });
  }

  Color getCounterColor() {
    if (isCorrectPosture) {
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
    if (widget.exerciseid != 3) {
      listToReturn.add(_createPositionedBlobs(5, 40, 0, upperRange));
      listToReturn.add(_createPositionedBlobs(5, 40, 0, lowerRange));
    } else {
      listToReturn.add(_createPositionedBlobs(40, 5, upperRange, 0));
      listToReturn.add(_createPositionedBlobs(40, 5, lowerRange, 0));
    }
    return listToReturn;
  }

  //region Core
  bool _postureAccordingToExercise(Map<String, List<double>> poses) {
    if (widget.exerciseid == 0) {
      return poses['leftShoulder'][1] < upperRange &&
          poses['rightShoulder'][1] < upperRange &&
          poses['leftHip'][1] < lowerRange &&
          poses['rightHip'][1] < lowerRange;
    }
    if (widget.exerciseid == 1) {
      return poses['leftShoulder'][1] > upperRange &&
          poses['rightShoulder'][1] > upperRange &&
          poses['leftShoulder'][1] < lowerRange &&
          poses['rightShoulder'][1] < lowerRange;
    }
    if (widget.exerciseid == 2) {
      return poses['leftShoulder'][1] < upperRange &&
          poses['rightShoulder'][1] < upperRange;
    }
    if (widget.exerciseid == 3) {
      return poses['rightShoulder'][0] > upperRange &&
          poses['rightShoulder'][0] < lowerRange;
    }
  }

  bool _midPostureExercise(Map<String, List<double>> poses) {
    if (widget.exerciseid == 0) {
      return poses['leftShoulder'][1] > upperRange &&
          poses['rightShoulder'][1] > upperRange;
    }
    if (widget.exerciseid == 1) {
      return poses['leftShoulder'][1] > lowerRange &&
          poses['rightShoulder'][1] > lowerRange;
    }
    if (widget.exerciseid == 2) {
      return poses['leftShoulder'][1] > upperRange &&
          poses['rightShoulder'][1] > upperRange &&
          (poses['leftKnee'][1] > lowerRange ||
              poses['rightKnee'][1] > lowerRange) &&
          (poses['leftKnee'][1] < lowerRange ||
              poses['rightKnee'][1] < lowerRange);
    }
    if (widget.exerciseid == 3) {
      return poses['rightShoulder'][0] < upperRange;
    }
  }

  _checkCorrectPosture(Map<String, List<double>> poses) {
    if (_postureAccordingToExercise(poses)) {
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

  Future<void> _countingLogic(Map<String, List<double>> poses) async {
    if (poses != null) {
      //check posture before beginning count
      if (isCorrectPosture && _midPostureExercise(poses)) {
        setMidCount(true);
      }
      if (midCount && _postureAccordingToExercise(poses)) {
        incrementCounter();
        setMidCount(false);
      }
      //check the posture when not in midcount
      if (!midCount) {
        _checkCorrectPosture(poses);
      }
    }
  }
  //endregion

  @override
  Widget build(BuildContext context) {
    List<Widget> _renderKeypoints() {
      var lists = <Widget>[];
      widget.results.forEach((re) {
        var list = re["keypoints"].values.map<Widget>((k) {
          var _x = k["x"];
          var _y = k["y"];
          var scaleW, scaleH, x, y;

          if (widget.screenH / widget.screenW >
              widget.previewH / widget.previewW) {
            scaleW = widget.screenH / widget.previewH * widget.previewW;
            scaleH = widget.screenH;
            var difW = (scaleW - widget.screenW) / scaleW;
            x = (_x - difW / 2) * scaleW;
            y = _y * scaleH;
          } else {
            scaleH = widget.screenW / widget.previewW * widget.previewH;
            scaleW = widget.screenW;
            var difH = (scaleH - widget.screenH) / scaleH;
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
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color.fromRGBO(37, 213, 253, 1.0),
                ),
              ));
        }).toList();

        _countingLogic(inputArr);

        inputArr.clear();
        lists..addAll(list);
      });
      return lists;
    }

    return Stack(
      children: <Widget>[
        Stack(
          children: _renderHelperBlobs(),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Align(
              alignment: Alignment.center,
//            child: LinearPercentIndicator(
//              animation: true,
//              lineHeight: 20.0,
//              animationDuration: 500,
//              animateFromLastPercent: true,
//              percent: _counter,
//              center: Text("${(_counter).toStringAsFixed(1)}"),
//              linearStrokeCap: LinearStrokeCap.roundAll,
//              progressColor: Colors.green,
//            ),
              child: Container(
                padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                height: 100,
                width: 100,
                child: FittedBox(
                  child: FloatingActionButton(
                    backgroundColor: getCounterColor(),
                    onPressed: () {},
                    child: Text(
                      '${_counter.toString()}',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        Stack(
          children: _renderKeypoints(),
        ),
      ],
    );
  }
}
