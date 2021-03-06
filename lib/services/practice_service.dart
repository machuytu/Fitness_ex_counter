import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:khoaluan/models/practice.dart';

import 'auth_service.dart';

class PracticeService {
  CollectionReference _ref;
  String _uid;

  PracticeService() {
    _ref = FirebaseFirestore.instance.collection('practices');
    _uid = AuthService().getUser().uid;
  }

  Future<void> addPractice(
    String exercise,
    int count,
    DateTime startTime,
  ) {
    if (count == 0) {
      // return null;
    }

    Practice practice = Practice(
      exercise: exercise,
      uid: _uid,
      count: count,
      startTime: startTime,
      endTime: DateTime.now(),
    );

    return _ref
        .add(practice.toJson())
        .then((value) async => {print("Add practice success")})
        .catchError((err) => {print(err)});
  }

  Future<List<Practice>> getPracticeByUser() {
    print('Hello $_uid');

    return _ref
        .where('uid', isEqualTo: _uid)
        .orderBy('endTime', descending: true)
        .get()
        .then((querySnapshot) => querySnapshot.docs
            .map((doc) => Practice.fromDocumentSnapshot(doc))
            .toList())
        .catchError((err) {
      print(err);
    });
  }
}
