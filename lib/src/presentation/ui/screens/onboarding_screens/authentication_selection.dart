import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
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
    var status = await Permission.location.request();
    if (status.isGranted) {
      // Get current position
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // Update the map to show the user's current location
      userlocation = LatLng(position.latitude, position.longitude);
      setState(() {
        userLiveLocation().userlivelocation=userlocation;
      });
    } else {
      print('Location permission denied');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Center(
            child: Text(
              'Please Give You Live Location',style: TextStyle(fontSize: 15,color: Colors.white),),
          ),
          backgroundColor: Colors.black,
          behavior: SnackBarBehavior.floating,
        ),
      );
      _requestPermissionAndGetCurrentLocation();
    }
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
      body: Center(
        child: SizedBox(
          height: ScreenConfig.screenSizeHeight * 1.2,
          width: ScreenConfig.screenSizeWidth * 0.9,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                children: [
                  spaceHeight(ScreenConfig.screenSizeHeight * 0.15),
                  logoDisplay(),
                  spaceHeight(ScreenConfig.screenSizeHeight * 0.05),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Buttons.longWidthButton("Sign-Up/Register", () {
                    Navigator.of(context)
                        .pushNamed(ChoiceCustomerDriverScreen.routeName);
                  }),
                  spaceHeight(ScreenConfig.screenSizeHeight * 0.02),
                  Buttons.longWidthButton("Login with Email", () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context)=>Login()));
                  }),
                  spaceHeight(ScreenConfig.screenSizeHeight * 0.02),
                  Buttons.longWidthButton("Login with Phone Number", () {
                    Navigator.of(context)
                        .pushNamed(LoginNumberScreen.routeName);
                  }),
                  spaceHeight(ScreenConfig.screenSizeHeight * 0.03),

                ],
              ),
              spaceHeight(ScreenConfig.screenSizeHeight * 0.2),
            ],
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
