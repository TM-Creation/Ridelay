import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ridely/src/infrastructure/screen_config/screen_config.dart';
import 'package:ridely/src/presentation/ui/config/validator.dart';
import 'package:ridely/src/presentation/ui/templates/main_generic_templates/validator_widgets/error_text.dart';

bool errorValidatorShow = false;
TextEditingController phoneNumberController = TextEditingController();

class PhoneNumberTextField extends StatefulWidget {
  const PhoneNumberTextField({Key? key}) : super(key: key);

  @override
  State<PhoneNumberTextField> createState() => _PhoneNumberTextFieldState();
}

class _PhoneNumberTextFieldState extends State<PhoneNumberTextField> {
  String errorString = "Enter a valid phone number with country extension";
  // String errorString = "Enter your phone number with country extension";

  @override
  Widget build(BuildContext context) {
    Widget _displayTextField(TextEditingController controller) {
      return SizedBox(
        width: ScreenConfig.screenSizeWidth * 0.9,
        child: Column(
          children: [
            TextFormField(
              style: ScreenConfig.theme.textTheme.headline4
                  ?.copyWith(fontWeight: FontWeight.normal, fontSize: 20),
              textInputAction: TextInputAction.done,
              keyboardType: TextInputType.text,
              textAlign: TextAlign.left,
              inputFormatters: [
                LengthLimitingTextInputFormatter(13),
              ],
              validator: (val) {
                if (controller.text.isEmpty) {
                  setState(() {
                    errorString = "Can't leave this field empty";
                    errorValidatorShow = true;
                  });
                  return null;
                }
                if (controller.text.length < 13 ||
                    controller.text.length > 14) {
                  setState(() {
                    errorString =
                        "Enter a valid phone number with country extension";
                    errorValidatorShow = true;
                  });
                  return null;
                }
                return null;
              },
              onChanged: (val) {
                if (controller.text.isNotEmpty) {
                  setState(() {
                    errorValidatorShow = false;
                  });
                }
                if (controller.text.length > 12 &&
                    controller.text.length < 14) {
                  setState(() {
                    errorValidatorShow = false;
                  });
                }
                if (controller.text.length < 13 ||
                    controller.text.length > 14) {
                  setState(() {
                    errorString =
                        "Enter a valid phone number with country extension";
                    // errorString =
                    //     "Enter a valid phone number with country extension";
                    // "Enter a valid phone number with country extension";
                    errorValidatorShow = true;
                  });
                }
                if (!validatePhoneNumber(controller.text)) {
                  setState(() {
                    errorString =
                        "Enter a valid phone number with country extension";
                    errorValidatorShow = true;
                  });
                }
              },
              controller: controller,
              decoration: InputDecoration(
                hintText: '+921234567890',
                errorMaxLines: 2,
                enabledBorder: OutlineInputBorder(
                  borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                  borderSide: BorderSide(
                      color: ScreenConfig.theme.colorScheme.primary,
                      width: 0.75),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                  borderSide: BorderSide(
                      color: ScreenConfig.theme.colorScheme.primary,
                      width: 0.75),
                ),
              ),
            ),
            if (errorValidatorShow)
              Column(
                children: [
                  const SizedBox(height: 10),
                  errorValidator(errorString, TextAlign.center),
                ],
              )
          ],
        ),
      );
    }

    return _displayTextField(phoneNumberController);
  }
}
