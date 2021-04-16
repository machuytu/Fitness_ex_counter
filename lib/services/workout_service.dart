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

  Future<void> setWorkout(
    int index,
    int count,
    bool isDone,
    List<int> listExerciseId,
    List<int> listMax,
    DateTime start,
  ) {
    if (count == 0) {
      // return null;
    }
    var now = DateTime.now();
    var todayStr = now.toString().split(' ')[0];
    return _ref
        .doc(todayStr)
        .set(Workout(
          index,
          count,
          isDone,
          listExerciseId: listExerciseId,
          listMax: listMax,
          start: start,
          end: now,
        ).addJson())
        .then((value) => {print('Added workout')})
        .catchError((err) {
      print(err);
    });
  }

  Future<List<Workout>> getWorkoutByUser() {
    return _ref
        // .orderBy('end', descending: true)
        .get()
        .then((querySnapshot) => querySnapshot.docs
            .map((snapshot) => Workout.fromFirestoreSnapshot(snapshot))
            .toList())
        .catchError((err) {
      print(err);
    });
  }

  Future<Workout> getWorkoutByDate(DateTime date) {
    var todayStr = date.toString().split(' ')[0];

    return _ref
        .doc(todayStr)
        .get()
        .then((snapshot) => Workout.fromFirestoreSnapshot(snapshot))
        .catchError((err) {
      print(err);
    });
  }
}
