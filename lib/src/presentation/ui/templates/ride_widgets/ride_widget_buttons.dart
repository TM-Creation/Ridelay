import 'package:flutter/material.dart';
import 'package:ridely/src/infrastructure/screen_config/screen_config.dart';
import 'package:ridely/src/presentation/ui/config/theme.dart';
import 'package:ridely/src/presentation/ui/templates/decorations/box_decoration_templates.dart';
import 'package:ridely/src/presentation/ui/templates/main_generic_templates/text_templates/display_text.dart';

Widget smallSquareButton(String iconImage, void Function() func) {
  return GestureDetector(
    onTap: func,
    child: Container(
      width: 35,
      height: 35,
      decoration: squareButtonTemplate(radius: 5),
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Image.asset(
          iconImage,
          fit: BoxFit.contain,
        ),
      ),
    ),
  );
}

Widget rectangleSquareButton(String type, void Function() func) {
  return GestureDetector(
    onTap: func,
    child: Container(
      width: ScreenConfig.screenSizeWidth * 0.25,
      decoration: BoxDecoration(
          color: (type == "Confirm Partner")
              ? thirdColor
              : (type == "Cancel Ride")
                  ? redFourthColor
                  : Colors.white,
          borderRadius: const BorderRadius.all(Radius.circular(5)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.40),
              offset: const Offset(0.0, 1.2), //(x,y)
              blurRadius: 6.0,
            )
          ]),
      child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: displayNoSizedText(
              type,
              ScreenConfig.theme.textTheme.caption
                  ?.copyWith(color: Colors.white),
              textAlign: TextAlign.center)),
    ),
  );
}

Widget driverRectangleSquareButton(String type, void Function() func) {
  return GestureDetector(
    onTap: func,
    child: Container(
      width: ScreenConfig.screenSizeWidth * 0.25,
      decoration: BoxDecoration(
          color: (type == "Confirm Rider")
              ? thirdColor
              : (type == "Cancel Ride")
                  ? redFourthColor
                  : Colors.white,
          borderRadius: const BorderRadius.all(Radius.circular(5)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.40),
              offset: const Offset(0.0, 1.2), //(x,y)
              blurRadius: 6.0,
            )
          ]),
      child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: displayNoSizedText(
              type,
              ScreenConfig.theme.textTheme.caption
                  ?.copyWith(color: ScreenConfig.theme.primaryColor,fontWeight: FontWeight.bold),
              textAlign: TextAlign.center)),
    ),
  );
}
