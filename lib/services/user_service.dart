import 'package:khoaluan/models/user.dart';
import 'package:khoaluan/services/auth_service.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserService {
  final databaseReference = FirebaseDatabase.instance.reference();

  CollectionReference _ref = FirebaseFirestore.instance.collection('users');

  Future<User> getUser(AuthService auth) {
    String userId = auth.getUser().uid;

    return _ref
        .doc(userId)
        .get()
        .then((value) => User.fromFirestoreSnapshot(value))
        .catchError((onError) {
      print(onError);
    });
  }

  Future<void> updateUser(String userId, String key, var valueUpdate) async {
    return _ref.doc(userId).update({key: valueUpdate}).then((value) {
      print("thanh cong");
    }).catchError((e) {
      print(e);
    });
  }

  void setValueRegister(
      String userId,
      String nameUser,
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

    _ref
        .doc(userId)
        .set({
          'name': nameUser,
          'age': age,
          'height': heightValue,
          'height_unit': heightUnit,
          'weight': weightValue,
          'weight_unit': weightUnit,
          'bmr_int': bmrInt,
          'fitness_mode': fitnessMode,
          'gender': isMale
        })
        .then((value) async => {print("add user $userId")})
        .catchError((err) => {print(err)});
  }

  void updateValueRegister(
      String userId,
      String nameUser,
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

    _ref
        .doc(userId)
        .set({
          'name': nameUser,
          'age': age,
          'height': heightValue,
          'height_unit': heightUnit,
          'weight': weightValue,
          'weight_unit': weightUnit,
          'bmr_int': bmrInt,
          'fitness_mode': fitnessMode,
          'gender': isMale
        })
        .then((value) async => {print("update user $userId")})
        .catchError((err) => {print(err)});
  }
}
