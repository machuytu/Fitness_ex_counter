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
      return null;
    }

    return _ref
        .add(Practice(exerciseid, count, timeStart, DateTime.now()).addJson())
        .then((value) => {print("Added practice ${value.id}")})
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

  Map<BodyPart, double> getBodyPartKcal(List<Practice> practices) {
    return Map.fromIterables(
      BodyPart.values,
      BodyPart.values.map((part) {
        var sum = 0.0;
        practices.forEach((practice) {
          sum += practice.bodyPartKcal[part.index];
        });
        return sum;
      }),
    );
  }

  List<double> getBodyMainPartKcal(List<Practice> practices) {
    final map = this.getBodyPartKcal(practices);

    final topPart = map[BodyPart.TRAPS] +
        map[BodyPart.CHEST] +
        map[BodyPart.SHOULDERS] +
        map[BodyPart.BICEPS] +
        map[BodyPart.FOREARM];

    final middlePart = map[BodyPart.ABS] + map[BodyPart.BACK];

    final bottomPart =
        map[BodyPart.GLUTES] + map[BodyPart.QUADS] + map[BodyPart.CALVES];

    return <double>[topPart, middlePart, bottomPart];
  }

  double getTotalKcal(List<Practice> practices) {
    double sum = 0.0;
    practices.forEach((practice) {
      sum += practice.kcal;
    });
    return sum;
  }
}
