import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'dart:io';

import 'package:image_picker/image_picker.dart';

import 'package:ridely/src/infrastructure/screen_config/screen_config.dart';
import 'package:ridely/src/presentation/ui/config/compress_image.dart';
import 'package:ridely/src/presentation/ui/config/validator.dart';
import 'package:ridely/src/presentation/ui/screens/onboarding_screens/register_screens/choice_customer_driver.dart';
import 'package:ridely/src/presentation/ui/templates/main_generic_templates/app_bars/app_bar.dart';
import 'package:ridely/src/presentation/ui/templates/main_generic_templates/app_buttons/buttons.dart';
import 'package:ridely/src/presentation/ui/templates/main_generic_templates/spacing_widgets.dart';
import 'package:ridely/src/presentation/ui/templates/main_generic_templates/text_fields/text_fields.dart';
import 'package:ridely/src/presentation/ui/templates/main_generic_templates/text_templates/display_text.dart';

import 'package:ridely/src/presentation/ui/templates/register_info_widgets/get_validation_texts.dart';

class RegisterInfoScreen extends StatefulWidget {
  const RegisterInfoScreen({Key? key}) : super(key: key);
  static const routeName = '/registerInfo-screen';

  @override
  State<RegisterInfoScreen> createState() => _RegisterInfoScreenState();
}

class _RegisterInfoScreenState extends State<RegisterInfoScreen> {
  final ImagePicker _picker = ImagePicker();

  PickedFile? _imageFile;

  final TextEditingController firstName = TextEditingController();

  final TextEditingController lastName = TextEditingController();

  final TextEditingController email = TextEditingController();
  final TextEditingController country = TextEditingController();
  final TextEditingController city = TextEditingController();

  final TextEditingController phoneNumber = TextEditingController();

  final TextEditingController image = TextEditingController();
  String valueCity = '';
  String valueCountry = '';

  final _formKey = GlobalKey<FormState>();

  String userNumber = "";
  @override
  void initState() {
    super.initState();
  }

  bool phoneNumberError = true;
  bool picError = true;
  bool fNameError = true;
  bool lNameError = true;
  bool emailError = true;
  bool countryError = true;
  bool cityError = true;

