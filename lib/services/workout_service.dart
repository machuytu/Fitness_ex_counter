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

  Future<void> addWorkout(
    int index,
    int count,
    bool isDone,
    List<int> listExerciseId,
    List<int> listMax,
    DateTime start,
  ) {
    if (count == 0) {
      return null;
    }

    return _ref
        .add(Workout(
          index,
          count,
          isDone,
          listExerciseId: listExerciseId,
          listMax: listMax,
          start: start,
          end: DateTime.now(),
        ).addJson())
        .then((value) => {print('Added workout ${value.id}')})
        .catchError((err) {
      print(err);
    });
  }

  Future<void> updateWorkout(
    String id,
    int index,
    int count,
    bool isDone,
    DateTime end,
  ) {
    if (count == 0) {
      return null;
    }

    return _ref
        .doc(id)
        .update(Workout(index, count, isDone, end: end).updateJson())
        .then((value) => {print('Updated workout}')})
        .catchError((err) {
      print(err);
    });
  }

  Future<List<Workout>> getWorkoutByUser() {
    return _ref
        .orderBy('end', descending: true)
        .get()
        .then((querySnapshot) => querySnapshot.docs
            .map((snapshot) => Workout.fromFirestoreSnapshot(snapshot))
            .toList())
        .catchError((err) {
      print(err);
    });
  }

  Future<List<Workout>> getWorkoutByDate(DateTime date) {
    var today = DateTime(date.year, date.month, date.day);
    var tomorrow = today.add(Duration(days: 1));

    return _ref
        .orderBy('end', descending: true)
        .where('end', isGreaterThanOrEqualTo: today)
        .where('end', isLessThan: tomorrow)
        .get()
        .then((querySnapshot) => querySnapshot.docs
            .map((snapshot) => Workout.fromFirestoreSnapshot(snapshot))
            .toList())
        .catchError((err) {
      print(err);
    });
  }
}
