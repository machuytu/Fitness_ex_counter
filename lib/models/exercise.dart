class Exercise {
  static int autoId = 0;
  final int id = autoId;
  final String name;
  final double kcal;
  final List<BodyPart> bodyParts;

  Exercise(this.name, this.kcal, this.bodyParts) {
    autoId++;
  }

  @override
  String toString() => 'Exercise: ${this.id} / ${this.name} / ${this.kcal}';
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
