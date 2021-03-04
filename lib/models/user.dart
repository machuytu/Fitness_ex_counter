import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String uid;
  bool gender;
  String heightUnit;
  String weightUnit;
  int fitnessMode;
  String name;
  int weight;
  int height;

  User(
      {String uid,
      bool gender,
      String heightUnit,
      String weightUnit,
      int fitnessMode,
      String name,
      int weight,
      int height}) {
    this.gender = gender;
    this.heightUnit = heightUnit;
    this.weightUnit = weightUnit;
    this.fitnessMode = fitnessMode;
    this.name = name;
    this.weight = weight;
    this.height = height;
  }

  User.fromJson(QueryDocumentSnapshot json) {
    gender = json.data()['gender'];
    heightUnit = json.data()['heightunit'];
    weightUnit = json.data()['weightunit'];
    fitnessMode = json.data()['fitnessmode'];
    name = json.data()['name'];
    weight = json.data()['weight'];
    height = json.data()['height'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['gender'] = this.gender;
    data['heightunit'] = this.heightUnit;
    data['weightunit'] = this.weightUnit;
    data['fitnessmode'] = this.fitnessMode;
    data['name'] = this.name;
    data['weight'] = this.weight;
    data['height'] = this.height;
    return data;
  }
}
