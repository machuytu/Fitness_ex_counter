import 'package:cloud_firestore/cloud_firestore.dart';

class Workout {
  String id;
  String uid;
  bool isDone;
  int index;
  int count;
  List<int> listExerciseId;
  List<int> listMax;
  DateTime start;
  DateTime end;

  Workout(
    this.index,
    this.count,
    this.isDone, {
    this.listExerciseId,
    this.listMax,
    this.start,
    this.end,
    this.id,
    this.uid,
  });

  @override
  String toString() => 'Workout(${this.id}): / ${this.index} / ${this.count}';

  factory Workout.fromFirestoreSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data();
    data['id'] = snapshot.id;
    data['uid'] = snapshot.reference.parent.parent.id;
    return Workout.fromJson(data);
  }

  Workout.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        uid = json['uid'],
        index = json['index'],
        count = json['count'],
        isDone = json['isDone'],
        listExerciseId = json['listExerciseId'],
        listMax = json['listMax'],
        start = json['start'].toDate(),
        end = json['end'].toDate();

  Map<String, dynamic> toJson() => {
        'id': this.id,
        'uid': this.uid,
        'index': this.index,
        'count': this.count,
        'isDone': this.isDone,
        'listExerciseId': this.listExerciseId,
        'listMax': this.listMax,
        'start': this.start,
        'end': this.end,
      };

  Map<String, dynamic> addJson() => {
        'index': this.index,
        'count': this.count,
        'isDone': this.isDone,
        'listExerciseId': this.listExerciseId,
        'listMax': this.listMax,
        'start': this.start,
        'end': this.end,
      };

  Map<String, dynamic> updateJson() => {
        'index': this.index,
        'count': this.count,
        'isDone': this.isDone,
        'end': this.end,
      };
}
