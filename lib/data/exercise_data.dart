import 'package:khoaluan/models/exercise.dart';

final exercises = <Exercise>[
  Exercise(
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
    'Crunches',
    0.25,
    [
      BodyPart.ABS,
      BodyPart.BACK,
    ],
  ),
];
