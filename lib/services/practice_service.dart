import 'package:firebase_core/firebase_core.dart';
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
  ) async {
    Practice practice = Practice(
      excercise: excercise,
      uid: uid,
      count: count,
      startTime: startTime,
      endTime: DateTime.now(),
    );
    return _ref
        .add(practice.toJson())
        .then((value) async => {print("add practice ${await value.get()}")})
        .catchError((err) => {print(err)});
  }

  Future<List<Practice>> getPracticeByUser(String uid) async {
    var docs = (await _ref.where('uid', isEqualTo: uid).get()).docs;
    var result =
        docs.map((data) => Practice.fromQueryDocumentSnapshot(data)).toList();
    return result;
  }
}
