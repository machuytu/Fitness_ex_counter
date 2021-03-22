import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:khoaluan/constants/home/constants.dart';
import 'package:khoaluan/data/exercise_data.dart';

import 'inference.dart';

class ExerciseCard extends StatelessWidget {
  final int exerciseid;
  final List<CameraDescription> cameras;
  ExerciseCard({
    this.exerciseid,
    this.cameras,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Get.to(
        InferencePage(
          cameras: cameras,
          exerciseid: exerciseid,
        ),
      ),
      child: Container(
        width: 140.0,
        margin: EdgeInsets.only(right: 18.0),
        padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 15.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          image: DecorationImage(
            image: AssetImage(
                'assets/images/${exercises[exerciseid].name.replaceAll(' ', '_')}.jpg'),
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
              exercises[exerciseid].name.toUpperCase(),
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
}
