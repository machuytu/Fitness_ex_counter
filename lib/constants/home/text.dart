import 'package:flutter/material.dart';

import '../color.dart';
import '../font.dart';

class HomeText {
  static const Text SeeAll = Text(
    'SEE ALL',
    style: TextStyle(color: Colors.green),
  );
  static const Text Popular_workout = Text(
    'POPULAR WORKOUT',
    style: TextStyle(
      fontSize: FontString.primaryFontSizeLabel,
      color: ColorName.appBarTitle,
    ),
  );
}
