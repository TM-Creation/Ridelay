import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'dart:io';

import 'package:image_picker/image_picker.dart';

import 'package:ridely/src/infrastructure/screen_config/screen_config.dart';
import 'package:ridely/src/presentation/ui/config/compress_image.dart';
import 'package:ridely/src/presentation/ui/config/validator.dart';
import 'package:ridely/src/presentation/ui/screens/onboarding_screens/login_number_screen.dart';
import 'package:ridely/src/presentation/ui/screens/onboarding_screens/register_screens/choice_customer_driver.dart';
import 'package:ridely/src/presentation/ui/templates/main_generic_templates/app_bars/app_bar.dart';
import 'package:ridely/src/presentation/ui/templates/main_generic_templates/app_buttons/buttons.dart';
import 'package:ridely/src/presentation/ui/templates/main_generic_templates/snack_bars/custom_snack_bar.dart';
import 'package:ridely/src/presentation/ui/templates/main_generic_templates/spacing_widgets.dart';
import 'package:ridely/src/presentation/ui/templates/main_generic_templates/text_fields/phone_number_textfield.dart';
import 'package:ridely/src/presentation/ui/templates/main_generic_templates/text_fields/text_fields.dart';
import 'package:ridely/src/presentation/ui/templates/main_generic_templates/text_templates/display_text.dart';

import 'package:ridely/src/presentation/ui/templates/register_info_widgets/get_validation_texts.dart';

import '../../driver_screens/driver_main_screen.dart';

class RegisterDriverVehicleInfoScreen extends StatefulWidget {
  const RegisterDriverVehicleInfoScreen({Key? key}) : super(key: key);
  static const routeName = '/registerDriverVehicleInfo-screen';

  @override
  State<RegisterDriverVehicleInfoScreen> createState() =>
      _RegisterDriverVehicleInfoScreenState();
}

