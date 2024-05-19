import 'package:flutter/material.dart';
import 'package:ridely/src/infrastructure/screen_config/screen_config.dart';

Widget errorValidator(String error, TextAlign alignmentText) {
  return SizedBox(
    width: ScreenConfig.screenSizeWidth * 0.9,
    child: Text(
      error,
      style: ScreenConfig.theme.textTheme.bodyText1?.merge(TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.normal)),
      textAlign: alignmentText,
    ),
  );
}
