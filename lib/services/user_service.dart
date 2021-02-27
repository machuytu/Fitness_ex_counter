import 'package:khoaluan/models/user.dart';
import 'package:khoaluan/services/auth_service.dart';
import 'package:firebase_database/firebase_database.dart';

class UserService {
  final databaseReference = FirebaseDatabase.instance.reference();
  User _user;
  Future<User> getUser(AuthService auth) async {
    String userId = auth.getUser().uid;
    await databaseReference
        .child("User")
        .child(userId)
        .once()
        .then((DataSnapshot snapshot) {
      _user = User.fromJson(snapshot);
    });
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
    databaseReference.child("User").child(userId).set({
      'name': nameUser,
      'height': heightValue,
      'height_unit': heightUnit,
      'weight': weightValue,
      'weight_unit': weightUnit,
      'fitness_mode': fitnessMode,
      'gender': isMale
    });
  }
}
