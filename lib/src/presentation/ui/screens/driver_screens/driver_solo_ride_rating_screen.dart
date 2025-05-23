import 'package:flutter/material.dart';
import 'package:ridely/src/infrastructure/screen_config/screen_config.dart';
import 'package:ridely/src/presentation/ui/screens/booking_screens/ride_selection_screen.dart';
import 'package:ridely/src/presentation/ui/screens/driver_screens/driver_main_screen.dart';
import 'package:ridely/src/presentation/ui/screens/onboarding_screens/authentication_selection.dart';
import 'package:ridely/src/presentation/ui/templates/decorations/box_decoration_templates.dart';
import 'package:ridely/src/presentation/ui/templates/main_generic_templates/app_bars/app_bar.dart';
import 'package:ridely/src/presentation/ui/templates/main_generic_templates/app_buttons/buttons.dart';
import 'package:ridely/src/presentation/ui/templates/main_generic_templates/booking_widgets/map_widgets.dart';
import 'package:ridely/src/presentation/ui/templates/main_generic_templates/other_widgets/slider_for_bottom_navigation.dart';
import 'package:ridely/src/presentation/ui/templates/main_generic_templates/spacing_widgets.dart';
import 'package:ridely/src/presentation/ui/templates/ride_widgets/driver_ride_detail_widgets.dart';
import 'package:ridely/src/presentation/ui/templates/ride_widgets/ride_detail_widgets.dart';

class DriverSoloRideRatingScreen extends StatefulWidget {
  const DriverSoloRideRatingScreen({Key? key}) : super(key: key);
  static const routeName = '/driversoloriderating-screen';

  @override
  State<DriverSoloRideRatingScreen> createState() =>
      _DriverSoloRideRatingScreenState();
}

class _DriverSoloRideRatingScreenState
    extends State<DriverSoloRideRatingScreen> {
  TextEditingController pickupEnterController = TextEditingController();
  TextEditingController dropoffEnterController = TextEditingController();
  int fare=0;
  String rideId='';
  String image = "assets/images/RideFinishedScreenMap.png";
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Retrieve pickup and drop-off locations from arguments after dependencies change
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    if (args != null) {
      setState(() {
        fare = args['fare']!;
        rideId=args['rideId'];
        print("data of eve 222:  $fare $rideId");
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    Widget bottomModalNonSlideable() {
      return Container(
        height: ScreenConfig.screenSizeHeight * 0.34,
        width: ScreenConfig.screenSizeWidth,
        decoration: bottomModalTemplate(),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: SizedBox(
            width: ScreenConfig.screenSizeWidth * 0.9,
            child: Column(
              children: [
                sliderBar(),
                spaceHeight(ScreenConfig.screenSizeHeight * 0.02),
                driverRideRatingWidget(context,fare,rideId),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.white,
      body: GestureDetector(
        onTap: () {
          Navigator.of(context).pushReplacementNamed(
              DriverRideSelectionScreen.routeName);
        },
        child: Stack(
          alignment: AlignmentDirectional.bottomCenter,
          children: [
            SizedBox(
              height: ScreenConfig.screenSizeHeight * 1.2,
              child: Column(
                children: [
                  MapScreen(
                    check: false,
                      search: [],
                      showAds: false,
                      showTextFields: true,
                      isFieldsReadOnly: true,
                      isFullScreen: false,
                      isShowMyLocationIcon: false,
                      image: image,
                      hintFieldOne: "Pick-Up Location",
                      fieldOneButtonFunction: () {},
                      suffixIconFieldOne: SizedBox(
                        height: 60,
                        width: 50,
                        child: Row(
                          children: [
                            Buttons.smallSquareButton(
                                "assets/images/CircularIconButton.png", () {}),
                          ],
                        ),
                      ),
                      fieldOneController: pickupEnterController,
                      isDisplayFieldTwo: true,
                      hintFieldTwo: "Drop Off Location",
                      fieldTwoButtonFunction: () {},
                      suffixIconFieldTwo: SizedBox(
                        height: 60,
                        width: 50,
                        child: Row(
                          children: [
                            Buttons.smallSquareButton(
                                "assets/images/PinPointIcon.png", () {}),
                          ],
                        ),
                      ),
                      fieldTwoController: dropoffEnterController),

                  // mapWidget(
                  //     showTextFields: false,
                  //     isFieldsReadOnly: true,
                  //     isFullScreen: false,
                  //     isShowMyLocationIcon: false,
                  //     image: image,
                  //     hintFieldOne: "Pick-Up Location",
                  //     fieldOneButtonFunction: () {},
                  //     suffixIconFieldOne: SizedBox(
                  //       height: 60,
                  //       width: 50,
                  //       child: Row(
                  //         children: [
                  //           Buttons.smallSquareButton(
                  //               "assets/images/CircularIconButton.png", () {}),
                  //         ],
                  //       ),
                  //     ),
                  //     fieldOneController: pickupEnterController,
                  //     isDisplayFieldTwo: true,
                  //     hintFieldTwo: "Drop Off Location",
                  //     fieldTwoButtonFunction: () {},
                  //     suffixIconFieldTwo: SizedBox(
                  //       height: 60,
                  //       width: 50,
                  //       child: Row(
                  //         children: [
                  //           Buttons.smallSquareButton(
                  //               "assets/images/PinPointIcon.png", () {}),
                  //         ],
                  //       ),
                  //     ),
                  //     fieldTwoController: dropoffEnterController),
                  spaceHeight(
                    ScreenConfig.screenSizeHeight * 0.2,
                  )
                ],
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                spaceHeight(ScreenConfig.screenSizeHeight * 0.04),
                bottomModalNonSlideable(),
              ],
            )
          ],
        ),
      ),
    );
  }
}
