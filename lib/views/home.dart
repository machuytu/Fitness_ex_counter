import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:math' as math;

import 'package:khoaluan/constants/home/constants.dart';
import 'package:khoaluan/data/fitness.dart';
import 'package:khoaluan/widgets/custom_list_tile.dart';
import 'package:khoaluan/widgets/exercise_card.dart';
import 'package:camera/camera.dart';

class Home extends StatelessWidget {
  final List<CameraDescription> cameras;
  const Home({
    this.cameras,
  });
  @override
  Widget build(BuildContext context) {
    double lol;
    return Container(
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 40.0),
            SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 18.0),
                child: Row(
                  children: [
                    Container(
                      width: 50.0,
                      height: 50.0,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: AssetImage("assets/images/photo.jpeg"),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Spacer(),
                    Text("Gain Muscle", style: kTitleStyle),
                    Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.rotationY(math.pi),
                      child: SvgPicture.asset(
                        "assets/images/muscle.svg",
                        width: 35.0,
                        color: kGreenColor,
                      ),
                    )
                  ],
                ),
              ),
            ),
            SizedBox(height: 15.0),
            Padding(
              padding: const EdgeInsets.only(right: 5.0),
              child: CustomListTile(
                title: Text("Trần Quang Phúc", style: kTitleStyle),
                subtitle:
                    Text("You have new 12 notification", style: kSubtitleStyle),
                trailing: Image.asset(
                  "assets/images/notification.png",
                  width: 25.0,
                ),
              ),
            ),
            SizedBox(height: 25.0),
            CustomListTile(
              title: Text("Các bài tập cho bạn", style: kTitleStyle),
              trailing: SvgPicture.asset(
                "assets/images/fire.svg",
                width: 35.0,
              ),
            ),
            SizedBox(height: 20.0),
            Container(
              width: double.infinity,
              height: 180.0,
              margin: EdgeInsets.only(left: 18.0),
              child: ListView.builder(
                itemCount: fitnessData.length,
                scrollDirection: Axis.horizontal,
                physics: BouncingScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return ExerciseCard(
                      fitnessData: fitnessData[index], cameras: cameras);
                },
              ),
            ),
            SizedBox(height: 25.0),
            Container(
              width: double.infinity,
              height: 380.0,
              child: Stack(
                children: [
                  Positioned(
                    top: 0.0,
                    left: 20.0,
                    right: 0.0,
                    bottom: 0.0,
                    child: Container(
                      decoration: BoxDecoration(
                        color: kGreenColor,
                        borderRadius:
                            BorderRadius.only(topLeft: Radius.circular(40.0)),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 0.0,
                    top: 15.0,
                    right: 0.0,
                    bottom: 0.0,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        // horizontal: 20.0,
                        vertical: 25.0,
                      ),
                      decoration: BoxDecoration(
                        color: kIndigoColor,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(40.0),
                        ),
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 18.0),
                            child: Row(
                              children: [
                                Text("Weekly Progress", style: kTitle2Style),
                                Spacer(),
                                Text("10 Jun - 17 Jun", style: kSubtitle2Style),
                              ],
                            ),
                          ),
                          SizedBox(height: 25.0),
                          Container(
                            width: double.infinity,
                            padding:
                                const EdgeInsets.symmetric(horizontal: 18.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("80%", style: kProgressStyle),
                                SizedBox(width: 14.0),
                                VerticalDivider(
                                  color: kGreenColor,
                                  thickness: 5,
                                ),
                                SizedBox(width: 14.0),
                                Expanded(
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            "Last Exercise",
                                            style: kTitle2Style.copyWith(
                                                fontSize: 12.0),
                                          ),
                                          Spacer(),
                                          Icon(
                                            Icons.arrow_forward,
                                            color: kGreyColor,
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 5.0),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          SvgPicture.asset(
                                            "assets/images/shoulder.svg",
                                            width: 29.0,
                                            color: Color(0xFFC25BD6),
                                          ),
                                          SvgPicture.asset(
                                            "assets/images/chest.svg",
                                            width: 29.0,
                                            color: Color(0xFFFC902C),
                                          ),
                                          SvgPicture.asset(
                                            "assets/images/abdominal.svg",
                                            width: 29.0,
                                            color: Color(0xFF0295ED),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                          Slider(
                            value: 80,
                            onChanged: (val) => lol = val,
                            activeColor: Colors.green,
                            max: 100,
                            min: 0.0,
                            inactiveColor: Colors.white,
                          ),
                          SizedBox(height: 25.0),
                          Container(
                            width: double.infinity,
                            height: 50.0,
                            margin: EdgeInsets.symmetric(horizontal: 18.0),
                            child: RaisedButton(
                              onPressed: () {},
                              color: Color(0xFF070A29),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              child: Text(
                                "See all result",
                                style:
                                    kTitleStyle.copyWith(color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
