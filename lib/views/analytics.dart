import 'package:flutter/material.dart';
import 'package:khoaluan/constants/home/constants.dart';
import 'package:khoaluan/models/practice.dart';
import 'package:khoaluan/models/user.dart';
import 'package:khoaluan/services/practice_service.dart';
import 'package:khoaluan/services/user_service.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:timeago/timeago.dart' as timeago;

class Analytics extends StatelessWidget {
  int kcalBurn = 74;
  PracticeService _practiceService = PracticeService();
  DateTime now = DateTime.now();
  UserService user = new UserService();

  @override
  Widget build(BuildContext context) {
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
                child: FutureBuilder(
                    future: _practiceService.getPracticeByDate(now),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        List<Practice> list = snapshot.data;
                        double totalKcal = _practiceService.getTotalKcal(list);

                        return FutureBuilder(
                            future: user.getUser(),
                            builder: (context, snapshotUser) {
                              if (snapshotUser.hasData) {
                                User user = snapshotUser.data;
                                return Container(
                                  color: kIndigoColor,
                                  child: CircularStepProgressIndicator(
                                    totalSteps: user.bmr,
                                    currentStep: totalKcal.toInt(),
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
                                              text: totalKcal.toString(),
                                              style: TextStyle(
                                                  fontSize: 25,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white)),
                                          TextSpan(
                                              text: ' Kcal',
                                              style: TextStyle(
                                                  fontSize: 25,
                                                  color: Colors.white)),
                                        ],
                                      ),
                                    )),
                                  ),
                                );
                              }
                              return CircularProgressIndicator();
                            });
                      }
                      return CircularProgressIndicator();
                    }),
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
              FutureBuilder(
                  future: _practiceService.getPracticeByUser(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      List<Practice> listPractice = snapshot.data;
                      var result =
                          _practiceService.getBodyPartKcal(listPractice);
                      print('Body Part Kcal: $result');
                      // print('SHOULDERS Kcal ${result[BodyPart.SHOULDERS]}');
                      listPractice.forEach((element) {
                        print(element);
                      });
                      return listPractice != null
                          ? ListView.builder(
                              shrinkWrap: true,
                              itemCount: listPractice.length < 4
                                  ? listPractice.length
                                  : 4,
                              physics: NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.only(
                                      right: 10.0, left: 10.0, bottom: 15.0),
                                  child: Container(
                                    height: 100,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(10.0)),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
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
                                            Text(
                                                listPractice[index]
                                                    .exercise
                                                    .name,
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    color: kIndigoColor,
                                                    fontWeight:
                                                        FontWeight.bold))
                                          ],
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              right: 10.0),
                                          child: Text(timeago.format(
                                              listPractice[index].end,
                                              locale: 'en')),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            )
                          : Container();
                    }
                    return Center(child: CircularProgressIndicator());
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
