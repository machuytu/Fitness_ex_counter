import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:khoaluan/data/exercise_data.dart';

import 'exercise.dart';

class Practice {
  final String id;
  final String uid;
  final int count;
  final DateTime timeStart;
  final DateTime timeEnd;
  Exercise _exercise;

  Practice(
    int exerciseid,
    this.count,
    this.timeStart,
    this.timeEnd, {
    this.id,
    this.uid,
  }) {
    this._exercise = exercises[exerciseid];
  }

  @override
  String toString() =>
      'Practice: ${this.id} / ${this.exercise.name} / ${this.exercise.bodyParts} / ${this.count} / ${this.kcal} ';

  Exercise get exercise => _exercise;

  double get kcal => this.exercise.kcal * this.count;

  List<double> get bodyPartKcal {
    return BodyPart.values
        .map((part) => (this.exercise.bodyParts.contains(part))
            ? this.exercise.kcal * this.count
            : 0.0)
        .toList();
  }

  factory Practice.fromFirestoreSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data();
    data['id'] = snapshot.id;
    data['uid'] = snapshot.reference.parent.parent.id;
    return Practice.fromJson(data);
  }

  Practice.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        uid = json['uid'],
        _exercise = exercises[json['exerciseid']],
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
