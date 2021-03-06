import 'package:cloud_firestore/cloud_firestore.dart';

class Practice {
  String id;
  String uid;
  String exercise;
  int count;
  DateTime timeStart;
  DateTime timeEnd;

  Practice({
    this.id,
    this.uid,
    this.exercise,
    this.count,
    this.timeStart,
    this.timeEnd,
  });

  @override
  String toString() =>
      'Practice: ${this.id} / ${this.uid} / ${this.exercise} / ${this.count} / ${this.timeStart} -> ${this.timeEnd}';

  factory Practice.fromFirestoreSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data();
    data['id'] = snapshot.id;
    data['uid'] = snapshot.reference.toString().split('/')[1];
    return Practice.fromJson(data);
  }

  Practice.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        uid = json['uid'],
        exercise = json['exercise'],
        count = json['count'],
        timeStart = json['timeStart'].toDate(),
        timeEnd = json['timeEnd'].toDate();

  Map<String, dynamic> toJson() => {
        'id': this.id,
        'uid': this.uid,
        'exercise': this.exercise,
        'count': this.count,
        'timeStart': this.timeStart,
        'timeEnd': this.timeEnd,
      };

  Map<String, dynamic> addJson() => {
        'exercise': this.exercise,
        'count': this.count,
        'timeStart': this.timeStart,
        'timeEnd': this.timeEnd,
      };
}
