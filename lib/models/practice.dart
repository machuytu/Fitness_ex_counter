import 'package:cloud_firestore/cloud_firestore.dart';

class Practice {
  String exercise;
  String uid;
  int count;
  DateTime timeStart;
  DateTime timeEnd;

  Practice({
    this.exercise,
    this.uid,
    this.count,
    this.timeStart,
    this.timeEnd,
  });

  @override
  String toString() =>
      'Practice: ${this.uid} / ${this.exercise} / ${this.count} / ${this.timeStart} -> ${this.timeEnd}';

  Practice.fromJson(Map<String, dynamic> json)
      : exercise = json['exercise'],
        count = json['count'],
        timeStart = json['timeStart'],
        timeEnd = json['timeEnd'];

  Practice.fromDocumentSnapshot(DocumentSnapshot snapshot)
      : exercise = snapshot.data()['exercise'],
        count = snapshot.data()['count'],
        timeStart = (snapshot.data()['timeStart']).toDate(),
        timeEnd = (snapshot.data()['timeEnd']).toDate();

  Map<String, dynamic> toJson() => {
        'exercise': this.exercise,
        'count': this.count,
        'timeStart': this.timeStart,
        'timeEnd': this.timeEnd,
      };
}
