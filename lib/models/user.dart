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
  int bmr;
  int age;

  User({
    String uid,
    bool gender,
    String heightUnit,
    String weightUnit,
    int fitnessMode,
    String name,
    int age,
    int bmr,
    int weight,
    int height,
  }) {
    this.gender = gender;
    this.heightUnit = heightUnit;
    this.weightUnit = weightUnit;
    this.fitnessMode = fitnessMode;
    this.name = name;
    this.weight = weight;
    this.height = height;
    this.bmr = bmr;
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
    heightUnit = json['heightUnit'];
    weightUnit = json['weightUnit'];
    fitnessMode = json['fitnessMode'];
    name = json['name'];
    weight = json['weight'];
    height = json['height'];
    bmr = json['bmr'];
    age = json['age'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['gender'] = this.gender;
    data['heightUnit'] = this.heightUnit;
    data['weightUnit'] = this.weightUnit;
    data['fitnessMode'] = this.fitnessMode;
    data['name'] = this.name;
    data['weight'] = this.weight;
    data['height'] = this.height;
    data['bmr'] = this.bmr;
    data['age'] = this.age;
    return data;
  }
}
