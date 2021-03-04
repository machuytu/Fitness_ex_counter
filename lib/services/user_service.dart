import 'package:khoaluan/models/user.dart';
import 'package:khoaluan/services/auth_service.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserService {
  final databaseReference = FirebaseDatabase.instance.reference();
  User _user;

  CollectionReference _ref = FirebaseFirestore.instance.collection('users');

  Future<User> getUser(AuthService auth) async {
    String userId = auth.getUser().uid;
    _ref
        .where('uid', isEqualTo: userId)
        .get()
        .then((value) => {
              value.docs.forEach((doc) {
                _user = User.fromJson(doc);
              })
            })
        .catchError((onError) {
      print(onError);
    });

    // docs.map((data) {
    //   print(data.data()['gender']);
    //   _user = User.fromJson(data);
    // });
    return _user;
  }

  Future<void> updateUser(String userId, String key, var valueUpdate) async {
    databaseReference.child("User").child(userId).update({
      key: valueUpdate,
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
        .add({
          'uid': userId,
          'name': nameUser,
          'height': heightValue,
          'height_unit': heightUnit,
          'weight': weightValue,
          'weight_unit': weightUnit,
          'fitness_mode': fitnessMode,
          'gender': isMale
        })
        .then((value) async => {print("add practice ${await value.get()}")})
        .catchError((err) => {print(err)});
  }
}
