import 'package:khoaluan/models/user.dart';
import 'package:khoaluan/services/auth_service.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserService {
  final databaseReference = FirebaseDatabase.instance.reference();
  User _user;

  CollectionReference _ref = FirebaseFirestore.instance.collection('users');

  Future<User> getUser(AuthService auth) {
    String userId = auth.getUser().uid;

    return _ref.doc(userId).get().then((value) {
      var user = User.fromJson(value.data());
      user.uid = userId;
      return user;
    }).catchError((onError) {
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
      int heightValue,
      String heightUnit,
      int weightValue,
      String weightUnit,
      int fitnessMode,
      bool isMale) async {
    _ref
        .doc(userId)
        .set({
          'name': nameUser,
          'height': heightValue,
          'height_unit': heightUnit,
          'weight': weightValue,
          'weight_unit': weightUnit,
          'fitness_mode': fitnessMode,
          'gender': isMale
        })
        .then((value) async => {print("add user $userId")})
        .catchError((err) => {print(err)});
  }
}
