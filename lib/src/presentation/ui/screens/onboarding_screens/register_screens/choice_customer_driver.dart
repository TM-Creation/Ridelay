import 'package:flutter/material.dart';
import 'package:ridely/src/infrastructure/screen_config/screen_config.dart';
import 'package:ridely/src/presentation/ui/screens/onboarding_screens/login_number_screen.dart';
import 'package:ridely/src/presentation/ui/screens/onboarding_screens/register_screens/register_driver_vehicle_info_screen.dart';
import 'package:ridely/src/presentation/ui/templates/main_generic_templates/app_bars/app_bar.dart';
import 'package:ridely/src/presentation/ui/templates/main_generic_templates/app_buttons/buttons.dart';
import 'package:ridely/src/presentation/ui/templates/main_generic_templates/snack_bars/custom_snack_bar.dart';
import 'package:ridely/src/presentation/ui/templates/main_generic_templates/spacing_widgets.dart';
import 'package:ridely/src/presentation/ui/templates/main_generic_templates/text_templates/display_text.dart';

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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: GenericAppBars.appBarWithBackButtonOnly(context, false),
      body: SizedBox(
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
                    ScreenConfig.theme.textTheme.headline6
                        ?.copyWith(fontWeight: FontWeight.w500),
                    textAlign: TextAlign.center),
                spaceHeight(ScreenConfig.screenSizeHeight * 0.02),
                Buttons.squareLargeSelectionScreenButton(
                    "assets/images/Customer.png",
                    "Customer",
                    "Register as a Customer", () {
                  ScaffoldMessenger.of(context).showSnackBar(showSnackbar(
                      "You have been registered successfully. Please login to book a ride."));
                  Future.delayed(const Duration(seconds: 3), () {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                        LoginNumberEnterScreen.routeName,
                        ModalRoute.withName("/"));
                  });

                  // Navigator.pushNamed(context, RideSelectionScreen.routeName);
                  // Navigator.of(context).pushNamed(VehicleSelectionScreen.routeName);
                }),
                spaceHeight(ScreenConfig.screenSizeHeight * 0.02),
                displayText(
                    'Or a',
                    ScreenConfig.theme.textTheme.headline6
                        ?.copyWith(fontWeight: FontWeight.w500),
                    textAlign: TextAlign.center),
                spaceHeight(ScreenConfig.screenSizeHeight * 0.02),
                Buttons.squareLargeSelectionScreenButton(
                    "assets/images/DriverAsset.png",
                    "Driver",
                    "Register as a Driver", () {
                  Navigator.of(context)
                      .pushNamed(RegisterDriverVehicleInfoScreen.routeName);
                }),
                spaceHeight(ScreenConfig.screenSizeHeight * 0.07),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
