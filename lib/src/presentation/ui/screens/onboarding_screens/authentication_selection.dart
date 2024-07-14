import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:ridely/src/infrastructure/screen_config/screen_config.dart';
import 'package:ridely/src/presentation/ui/config/debug_helper.dart';
import 'package:ridely/src/presentation/ui/screens/onboarding_screens/login.dart';
import 'package:ridely/src/presentation/ui/screens/onboarding_screens/login_number_screen.dart';
import 'package:ridely/src/presentation/ui/screens/onboarding_screens/otp_verification_screen.dart';
import 'package:ridely/src/presentation/ui/screens/onboarding_screens/register_screens/choice_customer_driver.dart';
import 'package:ridely/src/presentation/ui/screens/onboarding_screens/register_screens/passangerregistration.dart';
import 'package:ridely/src/presentation/ui/templates/main_generic_templates/app_buttons/buttons.dart';
import 'package:ridely/src/presentation/ui/templates/main_generic_templates/spacing_widgets.dart';
import 'package:ridely/src/presentation/ui/templates/main_generic_templates/text_fields/phone_number_textfield.dart';
import 'package:ridely/src/presentation/ui/templates/main_generic_templates/text_templates/display_text.dart';

import '../../config/theme.dart';

class AuthenticationSelection extends StatefulWidget {
  static const routeName = '/loginNumberEnter-screen';
  const AuthenticationSelection({Key? key}) : super(key: key);

  @override
  State<AuthenticationSelection> createState() => _AuthenticationSelectionState();
}

class _AuthenticationSelectionState extends State<AuthenticationSelection> {
  LatLng userlocation = LatLng(9.0, 7.9);
  @override
  void initState() {
    errorValidatorShow = true;
    phoneNumberController = TextEditingController();
    _requestPermissionAndGetCurrentLocation();
    super.initState();
  }
  Future<void> _requestPermissionAndGetCurrentLocation() async {
    // Check if location permission is granted
    print("1122Permission Start");
    var status = await Permission.location.request();
    if (status.isGranted) {
      // Get current position
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      print("1122Permission Accepted $position");
      // Update the map to show the user's current location
      userlocation = LatLng(position.latitude, position.longitude);
      setState(() {
        print("User Live Location in Pick Widget: $userlocation");
        userLiveLocation().userlivelocation=userlocation;
      });
    } else {
      print('Location permission denied');
      /*ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Center(
            child: Text(
              'Please Give You Live Location',style: TextStyle(fontSize: 15,color: Colors.white),),
          ),
          backgroundColor: Colors.black,
          behavior: SnackBarBehavior.floating,
        ),
      );*/
      Get.snackbar(
        'Location Permission',
        'Please Give You Live Location',
        snackPosition: SnackPosition.TOP,
        backgroundColor: themeColor,
        colorText: Colors.white,
        margin: EdgeInsets.all(10),
        duration: Duration(seconds: 3),
      );
      _requestPermissionAndGetCurrentLocation();
    }
  }
  @override
  Widget build(BuildContext context) {
    Widget logoDisplay() {
      return SizedBox(
        height: ScreenConfig.screenSizeHeight *0.15,
        child: Image.asset(
          "assets/images/SplashScreenLogo.png",
          fit: BoxFit.contain,
        ),
      );
    }
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Center(
          child: SizedBox(
            height: ScreenConfig.screenSizeHeight * 1.2,
            width: ScreenConfig.screenSizeWidth * 0.9,
            child: Column(
              children: [
                Center(
                  child: Column(
                    children: [
                      spaceHeight(ScreenConfig.screenSizeHeight * 0.25),
                      logoDisplay(),
                    ],
                  ),
                ),
                spaceHeight(ScreenConfig.screenSizeHeight * 0.1),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Buttons.longWidthButton( Text(
                      'Sign-Up/Register',
                      style: ScreenConfig.theme.textTheme.headline6?.copyWith(
                          color: Colors.white, fontWeight: FontWeight.w300),
                    ), () {
                      Navigator.of(context)
                          .pushNamed(ChoiceCustomerDriverScreen.routeName);
                    }),
                    spaceHeight(ScreenConfig.screenSizeHeight * 0.02),
                    Buttons.longWidthButton(Text(
                      'Login with Email',
                      style: ScreenConfig.theme.textTheme.headline6?.copyWith(
                          color: Colors.white, fontWeight: FontWeight.w300),
                    ), () {
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (context)=>Login()));
                    }),
                    spaceHeight(ScreenConfig.screenSizeHeight * 0.02),
                    Buttons.longWidthButton(Text(
                      'Login with Phone Number',
                      style: ScreenConfig.theme.textTheme.headline6?.copyWith(
                          color: Colors.white, fontWeight: FontWeight.w300),
                    ), () {
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (context)=>LoginNumberScreen()));
                    }),
                    spaceHeight(ScreenConfig.screenSizeHeight * 0.03),

                  ],
                ),
                spaceHeight(ScreenConfig.screenSizeHeight * 0.2),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
class userLiveLocation {
  static final userLiveLocation _instance = userLiveLocation._internal();

  factory userLiveLocation() {
    return _instance;
  }

  userLiveLocation._internal();
  LatLng? userlivelocation;
}
