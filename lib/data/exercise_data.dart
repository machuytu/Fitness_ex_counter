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
  posture: (poses) {
    final upper = squat.upperRange;
    final lower = squat.lowerRange;

    return poses['leftShoulder'][1] < upper &&
        poses['rightShoulder'][1] < upper &&
        poses['leftHip'][1] < lower &&
        poses['rightHip'][1] < lower;
  },
  midPosture: (poses) {
    final upper = squat.upperRange;

    return poses['leftShoulder'][1] > upper &&
        poses['rightShoulder'][1] > upper;
  },
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
  posture: (poses) {
    final upper = pushup.upperRange;
    final lower = pushup.lowerRange;

    return poses['leftShoulder'][1] > upper &&
        poses['rightShoulder'][1] > upper &&
        poses['leftShoulder'][1] < lower &&
        poses['rightShoulder'][1] < lower;
  },
  midPosture: (poses) {
    final lower = pushup.lowerRange;

    return poses['leftShoulder'][1] > lower &&
        poses['rightShoulder'][1] > lower;
  },
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
  posture: (poses) {
    final upper = lunge.upperRange;

    return poses['leftShoulder'][1] < upper &&
        poses['rightShoulder'][1] < upper;
  },
  midPosture: (poses) {
    final upper = lunge.upperRange;
    final lower = lunge.lowerRange;

    return poses['leftShoulder'][1] > upper &&
        poses['rightShoulder'][1] > upper &&
        (poses['leftKnee'][1] > lower || poses['rightKnee'][1] > lower) &&
        (poses['leftKnee'][1] < lower || poses['rightKnee'][1] < lower);
  },
);

final crunch = Exercise(
  'Crunches',
  0.0035,
  w * 0.30,
  w * 0.70,
  [
    BodyPart.ABS,
    BodyPart.BACK,
  ],
  posture: (poses) {
    final upper = crunch.upperRange;
    final lower = crunch.lowerRange;

    return poses['rightShoulder'][0] > upper &&
        poses['rightShoulder'][0] < lower;
  },
  midPosture: (poses) {
    final upper = lunge.upperRange;

    return poses['rightShoulder'][0] < upper;
  },
);

final exercises = <Exercise>[squat, pushup, lunge, crunch];
