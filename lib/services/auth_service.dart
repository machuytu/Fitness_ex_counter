import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User getUser() {
    return _auth.currentUser;
  }

  // wrapping the firebase calls
  Future logout() async {
    var result = FirebaseAuth.instance.signOut();
    notifyListeners();
    return result;
  }

  Future<UserCredential> loginUser(
      {String email, String password, BuildContext context}) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      Navigator.pushNamedAndRemoveUntil(
          context, "/", (Route<dynamic> route) => false);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        buildShowDialog(context, "Lỗi", "Không tồn tại email",
            returnScreen: true);
      } else if (e.code == 'wrong-password') {
        buildShowDialog(context, "Lỗi", "Sai mật khẩu", returnScreen: true);
      }
    }
  }

  Future buildShowDialog(
    BuildContext context,
    String title,
    String description, {
    bool returnScreen,
    String route,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(description),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                if (returnScreen == true) {
                  Navigator.of(context).pop();
                } else {
                  Navigator.pushNamedAndRemoveUntil(
                      context, route, (Route<dynamic> route) => false);
                }
              },
            ),
          ],
        );
      },
    );
  }
}
