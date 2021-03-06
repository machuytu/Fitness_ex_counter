import 'package:flutter/material.dart';
import 'package:khoaluan/constants/home/constants.dart';
import 'package:khoaluan/services/practice_service.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Analytics extends StatelessWidget {
  final int kcalBurn = 74;
  final PracticeService _practiceService = PracticeService();

  void getListPractice() async {
    var result = await _practiceService.getPracticeByUser();
  }

  @override
  Widget build(BuildContext context) {
    getListPractice();
    return Scaffold(
      backgroundColor: kIndigoColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8.0, top: 8.0),
                child: Text(
                  "Analytic",
                  style: TextStyle(
                      color: kGreenColor,
                      fontSize: 30,
                      fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Row(
                  children: [
                    SvgPicture.asset(
                      "assets/images/fire.svg",
                      width: 35,
                    ),
                    SizedBox(
                      width: 10.0,
                    ),
                    Text(
                      "Burnning today:",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 15.0,
              ),
              Center(
                child: Container(
                  color: kIndigoColor,
                  child: CircularStepProgressIndicator(
                    totalSteps: 100,
                    currentStep: kcalBurn,
                    stepSize: 10,
                    selectedColor: Colors.greenAccent,
                    unselectedColor: Colors.grey[200],
                    padding: 0,
                    width: 250,
                    height: 250,
                    selectedStepSize: 15,
                    roundedCap: (_, __) => true,
                    child: Center(
                        child: RichText(
                      text: TextSpan(
                        children: <TextSpan>[
                          TextSpan(
                              text: kcalBurn.toString(),
                              style: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white)),
                          TextSpan(
                              text: ' Kcal',
                              style:
                                  TextStyle(fontSize: 25, color: Colors.white)),
                        ],
                      ),
                    )),
                  ),
                ),
              ),
              SizedBox(
                height: 15.0,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  "List excercise recently",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
              ),
              SizedBox(
                height: 15.0,
              ),
              Padding(
                padding: const EdgeInsets.only(right: 10.0, left: 10.0),
                child: Container(
                  height: 100,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.0)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          SizedBox(
                            width: 5.0,
                          ),
                          Container(
                            child: SvgPicture.asset(
                              "assets/images/shoulder.svg",
                              width: 50,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(
                            width: 20.0,
                          ),
                          Text("Push Up",
                              style: TextStyle(
                                  fontSize: 20,
                                  color: kIndigoColor,
                                  fontWeight: FontWeight.bold))
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 10.0),
                        child: Text("6 min ago"),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 15.0,
              ),
              Padding(
                padding: const EdgeInsets.only(right: 10.0, left: 10.0),
                child: Container(
                  height: 100,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.0)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          SizedBox(
                            width: 5.0,
                          ),
                          Container(
                            child: SvgPicture.asset(
                              "assets/images/shoulder.svg",
                              width: 50,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(
                            width: 20.0,
                          ),
                          Text("Push Up",
                              style: TextStyle(
                                  fontSize: 20,
                                  color: kIndigoColor,
                                  fontWeight: FontWeight.bold))
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 10.0),
                        child: Text("6 min ago"),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 15.0,
              ),
              Padding(
                padding: const EdgeInsets.only(right: 10.0, left: 10.0),
                child: Container(
                  height: 100,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.0)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          SizedBox(
                            width: 5.0,
                          ),
                          Container(
                            child: SvgPicture.asset(
                              "assets/images/shoulder.svg",
                              width: 50,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(
                            width: 20.0,
                          ),
                          Text("Push Up",
                              style: TextStyle(
                                  fontSize: 20,
                                  color: kIndigoColor,
                                  fontWeight: FontWeight.bold))
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 10.0),
                        child: Text("6 min ago"),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
