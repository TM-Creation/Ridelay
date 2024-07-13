import 'dart:convert';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:ridely/src/infrastructure/screen_config/screen_config.dart';
import 'package:ridely/src/models/authmodels/driverregmodel.dart';
import 'package:ridely/src/presentation/ui/config/compress_image.dart';
import 'package:ridely/src/presentation/ui/config/validator.dart';
import 'package:ridely/src/presentation/ui/screens/onboarding_screens/authentication_selection.dart';
import 'package:ridely/src/presentation/ui/screens/onboarding_screens/register_screens/choice_customer_driver.dart';
import 'package:ridely/src/presentation/ui/screens/onboarding_screens/register_screens/vahicle_registeration.dart';
import 'package:ridely/src/presentation/ui/templates/main_generic_templates/app_bars/app_bar.dart';
import 'package:ridely/src/presentation/ui/templates/main_generic_templates/app_buttons/buttons.dart';
import 'package:ridely/src/presentation/ui/templates/main_generic_templates/snack_bars/custom_snack_bar.dart';
import 'package:ridely/src/presentation/ui/templates/main_generic_templates/spacing_widgets.dart';
import 'package:ridely/src/presentation/ui/templates/main_generic_templates/text_fields/phone_number_textfield.dart';
import 'package:ridely/src/presentation/ui/templates/main_generic_templates/text_fields/text_fields.dart';
import 'package:ridely/src/presentation/ui/templates/main_generic_templates/text_templates/display_text.dart';
import 'package:ridely/src/presentation/ui/templates/register_info_widgets/get_validation_texts.dart';
import '../../../../../models/base url.dart';
import '../../../config/theme.dart';
import '../../driver_screens/driver_main_screen.dart';

class DriverRegistrationScreen extends StatefulWidget {
  const DriverRegistrationScreen({Key? key}) : super(key: key);
  static const routeName = '/registerDriverVehicleInfo-screen';

  @override
  State<DriverRegistrationScreen> createState() =>
      _DriverRegistrationScreenState();
}

class _DriverRegistrationScreenState extends State<DriverRegistrationScreen> {
  final ImagePicker _picker = ImagePicker();

  PickedFile? _imageFile;
  bool progres=false;
  final TextEditingController email = TextEditingController();
  final TextEditingController drivername = TextEditingController();
  final TextEditingController driverphonenumber = TextEditingController();
  final TextEditingController idNumber = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController conpassword = TextEditingController();
  String valueCity = '';
  String valueCountry = '';
  String number='';
  final _formKey = GlobalKey<FormState>();

  String userNumber = "";

  @override
  void initState() {
    super.initState();
  }
  baseulr burl = baseulr();
  bool nameerror = false;
  bool phoneerror = false;
  bool idNumberError = false;
  bool picError = false;
  bool emailerror = false;
  bool passworderror = false;
  bool conpassworderror = false;

