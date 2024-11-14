import 'dart:convert';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:ridely/src/infrastructure/screen_config/screen_config.dart';
import 'package:ridely/src/models/authmodels/driverregmodel.dart';
import 'package:ridely/src/models/imageuploadmodel.dart';
import 'package:ridely/src/presentation/ui/config/compress_image.dart';
import 'package:ridely/src/presentation/ui/config/validator.dart';
import 'package:ridely/src/presentation/ui/screens/onboarding_screens/authentication_selection.dart';
import 'package:ridely/src/presentation/ui/screens/onboarding_screens/login.dart';
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
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../../models/base url.dart';
import '../../../config/theme.dart';
import '../../driver_screens/driver_main_screen.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';

class DriverRegistrationScreen extends StatefulWidget {
  const DriverRegistrationScreen({Key? key}) : super(key: key);
  static const routeName = '/registerDriverVehicleInfo-screen';

  @override
  State<DriverRegistrationScreen> createState() =>
      _DriverRegistrationScreenState();
}

class _DriverRegistrationScreenState extends State<DriverRegistrationScreen> {
  final ImagePicker _picker = ImagePicker();

  PickedFile? _imageFile1;
  PickedFile? _imageFile2;
  PickedFile? _imageFile3;
  PickedFile? _imageFile4;
  PickedFile? _imageFile5;

  bool progres = false;
  final TextEditingController email = TextEditingController();
  final TextEditingController drivername = TextEditingController();
  final TextEditingController driverphonenumber = TextEditingController();

  /*final TextEditingController idNumber = TextEditingController();*/
  final TextEditingController password = TextEditingController();
  final TextEditingController conpassword = TextEditingController();
  String valueCity = '';
  String valueCountry = '';
  String number = '';
  final _formKey = GlobalKey<FormState>();

  String userNumber = "";

  @override
  void initState() {
    super.initState();
  }

  baseulr burl = baseulr();
  bool nameerror = false;
  bool phoneerror = false;

  /*bool idNumberError = false;*/
  bool picError1 = false;
  bool picError2 = false;
  bool picError3 = false;
  bool picError4 = false;
  bool picError5 = false;
  bool emailerror = false;
  bool passworderror = false;
  bool conpassworderror = false;
  var url1;
  var url2;
  var url3;
  var url4;
  var url5;

  void navigate() {
    print('${userLiveLocation().userlivelocation!.latitude} longitude of driver is here');
    Driver user = Driver(name: drivername.text,
        type: 'driver',
        email: email.text,
        password: password.text,
        phone: driverphonenumber.text,
        location: Location(
          type: "Point",
          coordinates: [userLiveLocation().userlivelocation!.latitude, userLiveLocation().userlivelocation!.longitude], // Static example coordinates
        ),
        driverImage: url1,
        idCardFront: url2,
        idCardBack: url3,
        drivingLicenseFront: url4,
        drivingLicenseBack: url5);
    print('User data to be sent: ${jsonEncode(user.toJson())}');
    postUserData(user);
  }

