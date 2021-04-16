import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:khoaluan/data/exercise_data.dart';

import 'exercise.dart';

class Workout {
  String id;
  String uid;
  int count;
  DateTime start;
  DateTime end;
  int index;
  List<int> listExerciseId;
  List<int> listMax;

  Workout({
    this.id = '',
    this.uid = '',
    this.start,
    this.end,
    this.index = 0,
    this.count = 0,
    this.listExerciseId = const [0, 1, 2, 3, 0, 1, 2, 3],
    this.listMax = const [1, 1, 1, 1, 1, 1, 1, 1],
  });

  @override
  String toString() =>
      'Workout($id): index / $count / $isDone / $listExerciseId / $listMax / $getMainPartKcal';

  List<Exercise> get listExercise =>
      listExerciseId.map((id) => exercises[id]).toList();

  Exercise get exercise => listExercise[index];

  int get length => listExerciseId.length;

  String get name => exercise.name;

  int get exerciseId => exercise.id;

  int get max => listMax[index];

  bool get isDone => ((this.index == this.length - 1) &&
      (this.count >= this.listMax[this.index]));

  Map<BodyPart, double> get getBodyPartKcal {
    return Map.fromIterables(
      BodyPart.values,
      BodyPart.values.map((part) {
        var sum = 0.0;
        if (this.isDone) {
          sum += this.listMax[this.index] *
              this.listExercise[this.index].kcal(part);
        } else {
          sum += this.count * this.listExercise[this.index].kcal(part);
        }
        for (int i = 0; i < this.index; i++) {
          sum += this.listMax[i] * this.listExercise[i].kcal(part);
        }
        return sum;
      }),
    );
  }

  List<double> get getMainPartKcal {
    final map = this.getBodyPartKcal;

    final topPart = map[BodyPart.TRAPS] +
        map[BodyPart.CHEST] +
        map[BodyPart.SHOULDERS] +
        map[BodyPart.BICEPS] +
        map[BodyPart.FOREARM];

    final middlePart = map[BodyPart.ABS] + map[BodyPart.BACK];

    final bottomPart =
        map[BodyPart.GLUTES] + map[BodyPart.QUADS] + map[BodyPart.CALVES];

    return <double>[topPart, middlePart, bottomPart];
  }

  factory Workout.fromFirestoreSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data();
    if (data == null) return null;
    data['id'] = snapshot.id;
    data['uid'] = snapshot.reference.parent.parent.id;
    return Workout.fromJson(data);
  }

  Workout.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        uid = json['uid'],
        index = json['index'],
        count = json['count'],
        listExerciseId = List<int>.from(json['listExerciseId']),
        listMax = List<int>.from(json['listMax']),
        start = json['start'].toDate(),
        end = json['end'].toDate();

  Map<String, dynamic> toJson() => {
        'id': this.id,
        'uid': this.uid,
        'index': this.index,
        'count': this.count,
        'listExerciseId': this.listExerciseId,
        'listMax': this.listMax,
        'start': this.start,
        'end': this.end,
      };

  Map<String, dynamic> addJson() => {
        'index': this.index,
        'count': this.count,
        'listExerciseId': this.listExerciseId,
        'listMax': this.listMax,
        'start': this.start,
        'end': this.end,
      };
}
