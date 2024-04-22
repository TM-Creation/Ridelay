import 'package:flutter/material.dart';
import 'package:ridely/src/infrastructure/screen_config/screen_config.dart';

Widget lineSeparatorTextFields() {
  return Container(
    height: 1.7,
    width: ScreenConfig.screenSizeWidth * 0.9,
    color: ScreenConfig.theme.primaryColor,
  );
}

Widget lineSeparatorColored(Color color, double width) {
  return Container(
    height: 1.7,
    width: width,
    color: color,
  );
}
