import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/snackbar/snackbar.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:ridely/src/infrastructure/screen_config/screen_config.dart';
import 'package:ridely/src/models/authmodels/passangerloginmodel.dart';
import 'package:ridely/src/models/base%20url.dart';
import 'package:ridely/src/presentation/ui/config/validator.dart';
import 'package:ridely/src/presentation/ui/screens/booking_screens/ride_selection_screen.dart';
import 'package:ridely/src/presentation/ui/screens/driver_screens/driver_main_screen.dart';
import 'package:ridely/src/presentation/ui/screens/onboarding_screens/register_screens/passangerregistration.dart';
import 'package:ridely/src/presentation/ui/templates/main_generic_templates/app_bars/app_bar.dart';
import 'package:ridely/src/presentation/ui/templates/main_generic_templates/app_buttons/buttons.dart';
import 'package:ridely/src/presentation/ui/templates/main_generic_templates/spacing_widgets.dart';
import 'package:ridely/src/presentation/ui/templates/main_generic_templates/text_fields/text_fields.dart';
import 'package:ridely/src/presentation/ui/templates/main_generic_templates/text_templates/display_text.dart';

import 'package:ridely/src/presentation/ui/templates/register_info_widgets/get_validation_texts.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../../config/theme.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);
  static const routeName = '/registerInfo-screen';

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController email = TextEditingController();

  bool progres = false;
  final TextEditingController password = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  String userNumber = "";

  @override
  void initState() {
    super.initState();
  }

  baseulr burl = baseulr();
  bool pasd = false;
  bool emailError = false;

  void navigate() {
    Passangerloginmodel user = Passangerloginmodel(
      email: email.text,
      password: password.text,
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
            "Login",
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
                      SizedBox(
                        height: 50,
                      )
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
          child: Buttons.longWidthButton(
              progres
                  ? Container(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(color: Colors.white,))
                  : Text(
                      'Continue',
                      style: ScreenConfig.theme.textTheme.headline6?.copyWith(
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
            if (emailError == false && pasd == false) {
              print("Accepted");
              setState(() {
                progres=true;
              });
              navigate();
            }else {
              print("snakbar");
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Center(
                    child: Text(
                      'Email or Password is Incorect',
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

  Future<void> postUserData(Passangerloginmodel user) async {
    final url = Uri.parse(
        '${burl.burl}/api/v1/driver/login'); // Replace with your API endpoint
    final body = jsonEncode(user.toJson());
    final headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
    };
    late IO.Socket socket;
    try {
      final response = await http.post(url, headers: headers, body: body);
      setState(() {
        progres=false;
      });
      print("check try: ${response.statusCode}");
      if (response.statusCode == 200) {
        // Successful POST request
        print('User Login Successfully: ${response.body}');
        final responseData = jsonDecode(response.body);
        final data = responseData['data'];
        final iddata = data['data'];
        final id = iddata['_id'];
        final typeofuser = iddata['type'];
        final tokenofuser = data['token'];
        print("id a gi $id");
        setState(() {
          PassId().id = id;
          PassId().token = tokenofuser;
          PassId().type = typeofuser;
        });
        if (PassId().id != null &&
            PassId().token != null &&
            typeofuser != null) {
          if (typeofuser == 'driver') {
            print("Driver Done");
            socket = IO.io(baseulr().burl, <String, dynamic>{
              'transports': ['websocket'],
              'extraHeaders': {
                'authorization': PassId().token,
                'usertype': PassId().type
              },
              'autoConnect': false,
            });
            if(socket.connected){
              Get.snackbar(
                'Login',
                'Successfully',
                snackPosition: SnackPosition.TOP,
                backgroundColor: themeColor,
                colorText: Colors.white,
                margin: EdgeInsets.all(10),
                duration: Duration(seconds: 3),
              );
              Navigator.of(context)
                  .pushNamed(DriverRideSelectionScreen.routeName);
            }
            socket.connect();
            socket.onConnect((_) {
              print("Server Connect with Socket");
              setState(() {
                socketconnection().socket = socket;
              });
              Get.snackbar(
                'Login',
                'Successfully',
                snackPosition: SnackPosition.TOP,
                backgroundColor: themeColor,
                colorText: Colors.white,
                margin: EdgeInsets.all(10),
                duration: Duration(seconds: 3),
              );
              Navigator.of(context)
                  .pushNamed(DriverRideSelectionScreen.routeName);
            });
          } else if (typeofuser == 'passenger') {
            print("Passenger Done");
            socket = IO.io(baseulr().burl, <String, dynamic>{
              'transports': ['websocket'],
              'extraHeaders': {
                'authorization': PassId().token,
                'usertype': PassId().type
              },
              'autoConnect': false,
            });
            if(socket.connected){
              Get.snackbar(
                'Login',
                'Successfully',
                snackPosition: SnackPosition.TOP,
                backgroundColor: themeColor,
                colorText: Colors.white,
                margin: EdgeInsets.all(10),
                duration: Duration(seconds: 3),
              );
              Navigator.of(context).pushNamed(RideSelectionScreen.routeName);
            }
            socket.connect();
            socket.onConnect((_) {
              print("Server Connect with Socket");
              setState(() {
                socketconnection().socket = socket;
              });
              Get.snackbar(
                'Login',
                'Successfully',
                snackPosition: SnackPosition.TOP,
                backgroundColor: themeColor,
                colorText: Colors.white,
                margin: EdgeInsets.all(10),
                duration: Duration(seconds: 3),
              );
              Navigator.of(context).pushNamed(RideSelectionScreen.routeName);
            });
          } else {
            print("Nothing Done");
          }
        } else {
          print('Error: Something null in response');
        }
      }
      else if (response.statusCode == 404) {
        final responseData = jsonDecode(response.body);
        final message = responseData['message'];
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
      } else if (response.statusCode == 400) {
        final responseData = jsonDecode(response.body);
        final message = responseData['message'];
        print("object $message");
        Get.snackbar(
          'Error',
          'Username or Password is incorrect!',
          snackPosition: SnackPosition.TOP,
          backgroundColor: themeColor,
          colorText: Colors.white,
          margin: EdgeInsets.all(10),
          duration: Duration(seconds: 3),
        );
      }
      else {
        // Error occurred
        print('Failed to Login: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (error) {
      setState(() {
        progres=false;
      });
      // Handle network error
      print('Error: $error');
      Get.snackbar(
        'Error',
        'Server Not Found',
        snackPosition: SnackPosition.TOP,
        backgroundColor: themeColor,
        colorText: Colors.white,
        margin: EdgeInsets.all(10),
        duration: Duration(seconds: 3),
      );
    }
  }
}