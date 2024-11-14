import 'package:flutter/material.dart';
import 'package:ridely/src/infrastructure/screen_config/screen_config.dart';

Widget genericTextField(
    String hint, Widget suffixIconButton, TextEditingController controller,
    Function(String)? onChanged,
    {bool isReadOnly = false}) {
  return Container(
      width: ScreenConfig.screenSizeWidth * 0.9,
      height: 60,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.40),
              offset: const Offset(0.0, 1.2), //(x,y)
              blurRadius: 6.0,
            )
          ]),
      child: TextFormField(
          readOnly: isReadOnly,
          onChanged: onChanged,
          textInputAction: TextInputAction.done,
          textAlign: TextAlign.start,
          keyboardType: TextInputType.text,
          controller: controller,
          decoration: InputDecoration(
              hintText: hint,
              hintStyle: ScreenConfig.theme.textTheme.titleMedium,
              suffixIcon: suffixIconButton,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.all(20)),
          style: ScreenConfig.theme.textTheme.titleMedium));
}


