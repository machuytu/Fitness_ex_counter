import 'package:khoaluan/models/exercise.dart';

final exercises = <Exercise>[
  Exercise(
    0,
    'Squats',
    0.32,
    [
      // BodyPart.HAMSTRINGS,
      BodyPart.QUADS,
      BodyPart.CALVES,
      BodyPart.GLUTES,
    ],
  ),
  Exercise(
    1,
    'Push Ups',
    0.45,
    [
      // BodyPart.TRICEPS,
      BodyPart.FOREARM,
      BodyPart.BICEPS,
      BodyPart.CHEST,
      BodyPart.SHOULDERS,
      BodyPart.TRAPS,
    ],
  ),
  Exercise(
    2,
    'Stationary Lunges',
    0.3,
    [
      // BodyPart.HAMSTRINGS,
      BodyPart.QUADS,
      BodyPart.CALVES,
      BodyPart.GLUTES,
    ],
  ),
  Exercise(
    3,
    'Crunches',
    0.25,
    [
      BodyPart.ABS,
      BodyPart.BACK,
    ],
  ),
];