  Future<void> uploadImage(PickedFile pickedFile, int num) async {
    final String uploadUrl = '${burl.burl}/upload-image';
    try {
      final File imageFile = File(
          pickedFile.path); // Convert PickedFile to File
      var stream = http.ByteStream(imageFile.openRead());
      stream.cast();

      var length = await imageFile.length();

      // Get the mime type of the file
      var mimeType = lookupMimeType(imageFile.path);

      // Create the multipart request
      var request = http.MultipartRequest('POST', Uri.parse(uploadUrl));

      var multipartFile = http.MultipartFile(
        'image', stream, length,
        filename: basename(imageFile.path),
        contentType: MediaType(mimeType!.split('/')[0], mimeType.split('/')[1]),
      );

      // Attach the file to the request
      request.files.add(multipartFile);

      // Send the request
      var response = await request.send();

      // Check if the request was successful
      if (response.statusCode == 200) {
        // Get the response body
        final responseBody = await response.stream.bytesToString();
        print('Image uploaded successfully.');
        print('Response body: $responseBody');
        final jsonResponse = json.decode(responseBody);
        final imageUrl = jsonResponse['url'];
        setState(() {
          if (num == 1) {
            url1 = imageUrl;
            print('Image 1 Uploaded');
          } else if (num == 2) {
            url2 = imageUrl;
            print('Image 2 Uploaded');
          } else if (num == 3) {
            url3 = imageUrl;
            print('Image 3 Uploaded');
          } else if (num == 4) {
            url4 = imageUrl;
            print('Image 4 Uploaded');
          } else if (num == 5) {
            url5 = imageUrl;
            print('Image 5 Uploaded');
          } else {
            print('Num is Null');
          }
        });
      } else {
        print('Failed to upload image. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error uploading image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    Future<bool> pickImage(ImageSource source, {required int num}) async {
      try {
        // ignore: deprecated_member_use
        final pickedFile = await _picker.getImage(
          source: source,
        );
        if (pickedFile != null) {
          if (isImageLesserThanDefinedSize(File(pickedFile.path))) {
            setState(() {
              if (num == 1) {
                _imageFile1 = pickedFile;
                picError1 = false;
                uploadImage(pickedFile, 1);
              } else if (num == 2) {
                _imageFile2 = pickedFile;
                picError2 = false;
                uploadImage(pickedFile, 2);
              } else if (num == 3) {
                _imageFile3 = pickedFile;
                picError3 = false;
                uploadImage(pickedFile, 3);
              } else if (num == 4) {
                _imageFile4 = pickedFile;
                picError4 = false;
                uploadImage(pickedFile, 4);
              } else if (num == 5) {
                _imageFile5 = pickedFile;
                picError5 = false;
                uploadImage(pickedFile, 5);
              } else {
                print('Num is Null');
              }

              // _cnicFrontFile = pickedFile;
            });

            return true;
          } else {
            setState(() {
              if (num == 1) {
                picError1 = true;
              } else if (num == 2) {
                picError2 = true;
              } else if (num == 3) {
                picError3 = true;
              } else if (num == 4) {
                picError4 = true;
              } else if (num == 5) {
                picError5 = true;
              } else {
                print('Num is Null');
              }
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

    Widget _displayTextField({required String name,
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
              style: ScreenConfig.theme.textTheme.titleSmall
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

    Widget _displayBodyText() =>
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            spaceHeight(ScreenConfig.screenSizeHeight * 0.06),
            displayText(
              "Driver Information",
              ScreenConfig.theme.textTheme.displayLarge
                  ?.copyWith(color: Colors.black.withOpacity(0.5)),
            ),
            displayText(
              'Add Driver Photo',
              ScreenConfig.theme.textTheme.titleSmall
                  ?.copyWith(fontWeight: FontWeight.w500),
            ),
          ],
        );
    Future pickImageBottomSheet(
        {required BuildContext context, required int number}) {
      return showModalBottomSheet(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
          ),
          context: context,
          builder: (ctx) =>
              Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                Container(
                  color: themeColor,
                  alignment: AlignmentDirectional.topStart,
                  padding: const EdgeInsets.only(top: 12, left: 15, bottom: 6),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(
                          Icons.close,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        "Pick Image",
                        style: ScreenConfig.theme.textTheme.titleSmall
                            ?.merge(const TextStyle(
                          color: Colors.white,
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
                                style: ScreenConfig.theme.textTheme.titleSmall
                                    ?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w300),
                              ),
                                  () async {
                                final isImageSelectedCorrectSize =
                                await pickImage(ImageSource.camera,
                                    num: number);
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
                                style: ScreenConfig.theme.textTheme.titleSmall
                                    ?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w300),
                              ),
                                  () async {
                                final isImageSelectedCorrectSize =
                                await pickImage(ImageSource.gallery,
                                    num: number);
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

    Widget _displayAddPhotoSection() =>
        Column(
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
                      child: _imageFile1 != null
                          ? CircleAvatar(
                          radius: ScreenConfig.screenSizeHeight * 0.1,
                          backgroundImage: FileImage(
                            File(_imageFile1!.path),
                          ))
                          : GestureDetector(
                        onTap: () async {
                          pickImageBottomSheet(
                              context: context, number: 1);
                        },
                        child: Center(
                            child: Icon(
                              Icons.person,
                              color: ScreenConfig.theme.primaryColor,
                              size: MediaQuery
                                  .sizeOf(context)
                                  .width * 0.15,
                            )),
                      )),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'Driver Image',
                  style: ScreenConfig.theme.textTheme.titleSmall
                      ?.copyWith(fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ],
        );

    Widget _displayBody() =>
        Padding(
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
                      if (picError1) displayRegistrationValidation("image"),
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
                            style: ScreenConfig.theme.textTheme.titleSmall
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
                                contentPadding:
                                const EdgeInsets.symmetric(horizontal: 15),
                                hintText: 'Enter Phone Number',
                                hintStyle:
                                ScreenConfig.theme.textTheme.titleMedium,
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(8.0)),
                                  borderSide: BorderSide(
                                      color: ScreenConfig
                                          .theme.colorScheme.primary,
                                      width: 0.75),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(8.0)),
                                  borderSide: BorderSide(
                                      color: ScreenConfig
                                          .theme.colorScheme.primary,
                                      width: 0.75),
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
                              style:
                              TextStyle(color: Colors.black, fontSize: 15),
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
                      /*_displayTextField(
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
                          filterTextInput: FilteringTextInputFormatter.allow(
                              RegExp('[0-9]')),
                          // capText: UpperCaseTextFormatter(),

                          validator: (value) {
                            // if (value!.isEmpty || value.length < 2) {
                            //   return 'First name is not valid';
                            // }
                            return null;
                          },
                          controller: idNumber,
                          inputType: TextInputType.number),*/
                      Text(
                        'Id Card Front Side Image',
                        style: ScreenConfig.theme.textTheme.titleSmall
                            ?.copyWith(fontWeight: FontWeight.w500),
                      ),
                      spaceHeight(ScreenConfig.screenSizeHeight * 0.02),
                      DottedBorder(
                        color: Colors.black,
                        // Color of the dotted border
                        strokeWidth: 2,
                        // Thickness of the dots
                        dashPattern: [6, 3],
                        // Length and spacing of the dashes
                        borderType: BorderType.RRect,
                        radius: Radius.circular(20),
                        child: GestureDetector(
                          onTap: () async {
                            pickImageBottomSheet(context: context, number: 2);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20)),
                            height: ScreenConfig.screenSizeHeight * 0.25,
                            width: double.infinity,
                            child: _imageFile2 != null
                                ? ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Image(
                                  fit: BoxFit.fill,
                                  image: FileImage(
                                    File(_imageFile2!.path),
                                  )),
                            )
                                : Icon(
                              CupertinoIcons.add_circled,
                              size: ScreenConfig.screenSizeWidth * 0.1,
                            ),
                          ),
                        ),
                      ),
                      if (picError2) displayRegistrationValidation("image1"),
                      spaceHeight(ScreenConfig.screenSizeHeight * 0.02),
                      Text(
                        'Id Card Back Side Image',
                        style: ScreenConfig.theme.textTheme.titleSmall
                            ?.copyWith(fontWeight: FontWeight.w500),
                      ),
                      spaceHeight(ScreenConfig.screenSizeHeight * 0.02),
                      DottedBorder(
                        color: Colors.black,
                        // Color of the dotted border
                        strokeWidth: 2,
                        // Thickness of the dots
                        dashPattern: [6, 3],
                        // Length and spacing of the dashes
                        borderType: BorderType.RRect,
                        radius: Radius.circular(20),
                        child: GestureDetector(
                          onTap: () async {
                            pickImageBottomSheet(context: context, number: 3);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20)),
                            height: ScreenConfig.screenSizeHeight * 0.25,
                            width: double.infinity,
                            child: _imageFile3 != null
                                ? ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Image(
                                  fit: BoxFit.fill,
                                  image: FileImage(
                                    File(_imageFile3!.path),
                                  )),
                            )
                                : Icon(
                              CupertinoIcons.add_circled,
                              size: ScreenConfig.screenSizeWidth * 0.1,
                            ),
                          ),
                        ),
                      ),
                      if (picError3) displayRegistrationValidation("image1"),
                      spaceHeight(ScreenConfig.screenSizeHeight * 0.02),
                      Text(
                        'Driving License Front Side Image',
                        style: ScreenConfig.theme.textTheme.titleSmall
                            ?.copyWith(fontWeight: FontWeight.w500),
                      ),
                      spaceHeight(ScreenConfig.screenSizeHeight * 0.02),
                      DottedBorder(
                        color: Colors.black,
                        // Color of the dotted border
                        strokeWidth: 2,
                        // Thickness of the dots
                        dashPattern: [6, 3],
                        // Length and spacing of the dashes
                        borderType: BorderType.RRect,
                        radius: Radius.circular(20),
                        child: GestureDetector(
                          onTap: () async {
                            pickImageBottomSheet(context: context, number: 4);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20)),
                            height: ScreenConfig.screenSizeHeight * 0.25,
                            width: double.infinity,
                            child: _imageFile4 != null
                                ? ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Image(
                                  fit: BoxFit.fill,
                                  image: FileImage(
                                    File(_imageFile4!.path),
                                  )),
                            )
                                : Icon(
                              CupertinoIcons.add_circled,
                              size: ScreenConfig.screenSizeWidth * 0.1,
                            ),
                          ),
                        ),
                      ),
                      if (picError4) displayRegistrationValidation("image1"),
                      spaceHeight(ScreenConfig.screenSizeHeight * 0.02),
                      Text(
                        'Driving Liicense Back Side Image',
                        style: ScreenConfig.theme.textTheme.titleSmall
                            ?.copyWith(fontWeight: FontWeight.w500),
                      ),
                      spaceHeight(ScreenConfig.screenSizeHeight * 0.02),
                      DottedBorder(
                        color: Colors.black,
                        // Color of the dotted border
                        strokeWidth: 2,
                        // Thickness of the dots
                        dashPattern: [6, 3],
                        // Length and spacing of the dashes
                        borderType: BorderType.RRect,
                        radius: Radius.circular(20),
                        child: GestureDetector(
                          onTap: () async {
                            pickImageBottomSheet(context: context, number: 5);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20)),
                            height: ScreenConfig.screenSizeHeight * 0.25,
                            width: double.infinity,
                            child: _imageFile5 != null
                                ? ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Image(
                                  fit: BoxFit.fill,
                                  image: FileImage(
                                    File(_imageFile5!.path),
                                  )),
                            )
                                : Icon(
                              CupertinoIcons.add_circled,
                              size: ScreenConfig.screenSizeWidth * 0.1,
                            ),
                          ),
                        ),
                      ),
                      if (picError5) displayRegistrationValidation("image1"),
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
                      Center(
                          child: Text(
                            'If You Alreday Have an Account!',
                            style: TextStyle(
                                color: themeColor,
                                fontSize: ScreenConfig.screenSizeWidth * 0.04),
                          )),
                      spaceHeight(ScreenConfig.screenSizeHeight * 0.01),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          VehicleRegistrationScreen()));
                            },
                            child: Text(
                              'Register Vahicle',
                              style: TextStyle(
                                  color: Colors.blue,
                                  fontSize: ScreenConfig.screenSizeWidth * 0.03,
                                  decoration: TextDecoration.underline,
                                  decorationColor: Colors.blue),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            'or',
                            style: TextStyle(
                                color: themeColor,
                                fontSize: ScreenConfig.screenSizeWidth * 0.03),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                      builder: (context) => Login()));
                            },
                            child: Text(
                              'Login',
                              style: TextStyle(
                                  color: Colors.blue,
                                  fontSize: ScreenConfig.screenSizeWidth * 0.03,
                                  decoration: TextDecoration.underline,
                                  decorationColor: Colors.blue),
                            ),
                          ),
                        ],
                      ),
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
          child: Buttons.longWidthButton(
              progres
                  ? Container(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ))
                  : Text(
                'Continue',
                style: ScreenConfig.theme.textTheme.titleSmall?.copyWith(
                    color: Colors.white, fontWeight: FontWeight.w300),
              ), () {
            // navigate();

            FocusScope.of(context).unfocus();
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
            if (_imageFile1 == null) {
              setState(() {
                picError1 = true;
              });
            } else {
              setState(() {
                picError1 = false;
              });
            }
            if (_imageFile2 == null) {
              setState(() {
                picError2 = true;
              });
            } else {
              setState(() {
                picError2 = false;
              });
            }
            if (_imageFile3 == null) {
              setState(() {
                picError3 = true;
              });
            } else {
              setState(() {
                picError3 = false;
              });
            }
            if (picError3 == false &&
                picError2 == false &&
                picError1 == false &&
                emailerror == false &&
                passworderror == false &&
                nameerror == false &&
                password.text == conpassword.text) {
              print("Accepted");
              setState(() {
                progres = true;
              });
              navigate();
            } else if (password.text.isNotEmpty &&
                conpassword.text.isNotEmpty &&
                password.text != conpassword.text) {
              Get.snackbar(
                'Alert!',
                'Password & Confirm Password are not Equal',
                snackPosition: SnackPosition.TOP,
                backgroundColor: themeColor,
                colorText: Colors.white,
                margin: EdgeInsets.all(10),
                duration: Duration(seconds: 3),
              );
            } else {
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
  Future<void> postUserData(Driver user) async {
    final url = Uri.parse(
        '${burl
            .burl}/api/v1/driver/register'); // Replace with your API endpoint
    final body = jsonEncode(user.toJson());
    final headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
    };

    try {
      final response = await http.post(url, headers: headers, body: body);
      setState(() {
        progres = false;
      });
      if (response.statusCode == 201) {
        // Successful POST request
        print('User data posted successfully: ${response.body}');
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString(
            'driverid', jsonDecode(response.body)['data']['_id']);
        setState(() {
          driverId().driverid = jsonDecode(response.body)['data']['_id'];
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
        Get.off(VehicleRegistrationScreen());
      } else if (response.statusCode == 400) {
        final responseData = jsonDecode(response.body);
        final message = responseData['message'];
        print("Responce $message");
        Get.snackbar(
          'Error',
          '$message',
          snackPosition: SnackPosition.TOP,
          backgroundColor: themeColor,
          colorText: Colors.white,
          margin: EdgeInsets.all(10),
          duration: Duration(seconds: 3),
        );
      } else {
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

