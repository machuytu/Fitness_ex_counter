import 'package:firebase_database/firebase_database.dart';

class User {
  bool gender;
  String heightUnit;
  String weightUnit;
  int fitnessMode;
  String name;
  int weight;
  int height;

  User(
      {bool gender,
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

  User.fromJson(DataSnapshot json) {
    gender = json.value['gender'];
    heightUnit = json.value['heightunit'];
    weightUnit = json.value['weightunit'];
    fitnessMode = json.value['fitnessmode'];
    name = json.value['name'];
    weight = json.value['weight'];
    height = json.value['height'];
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
