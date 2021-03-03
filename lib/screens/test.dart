import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:khoaluan/constants/home/constants.dart';

class Test extends StatefulWidget {
  Test({Key key}) : super(key: key);

  @override
  _TestState createState() => _TestState();
}

class _TestState extends State<Test> {
  double ratio = 0.8;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Container(
      child: Stack(
        children: [
          Positioned.fill(
              left: 140 * ratio,
              top: 15 * ratio,
              child: Align(
                alignment: Alignment.topCenter,
                child: SvgPicture.asset(
                  "assets/check_pose/right_arm.svg",
                  height: 75 * ratio,
                  color: Colors.yellow,
                ),
              )),
          Positioned.fill(
              right: 140 * ratio,
              top: 15 * ratio,
              child: Align(
                alignment: Alignment.topCenter,
                child: SvgPicture.asset(
                  "assets/check_pose/left_arm.svg",
                  height: 75 * ratio,
                  color: Colors.yellow,
                ),
              )),
          Positioned.fill(
              right: 85 * ratio,
              top: 62.5 * ratio,
              child: Align(
                alignment: Alignment.topCenter,
                child: SvgPicture.asset(
                  "assets/check_pose/left_shoulder.svg",
                  height: 65 * ratio,
                  color: Colors.grey,
                ),
              )),
          Positioned.fill(
              left: 85 * ratio,
              top: 62.5 * ratio,
              child: Align(
                alignment: Alignment.topCenter,
                child: SvgPicture.asset(
                  "assets/check_pose/right_shoulder.svg",
                  height: 65 * ratio,
                  color: Colors.grey,
                ),
              )),
          Positioned.fill(
              top: 75 * ratio,
              child: Align(
                alignment: Alignment.topCenter,
                child: SvgPicture.asset(
                  "assets/check_pose/shoulder_line.svg",
                  height: 12 * ratio,
                  color: Colors.black,
                ),
              )),
          Positioned.fill(
              right: 5 * ratio,
              top: 45 * ratio,
              child: Align(
                alignment: Alignment.topCenter,
                child: SvgPicture.asset(
                  "assets/check_pose/neck.svg",
                  height: 30 * ratio,
                  color: Colors.grey,
                ),
              )),
          Positioned.fill(
              right: 5 * ratio,
              top: 62.5 * ratio,
              child: Align(
                alignment: Alignment.topCenter,
                child: SvgPicture.asset(
                  "assets/check_pose/shirt_neck.svg",
                  height: 12.5 * ratio,
                  color: kGreenColor,
                ),
              )),
          Positioned.fill(
              right: 5 * ratio,
              top: 62.5 * ratio,
              child: Align(
                alignment: Alignment.topCenter,
                child: SvgPicture.asset(
                  "assets/check_pose/chest.svg",
                  height: 65 * ratio,
                  color: Colors.grey,
                ),
              )),
          Positioned.fill(
              right: 5 * ratio,
              top: 65.5 * ratio,
              child: Align(
                alignment: Alignment.topCenter,
                child: SvgPicture.asset(
                  "assets/check_pose/shirt_arm.svg",
                  height: 49 * ratio,
                  color: kGreenColor,
                ),
              )),
          Positioned.fill(
              right: 5 * ratio,
              top: 76.5 * ratio,
              child: Align(
                alignment: Alignment.topCenter,
                child: SvgPicture.asset(
                  "assets/check_pose/chest_line.svg",
                  height: 51 * ratio,
                  color: Colors.black,
                ),
              )),
          Positioned.fill(
              right: 5 * ratio,
              top: 117.5 * ratio,
              child: Align(
                alignment: Alignment.topCenter,
                child: SvgPicture.asset(
                  "assets/check_pose/stomach.svg",
                  height: 50 * ratio,
                  color: Colors.grey,
                ),
              )),
          Positioned.fill(
              right: 5 * ratio,
              top: 117.5 * ratio,
              child: Align(
                alignment: Alignment.topCenter,
                child: SvgPicture.asset(
                  "assets/check_pose/stomach_line.svg",
                  height: 50 * ratio,
                  color: Colors.black,
                ),
              )),
          Positioned.fill(
              right: 36 * ratio,
              top: 165 * ratio,
              child: Align(
                alignment: Alignment.topCenter,
                child: SvgPicture.asset(
                  "assets/check_pose/left_femoral.svg",
                  height: 120 * ratio,
                  color: Colors.grey,
                ),
              )),
          Positioned.fill(
              left: 36 * ratio,
              top: 165 * ratio,
              child: Align(
                alignment: Alignment.topCenter,
                child: SvgPicture.asset(
                  "assets/check_pose/right_femoral.svg",
                  height: 120 * ratio,
                  color: Colors.grey,
                ),
              )),
          Positioned.fill(
              right: 5 * ratio,
              top: 165 * ratio,
              child: Align(
                alignment: Alignment.topCenter,
                child: SvgPicture.asset(
                  "assets/check_pose/butt.svg",
                  height: 50 * ratio,
                  color: Colors.red,
                ),
              )),
          Positioned.fill(
              right: 50 * ratio,
              top: 250 * ratio,
              child: Align(
                alignment: Alignment.topCenter,
                child: SvgPicture.asset(
                  "assets/check_pose/left_leg.svg",
                  height: 120 * ratio,
                  color: Colors.green,
                ),
              )),
          Positioned.fill(
              left: 50 * ratio,
              top: 250 * ratio,
              child: Align(
                alignment: Alignment.topCenter,
                child: SvgPicture.asset(
                  "assets/check_pose/right_leg.svg",
                  height: 120 * ratio,
                  color: Colors.green,
                ),
              )),
          Positioned.fill(
              child: Align(
            alignment: Alignment.topCenter,
            child: SvgPicture.asset(
              "assets/check_pose/head.svg",
              height: 60 * ratio,
              color: Colors.grey,
            ),
          )),
        ],
      ),
    ));
  }
}
