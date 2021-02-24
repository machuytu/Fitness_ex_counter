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

  User.fromJson(Map<String, dynamic> json) {
    gender = json['gender'];
    heightUnit = json['heightunit'];
    weightUnit = json['weightunit'];
    fitnessMode = json['fitnessmode'];
    name = json['name'];
    weight = json['weight'];
    height = json['height'];
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
