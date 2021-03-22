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
    int exerciseid,
    int count,
    DateTime timeStart,
  ) {
    if (count == 0) {
      // return null;
    }

    return _ref
        .add(
          Practice(
            exerciseid: exerciseid,
            count: count,
            timeStart: timeStart,
            timeEnd: DateTime.now(),
          ).addJson(),
        )
        .then((value) => {print("Add practice success")})
        .catchError((err) {
      print(err);
    });
  }

  Future<List<Practice>> getPracticeByUser() {
    return _ref
        .orderBy('timeEnd', descending: true)
        .get()
        .then((querySnapshot) => querySnapshot.docs
            .map((snapshot) => Practice.fromFirestoreSnapshot(snapshot))
            .toList())
        .catchError((err) {
      print(err);
    });
  }

  Future<List<Practice>> getPracticeByDay(DateTime date) {
    var today = DateTime(date.year, date.month, date.day);
    var tomorrow = today.add(Duration(days: 1));

    return _ref
        .orderBy('timeEnd', descending: true)
        .where('timeEnd', isGreaterThanOrEqualTo: today)
        .where('timeEnd', isLessThan: tomorrow)
        .get()
        .then((querySnapshot) => querySnapshot.docs
            .map((snapshot) => Practice.fromFirestoreSnapshot(snapshot))
            .toList())
        .catchError((err) {
      print(err);
    });
  }
}
