import 'package:khoaluan/models/user.dart';
import 'package:khoaluan/services/auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserService {
  CollectionReference _ref;
  String _uid = ' ';

  UserService() {
    var user = AuthService().getUser();
    if (user != null) {
      _uid = user.uid;
    }
    _ref = FirebaseFirestore.instance.collection('Users');
  }

  Future<User> getUser() {
    return _ref
        .doc(_uid)
        .get()
        .then((value) => User.fromFirestoreSnapshot(value))
        .catchError((onError) {
      print(onError);
    });
  }

  Future<void> updateUser(String key, var valueUpdate) async {
    return _ref.doc(_uid).update({key: valueUpdate}).then((value) {
      print("Updated user");
    }).catchError((e) {
      print(e);
    });
  }

  Future<void> setValueRegister(
      String name,
      int age,
      int heightValue,
      String heightUnit,
      int weightValue,
      String weightUnit,
      int fitnessMode,
      bool isMale) async {
    int bmr;
    double activeLevel;
    if (fitnessMode == 0) {
      activeLevel = 1.37;
    } else if (fitnessMode == 1) {
      activeLevel = 1.55;
    } else {
      activeLevel = 1.725;
    }
    if (isMale) {
      bmr = ((66 +
                  (6.2 * weightValue) +
                  (12.7 * heightValue) -
                  (6.76 * age) * activeLevel) /
              7)
          .round();
    } else {
      bmr = ((655.1 +
                  (4.35 * weightValue) +
                  (4.7 * heightValue) -
                  (4.7 * age) * activeLevel) /
              7)
          .round();
    }

    return _ref.doc(_uid).set({
      'name': name,
      'age': age,
      'height': heightValue,
      'heightUnit': heightUnit,
      'weight': weightValue,
      'weightUnit': weightUnit,
      'bmr': bmr,
      'fitnessMode': fitnessMode,
      'gender': isMale
    }).then((value) {
      print("Added user $_uid");
    }).catchError((err) {
      print(err);
    });
  }

  void updateValueRegister(
      String uid,
      String name,
      int age,
      int heightValue,
      String heightUnit,
      int weightValue,
      String weightUnit,
      int fitnessMode,
      bool isMale) async {
    double bmr;
    double activeLevel;
    if (fitnessMode == 0) {
      activeLevel = 1.37;
    } else if (fitnessMode == 1) {
      activeLevel = 1.55;
    } else {
      activeLevel = 1.725;
    }
    if (isMale) {
      bmr = (66 +
              (6.2 * weightValue) +
              (12.7 * heightValue) -
              (6.76 * age) * activeLevel) /
          7;
    } else {
      bmr = (655.1 +
              (4.35 * weightValue) +
              (4.7 * heightValue) -
              (4.7 * age) * activeLevel) /
          7;
    }
    int bmrInt = bmr.toInt();

    return _ref.doc(uid).set({
      'name': name,
      'age': age,
      'height': heightValue,
      'heightUnit': heightUnit,
      'weight': weightValue,
      'weightUnit': weightUnit,
      'bmr': bmrInt,
      'fitness_mode': fitnessMode,
      'gender': isMale
    }).then((value) {
      print("update user $uid");
    }).catchError((err) {
      print(err);
    });
  }
}
