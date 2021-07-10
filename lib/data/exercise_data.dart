import 'package:khoaluan/models/exercise.dart';

class Weight {
  static int weight = 0;
}

final squat = Exercise(
  'Squats',
  5.5 * 0.0175 / 25,
  [
    BodyPart.QUADS,
    BodyPart.CALVES,
    BodyPart.GLUTES,
  ],
);

final pushup = Exercise(
  'Push Ups',
  8 * 0.0175 / 25,
  [
    BodyPart.FOREARM,
    BodyPart.BICEPS,
    BodyPart.CHEST,
    BodyPart.SHOULDERS,
    BodyPart.TRAPS,
  ],
);

final lunge = Exercise(
  'Stationary Lunges',
  4 * 0.0175 / 25,
  [
    BodyPart.QUADS,
    BodyPart.CALVES,
    BodyPart.GLUTES,
  ],
);

final crunch = Exercise(
  'Crunches',
  5 * 0.0175 / 25,
  [
    BodyPart.ABS,
    BodyPart.BACK,
  ],
);

final exercises = <Exercise>[squat, pushup, lunge, crunch];