  void navigate() {
    driverregmodel user = driverregmodel(
      name: drivername.text,
      email: email.text,
      password: password.text,
      phone: number,
      location: Location(
        type: "Point",
        coordinates: [userLiveLocation().userlivelocation!.longitude, userLiveLocation().userlivelocation!.latitude], // Static example coordinates
      ),
      vehicle: "609c78a1c25e6d6bfdb1b16b",
      rating: 4.8,
      identityCardNumber:idNumber.text,
      status: "available",
      wallet: "60d21b4667d0d8992e610c87",
      driverImage: "http://example.com/images/john_doe.jpg",
    );
    print('User data to be sent: ${jsonEncode(user.toJson())}');
    postUserData(user);
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

    Widget _displayTextField(
            {required String name,
            required String hint,
            required String? Function(String?)? validator,
            required LengthLimitingTextInputFormatter lengthLimit,
            required FilteringTextInputFormatter filterTextInput,
            required TextEditingController controller,
            required Function(String val)? onChanged,
            required TextInputType inputType,
            bool readOnly = false}) =>
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
                isReadOnly: readOnly,
                onChanged: onChanged,
                hint: hint,
                controller: controller,
                validator: validator,
                textInputType: inputType,
                inputFormatters: [lengthLimit, filterTextInput],
                fieldOnTapEvent: () {}),
          ],
        );

    Widget _displayBodyText() => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            spaceHeight(ScreenConfig.screenSizeHeight * 0.06),
            displayText(
              "Driver Information",
              ScreenConfig.theme.textTheme.headline1
                  ?.copyWith(color: Colors.black.withOpacity(0.5)),
            ),
            displayText(
              'Add Driver Photo',
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
                              Text(
                                'Capture From Camera',
                                style: ScreenConfig.theme.textTheme.headline6?.copyWith(
                                    color: Colors.white, fontWeight: FontWeight.w300),
                              ),
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
                              Text(
                                'Pick From Gallery',
                                style: ScreenConfig.theme.textTheme.headline6?.copyWith(
                                    color: Colors.white, fontWeight: FontWeight.w300),
                              ),
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
            Column(
              children: [
                DottedBorder(
                  color: ScreenConfig.theme.primaryColor,
                  dashPattern: const [5, 5, 5, 5],
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
                                Icons.person,
                                color: ScreenConfig.theme.primaryColor,
                                size: MediaQuery.sizeOf(context).width * 0.15,
                              )),
                            )),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'Driver Image',
                  style: ScreenConfig.theme.textTheme.headline6
                      ?.copyWith(fontWeight: FontWeight.w500),
                ),
              ],
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
                          name: 'Name',
                          hint: 'Enter Your Name',
                          validator: (value) {
                            return null;
                          },
                          lengthLimit: LengthLimitingTextInputFormatter(30),
                          filterTextInput: FilteringTextInputFormatter.allow(
                              RegExp("[a-zA-Z ]")),
                          controller: drivername,
                          onChanged: (val) {
                            if (val.isEmpty || val.length < 2) {
                              setState(() {
                                nameerror = true;
                              });
                            } else {
                              setState(() {
                                nameerror = false;
                              });
                            }
                          },
                          inputType: TextInputType.text),
                      if (nameerror) displayRegistrationValidation("nameerror"),
                      spaceHeight(ScreenConfig.screenSizeHeight * 0.02),
                      /*_displayTextField(
                          name: 'Phone Number',
                          hint: 'Enter Your Phone Number',
                          validator: (value) {
                            return null;
                          },
                          lengthLimit: LengthLimitingTextInputFormatter(13),
                          filterTextInput: FilteringTextInputFormatter.allow(
                              RegExp("[0-9+ ]")),
                          controller: driverphonenumber,
                          onChanged: (val) {
                            if (val.isEmpty || val.length < 2) {
                              setState(() {
                                phoneerror = true;
                              });
                            } else {
                              setState(() {
                                phoneerror = false;
                              });
                            }
                          },
                          inputType: TextInputType.text),
                      if (phoneerror)
                        displayRegistrationValidation("phoneerror"),*/
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Phone Number',
                            style: ScreenConfig.theme.textTheme.headline6
                                ?.copyWith(fontWeight: FontWeight.w500),
                          ),
                          SizedBox(
                            height: ScreenConfig.screenSizeHeight * 0.01,
                          ),
                          Container(
                            height: 70,
                            child: IntlPhoneField(
                              controller: driverphonenumber,
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.symmetric(horizontal: 15),
                                hintText: 'Enter Phone Number',
                                hintStyle: ScreenConfig.theme.textTheme.headline5,
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
                              initialCountryCode: 'US',
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
                          name: 'Email',
                          hint: 'Enter Your Email',
                          lengthLimit: LengthLimitingTextInputFormatter(20),
                          filterTextInput: FilteringTextInputFormatter.allow(
                              RegExp(r'^[a-zA-Z0-9_\-=@,\.;]+$')),
                          onChanged: (val) {
                            if (val.isEmpty || val.length < 2) {
                              setState(() {
                                emailerror = true;
                              });
                            } else {
                              setState(() {
                                emailerror = false;
                              });
                            }
                          },
                          validator: (value) {
                            // if (value!.isEmpty || value.length < 2) {
                            //   return 'last name is not valid';
                            // }
                            return null;
                          },
                          controller: email,
                          inputType: TextInputType.text),
                      if (emailerror) displayRegistrationValidation("email"),
                      spaceHeight(ScreenConfig.screenSizeHeight * 0.02),
                      _displayTextField(
                          name: 'ID Card Number',
                          hint: 'Enter your National ID Card Number',
                          onChanged: (val) {
                            if (val.isNotEmpty) {
                              setState(() {
                                idNumberError = false;
                              });
                            }
                            if (val.length > 12 && val.length < 14) {
                              setState(() {
                                idNumberError = false;
                              });
                            }
                            if (val.length < 13 || val.length > 14) {
                              setState(() {
                                idNumberError = true;
                              });
                            }
                          },
                          lengthLimit: LengthLimitingTextInputFormatter(13),
                          filterTextInput:
                              FilteringTextInputFormatter.allow(RegExp('[0-9]')),
                          // capText: UpperCaseTextFormatter(),

                          validator: (value) {
                            // if (value!.isEmpty || value.length < 2) {
                            //   return 'First name is not valid';
                            // }
                            return null;
                          },
                          controller: idNumber,
                          inputType: TextInputType.number),
                      if (idNumberError)
                        displayRegistrationValidation("idNumber"),
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
                              passworderror = true;
                            });
                          } else {
                            setState(() {
                              passworderror = false;
                            });
                          }
                        },
                        inputType: TextInputType.text,
                      ),
                      if (passworderror) displayRegistrationValidation("passd"),
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
                              conpassworderror = true;
                            });
                          } else {
                            setState(() {
                              conpassworderror = false;
                            });
                          }
                        },
                        inputType: TextInputType.text,
                      ),
                      if (conpassworderror)
                        displayRegistrationValidation("conpassd"),
                      spaceHeight(ScreenConfig.screenSizeHeight * 0.02),
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
            style: ScreenConfig.theme.textTheme.headline6?.copyWith(
                color: Colors.white, fontWeight: FontWeight.w300),
          ), () {
            // navigate();

            FocusScope.of(context).unfocus();
            if (idNumber.text.isEmpty || idNumber.text.length != 13) {
              setState(() {
                idNumberError = true;
              });
            } else {
              setState(() {
                idNumberError = false;
              });
            }
            if (drivername.text.isEmpty || drivername.text.length < 2) {
              setState(() {
                nameerror = true;
              });
            } else {
              setState(() {
                nameerror = false;
              });
            }
            if (email.text.isEmpty) {
              setState(() {
                emailerror = true;
              });
            } else {
              setState(() {
                emailerror = false;
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
            if (picError == false &&
                idNumberError == false &&
                emailerror == false &&
                passworderror == false &&
                nameerror == false &&
                password.text == conpassword.text) {
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
  Future<void> postUserData(driverregmodel user) async {
    final url = Uri.parse(
        '${burl.burl}/api/v1/driver/register'); // Replace with your API endpoint
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
        setState(() {
          driverId().driverid=jsonDecode(response.body)['data']['_id'];
          print("Driver Id is: ${driverId().driverid}");
        });
        Get.snackbar(
          'Register Successfully',
          "Now You're Ridely User!",
          snackPosition: SnackPosition.TOP,
          backgroundColor: themeColor,
          colorText: Colors.white,
          margin: EdgeInsets.all(10),
          duration: Duration(seconds: 3),
        );
        Navigator.of(context).push(MaterialPageRoute(builder: (context)=>VehicleRegistrationScreen()));
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
      else {
        // Error occurred
        print('Failed to post user data: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (error) {
      // Handle network error
      Get.snackbar(
        'Error',
        'Server Not Found',
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
class driverId {
  static final driverId _instance = driverId._internal();

  factory driverId() {
    return _instance;
  }

  driverId._internal();

  String? driverid;
}