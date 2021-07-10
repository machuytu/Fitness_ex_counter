import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:khoaluan/data/exercise_data.dart';
import 'exercise.dart';

class Practice {
  final String id;
  final String uid;
  final DateTime start;
  final DateTime end;
  final int exerciseId;
  final int count;

  Practice({
    this.exerciseId,
    this.count,
    this.start,
    this.end,
    this.id,
    this.uid,
  });

  @override
  String toString() => 'Practice(${this.id}): ${this.exercise.name} / ${this.exercise.bodyParts} / ${this.count} / ${this.kcal}';

  Exercise get exercise => exercises[this.exerciseId];

  double get kcal => this.exercise.coefficient * Weight.weight * this.count;

  double bodyPartKcal(BodyPart part) => this.exercise.kcal(part) * this.count;

  factory Practice.fromFirestoreSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data();
    if (data == null) return null;
    data['id'] = snapshot.id;
    data['uid'] = snapshot.reference.parent.parent.id;
    return Practice.fromJson(data);
  }

  Practice.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        uid = json['uid'],
        exerciseId = json['exerciseId'],
        count = json['count'],
        start = json['start'].toDate(),
        end = json['end'].toDate();

  Map<String, dynamic> toJson() => {
        'id': this.id,
        'uid': this.uid,
        'exerciseId': this.exerciseId,
        'count': this.count,
        'start': this.start,
        'end': this.end,
      };

  Map<String, dynamic> addJson() => {
        'exerciseId': this.exerciseId,
        'count': this.count,
        'start': this.start,
        'end': this.end,
      };
}
