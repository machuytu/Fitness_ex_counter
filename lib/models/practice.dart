import 'package:cloud_firestore/cloud_firestore.dart';

class Practice {
  String excercise;
  String uid;
  int count;
  DateTime startTime;
  DateTime endTime;

  Practice({
    this.excercise,
    this.uid,
    this.count,
    this.startTime,
    this.endTime,
  });

  // Practice.fromJson(Map<String, dynamic> json)
  //     : excercise = json['excercise'],
  //       uid = json['email'],
  //       count = json['count'],
  //       startTime = json['startTime'],
  //       endTime = json['endTime'];

  Practice.fromJson(dynamic json)
      : excercise = json['excercise'],
        uid = json['email'],
        count = json['count'],
        startTime = json['startTime'],
        endTime = json['endTime'];

  Practice.fromDocumentSnapshot(DocumentSnapshot snapshot)
      : excercise = snapshot['excercise'],
        uid = snapshot['email'],
        count = snapshot['count'],
        startTime = snapshot['startTime'],
        endTime = snapshot['endTime'];

  Map<String, dynamic> toJson() => {
        'excercise': this.excercise,
        'uid': this.uid,
        'count': this.count,
        'startTime': this.startTime,
        'endTime': this.endTime,
      };
}
