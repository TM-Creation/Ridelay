import 'package:flutter/material.dart';
import 'package:ridely/src/infrastructure/screen_config/screen_config.dart';

Widget errorValidator(String error, TextAlign alignmentText) {
  return SizedBox(
    width: ScreenConfig.screenSizeWidth * 0.9,
    child: Text(
      error,
      style: ScreenConfig.theme.textTheme.bodyLarge?.merge(TextStyle(
          color: Colors.red,
          fontWeight: FontWeight.normal)),
      textAlign: alignmentText,
    ),
  );
}
