import 'package:flutter/material.dart';
import 'package:khoaluan/constants/color.dart';
import 'package:khoaluan/constants/font.dart';
import 'package:khoaluan/constants/home/text.dart';
import 'package:khoaluan/models/excercise.dart';

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  PageController ctrl;
  int currentPage = 0;

  @override
  void initState() {
    ctrl = PageController(initialPage: currentPage, viewportFraction: 0.8);
    ctrl.addListener(() {
      int next = ctrl.page.round();

      if (currentPage != next) {
        setState(() {
          currentPage = next;
        });
      }
    });
    super.initState();
  }

  List<Exercise> exerciseList = [
    Exercise('hit up', Colors.red),
    Exercise('plank', Colors.green),
    Exercise('push up', Colors.blue),
    Exercise('algine', Colors.yellow),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        backgroundColor: ColorName.backgroundColor,
        body: Column(
          children: [
            // Top
            Flexible(
              flex: 4,
              child: Container(
                decoration: BoxDecoration(
                  color: ColorName.backgroundColor,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(36.0),
                    bottomRight: Radius.circular(36.0),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: SafeArea(
                        top: true,
                        bottom: true,
                        left: true,
                        right: true,
                        child: Container(
                          height: 40,
                          width: 40,
                          child: IconButton(
                            icon: Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                            ),
                            onPressed: () {},
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Body
            Flexible(
              flex: 6,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          HomeText.Popular_workout,
                          Container(
                            height: 30,
                            width: 70,
                            decoration: BoxDecoration(
                              color: Colors.grey[900],
                              borderRadius: BorderRadius.all(
                                Radius.circular(15),
                              ),
                            ),
                            child: Center(
                              child: HomeText.SeeAll,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Container(
                    height: 380,
                    child: PageView.builder(
                      controller: ctrl,
                      itemCount: exerciseList.length,
                      itemBuilder: (context, index) {
                        if (exerciseList.length >= index) {
                          bool active = index == currentPage;
                          return _buildStoryPage(
                              exerciseList[index], active, index);
                        }
                      },
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

  _buildStoryPage(Exercise exerciseList, bool active, int index) {
    final double blur = active ? 30 : 0;
    final double offset = active ? 20 : 0;
    final double top = active ? 10 : 30;

    return Transform.translate(
      offset: Offset(-40.0, 0.0),
      child: AnimatedContainer(
        duration: Duration(
          milliseconds: 500,
        ),
        curve: Curves.easeInOutQuint,
        margin: EdgeInsets.only(top: top, bottom: 50, right: 15, left: 15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: exerciseList.color,
          boxShadow: [
            BoxShadow(
              color: Colors.black87,
              blurRadius: blur,
              offset: Offset(offset, offset),
            ),
          ],
        ),
        child: Center(
          child: Text(exerciseList.title,
              style: TextStyle(
                fontSize: 40,
                color: Colors.white,
              )),
        ),
      ),
    );
  }
}
