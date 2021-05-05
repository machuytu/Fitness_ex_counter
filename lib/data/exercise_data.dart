import 'package:khoaluan/models/exercise.dart';

final squat = Exercise(
  'Squats',
  0.004,
  [
    BodyPart.QUADS,
    BodyPart.CALVES,
    BodyPart.GLUTES,
  ],
);

final pushup = Exercise(
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

final lunge = Exercise(
  'Stationary Lunges',
  0.0035,
  [
    BodyPart.QUADS,
    BodyPart.CALVES,
    BodyPart.GLUTES,
  ],
);

final crunch = Exercise(
  'Crunches',
  0.0035,
  [
    BodyPart.ABS,
    BodyPart.BACK,
  ],
);

// final bridge = Exercise(
//   'Bridges',
//   0.007,
//   [
//     BodyPart.ABS,
//     BodyPart.BACK,
//     BodyPart.QUADS,
//   ],
// );

final exercises = <Exercise>[squat, pushup, lunge, crunch];
