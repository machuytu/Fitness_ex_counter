import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:khoaluan/models/practice.dart';

class PracticeService {
  CollectionReference _ref;

  PracticeService() {
    _ref = FirebaseFirestore.instance.collection('practices');
  }

  Future<void> addPractice(
    String excercise,
    String uid,
    int count,
    DateTime startTime,
  ) {
    Practice practice = Practice(
      excercise: excercise,
      uid: uid,
      count: count,
      startTime: startTime,
      endTime: DateTime.now(),
    );
    return _ref
        .add(practice.toJson())
        .then((value) async => {print("add practice")})
        .catchError((err) => {print(err)});
  }

  Future<List<Practice>> getPracticeByUser(String uid) {
    return _ref
        .where('uid', isEqualTo: uid)
        .get()
        .then((querySnapshot) => querySnapshot.docs
            .map((doc) => Practice.fromQueryDocumentSnapshot(doc))
            .toList())
        .catchError((err) {
      print(err);
    });
  }
}
