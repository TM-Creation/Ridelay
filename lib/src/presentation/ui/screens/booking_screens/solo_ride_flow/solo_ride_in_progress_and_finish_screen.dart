import 'package:flutter/material.dart';
import 'package:ridely/src/infrastructure/screen_config/screen_config.dart';
import 'package:ridely/src/presentation/ui/screens/booking_screens/ride_rating_screen.dart';
import 'package:ridely/src/presentation/ui/screens/booking_screens/solo_ride_flow/solo_ride_rating_screen.dart';

import 'package:ridely/src/presentation/ui/templates/decorations/box_decoration_templates.dart';
import 'package:ridely/src/presentation/ui/templates/main_generic_templates/app_bars/app_bar.dart';
import 'package:ridely/src/presentation/ui/templates/main_generic_templates/app_buttons/buttons.dart';
import 'package:ridely/src/presentation/ui/templates/main_generic_templates/booking_widgets/map_widgets.dart';
import 'package:ridely/src/presentation/ui/templates/main_generic_templates/other_widgets/slider_for_bottom_navigation.dart';
import 'package:ridely/src/presentation/ui/templates/main_generic_templates/spacing_widgets.dart';
import 'package:ridely/src/presentation/ui/templates/main_generic_templates/text_templates/display_text.dart';
import 'package:ridely/src/presentation/ui/templates/ride_widgets/ride_detail_widgets.dart';

class SoloRideInProgressAndFinishedScreen extends StatefulWidget {
  const SoloRideInProgressAndFinishedScreen({Key? key}) : super(key: key);
  static const routeName = '/solorideinprogressandfinished-screen';

  @override
  State<SoloRideInProgressAndFinishedScreen> createState() =>
      _SoloRideInProgressAndFinishedScreenState();
}

class _SoloRideInProgressAndFinishedScreenState
    extends State<SoloRideInProgressAndFinishedScreen> {
  int currentIndex = -1;
  TextEditingController pickupEnterController = TextEditingController();
  TextEditingController dropoffEnterController = TextEditingController();
  String image = "assets/images/LocationDistanceScreenMap.png";
  List namesList = ["Mini", "Go", "Comfort", "Mini"];
  bool inProgress = true;

  @override
  void initState() {
    pickupEnterController.text = "Gulberg Phase II";
    dropoffEnterController.text = "Bahria Town";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget bottomModalNonSlideable() {
      return Container(
        height: ScreenConfig.screenSizeHeight * 0.42,
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
                Container(
                  height: 35,
                  width: 35,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    image: DecorationImage(
                        image: AssetImage("assets/images/AppIcon.png"),
                        fit: BoxFit.contain),
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                  ),
                ),
                spaceHeight(ScreenConfig.screenSizeHeight * 0.02),
                inProgress
                    ? rideDetailsInProgressAndFinishedWidget(
                        "Your Ride Is In Progress", context)
                    : rideDetailsInProgressAndFinishedWidget(
                        "Your Ride Is Finished", context),
                spaceHeight(ScreenConfig.screenSizeHeight * 0.02),
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
      appBar: GenericAppBars.appBarWithBackButtonOnly(context, false),
      body: GestureDetector(
        onTap: () {
          if (inProgress) {
            setState(() {
              inProgress = false;
              image = "assets/images/RideFinishedScreenMap.png";
            });
          } else if (!inProgress) {
            Navigator.of(context).pushNamed(SoloRideRatingScreen.routeName);
          }
        },
        child: Stack(
          alignment: AlignmentDirectional.bottomCenter,
          children: [
            SizedBox(
              height: ScreenConfig.screenSizeHeight * 1.2,
              child: Column(
                children: [
                  MapScreen(
                    check: true,
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
