import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:khoaluan/models/workout.dart';
import 'auth_service.dart';

class WorkoutService {
  CollectionReference _ref;
  String _uid;

  WorkoutService() {
    _uid = AuthService().getUser().uid;
    _ref = FirebaseFirestore.instance
        .collection('users')
        .doc(_uid)
        .collection('workouts');
  }

  Future<void> setWorkout(Workout workout) {
    if (workout.count == 0 && workout.index == 0) {
      // return null;
    }

    workout.end = DateTime.now();
    final todayStr = workout.end.toString().split(' ')[0];

    return _ref
        .doc(todayStr)
        .set(workout.setJson)
        .then((value) => {print('Setted workout')})
        .catchError((err) {
      print(err);
    });
  }

  Future<List<Workout>> getWorkoutByUser() {
    return _ref
        .get()
        .then((querySnapshot) => querySnapshot.docs
            .map((snapshot) => Workout.fromFirestoreSnapshot(snapshot))
            .toList())
        .catchError((err) {
      print(err);
    });
  }

  Future<Workout> getWorkoutByDate(DateTime date) {
    final todayStr = date.toString().split(' ')[0];

    return _ref
        .doc(todayStr)
        .get()
        .then((snapshot) => Workout.fromFirestoreSnapshot(snapshot))
        .catchError((err) {
      print(err);
    });
  }
}
