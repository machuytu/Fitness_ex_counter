import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:khoaluan/data/exercise_data.dart';

import 'exercise.dart';

class Practice {
  final String id;
  final String uid;
  final int exerciseid;
  final int count;
  final DateTime timeStart;
  final DateTime timeEnd;
  Exercise exercise;

  Practice({
    this.id,
    this.uid,
    this.exerciseid,
    this.count,
    this.timeStart,
    this.timeEnd,
  }) {
    this.exercise = exercises[this.exerciseid];
  }

  @override
  String toString() =>
      'Practice: ${this.id} / ${this.uid} / ${this.exercise.name} / ${this.count} / ${this.getKcal()}}';

  double getKcal() => this.exercise.kcal * this.count;

  double getKcalByBodyPart(BodyPart bodyPart) =>
      this.exercise.getKcalByBodyPart(bodyPart) * this.count;

  factory Practice.fromFirestoreSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data();
    data['id'] = snapshot.id;
    data['uid'] = snapshot.reference.parent.parent.id;
    return Practice.fromJson(data);
  }

  Practice.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        uid = json['uid'],
        exerciseid = json['exerciseid'],
        exercise = exercises[json['exerciseid']],
        count = json['count'],
        timeStart = json['timeStart'].toDate(),
        timeEnd = json['timeEnd'].toDate();

  Map<String, dynamic> toJson() => {
        'id': this.id,
        'uid': this.uid,
        'exerciseid': this.exerciseid,
        'count': this.count,
        'timeStart': this.timeStart,
        'timeEnd': this.timeEnd,
      };

  Map<String, dynamic> addJson() => {
        'exerciseid': this.exerciseid,
        'count': this.count,
        'timeStart': this.timeStart,
        'timeEnd': this.timeEnd,
      };
}
