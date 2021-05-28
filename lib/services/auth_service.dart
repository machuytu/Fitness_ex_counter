import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:khoaluan/plugin/notification.dart';
import 'package:khoaluan/services/notification_service.dart';

class AuthService with ChangeNotifier {
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseAuth get auth => _auth;
  User getUser() {
    return _auth.currentUser;
  }

  // wrapping the firebase calls
  Future logout() async {
    NotificationPlugin notificationPlugin = new NotificationPlugin();
    notificationPlugin.deleteAllScheduleDailyNotification();
    var result = FirebaseAuth.instance.signOut();
    notifyListeners();
    return result;
  }

  Future<void> loginUser(String email, String password, BuildContext context) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      NotificationService notificationService = new NotificationService();
      NotificationPlugin notificationPlugin = new NotificationPlugin();
      notificationService.getNotification().then((value) {
        for (var i = 0; i < value.length; i++) {
          notificationPlugin.scheduleDailyNotificationOnLogin(value[i].title, value[i].message, value[i].hour, value[i].minute, value[i].listDaily);
        }
      });
      Navigator.pushNamedAndRemoveUntil(context, "/", (Route<dynamic> route) => false);
    } catch (e) {
      if (e.code == 'user-not-found') {
        Fluttertoast.showToast(
          msg: "Tài khoản không tồn tại",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
        );
      } else if (e.code == 'wrong-password') {
        Fluttertoast.showToast(
          msg: "Sai mật khẩu",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
        );
      }
    }
  }

  Future<void> registerUser(String email, String password, BuildContext context) async {
    try {
      await _auth.createUserWithEmailAndPassword(email: email, password: password);
      Fluttertoast.showToast(
        msg: "Đăng ký thành công",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );

      Navigator.pushNamedAndRemoveUntil(context, "/info_user", (Route<dynamic> route) => false);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        Fluttertoast.showToast(
          msg: "Mật khẩu yếu",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
        );
      } else if (e.code == 'email-already-in-use') {
        Fluttertoast.showToast(
          msg: "Tài khoản đã tồn tại",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
        );
      }
    }
  }
}
