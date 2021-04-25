import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:khoaluan/models/daily_exercise.dart';
import 'auth_service.dart';

class DailyExerciseService {
  CollectionReference _ref;
  String _uid;

  DailyExerciseService() {
    _uid = AuthService().getUser().uid;
    _ref = FirebaseFirestore.instance
        .collection('Users')
        .doc(_uid)
        .collection('DailyExercises');
  }

  Future<void> setDailyExercise(DailyExercise dailyExercise) {
    if (dailyExercise.isInit) {
      // return null;
    }

    dailyExercise.end = DateTime.now();
    final todayStr = dailyExercise.end.toString().split(' ')[0];

    return _ref.doc(todayStr).set(dailyExercise.setJson).then((value) {
      print('Setted dailyExercise');
    }).catchError((err) {
      print(err);
    });
  }

  Future<List<DailyExercise>> getDailyExerciseByUser() {
    return _ref
        .get()
        .then((querySnapshot) => querySnapshot.docs
            .map((snapshot) => DailyExercise.fromFirestoreSnapshot(snapshot))
            .toList())
        .catchError((err) {
      print(err);
    });
  }

  Future<DailyExercise> getDailyExerciseByDate(DateTime date) {
    final todayStr = date.toString().split(' ')[0];

    return _ref
        .doc(todayStr)
        .get()
        .then((snapshot) => DailyExercise.fromFirestoreSnapshot(snapshot))
        .catchError((err) {
      print(err);
    });
  }
}
