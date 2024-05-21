import 'dart:convert';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:io';

import 'package:image_picker/image_picker.dart';

import 'package:ridely/src/infrastructure/screen_config/screen_config.dart';
import 'package:ridely/src/models/base%20url.dart';
import 'package:ridely/src/presentation/ui/config/compress_image.dart';
import 'package:ridely/src/presentation/ui/config/validator.dart';
import 'package:ridely/src/presentation/ui/screens/onboarding_screens/otp_verification_screen.dart';
import 'package:ridely/src/presentation/ui/screens/onboarding_screens/register_screens/choice_customer_driver.dart';
import 'package:ridely/src/presentation/ui/templates/main_generic_templates/app_bars/app_bar.dart';
import 'package:ridely/src/presentation/ui/templates/main_generic_templates/app_buttons/buttons.dart';
import 'package:ridely/src/presentation/ui/templates/main_generic_templates/spacing_widgets.dart';
import 'package:ridely/src/presentation/ui/templates/main_generic_templates/text_fields/text_fields.dart';
import 'package:ridely/src/presentation/ui/templates/main_generic_templates/text_templates/display_text.dart';

import 'package:ridely/src/presentation/ui/templates/register_info_widgets/get_validation_texts.dart';

import '../../../../../models/authmodels/passengerregmodel.dart';

class RegisterInfoScreen extends StatefulWidget {
  const RegisterInfoScreen({Key? key}) : super(key: key);
  static const routeName = '/registerInfo-screen';

  @override
  State<RegisterInfoScreen> createState() => _RegisterInfoScreenState();
}

class _RegisterInfoScreenState extends State<RegisterInfoScreen> {
  final TextEditingController firstName = TextEditingController();

  final TextEditingController email = TextEditingController();

  final TextEditingController phoneNumber = TextEditingController();

  final TextEditingController password = TextEditingController();

  final TextEditingController conpassword = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  String userNumber = "";

  @override
  void initState() {
    super.initState();
  }

  baseulr burl = baseulr();
  bool phoneNumberError = false;
  bool pasd = false;
  bool conpsd = false;
  bool fNameError = false;
  bool emailError = false;

  void navigate() {
    User user = User(
      name: firstName.text,
      email: email.text,
      password: password.text,
      phone: phoneNumber.text,
      location: Location(
        type: "Passenger",
        coordinates: [-73.935242, 40.730610], // Static example coordinates
      ),
      preferences: Preferences(
        language: 'en',
        preferredDriverRating: 4.5,
      ),
      wallet: "60d21b4667d0d8992e610c87", // Static example wallet ID
    );
    print('User data to be sent: ${jsonEncode(user.toJson())}');
    postUserData(user);
  }

  @override
  Widget build(BuildContext context) {
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

    Widget _displayBodyText() => Padding(
          padding:
              EdgeInsets.only(left: MediaQuery.sizeOf(context).width * 0.35),
          child: displayText(
            "Sign-up",
            ScreenConfig.theme.textTheme.headline1
                ?.copyWith(color: Colors.black.withOpacity(0.7)),
          ),
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
                      spaceHeight(ScreenConfig.screenSizeHeight * 0.05),
                      _displayTextField(
                        name: 'Driver Name',
                        hint: 'Enter Your Name',
                        validator: (value) {
                          return null;
                        },
                        lengthLimit: LengthLimitingTextInputFormatter(30),
                        filterTextInput: FilteringTextInputFormatter.allow(
                            RegExp("[a-zA-Z ]")),
                        controller: firstName,
                        onChanged: (val) {
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
                      ),
                      if (fNameError)
                        displayRegistrationValidation("nameerror"),
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
                              RegExp('[0-9+]')),
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
                        name: 'Password',
                        hint: 'Set a Complex Password',
                        validator: (value) {
                          return null;
                        },
                        lengthLimit: LengthLimitingTextInputFormatter(30),
                        filterTextInput: FilteringTextInputFormatter.allow(
                            RegExp('[a-zA-Z0-9!@#%^&*(),.?":{}|<>]')),
                        controller: password,
                        onChanged: (val) {
                          if (val.isEmpty || val.length < 8) {
                            setState(() {
                              pasd = true;
                            });
                          } else {
                            setState(() {
                              pasd = false;
                            });
                          }
                        },
                      ),
                      if (pasd) displayRegistrationValidation("passd"),
                      spaceHeight(ScreenConfig.screenSizeHeight * 0.02),
                      _displayTextField(
                        name: 'Confirm Password',
                        hint: 'Re-Enter Same Password',
                        validator: (value) {
                          return null;
                        },
                        lengthLimit: LengthLimitingTextInputFormatter(30),
                        filterTextInput: FilteringTextInputFormatter.allow(
                            RegExp(r'[a-zA-Z0-9!@#$%^&*(),.?":{}|<>]')),
                        controller: conpassword,
                        onChanged: (val) {
                          if (val.isEmpty || val.length < 8) {
                            setState(() {
                              conpsd = true;
                            });
                          } else {
                            setState(() {
                              conpsd = false;
                            });
                          }
                        },
                      ),
                      if (conpsd) displayRegistrationValidation("conpassd"),
                      spaceHeight(ScreenConfig.screenSizeHeight * 0.02),
                      SizedBox(height: 50,)
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
            if (firstName.text.isEmpty || firstName.text.length < 2) {
              setState(() {
                fNameError = true;
              });
            } else {
              setState(() {
                fNameError = false;
              });
            }
            if (phoneNumberError == false &&
                fNameError == false &&
                emailError == false &&
                pasd == false &&
                conpsd == false && password.text==conpassword.text) {
              print("Accepted");
              navigate();
            }else {
              print("snakbar");
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Center(
                    child: Text(
                      'Password & Confirom Password are not Equal',
                      style: TextStyle(fontSize: 15, color: Colors.white),
                    ),
                  ),
                  backgroundColor: Colors.black,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            }
          }),
        ),
      ),
      // continueButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Future<void> postUserData(User user) async {
    final url = Uri.parse(
        '${burl.burl}/api/v1/passenger/register'); // Replace with your API endpoint
    final body = jsonEncode(user.toJson());
    final headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
    };

    try {
      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 201) {
        // Successful POST request
        print('User data posted successfully: ${response.body}');
        Navigator.of(context).pushNamed(OTPVerificationScreen.routeName);
      } else {
        // Error occurred
        print('Failed to post user data: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (error) {
      // Handle network error
      print('Error: $error');
    }
  }
}
