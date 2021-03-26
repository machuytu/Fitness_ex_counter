import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:khoaluan/constants/home/constants.dart';
import 'package:khoaluan/views/analytics.dart';
import 'package:khoaluan/views/home.dart';
import 'package:khoaluan/views/schedule.dart';
import 'package:khoaluan/views/settings.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BottomNav extends StatefulWidget {
  final List<CameraDescription> cameras;
  BottomNav({Key key, this.cameras}) : super(key: key);

  @override
  _BottomNavState createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  int _selectedIndex = 0;
  onTappedItem(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _viewList = [
      Home(
        cameras: widget.cameras,
      ),
      Analytics(),
      Schedule(),
      Setting(),
    ];
    return Container(
      child: Scaffold(
        body: Stack(
          children: [
            _viewList.elementAt(_selectedIndex),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: bottomNavigationBar,
            )
          ],
        ),
      ),
    );
  }

  Widget get bottomNavigationBar {
    return BottomNavigationBar(
      onTap: onTappedItem,
      currentIndex: _selectedIndex,
      backgroundColor: kIndigoColor,
      type: BottomNavigationBarType.fixed,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      // selectedItemColor: kGreenColor,
      iconSize: 25.0,
      items: [
        BottomNavigationBarItem(
          icon: SvgPicture.asset(
            "assets/images/gym.svg",
            width: 25,
            color: kGreyColor,
          ),
          activeIcon: SvgPicture.asset(
            "assets/images/gym.svg",
            width: 25,
            color: kGreenColor,
          ),
          label: "",
        ),
        BottomNavigationBarItem(
          icon: SvgPicture.asset(
            "assets/images/chart.svg",
            color: kGreyColor,
            width: 25,
          ),
          activeIcon: SvgPicture.asset(
            "assets/images/chart.svg",
            color: kGreenColor,
            width: 25,
          ),
          label: "",
        ),
        BottomNavigationBarItem(
          icon: SvgPicture.asset(
            "assets/images/calendar.svg",
            width: 25,
            color: kGreyColor,
          ),
          activeIcon: SvgPicture.asset(
            "assets/images/calendar.svg",
            width: 25,
            color: kGreenColor,
          ),
          label: "",
        ),
        BottomNavigationBarItem(
          icon: SvgPicture.asset(
            "assets/images/settings.svg",
            width: 25,
            color: kGreyColor,
          ),
          activeIcon: SvgPicture.asset(
            "assets/images/settings.svg",
            width: 25,
            color: kGreenColor,
          ),
          label: "",
        ),
      ],
    );
  }
}
