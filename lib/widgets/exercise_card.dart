import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:khoaluan/constants/home/constants.dart';

import 'inference.dart';

class ExerciseCard extends StatelessWidget {
  final String fitnessData;
  final List<CameraDescription> cameras;
  ExerciseCard({
    this.fitnessData,
    this.cameras,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _onSelect(context, fitnessData),
      child: Container(
        width: 140.0,
        margin: EdgeInsets.only(right: 18.0),
        padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 15.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          image: DecorationImage(
            image: AssetImage("assets/images/" + fitnessData + ".jpg"),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Color(0xFF636477),
              BlendMode.color,
            ),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              replaceWord(fitnessData.toUpperCase()),
              style: kTitleStyle.copyWith(color: Colors.white),
            ),
            Divider(
              color: kGreenColor,
              thickness: 1,
            ),
          ],
        ),
      ),
    );
  }

  String replaceWord(String text) {
    final find = '_';
    final replaceWith = " ";
    final newString = text.replaceAll(find, replaceWith);
    return newString;
  }

  void _onSelect(BuildContext context, String customModelName) async {
    print(customModelName);
    Get.to(
      InferencePage(
        cameras: cameras,
        title: fitnessData,
        customModel: fitnessData,
      ),
    );
  }
}
