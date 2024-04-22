import 'package:flutter/material.dart';
import 'package:ridely/src/infrastructure/screen_config/screen_config.dart';

Widget displayText(String text, TextStyle? style,
    {TextAlign textAlign = TextAlign.start, double width = 0.9}) {
  return SizedBox(
      width: ScreenConfig.screenSizeWidth * width,
      child: Text(text, textAlign: textAlign, style: style));
}

Widget displayNoSizedText(String text, TextStyle? style,
    {TextAlign textAlign = TextAlign.start}) {
  return Text(text, textAlign: textAlign, style: style);
}
