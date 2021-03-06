import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:khoaluan/models/practice.dart';

import 'auth_service.dart';

class PracticeService {
  CollectionReference _ref;
  String _uid;

  PracticeService() {
    _uid = AuthService().getUser().uid;
    _ref = FirebaseFirestore.instance
        .collection('users')
        .doc(_uid)
        .collection('practices');
  }

  Future<void> addPractice(
    String exercise,
    int count,
    DateTime timeStart,
  ) {
    if (count == 0) {
      // return null;
    }

    final practice = Practice(
      exercise: exercise,
      count: count,
      timeStart: timeStart,
      timeEnd: DateTime.now(),
    );

    return _ref
        .add(practice.toJson())
        .then((value) async => {print("Add practice success")})
        .catchError((err) {
      print(err);
    });
  }

  Future<List<Practice>> getPracticeByUser() {
    return _ref
        .orderBy('timeEnd', descending: true)
        .get()
        .then((querySnapshot) => querySnapshot.docs.map((snapshot) {
              var practice = Practice.fromJson(snapshot.data());
              practice.uid = _uid;
              return practice;
            }).toList())
        .catchError((err) {
      print(err);
    });
  }
}
