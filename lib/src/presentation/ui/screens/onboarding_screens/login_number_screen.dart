import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:ridely/src/infrastructure/screen_config/screen_config.dart';
import 'package:ridely/src/presentation/ui/config/debug_helper.dart';
import 'package:ridely/src/presentation/ui/screens/onboarding_screens/login.dart';
import 'package:ridely/src/presentation/ui/screens/onboarding_screens/otp_verification_screen.dart';
import 'package:ridely/src/presentation/ui/screens/onboarding_screens/register_screens/choice_customer_driver.dart';
import 'package:ridely/src/presentation/ui/screens/onboarding_screens/register_screens/passangerregistration.dart';
import 'package:ridely/src/presentation/ui/templates/main_generic_templates/app_buttons/buttons.dart';
import 'package:ridely/src/presentation/ui/templates/main_generic_templates/spacing_widgets.dart';
import 'package:ridely/src/presentation/ui/templates/main_generic_templates/text_fields/phone_number_textfield.dart';
import 'package:ridely/src/presentation/ui/templates/main_generic_templates/text_templates/display_text.dart';

import '../../config/theme.dart';
import '../../templates/main_generic_templates/app_bars/app_bar.dart';
import 'authentication_selection.dart';

class LoginNumberScreen extends StatefulWidget {
  static const routeName = '/loginNumberEnter-screen';

  const LoginNumberScreen({Key? key}) : super(key: key);

  @override
  State<LoginNumberScreen> createState() => _LoginNumberScreenState();
}

class _LoginNumberScreenState extends State<LoginNumberScreen> {
  LatLng userlocation = LatLng(9.0, 7.9);
  bool progres = false;

  @override
  void initState() {
    errorValidatorShow = false;
    phoneNumberController = TextEditingController();
    _requestPermissionAndGetCurrentLocation();
    super.initState();
  }
  Future<void> _requestPermissionAndGetCurrentLocation() async {
    if(userLiveLocation().userlivelocation!=null){
      print("User Live Location: ${userLiveLocation().userlivelocation}");
    }else{
      try {
        print("Permission Request Started");
        // Request location permission
        var status = await Permission.location.request();
        print('Accepted Request of Location');
        if (status.isGranted) {
          // Get the current location
          Position position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high,
          );
          LatLng currentLocation = LatLng(position.latitude, position.longitude);
          setState(() {
            userlocation = currentLocation;
            userLiveLocation().userlivelocation = userlocation;
          });
          print("User Live Location: $userlocation");
        } else {
          // Show snackbar to inform the user
          Get.snackbar(
            'Location Permission',
            'Location permission is required to continue. Please enable it.',
            snackPosition: SnackPosition.TOP,
            backgroundColor: themeColor,
            colorText: Colors.white,
            margin: const EdgeInsets.all(10),
            duration: const Duration(seconds: 3),
          );
        }
      } catch (e) {
        print("Error in _requestPermissionAndGetCurrentLocation: $e");
      }
    }
  }
  String number = '';
@override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    phoneNumberController.dispose();
  }
  @override
  Widget build(BuildContext context) {
    Widget logoDisplay() {
      return SizedBox(
        height: 130,
        child: Image.asset(
          "assets/images/SplashScreenLogo.png",
          fit: BoxFit.contain,
        ),
      );
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: GenericAppBars.appBarWithBackButtonOnly(context, false),
      body: Center(
        child: SizedBox(
          height: ScreenConfig.screenSizeHeight * 1.2,
          width: ScreenConfig.screenSizeWidth * 0.9,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  spaceHeight(ScreenConfig.screenSizeHeight * 0.15),
                  logoDisplay(),
                ],
              ),
              spaceHeight(ScreenConfig.screenSizeHeight * 0.02),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  displayText(
                    "Login",
                    ScreenConfig.theme.textTheme.displayLarge
                        ?.copyWith(color: Colors.black.withOpacity(0.5)),
                  ),
                  spaceHeight(ScreenConfig.screenSizeHeight * 0.02),
                  displayText("Enter phone number with country extension.",
                      ScreenConfig.theme.textTheme.displaySmall),
                  spaceHeight(ScreenConfig.screenSizeHeight * 0.02),
                  IntlPhoneField(
                    keyboardType: TextInputType.number,
                    controller: phoneNumberController,
                    decoration: InputDecoration(
                      hintText: 'Enter Phone Number',
                      border: OutlineInputBorder(
                        borderSide: BorderSide(),
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
                    style: TextStyle(color: Colors.black, fontSize: 20),
                  ),
                  spaceHeight(ScreenConfig.screenSizeHeight * 0.03),
                  Buttons.longWidthButton(
                      progres
                          ? Container(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ))
                          : Text(
                              'Login',
                              style: ScreenConfig.theme.textTheme.titleSmall
                                  ?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w300),
                            ), () {
                    if (!errorValidatorShow) {
                      DebugHelper.printAll("Initiate Print");
                      Navigator.pushNamed(
                          context, OTPVerificationScreen.routeName,
                          arguments: {'number': number});
                    }
                  }),
                ],
              ),
              spaceHeight(ScreenConfig.screenSizeHeight * 0.02),
            ],
          ),
        ),
      ),
    );
  }
}
