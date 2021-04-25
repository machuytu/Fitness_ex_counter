import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:khoaluan/data/exercise_data.dart';
import 'exercise.dart';

class DailyExercise {
  String _id;
  String _uid;
  int _index;
  int _count;
  DateTime _start;
  DateTime _end;
  List<int> _listExerciseId;
  List<int> _listMax;

  DailyExercise({
    int weight,
    int bmr,
    DateTime start,
    DateTime end,
  }) {
    this._id = '';
    this._uid = '';
    this._index = 0;
    this._count = 0;
    this._start = start ?? DateTime.now();
    this._end = end ?? DateTime.now();
    if (weight != null && bmr != null) {
      this._listExerciseId = [0, 1, 2, 3, 0, 1, 2, 3];
      this._listMax = this
          .listExercise
          .map((e) => (((bmr / this.length) * (1 / 3)) /
              (e.coefficient * weight)) as int)
          .toList();
    } else {
      this._listExerciseId = [0, 1];
      this._listMax = [3, 3];
    }
  }

  @override
  String toString() =>
      'DailyExercise($_id): $_index / $_count / $isDone / $_listExerciseId / $_listMax / $getMainPartKcal';

  List<Exercise> get listExercise =>
      this._listExerciseId.map((id) => exercises[id]).toList();

  Exercise get exercise => this.listExercise[_index];

  int get length => this._listExerciseId.length;

  int get max => this._listMax[this.index];

  int get count => this._count;

  int get index => this._index;

  bool get isMax => this.count >= this.max;

  bool get isInit => this.index == 0 && this.count == 0;

  bool get isLast => this.index == this.length - 1;

  bool get isDone => this.isMax && this.isLast;

  String get id => this._id;

  String get uid => this._uid;

  DateTime get start => this._start;

  DateTime get end => this._end;

  set start(DateTime value) => this._start = value;

  set end(DateTime value) => this._end = value;

  void increaseCount({
    void Function(int) onCount,
    void Function() onMax,
    void Function() onDone,
  }) {
    if (!this.isDone) {
      this._count++;
      if (onCount != null) onCount(this.count);
      if (this.isMax) {
        if (this.isLast) {
          if (onDone != null) onDone();
        } else {
          this._index++;
          this._count = 0;
          if (onMax != null) onMax();
        }
      }
    }
  }

  Map<BodyPart, double> get getBodyPartKcal {
    return Map.fromIterables(
      BodyPart.values,
      BodyPart.values.map((part) {
        var sum = 0.0;
        sum += this._count * this.exercise.kcal(part);
        for (int i = 0; i < this._index; i++) {
          sum += this._listMax[i] * this.listExercise[i].kcal(part);
        }
        return sum;
      }),
    );
  }

  List<double> get getMainPartKcal {
    final map = this.getBodyPartKcal;

    return <double>[
      map[BodyPart.TRAPS] +
          map[BodyPart.CHEST] +
          map[BodyPart.SHOULDERS] +
          map[BodyPart.BICEPS] +
          map[BodyPart.FOREARM],
      map[BodyPart.ABS] + map[BodyPart.BACK],
      map[BodyPart.GLUTES] + map[BodyPart.QUADS] + map[BodyPart.CALVES],
    ];
  }

  factory DailyExercise.fromFirestoreSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data();
    if (data == null) return null;
    data['id'] = snapshot.id;
    data['uid'] = snapshot.reference.parent.parent.id;
    return DailyExercise.fromJson(data);
  }

  DailyExercise.fromJson(Map<String, dynamic> json)
      : _id = json['id'],
        _uid = json['uid'],
        _index = json['index'],
        _count = json['count'],
        _listExerciseId = List<int>.from(json['listExerciseId']),
        _listMax = List<int>.from(json['listMax']),
        _start = json['start'].toDate(),
        _end = json['end'].toDate();

  Map<String, dynamic> get toJson => {
        'id': this._id,
        'uid': this._uid,
        'index': this._index,
        'count': this._count,
        'listExerciseId': this._listExerciseId,
        'listMax': this._listMax,
        'start': this._start,
        'end': this._end,
      };

  Map<String, dynamic> get setJson => {
        'index': this._index,
        'count': this._count,
        'listExerciseId': this._listExerciseId,
        'listMax': this._listMax,
        'start': this._start,
        'end': this._end,
      };
}
