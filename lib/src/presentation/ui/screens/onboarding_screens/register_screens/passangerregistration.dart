import 'dart:convert';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:http/http.dart' as http;
import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

import 'package:ridely/src/infrastructure/screen_config/screen_config.dart';
import 'package:ridely/src/models/base%20url.dart';
import 'package:ridely/src/presentation/ui/config/compress_image.dart';
import 'package:ridely/src/presentation/ui/config/validator.dart';
import 'package:ridely/src/presentation/ui/screens/booking_screens/ride_selection_screen.dart';
import 'package:ridely/src/presentation/ui/screens/onboarding_screens/login.dart';
import 'package:ridely/src/presentation/ui/screens/onboarding_screens/authentication_selection.dart';
import 'package:ridely/src/presentation/ui/screens/onboarding_screens/otp_verification_screen.dart';
import 'package:ridely/src/presentation/ui/screens/onboarding_screens/register_screens/choice_customer_driver.dart';
import 'package:ridely/src/presentation/ui/templates/main_generic_templates/app_bars/app_bar.dart';
import 'package:ridely/src/presentation/ui/templates/main_generic_templates/app_buttons/buttons.dart';
import 'package:ridely/src/presentation/ui/templates/main_generic_templates/spacing_widgets.dart';
import 'package:ridely/src/presentation/ui/templates/main_generic_templates/text_fields/text_fields.dart';
import 'package:ridely/src/presentation/ui/templates/main_generic_templates/text_templates/display_text.dart';

import 'package:ridely/src/presentation/ui/templates/register_info_widgets/get_validation_texts.dart';

import '../../../../../models/authmodels/passengerregmodel.dart';
import '../../../config/theme.dart';

class RegisterInfoScreen extends StatefulWidget {
  const RegisterInfoScreen({Key? key}) : super(key: key);
  static const routeName = '/registerInfo-screen';

  @override
  State<RegisterInfoScreen> createState() => PassangerRegistrationScreen();
}

class PassangerRegistrationScreen extends State<RegisterInfoScreen> {
  final TextEditingController firstName = TextEditingController();

  final TextEditingController email = TextEditingController();

  final TextEditingController phoneNumber = TextEditingController();

  final TextEditingController password = TextEditingController();
  bool progres=false;
  final TextEditingController conpassword = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  String userNumber = "";
  String number='';
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
    passanger user = passanger(
      name: firstName.text,
      email: email.text,
      password: password.text,
      phone: number,
      location: Location(
        type: "Point",
        coordinates: [userLiveLocation().userlivelocation!.longitude, userLiveLocation().userlivelocation!.latitude], // Static example coordinates
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
              style: ScreenConfig.theme.textTheme.titleSmall
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
            ScreenConfig.theme.textTheme.displayLarge
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
                        name: 'Passanger Name',
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
                      /*_displayTextField(
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
                      spaceHeight(ScreenConfig.screenSizeHeight * 0.02),*/
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Phone Number',
                            style: ScreenConfig.theme.textTheme.titleSmall
                                ?.copyWith(fontWeight: FontWeight.w500),
                          ),
                          SizedBox(
                            height: ScreenConfig.screenSizeHeight * 0.01,
                          ),
                          Container(
                            height: 70,
                            child: IntlPhoneField(
                              controller: phoneNumber,
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.symmetric(horizontal: 15),
                                hintText: 'Enter Phone Number',
                                hintStyle: ScreenConfig.theme.textTheme.titleMedium,
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
                              initialCountryCode: 'PK',
                              // Initial selection and favorite
                              onChanged: (phone) {
                                print(phone
                                    .completeNumber); // Prints the complete number with country code
                                setState(() {
                                  number = phone.completeNumber;
                                });
                              },
                              style: TextStyle(color: Colors.black, fontSize: 15),
                            ),
                          ),
                        ],
                      ),
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
                          hint: 'Enter Your Email',
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
          child: Buttons.longWidthButton(progres
              ? Container(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(color: Colors.white,))
              : Text(
            'Continue',
            style: ScreenConfig.theme.textTheme.titleSmall?.copyWith(
                color: Colors.white, fontWeight: FontWeight.w300),
          ), () {
            FocusScope.of(context).unfocus();
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
            if (fNameError == false &&
                emailError == false &&
                pasd == false &&
                conpsd == false && password.text==conpassword.text) {
              print("Accepted");
              setState(() {
                progres=true;
              });
              navigate();
            }else if(password.text.isNotEmpty && conpassword.text.isNotEmpty && password.text != conpassword.text){
              Get.snackbar(
                'Alert!',
                'Password & Confirm Password are not Equal',
                snackPosition: SnackPosition.TOP,
                backgroundColor: themeColor,
                colorText: Colors.white,
                margin: EdgeInsets.all(10),
                duration: Duration(seconds: 3),
              );
            }else{
              Get.snackbar(
                'Alert!',
                'Please Fill All Data',
                snackPosition: SnackPosition.TOP,
                backgroundColor: themeColor,
                colorText: Colors.white,
                margin: EdgeInsets.all(10),
                duration: Duration(seconds: 3),
              );
            }
          }),
        ),
      ),
      // continueButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Future<void> postUserData(passanger user) async {
    final url = Uri.parse(
        '${burl.burl}/api/v1/passenger/register'); // Replace with your API endpoint
    final body = jsonEncode(user.toJson());
    final headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
    };

    try {
      final response = await http.post(url, headers: headers, body: body);
      setState(() {
        progres=false;
      });
      if (response.statusCode == 201) {
        // Successful POST request
        print('User data posted successfully: ${response.body}');
        final responseData = jsonDecode(response.body);
        print('responce$responseData');
        Get.snackbar(
          'Register Successfully',
          "Now You're Ridely User!",
          snackPosition: SnackPosition.TOP,
          backgroundColor: themeColor,
          colorText: Colors.white,
          margin: EdgeInsets.all(10),
          duration: Duration(seconds: 3),
        );
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => Login(),));
      }
      else if(response.statusCode == 400){
        final responseData = jsonDecode(response.body);
        final message=responseData['message'];

        print("object $message");
        Get.snackbar(
          'Error',
          '$message',
          snackPosition: SnackPosition.TOP,
          backgroundColor: themeColor,
          colorText: Colors.white,
          margin: EdgeInsets.all(10),
          duration: Duration(seconds: 3),
        );
      }
      else if(response.statusCode == 404){
        final responseData = jsonDecode(response.body);
        final message=responseData['message'];
        print("object $message");
        Get.snackbar(
          'Error',
          '$message',
          snackPosition: SnackPosition.TOP,
          backgroundColor: themeColor,
          colorText: Colors.white,
          margin: EdgeInsets.all(10),
          duration: Duration(seconds: 3),
        );
      }
      else {
        // Error occurred
        print('Failed to post user data: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (error) {
      // Handle network error
      Get.snackbar(
        'Error',
        '$error',
        snackPosition: SnackPosition.TOP,
        backgroundColor: themeColor,
        colorText: Colors.white,
        margin: EdgeInsets.all(10),
        duration: Duration(seconds: 3),
      );
      print('Error: $error');
    }
  }
}

class PassId {
  static final PassId _instance = PassId._internal();

  factory PassId() {
    return _instance;
  }

  PassId._internal();

  String? id,token,type;
}
