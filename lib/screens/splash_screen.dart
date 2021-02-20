import 'package:flutter/material.dart';
import 'package:khoaluan/services/auth_service.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration(seconds: 1), () {
      FirebaseAuth auth = FirebaseAuth.instance;
      User user = auth.currentUser;
      if (user != null) {
        Navigator.of(context).pushReplacementNamed("/");
      } else {
        Navigator.of(context).pushReplacementNamed("/login");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
      ),
    );
  }
}
