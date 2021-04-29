class Exercise {
  static int autoId = 0;
  final int id = autoId;
  final String name;
  final double coefficient;

  final double upperRange;
  final double lowerRange;

  final List<BodyPart> bodyParts;

  bool Function(Map<String, List<double>> poses) posture;
  bool Function(Map<String, List<double>> poses) midPosture;

  Exercise(
    this.name,
    this.coefficient,
    this.upperRange,
    this.lowerRange,
    this.bodyParts, {
    this.posture,
    this.midPosture,
  }) {
    autoId++;
  }

  double kcal(BodyPart part) =>
      (this.bodyParts.contains(part)) ? this.coefficient : 0.0;

  @override
  String toString() =>
      'Exercise(${this.id}): ${this.name} / ${this.coefficient}';
}

enum BodyPart {
  TRAPS, // cổ
  CHEST, // ngực
  BACK, // lưng
  SHOULDERS, // vai
  BICEPS, // bắp tay trước
  FOREARM, // cẳng tay
  ABS, // bụng
  GLUTES, // mông
  QUADS, // đùi trước
  CALVES, // cẳng chân
}
