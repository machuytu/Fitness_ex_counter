import 'dart:math';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:khoaluan/screens/camera.dart';
import 'package:khoaluan/models/bndbox.dart';
import 'package:tflite/tflite.dart';

class InferencePage extends StatefulWidget {
  final List<CameraDescription> cameras;
  final String title;
  final String customModel;

  const InferencePage({this.cameras, this.title, this.customModel});

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
        title: Text(widget.title),
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
                customModel: widget.customModel,
              ),
              Center(
                child: Container(
                    width: screen.width * 0.8,
                    height: screen.height * 0.8,
                    decoration: new BoxDecoration(
                      image: new DecorationImage(
                        image: ExactAssetImage('assets/poses/base_pose.png'),
                        fit: BoxFit.fitHeight,
                        colorFilter: ColorFilter.mode(
                            Colors.black.withOpacity(0.5), BlendMode.dstIn),
                      ),
                    )),
              ),
            ],
          ),
        ],
      ),
    );
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
    );
  }
}
