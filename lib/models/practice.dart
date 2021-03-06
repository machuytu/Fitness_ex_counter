import 'package:cloud_firestore/cloud_firestore.dart';

class Practice {
  String exercise;
  String uid;
  int count;
  DateTime startTime;
  DateTime endTime;

  Practice({
    this.exercise,
    this.uid,
    this.count,
    this.startTime,
    this.endTime,
  });

  Practice.fromJson(Map<String, dynamic> json)
      : exercise = json['exercise'],
        uid = json['email'],
        count = json['count'],
        startTime = json['startTime'],
        endTime = json['endTime'];

  Practice.fromDocumentSnapshot(DocumentSnapshot snapshot)
      : exercise = snapshot.data()['exercise'],
        uid = snapshot.data()['email'],
        count = snapshot.data()['count'],
        startTime = (snapshot.data()['startTime']).toDate(),
        endTime = (snapshot.data()['endTime']).toDate();

  Map<String, dynamic> toJson() => {
        'exercise': this.exercise,
        'uid': this.uid,
        'count': this.count,
        'startTime': this.startTime,
        'endTime': this.endTime,
      };
}
