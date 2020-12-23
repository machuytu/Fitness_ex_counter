import 'package:flutter_tts/flutter_tts.dart';
import 'package:flutter/material.dart';
import 'package:khoaluan/data/fitness.dart';

class BndBox extends StatefulWidget {
  final List<dynamic> results;
  final int previewH;
  final int previewW;
  final double screenH;
  final double screenW;
  final String customModel;

  BndBox({
    this.results,
    this.previewH,
    this.previewW,
    this.screenH,
    this.screenW,
    this.customModel,
  });

  @override
  _BndBoxState createState() => _BndBoxState();
}

class _BndBoxState extends State<BndBox> {
  Map<String, List<double>> inputArr;
  int _counter;
  bool midCount, isCorrectPosture;
  double lowerRange, upperRange;
  FlutterTts flutterTts;

  @override
  void initState() {
    super.initState();
    inputArr = new Map();
    _counter = 0;
    midCount = false;
    isCorrectPosture = false;
    setRangeBasedOnModel();
    flutterTts = new FlutterTts();
    flutterTts.speak('Your ${widget.customModel} Has Started');
  }

  void setRangeBasedOnModel() {
    // Push Up
    if (widget.customModel == fitnessData[0]) {
      upperRange = 300;
      lowerRange = 500;
    }
    // Squat
    else if (widget.customModel == fitnessData[1]) {
      upperRange = 500;
      lowerRange = 700;
    }
  }

  void resetCounter() {
    setState(() {
      _counter = 0;
    });
    flutterTts.speak('Your Workout Has Been Reset, Try Again!');
  }

  List<Widget> _renderKeypoints() {
    var lists = <Widget>[];
    widget.results.forEach((element) {
      var list = element["keypoints"].value.map<Widget>((function) {
        var _x = function["x"];
        var _y = function["y"];
        var scaleW, scaleH, x, y;
        // change scale of screen
        if (widget.screenH / widget.screenW >
            widget.previewH / widget.previewW) {
          scaleW = widget.screenH / widget.previewH * widget.previewW;
          scaleH = widget.screenH;
          // get diffrent width
          var difw = (scaleW - widget.previewW) / scaleW;
          x = (_x - difw / 2) * scaleW;
          y = _y * scaleH;
        } else {
          scaleH = widget.screenW / widget.previewW * widget.previewH;
          scaleW = widget.screenW;
          // get diffent height
          var difh = (scaleH - widget.screenH) / scaleH;
          x = _x * scaleW;
          y = (_y - difh / 2) * scaleH;
        }

        // create part of body
        inputArr[function['part']] = [x, y];

        // Solve mirror problem on front camera
        if (x > 320) {
          var require = x - 320;
          x = 320 - require;
        } else {
          var require = 320 - x;
          x = 320 + require;
        }

        return Positioned(
          left: x - 275,
          top: y - 50,
          width: 100,
          height: 15,
          child: Container(
            child: Text(
              "●",
              style: TextStyle(
                color: Colors.blue,
                fontSize: 12.0,
              ),
            ),
          ),
        );
      }).toList();

      _countingLogic(inputArr);

      inputArr.clear();
      lists..addAll(list);
    });
    return lists;
  }

  Future<void> _countingLogic(Map<String, List<double>> poses) async {
    if (poses != null) {
      // check pose before begin count
      if (isCorrectPosture &&
          poses['leftShoulder'][1] > upperRange &&
          poses['rightShoulder'][1] > upperRange) {
        setMidCount(true);
      }

      if (midCount &&
          poses['leftShoulder'][1] < upperRange &&
          poses['rightShoulder'][1] < upperRange) {
        incrementCounter();
        setMidCount(false);
      }
      //check the posture when not in midcount
      if (!midCount) {
        _checkCorrectPosture(poses);
      }
    }
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

  // check count
  bool _postureAccordingToExercise(Map<String, List<double>> poses) {
    if (widget.customModel == fitnessData[1]) {
      return poses['leftShoulder'][1] < upperRange &&
          poses['rightShoulder'][1] < upperRange;
    } else {
      return poses['leftShoulder'][1] < upperRange &&
          poses['rightShoulder'][1] < upperRange &&
          poses['rightKnee'][1] > lowerRange &&
          poses['leftKnee'][1] > lowerRange;
    }
  }

  Color getCounterColor() {
    if (isCorrectPosture) {
      return Colors.green;
    } else {
      return Colors.red;
    }
  }

  List<Widget> _renderHelperBlobs() {
    List<Widget> listToReturn = <Widget>[];
    listToReturn.add(_createPositionedBlobs(0, upperRange));
    listToReturn.add(_createPositionedBlobs(0, lowerRange));
    return listToReturn;
  }

  Positioned _createPositionedBlobs(double x, double y) {
    return new Positioned(
      height: 5,
      width: 40,
      left: x,
      top: y,
      child: Container(
        color: getCounterColor(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Stack(
          children: _renderHelperBlobs(),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Align(
              alignment: Alignment.center,
              child: Padding(
                padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                child: Container(
                  height: 100,
                  width: 100,
                  child: FittedBox(
                    child: FloatingActionButton(
                      backgroundColor: getCounterColor(),
                      onPressed: resetCounter,
                      child: Text(
                        '${_counter.toString()}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
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
