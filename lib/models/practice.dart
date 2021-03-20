import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:khoaluan/data/exercise_data.dart';

import 'exercise.dart';

class Practice {
  String id;
  String uid;
  Exercise exercise;
  int count;
  DateTime timeStart;
  DateTime timeEnd;

  Practice({
    this.id,
    this.uid,
    String exerciseName,
    this.count,
    this.timeStart,
    this.timeEnd,
  }) {
    this.exercise = getExercise(exerciseName);
  }

  @override
  String toString() =>
      'Practice: ${this.id} / ${this.uid} / ${this.exercise.name} / ${this.count} / ${this.getKcal()}  / ${this.timeStart} -> ${this.timeEnd} ';

  double getKcal() => this.exercise.kcal * this.count;

  factory Practice.fromFirestoreSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data();
    data['id'] = snapshot.id;
    data['uid'] = snapshot.reference.toString().split('/')[1];
    return Practice.fromJson(data);
  }

  Practice.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        uid = json['uid'],
        exercise = getExercise(json['exercise']),
        count = json['count'],
        timeStart = json['timeStart'].toDate(),
        timeEnd = json['timeEnd'].toDate();

  Map<String, dynamic> toJson() => {
        'id': this.id,
        'uid': this.uid,
        'exercise': this.exercise.name,
        'count': this.count,
        'timeStart': this.timeStart,
        'timeEnd': this.timeEnd,
      };

  Map<String, dynamic> addJson() => {
        'exercise': this.exercise.name,
        'count': this.count,
        'timeStart': this.timeStart,
        'timeEnd': this.timeEnd,
      };
}

Exercise getExercise(String name) =>
    exercises.firstWhere((element) => element.name == name);
