import 'dart:math';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:khoaluan/data/exercise_data.dart';
import 'package:khoaluan/screens/camera.dart';
import 'package:khoaluan/models/bndbox.dart';
import 'package:tflite/tflite.dart';

class InferencePage extends StatefulWidget {
  final List<CameraDescription> cameras;
  final int exerciseid;

  const InferencePage({this.cameras, this.exerciseid});

  @override
  _InferencePageState createState() => _InferencePageState();
}

class _InferencePageState extends State<InferencePage> {
  List<dynamic> _recognitions;
  int _imageHeight = 0;
  int _imageWidth = 0;

  @override
  void initState() {
    super.initState();
    var res = loadModel();
    print('Model Response: ' + res.toString());
  }

  @override
  Widget build(BuildContext context) {
    Size screen = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        title: Text(exercises[widget.exerciseid].name),
      ),
      body: Stack(
        children: [
          Stack(
            children: <Widget>[
              Camera(
                cameras: widget.cameras,
                setRecognitions: _setRecognitions,
              ),
              BndBox(
                results: _recognitions == null ? [] : _recognitions,
                previewH: max(_imageHeight, _imageWidth),
                previewW: min(_imageHeight, _imageWidth),
                screenH: screen.height,
                screenW: screen.width,
                exerciseid: widget.exerciseid,
                width: screen.width * 0.8,
                height: screen.height * 0.8,
              ),
              Center(
                child: Image(
                  image: AssetImage(_assetName()),
                  color: Colors.black.withOpacity(0.5),
                  colorBlendMode: BlendMode.dstIn,
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  String _assetName() {
    String name = (widget.exerciseid == 3)
        ? 'lie_pose'
        : ((widget.exerciseid == 1) ? 'push_up_pose' : 'stand_pose');

    return 'assets/poses/$name.png';
  }

  _setRecognitions(recognitions, imageHeight, imageWidth) {
    if (!mounted) {
      return;
    }
    setState(() {
      _recognitions = recognitions;
      _imageHeight = imageHeight;
      _imageWidth = imageWidth;
    });
  }

  loadModel() async {
    return await Tflite.loadModel(
      model: 'assets/models/posenet_mv1_075_float_from_checkpoints.tflite',
      numThreads: 5, // defaults to 1
      isAsset: true,
      useGpuDelegate: true,
    );
  }
}
