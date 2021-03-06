import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:khoaluan/models/practice.dart';

import 'auth_service.dart';

class PracticeService {
  CollectionReference _ref;
  String _uid;

  PracticeService() {
    _ref = FirebaseFirestore.instance.collection('practices');
    _uid = AuthService().getUser().uid;
  }

  Future<void> addPractice(
    String excercise,
    int count,
    DateTime startTime,
  ) {
    Practice practice = Practice(
      excercise: excercise,
      uid: _uid,
      count: count,
      startTime: startTime,
      endTime: DateTime.now(),
    );
    return _ref
        .add(practice.toJson())
        .then((value) async => {print("add practice")})
        .catchError((err) => {print(err)});
  }

  Future<List<Practice>> getPracticeByUser() {
    return _ref
        .where('uid', isEqualTo: _uid)
        .get()
        .then((querySnapshot) =>
            querySnapshot.docs.map((doc) => Practice.fromJson(doc)).toList())
        .catchError((err) {
      print(err);
    });
  }
}
