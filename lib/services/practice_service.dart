import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:khoaluan/models/exercise.dart';
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
        .add(Practice(exerciseid, count, timeStart, DateTime.now()).addJson())
        .then((value) => {print("Add practice success ${value.id}")})
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

  Future<List<Practice>> getPracticeByDate(DateTime date) {
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

  // List<double> getBodyPartKcal(List<Practice> practices) {
  //   return BodyPart.values.map((part) {
  //     double sum = 0.0;
  //     practices.forEach((practice) {
  //       sum += practice.getKcalBodyPart(part);
  //     });
  //     return sum;
  //   });
  // }

  Map<BodyPart, double> getBodyPartKcal(List<Practice> practices) {
    return Map.fromIterables(
      BodyPart.values,
      BodyPart.values.map((part) {
        double sum = 0.0;
        practices.forEach((practice) {
          sum += practice.getKcalBodyPart(part);
        });
        return sum;
      }),
    );
  }

  List<double> getBodyMainPartKcal(List<Practice> practices) {
    List<double> listMainPart = [];
    double sumTopPart = 0.0;
    double sumMiddlePart = 0.0;
    double sumBottomPart = 0.0;
    Map<BodyPart, double> list = Map.fromIterables(
      BodyPart.values,
      BodyPart.values.map((part) {
        double sum = 0.0;
        practices.forEach((practice) {
          sum += practice.getKcalBodyPart(part);
        });
        return sum;
      }),
    );
    list.forEach((key, value) {
      if (key == BodyPart.TRAPS ||
          key == BodyPart.CHEST ||
          key == BodyPart.SHOULDERS ||
          key == BodyPart.BICEPS ||
          key == BodyPart.FOREARM) {
        sumTopPart += value;
      } else if (key == BodyPart.ABS || key == BodyPart.BACK) {
        sumMiddlePart += value;
      } else {
        sumBottomPart += value;
      }
    });
    listMainPart.addAll([sumTopPart, sumMiddlePart, sumBottomPart]);
    return listMainPart;
  }

  double getTotalKcal(List<Practice> practices) {
    double sum = 0.0;
    practices.forEach((practice) {
      sum += practice.kcal;
    });
    return sum;
  }
}
