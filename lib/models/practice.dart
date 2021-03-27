import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:khoaluan/data/exercise_data.dart';

import 'exercise.dart';

class Practice {
  final String id;
  final String uid;
  final int count;
  final DateTime timeStart;
  final DateTime timeEnd;
  Exercise exercise;

  Practice({
    this.id,
    this.uid,
    int exerciseid = 0,
    this.count,
    this.timeStart,
    this.timeEnd,
  }) {
    this.exercise = exercises[exerciseid];
  }

  @override
  String toString() =>
      'Practice: ${this.id} / ${this.uid} / ${this.exercise.name} / ${this.count} / ${this.getKcal()}';

  double getKcal() => this.exercise.kcal * this.count;

  double getKcalBodyPart(BodyPart bodyPart) =>
      this.exercise.kcalBodyPart(bodyPart) * this.count;

  factory Practice.fromFirestoreSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data();
    data['id'] = snapshot.id;
    data['uid'] = snapshot.reference.parent.parent.id;
    return Practice.fromJson(data);
  }

  Practice.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        uid = json['uid'],
        exercise = exercises[json['exerciseid']],
        count = json['count'],
        timeStart = json['timeStart'].toDate(),
        timeEnd = json['timeEnd'].toDate();

  Map<String, dynamic> toJson() => {
        'id': this.id,
        'uid': this.uid,
        'exerciseid': this.exercise.id,
        'count': this.count,
        'timeStart': this.timeStart,
        'timeEnd': this.timeEnd,
      };

  Map<String, dynamic> addJson() => {
        'exerciseid': this.exercise.id,
        'count': this.count,
        'timeStart': this.timeStart,
        'timeEnd': this.timeEnd,
      };
}
