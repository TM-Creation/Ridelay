import 'package:flutter/material.dart';
import 'package:ridely/src/infrastructure/screen_config/screen_config.dart';
import 'package:ridely/src/presentation/ui/config/theme.dart';

BoxDecoration bottomModalTemplate() {
  return BoxDecoration(
      color: Colors.white,
      borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30), topRight: Radius.circular(30)),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.40),
          offset: const Offset(0.0, 1.2), //(x,y)
          blurRadius: 6.0,
        )
      ]);
}

BoxDecoration squareButtonTemplate({double radius = 10}) {
  return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.all(Radius.circular(radius)),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.40),
          offset: const Offset(0.0, 1.2), //(x,y)
          blurRadius: 6.0,
        )
      ]);
}

BoxDecoration blueContainerTemplate({double radius = 10}) {
  return BoxDecoration(
      color: ScreenConfig.theme.primaryColor,
      borderRadius: BorderRadius.all(Radius.circular(radius)),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.40),
          offset: const Offset(0.0, 1.2), //(x,y)
          blurRadius: 6.0,
        )
      ]);
}

BoxDecoration redContainerTemplate({double radius = 10}) {
  return BoxDecoration(
      color: redFourthColor,
      borderRadius: BorderRadius.all(Radius.circular(radius)),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.40),
          offset: const Offset(0.0, 1.2), //(x,y)
          blurRadius: 6.0,
        )
      ]);
}

BoxDecoration greyContainerTemplate({double radius = 10}) {
  return BoxDecoration(
      color: ScreenConfig.theme.colorScheme.surface,
      borderRadius: BorderRadius.all(Radius.circular(radius)),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.40),
          offset: const Offset(0.0, 1.2), //(x,y)
          blurRadius: 6.0,
        )
      ]);
}

BoxDecoration brownContainerTemplate({double radius = 10}) {
  return BoxDecoration(
      color: thirdColor,
      borderRadius: BorderRadius.all(Radius.circular(radius)),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.40),
          offset: const Offset(0.0, 1.2), //(x,y)
          blurRadius: 6.0,
        )
      ]);
}
