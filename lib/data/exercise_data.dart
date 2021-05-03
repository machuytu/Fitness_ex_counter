import 'package:get/get.dart';
import 'package:khoaluan/models/exercise.dart';

final h = Get.height * 0.8 - 5;
final w = Get.width - 5;

final squat = Exercise(
  'Squats',
  0.004,
  h * 0.35,
  h * 0.75,
  [
    BodyPart.QUADS,
    BodyPart.CALVES,
    BodyPart.GLUTES,
  ],
);

final pushup = Exercise(
  'Push Ups',
  0.0055,
  h * 0.45,
  h * 0.65,
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
  h * 0.35,
  h * 0.90,
  [
    BodyPart.QUADS,
    BodyPart.CALVES,
    BodyPart.GLUTES,
  ],
);

final crunch = Exercise(
  'Crunches',
  0.0035,
  w * 0.45,
  w * 0.80,
  [
    BodyPart.ABS,
    BodyPart.BACK,
  ],
);

// final bridge = Exercise(
//   'Bridges',
//   0.007,
//   w * 0.45,
//   w * 0.80,
//   [
//     BodyPart.ABS,
//     BodyPart.BACK,
//     BodyPart.QUADS,
//   ],
// );

final exercises = <Exercise>[squat, pushup, lunge, crunch];
