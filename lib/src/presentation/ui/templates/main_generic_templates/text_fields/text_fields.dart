import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ridely/src/infrastructure/screen_config/screen_config.dart';

class MyTextFields {
  static Widget generalTextField(
          {required String hint,
          required final TextEditingController controller,
          final Function(String val)? onChanged,
          final Function()? onEditComplete,
          final Function()? onTap,
          final Function(String?)? onSaved,
          List<TextInputFormatter>? inputFormatters,
          String? Function(String?)? validator,
          final TextInputType? textInputType,
          bool isReadOnly = false,
          required void Function() fieldOnTapEvent}) =>
      Container(
        // padding: EdgeInsets.fromLTRB(ScreenConfig.screenSizeWidth * 0.03, 0.0,
        //     ScreenConfig.screenSizeWidth * 0.03, 0.0),
        height: 50,
        child: TextFormField(
          style: ScreenConfig.theme.textTheme.titleMedium
              ?.copyWith(fontWeight: FontWeight.normal, color: Colors.black),
          readOnly: isReadOnly,
          keyboardType: textInputType,
          controller: controller,
          onChanged: onChanged,
          inputFormatters: inputFormatters,
          onEditingComplete: onEditComplete,
          onTap: fieldOnTapEvent,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(horizontal: 15),
            hintText: hint,
            hintStyle: ScreenConfig.theme.textTheme.titleMedium,
            errorMaxLines: 2,
            enabledBorder: OutlineInputBorder(
              borderRadius: const BorderRadius.all(Radius.circular(8.0)),
              borderSide: BorderSide(
                  color: ScreenConfig.theme.colorScheme.primary, width: 0.75),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: const BorderRadius.all(Radius.circular(8.0)),
              borderSide: BorderSide(
                  color: ScreenConfig.theme.colorScheme.primary, width: 0.75),
            ),
          ),
        ),
      );

  static Widget feedbackTextField(
          {required String hint,
          required final TextEditingController controller,
          final Function(String val)? onChanged,
          final Function()? onEditComplete,
          final Function()? onTap,
          final TextInputType? textInputType}) =>
      Container(
        padding: EdgeInsets.fromLTRB(
            ScreenConfig.screenSizeWidth * 0.05, 0.0, 0.0, 0.0),
        decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(12.0)),
        child: TextField(
          keyboardType: textInputType,
          controller: controller,
          maxLines: 5,
          onChanged: onChanged,
          onEditingComplete: onEditComplete,
          decoration: InputDecoration(hintText: hint),
        ),
      );
}
