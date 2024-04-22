import 'package:flutter/material.dart';
import 'package:ridely/src/infrastructure/screen_config/screen_config.dart';

Widget sliderBar() {
  return Container(
    height: 5,
    width: 45,
    decoration: BoxDecoration(
        color: ScreenConfig.theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.40),
            offset: const Offset(0.0, 1.2), //(x,y)
            blurRadius: 6.0,
          )
        ]),
  );
}
