class Exercise {
  final int id;
  final String name;
  final double kcal;

  Exercise(this.id, this.name, this.kcal);

  @override
  String toString() => 'Exercise: ${this.id} / ${this.name} / ${this.kcal}';
}
