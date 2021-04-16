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
  int bmrInt;
  int age;

  User(
      {String uid,
      bool gender,
      String heightUnit,
      String weightUnit,
      int fitnessMode,
      String name,
      int age,
      int bmrInt,
      int weight,
      int height}) {
    this.gender = gender;
    this.heightUnit = heightUnit;
    this.weightUnit = weightUnit;
    this.fitnessMode = fitnessMode;
    this.name = name;
    this.weight = weight;
    this.height = height;
    this.bmrInt = bmrInt;
    this.age = age;
  }

  factory User.fromFirestoreSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data();
    if (data == null) return null;
    data['uid'] = snapshot.id;
    return User.fromJson(data);
  }

  User.fromJson(Map<String, dynamic> json) {
    gender = json['gender'];
    uid = json['uid'];
    heightUnit = json['height_unit'];
    weightUnit = json['weight_unit'];
    fitnessMode = json['fitness_mode'];
    name = json['name'];
    weight = json['weight'];
    height = json['height'];
    bmrInt = json['bmr_int'];
    age = json['age'];
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
    data['bmr_int'] = this.bmrInt;
    data['age'] = this.age;
    return data;
  }
}
