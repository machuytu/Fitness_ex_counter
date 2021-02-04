import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:get/get.dart';
import 'package:khoaluan/screens/login_screen.dart';
import 'package:khoaluan/screens/register_screen.dart';
import 'package:khoaluan/screens/splash_screen.dart';
import 'package:khoaluan/widgets/bottomnav.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

List<CameraDescription> cameras;
Future<Null> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();

  try {
    cameras = await availableCameras();
  } on CameraException catch (e) {
    print('Error: $e.code\nError Message: $e.message');
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Firebase.initializeApp(),
        builder: (context, snapshot) {
          return GetMaterialApp(
            title: 'Flutter Fitness counter',
            theme: ThemeData(
              primarySwatch: Colors.blue,
              visualDensity: VisualDensity.adaptivePlatformDensity,
            ),
            initialRoute: "/splash",
            routes: {
              "/splash": (context) => SplashScreen(),
              "/login": (context) => LoginScreen(),
              "/": (context) => BottomNav(cameras: cameras),
              "/register": (context) => ResigterScreen(),
            },
          );
        });
  }
}