class _RegisterDriverVehicleInfoScreenState
    extends State<RegisterDriverVehicleInfoScreen> {
  final ImagePicker _picker = ImagePicker();

  PickedFile? _imageFile, _imageFile2;

  final TextEditingController licenseNumber = TextEditingController();
  final TextEditingController drivername = TextEditingController();
  final TextEditingController driverphonenumber = TextEditingController();
  final TextEditingController vehicleName = TextEditingController();
  final TextEditingController plateNumber = TextEditingController();
  final TextEditingController vehicleType = TextEditingController();
  final TextEditingController idNumber = TextEditingController();
  final TextEditingController image = TextEditingController();
  String valueCity = '';
  String valueCountry = '';

  final _formKey = GlobalKey<FormState>();

  String userNumber = "";

  @override
  void initState() {
    super.initState();
  }

  bool nameerror = true;
  bool phoneerror = true;
  bool idNumberError = true;
  bool picError = true;
  bool licenseNumberError = true;
  bool vehicleNameError = true;
  bool plateNumberError = true;
  bool vehicleTypeError = true;

  void navigate() {
    ScaffoldMessenger.of(context).showSnackBar(showSnackbar(
        "You have been registered successfully. Please login to start taking rides."));
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.of(context).pushNamed(
          DriverRideSelectionScreen.routeName,);
    });
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

    Future<bool> pickImage2(ImageSource source) async {
      try {
        // ignore: deprecated_member_use
        final pickedFile = await _picker.getImage(
          source: source,
        );
        if (pickedFile != null) {
          if (isImageLesserThanDefinedSize(File(pickedFile.path))) {
            setState(() {
              _imageFile2 = pickedFile;
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
            displayText(
              "Driver Information",
              ScreenConfig.theme.textTheme.headline1
                  ?.copyWith(color: Colors.black.withOpacity(0.5)),
            ),
            spaceHeight(ScreenConfig.screenSizeHeight * 0.01),
            displayText(
              'Add Driver and Vehicle Photo',
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

    Future pickImageBottomSheet2({required BuildContext context}) {
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
                                    await pickImage2(ImageSource.camera);
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
                                    await pickImage2(ImageSource.gallery);
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
            Row(
              children: [
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
                                    size:
                                        MediaQuery.sizeOf(context).width * 0.15,
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
                SizedBox(
                  width: MediaQuery.sizeOf(context).width * 0.25,
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
                          child: _imageFile2 != null
                              ? CircleAvatar(
                                  radius: ScreenConfig.screenSizeHeight * 0.1,
                                  backgroundImage: FileImage(
                                    File(_imageFile2!.path),
                                  ))
                              : GestureDetector(
                                  onTap: () async {
                                    pickImageBottomSheet2(context: context);
                                  },
                                  child: Center(
                                      child: Icon(
                                    Icons.car_rental,
                                    color: ScreenConfig.theme.primaryColor,
                                    size:
                                        MediaQuery.sizeOf(context).width * 0.15,
                                  )),
                                )),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Vehicle Image',
                      style: ScreenConfig.theme.textTheme.headline6
                          ?.copyWith(fontWeight: FontWeight.w500),
                    ),
                  ],
                )
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
                          name: 'Driver Name',
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
                      _displayTextField(
                          name: 'Driver Phone',
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
                        displayRegistrationValidation("phoneerror"),
                      spaceHeight(ScreenConfig.screenSizeHeight * 0.02),
                      Stack(
                        children: [
                          _displayTextField(
                              name: 'Vehicle Type',
                              hint: 'Select your vehicle type',
                              onChanged: (val) {
                                if (val.isNotEmpty) {
                                  setState(() {
                                    vehicleTypeError = false;
                                  });
                                }
                                if (val.length >= 3) {
                                  setState(() {
                                    vehicleTypeError = false;
                                  });
                                }
                                if (val.length < 3) {
                                  setState(() {
                                    vehicleTypeError = true;
                                  });
                                }
                              },
                              lengthLimit: LengthLimitingTextInputFormatter(13),
                              filterTextInput:
                                  FilteringTextInputFormatter.allow(
                                      RegExp("[a-zA-Z0-9 ]")),
                              validator: (value) {
                                return null;
                              },
                              controller: vehicleType,
                              inputType: TextInputType.text,
                              readOnly: true),
                          SizedBox(
                            // height: 7.h,
                            height: ScreenConfig.screenSizeHeight * 0.08,
                            width: ScreenConfig.screenSizeWidth * 0.9,
                            child: DropdownButton<String>(
                              underline: Container(),
                              icon: Container(),
                              items: <String>[
                                'Luxury',
                                'Car AC',
                                'Car Mini (Without AC)',
                                'Bike',
                                'Rickshaw',
                              ].map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              onChanged: (value) {
                                if (value!.isNotEmpty) {
                                  setState(() {
                                    vehicleTypeError = false;
                                  });
                                }
                                if (value.length >= 3) {
                                  setState(() {
                                    vehicleTypeError = false;
                                  });
                                }
                                if (value.length < 3) {
                                  setState(() {
                                    vehicleTypeError = true;
                                  });
                                }
                                setState(() {
                                  vehicleType.text = value;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      if (vehicleTypeError)
                        displayRegistrationValidation("vehicleType"),
                      spaceHeight(ScreenConfig.screenSizeHeight * 0.02),
                      _displayTextField(
                          name: 'Vehicle Model',
                          hint:
                              'Type vehicle model here (e.g Toyota Corolla Xli)',
                          lengthLimit: LengthLimitingTextInputFormatter(20),
                          filterTextInput: FilteringTextInputFormatter.allow(
                              RegExp("[a-zA-Z0-9 ]")),
                          onChanged: (val) {
                            if (val.isEmpty || val.length < 2) {
                              setState(() {
                                vehicleNameError = true;
                              });
                            } else {
                              setState(() {
                                vehicleNameError = false;
                              });
                            }
                          },
                          validator: (value) {
                            // if (value!.isEmpty || value.length < 2) {
                            //   return 'last name is not valid';
                            // }
                            return null;
                          },
                          controller: vehicleName,
                          inputType: TextInputType.text),
                      if (vehicleNameError)
                        displayRegistrationValidation("vehicleModelName"),
                      spaceHeight(ScreenConfig.screenSizeHeight * 0.02),
                      _displayTextField(
                          name: 'Number Plate',
                          // capText: UpperCaseTextFormatter(),
                          lengthLimit: LengthLimitingTextInputFormatter(30),
                          filterTextInput: FilteringTextInputFormatter.allow(
                              RegExp(r'^[a-zA-Z0-9_\-=@,\.;]+$')),
                          onChanged: (val) {
                            if (val.isEmpty || val.length < 4) {
                              setState(() {
                                plateNumberError = true;
                              });
                            } else {
                              setState(() {
                                plateNumberError = false;
                              });
                            }
                          },
                          validator: (value) {
                            return null;
                          },
                          hint: 'Plate Number (e.g KKN888)',
                          controller: plateNumber,
                          inputType: TextInputType.text),
                      if (plateNumberError)
                        displayRegistrationValidation("plateNumber"),
                      spaceHeight(ScreenConfig.screenSizeHeight * 0.02),
                      _displayTextField(
                          name: 'ID Number',
                          hint: 'Enter your identification number',
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
                          filterTextInput: FilteringTextInputFormatter.allow(
                              RegExp(r'^[0-9]+$')),
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
                          name: 'License Number',
                          hint: 'Enter your license number',
                          onChanged: (val) {
                            if (val.isNotEmpty) {
                              setState(() {
                                licenseNumberError = false;
                              });
                            }
                            if (val.length >= 9 && val.length <= 13) {
                              setState(() {
                                licenseNumberError = false;
                              });
                            }
                            if (val.length < 9 || val.length > 13) {
                              setState(() {
                                licenseNumberError = true;
                              });
                            }
                          },
                          lengthLimit: LengthLimitingTextInputFormatter(13),
                          filterTextInput: FilteringTextInputFormatter.allow(
                              RegExp(r'^[0-9]+$')),
                          // capText: UpperCaseTextFormatter(),

                          validator: (value) {
                            // if (value!.isEmpty || value.length < 2) {
                            //   return 'First name is not valid';
                            // }
                            return null;
                          },
                          controller: licenseNumber,
                          inputType: TextInputType.number),
                      if (licenseNumberError)
                        displayRegistrationValidation("licenseNumber"),
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
            if (idNumber.text.isEmpty || idNumber.text.length != 13) {
              setState(() {
                idNumberError = true;
              });
            } else {
              setState(() {
                idNumberError = false;
              });
            }
            if (vehicleName.text.isEmpty || vehicleName.text.length < 2) {
              setState(() {
                vehicleNameError = true;
              });
            } else {
              setState(() {
                vehicleNameError = false;
              });
            }
            if (plateNumber.text.isEmpty || plateNumber.text.length < 4) {
              setState(() {
                plateNumberError = true;
              });
            } else {
              setState(() {
                plateNumberError = false;
              });
            }
            if (licenseNumber.text.isEmpty || licenseNumber.text.length < 2) {
              setState(() {
                licenseNumberError = true;
              });
            } else {
              setState(() {
                licenseNumberError = false;
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
            if (vehicleType.text.isEmpty || vehicleType.text.length < 3) {
              setState(() {
                vehicleTypeError = true;
              });
            } else {
              setState(() {
                vehicleTypeError = false;
              });
            }

            if (picError == false &&
                idNumberError == false &&
                licenseNumberError == false &&
                vehicleNameError == false &&
                plateNumberError == false &&
                vehicleTypeError == false) {
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