  void navigate() {
    Navigator.of(context).pushNamed(ChoiceCustomerDriverScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    Future<bool> pickImage(ImageSource source) async {
      try {
        // ignore: deprecated_member_use
        final pickedFile = await _picker.getImage(
          source: source,
        );
        if (pickedFile != null) {
          if (isImageLesserThanDefinedSize(File(pickedFile.path))) {
            setState(() {
              _imageFile = pickedFile;
              picError = false;

              // _cnicFrontFile = pickedFile;
            });

            return true;
          } else {
            setState(() {
              picError = true;
            });

            return false;
            // ScaffoldMessenger.of(context)
            //     .showSnackBar(showSnackbar('Image size too large'));
          }
        }

        return true;
      } catch (e) {
        print(e.toString());
        return true;
      }
    }

    Widget _displayTextField({
      required String name,
      required String hint,
      required String? Function(String?)? validator,
      required LengthLimitingTextInputFormatter lengthLimit,
      required FilteringTextInputFormatter filterTextInput,
      required TextEditingController controller,
      required Function(String val)? onChanged,
    }) =>
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              name,
              style: ScreenConfig.theme.textTheme.headline6
                  ?.copyWith(fontWeight: FontWeight.w500),
            ),
            SizedBox(
              height: ScreenConfig.screenSizeHeight * 0.01,
            ),
            MyTextFields.generalTextField(
                onChanged: onChanged,
                hint: hint,
                controller: controller,
                validator: validator,
                textInputType: TextInputType.text,
                inputFormatters: [lengthLimit, filterTextInput],
                fieldOnTapEvent: () {}),
          ],
        );

    Widget _displayBodyText() => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            displayText(
              "Personal Information",
              ScreenConfig.theme.textTheme.headline1
                  ?.copyWith(color: Colors.black.withOpacity(0.5)),
            ),
            spaceHeight(ScreenConfig.screenSizeHeight * 0.01),
            displayText(
              'Add Profile Photo',
              ScreenConfig.theme.textTheme.headline6
                  ?.copyWith(fontWeight: FontWeight.w500),
            ),
          ],
        );
    Future pickImageBottomSheet({required BuildContext context}) {
      return showModalBottomSheet(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
          ),
          context: context,
          builder: (ctx) =>
              Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                Container(
                  alignment: AlignmentDirectional.topStart,
                  padding: const EdgeInsets.only(top: 12, left: 15, bottom: 6),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.close),
                      ),
                      Text(
                        "Pick Image",
                        style: ScreenConfig.theme.textTheme.headline6
                            ?.merge(const TextStyle(
                          fontWeight: FontWeight.normal,
                        )),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: ScreenConfig.screenSizeWidth,
                  height: ScreenConfig.screenSizeHeight * 0.17,
                  color: Colors.white,
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: ScreenConfig.screenSizeHeight * 0.01,
                            horizontal: ScreenConfig.screenSizeWidth * 0.05),
                        child: Column(
                          children: [
                            Buttons.longWidthButton(
                              'Capture From Camera',
                              () async {
                                final isImageSelectedCorrectSize =
                                    await pickImage(ImageSource.camera);
                                Navigator.of(context).pop();
                                // if (!isImageSelectedCorrectSize) {
                                //   imageSizeErrorDialogBox(context);
                                // }
                              },
                            ),
                            SizedBox(
                              height: ScreenConfig.screenSizeHeight * 0.02,
                            ),
                            Buttons.longWidthButton(
                              'Pick From Gallery',
                              () async {
                                final isImageSelectedCorrectSize =
                                    await pickImage(ImageSource.gallery);
                                Navigator.of(context).pop();
                                // if (!isImageSelectedCorrectSize) {
                                //   imageSizeErrorDialogBox(context);
                                // }
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),

                // SizedBox(
                //   height: ScreenConfig.screenSizeHeight * 0.04,
                // ),
              ]));
    }

    Widget _displayAddPhotoSection() => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: ScreenConfig.screenSizeHeight * 0.01,
            ),
            DottedBorder(
              color: ScreenConfig.theme.primaryColor,
              dashPattern: const [10, 10, 10, 10],
              borderType: BorderType.Circle,
              child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(40.0)),
                  constraints: BoxConstraints(
                      maxHeight: ScreenConfig.screenSizeHeight * 0.1,
                      minHeight: ScreenConfig.screenSizeHeight * 0.04,
                      maxWidth: ScreenConfig.screenSizeWidth * 0.2,
                      minWidth: ScreenConfig.screenSizeWidth * 0.1),
                  child: _imageFile != null
                      ? CircleAvatar(
                          radius: ScreenConfig.screenSizeHeight * 0.1,
                          backgroundImage: FileImage(
                            File(_imageFile!.path),
                          ))
                      : GestureDetector(
                          onTap: () async {
                            pickImageBottomSheet(context: context);
                          },
                          child: Center(
                              child: Icon(
                            Icons.add,
                            color: ScreenConfig.theme.primaryColor,
                          )),
                        )),
            ),
          ],
        );

    Widget _displayBody() => Padding(
          padding: EdgeInsets.all(ScreenConfig.screenSizeWidth * 0.03),
          child: SizedBox(
            height: ScreenConfig.screenSizeHeight,
            child: GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
              },
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _displayBodyText(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _displayAddPhotoSection(),
                        ],
                      ),
                      if (picError) displayRegistrationValidation("image"),
                      spaceHeight(ScreenConfig.screenSizeHeight * 0.02),
                      _displayTextField(
                          name: 'Phone number (e.g +923123456789)',
                          hint: 'Enter phone number with country extension',
                          onChanged: (val) {
                            if (val.isNotEmpty) {
                              setState(() {
                                phoneNumberError = false;
                              });
                            }
                            if (val.length > 12 && val.length < 14) {
                              setState(() {
                                phoneNumberError = false;
                              });
                            }
                            if (val.length < 13 || val.length > 14) {
                              setState(() {
                                phoneNumberError = true;
                              });
                            }
                            if (!validatePhoneNumber(val)) {
                              setState(() {
                                phoneNumberError = true;
                              });
                            }
                          },
                          lengthLimit: LengthLimitingTextInputFormatter(13),
                          filterTextInput: FilteringTextInputFormatter.allow(
                              RegExp(r'^[0-9+]+$')),
                          // capText: UpperCaseTextFormatter(),

                          validator: (value) {
                            // if (value!.isEmpty || value.length < 2) {
                            //   return 'First name is not valid';
                            // }
                            return null;
                          },
                          controller: phoneNumber),
                      if (phoneNumberError)
                        displayRegistrationValidation("phoneNumber"),
                      spaceHeight(ScreenConfig.screenSizeHeight * 0.02),
                      _displayTextField(
                          name: 'First Name',
                          hint: 'Type first name here',
                          lengthLimit: LengthLimitingTextInputFormatter(20),
                          filterTextInput: FilteringTextInputFormatter.allow(
                              RegExp("[a-zA-Z]")),
                          onChanged: (val) {
                            firstName.value = TextEditingValue(
                                text:
                                    '${val[0].toUpperCase()}${val.substring(1).toLowerCase()}',
                                selection: firstName.selection);
                            if (val.isEmpty || val.length < 2) {
                              setState(() {
                                fNameError = true;
                              });
                            } else {
                              setState(() {
                                fNameError = false;
                              });
                            }
                          },
                          validator: (value) {
                            // if (value!.isEmpty || value.length < 2) {
                            //   return 'last name is not valid';
                            // }
                            return null;
                          },
                          controller: firstName),
                      if (fNameError)
                        displayRegistrationValidation("firstName"),
                      spaceHeight(ScreenConfig.screenSizeHeight * 0.02),
                      _displayTextField(
                          name: 'Last Name',
                          hint: 'Type last name here',
                          lengthLimit: LengthLimitingTextInputFormatter(20),
                          filterTextInput: FilteringTextInputFormatter.allow(
                              RegExp("[a-zA-Z]")),
                          onChanged: (val) {
                            lastName.value = TextEditingValue(
                                text:
                                    '${val[0].toUpperCase()}${val.substring(1).toLowerCase()}',
                                selection: lastName.selection);
                            if (val.isEmpty || val.length < 2) {
                              setState(() {
                                lNameError = true;
                              });
                            } else {
                              setState(() {
                                lNameError = false;
                              });
                            }
                          },
                          validator: (value) {
                            // if (value!.isEmpty || value.length < 2) {
                            //   return 'last name is not valid';
                            // }
                            return null;
                          },
                          controller: lastName),
                      if (lNameError) displayRegistrationValidation("lastName"),
                      spaceHeight(ScreenConfig.screenSizeHeight * 0.02),
                      _displayTextField(
                          name: 'Email Address',
                          // capText: UpperCaseTextFormatter(),
                          lengthLimit: LengthLimitingTextInputFormatter(30),
                          filterTextInput: FilteringTextInputFormatter.allow(
                              RegExp(r'^[a-zA-Z0-9_\-=@,\.;]+$')),
                          onChanged: (val) {
                            if (!validateStructureEmail(val)) {
                              setState(() {
                                emailError = true;
                              });
                            } else {
                              setState(() {
                                emailError = false;
                              });
                            }
                          },
                          validator: (value) {
                            // if (value!.isEmpty ||
                            //     value.length < 2 ||
                            //     !value.contains('@') ||
                            //     !value.contains('.com')) {
                            //   return 'Email is not valid';
                            // }
                            return null;
                          },
                          hint: 'Please enter email (e.g email@mail.com)',
                          controller: email),
                      if (emailError) displayRegistrationValidation("email"),
                      spaceHeight(ScreenConfig.screenSizeHeight * 0.02),
                      _displayTextField(
                          name: 'Country',
                          hint: 'Type your country here',
                          lengthLimit: LengthLimitingTextInputFormatter(20),
                          filterTextInput: FilteringTextInputFormatter.allow(
                              RegExp("[a-zA-Z]")),
                          onChanged: (val) {
                            country.value = TextEditingValue(
                                text:
                                    '${val[0].toUpperCase()}${val.substring(1).toLowerCase()}',
                                selection: country.selection);
                            if (val.isEmpty || val.length < 2) {
                              setState(() {
                                countryError = true;
                              });
                            } else {
                              setState(() {
                                countryError = false;
                              });
                            }
                          },
                          validator: (value) {
                            // if (value!.isEmpty || value.length < 2) {
                            //   return 'last name is not valid';
                            // }
                            return null;
                          },
                          controller: country),
                      if (countryError)
                        displayRegistrationValidation("country"),
                      _displayTextField(
                          name: 'City',
                          hint: 'Type your city here',
                          lengthLimit: LengthLimitingTextInputFormatter(20),
                          filterTextInput: FilteringTextInputFormatter.allow(
                              RegExp("[a-zA-Z]")),
                          onChanged: (val) {
                            city.value = TextEditingValue(
                                text:
                                    '${val[0].toUpperCase()}${val.substring(1).toLowerCase()}',
                                selection: city.selection);
                            if (val.isEmpty || val.length < 2) {
                              setState(() {
                                cityError = true;
                              });
                            } else {
                              setState(() {
                                cityError = false;
                              });
                            }
                          },
                          validator: (value) {
                            // if (value!.isEmpty || value.length < 2) {
                            //   return 'last name is not valid';
                            // }
                            return null;
                          },
                          controller: city),
                      if (cityError) displayRegistrationValidation("city"),
                      spaceHeight(70),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: GenericAppBars.appBarWithBackButtonOnly(context, false),
      body: _displayBody(),
      floatingActionButton: Container(
        width: ScreenConfig.screenSizeWidth,
        height: 60,
        color: Colors.white,
        child: Center(
          child: Buttons.longWidthButton("Continue", () {
            // navigate();
            FocusScope.of(context).unfocus();
            if (!validatePhoneNumber(phoneNumber.text) ||
                phoneNumber.text.length != 13) {
              setState(() {
                phoneNumberError = true;
              });
            } else {
              setState(() {
                phoneNumberError = false;
              });
            }
            if (!validateStructureEmail(email.text)) {
              setState(() {
                emailError = true;
              });
            } else {
              setState(() {
                emailError = false;
              });
            }
            if (lastName.text.isEmpty || lastName.text.length < 2) {
              setState(() {
                lNameError = true;
              });
            } else {
              setState(() {
                lNameError = false;
              });
            }
            if (firstName.text.isEmpty || firstName.text.length < 2) {
              setState(() {
                fNameError = true;
              });
            } else {
              setState(() {
                fNameError = false;
              });
            }
            if (_imageFile == null) {
              setState(() {
                picError = true;
              });
            } else {
              setState(() {
                picError = false;
              });
            }
            if (country.text.isEmpty || country.text.length < 2) {
              setState(() {
                countryError = true;
              });
            } else {
              setState(() {
                countryError = false;
              });
            }
            if (city.text.isEmpty || city.text.length < 2) {
              setState(() {
                cityError = true;
              });
            } else {
              setState(() {
                cityError = false;
              });
            }
            if (picError == false &&
                phoneNumberError == false &&
                fNameError == false &&
                lNameError == false &&
                emailError == false &&
                countryError == false &&
                cityError == false) {
              print("Accepted");
              navigate();
            }
          }),
        ),
      ),
      // continueButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
