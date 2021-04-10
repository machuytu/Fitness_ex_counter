import 'package:khoaluan/models/exercise.dart';

final exerciseSquat = Exercise(
  'Squats',
  0.004,
  [
    BodyPart.QUADS,
    BodyPart.CALVES,
    BodyPart.GLUTES,
  ],
);

final exercisePushUp = Exercise(
  'Push Ups',
  0.0055,
  [
    BodyPart.FOREARM,
    BodyPart.BICEPS,
    BodyPart.CHEST,
    BodyPart.SHOULDERS,
    BodyPart.TRAPS,
  ],
);

final exerciseStationaryLunge = Exercise(
  'Stationary Lunges',
  0.0035,
  [
    BodyPart.QUADS,
    BodyPart.CALVES,
    BodyPart.GLUTES,
  ],
);

final exerciseCrunch = Exercise(
  'Crunches',
  0.0035,
  [
    BodyPart.ABS,
    BodyPart.BACK,
  ],
);

final exercises = <Exercise>[
  exerciseSquat,
  exercisePushUp,
  exerciseStationaryLunge,
  exerciseCrunch,
];
