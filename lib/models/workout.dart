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
    int weight,
    int bmr,
  }) {
    this.id = '';
    this.uid = '';
    this.index = 0;
    this.count = 0;
    this.start = DateTime.now();
    this.end = DateTime.now();
    if (weight != null && bmr != null) {
      this.listExerciseId = [0, 1, 2, 3, 0, 1, 2, 3];
      this.listMax = this
          .listExercise
          .map((e) =>
              ((bmr / this.length) * (1 / 3)) ~/ (e.coefficient * weight))
          .toList();
    } else {
      this.listExerciseId = [0, 1];
      this.listMax = [3, 3];
    }
  }

  @override
  String toString() =>
      'Workout($id): $index / $count / $isDone / $listExerciseId / $listMax / $getMainPartKcal';

  List<Exercise> get listExercise =>
      this.listExerciseId.map((id) => exercises[id]).toList();

  Exercise get exercise => this.listExercise[index];

  int get max => this.listMax[this.index];

  int get length => this.listExerciseId.length;

  String get exerciseName => this.exercise.name;

  int get exerciseId => this.exercise.id;

  bool get isMax => this.count >= this.max;

  bool get isLast => this.index == this.length - 1;

  bool get isDone => this.isMax && this.isLast;

  void increaseCount({
    void Function(int) fnCount,
    void Function() fnMax,
    void Function() fnDone,
  }) {
    if (!this.isDone) {
      this.count++;
      fnCount(this.count);
      if (this.isMax) {
        if (this.isLast) {
          fnDone();
        } else {
          this.index++;
          this.count = 0;
          fnMax();
        }
      }
    }
  }

  Map<BodyPart, double> get getBodyPartKcal {
    return Map.fromIterables(
      BodyPart.values,
      BodyPart.values.map((part) {
        var sum = 0.0;
        sum += this.count * this.exercise.kcal(part);
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

  Map<String, dynamic> get toJson => {
        'id': this.id,
        'uid': this.uid,
        'index': this.index,
        'count': this.count,
        'listExerciseId': this.listExerciseId,
        'listMax': this.listMax,
        'start': this.start,
        'end': this.end,
      };

  Map<String, dynamic> get setJson => {
        'index': this.index,
        'count': this.count,
        'listExerciseId': this.listExerciseId,
        'listMax': this.listMax,
        'start': this.start,
        'end': this.end,
      };
}
