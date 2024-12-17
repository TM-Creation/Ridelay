import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:ridely/src/infrastructure/screen_config/screen_config.dart';
import 'package:ridely/src/presentation/ui/screens/onboarding_screens/authentication_selection.dart';
import 'package:ridely/src/presentation/ui/screens/onboarding_screens/register_screens/driver_registration.dart';
import 'package:ridely/src/presentation/ui/screens/onboarding_screens/register_screens/passangerregistration.dart';
import 'package:ridely/src/presentation/ui/templates/main_generic_templates/app_bars/app_bar.dart';
import 'package:ridely/src/presentation/ui/templates/main_generic_templates/app_buttons/buttons.dart';
import 'package:ridely/src/presentation/ui/templates/main_generic_templates/snack_bars/custom_snack_bar.dart';
import 'package:ridely/src/presentation/ui/templates/main_generic_templates/spacing_widgets.dart';
import 'package:ridely/src/presentation/ui/templates/main_generic_templates/text_templates/display_text.dart';

import '../../../config/theme.dart';

class ChoiceCustomerDriverScreen extends StatefulWidget {
  static const routeName = '/choiceCustomerDriver-screen';

  const ChoiceCustomerDriverScreen({Key? key}) : super(key: key);

  @override
  State<ChoiceCustomerDriverScreen> createState() =>
      _ChoiceCustomerDriverScreenState();
}

class _ChoiceCustomerDriverScreenState
    extends State<ChoiceCustomerDriverScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _requestPermissionAndGetCurrentLocation();
  }
  LatLng userlocation = LatLng(9.0, 7.9);
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: GenericAppBars.appBarWithBackButtonOnly(context, false),
      body: SingleChildScrollView(
        child: SizedBox(
          height: ScreenConfig.screenSizeHeight,
          width: ScreenConfig.screenSizeWidth,
          child: Center(
            child: SizedBox(
              width: ScreenConfig.screenSizeWidth * 0.9,
              // height: ScreenConfig.screenSizeHeight * 0.2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  displayText(
                      'Are you a',
                      ScreenConfig.theme.textTheme.titleSmall
                          ?.copyWith(fontWeight: FontWeight.w500),
                      textAlign: TextAlign.center),
                  Buttons.squareLargeSelectionScreenButton(
                      "assets/images/Customer.png",
                      "Passenger",
                      "Register as a Customer", () {
                    Navigator.of(context).pushNamed(
                      RegisterInfoScreen.routeName,
                    );
        
                    // Navigator.pushNamed(context, RideSelectionScreen.routeName);
                    // Navigator.of(context).pushNamed(VehicleSelectionScreen.routeName);
                  }),
                  displayText(
                      'Or a',
                      ScreenConfig.theme.textTheme.titleSmall
                          ?.copyWith(fontWeight: FontWeight.w500),
                      textAlign: TextAlign.center),
                  Buttons.squareLargeSelectionScreenButton(
                      "assets/images/DriverAsset.png",
                      "Driver",
                      "Register as a Driver", () {
                    Navigator.of(context)
                        .pushNamed(DriverRegistrationScreen.routeName);
                  }),
                  spaceHeight(ScreenConfig.screenSizeHeight * 0.07),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
