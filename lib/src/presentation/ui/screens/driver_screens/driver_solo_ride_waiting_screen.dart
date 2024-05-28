import 'package:flutter/material.dart';
import 'package:ridely/src/infrastructure/screen_config/screen_config.dart';
import 'package:ridely/src/presentation/ui/config/theme.dart';
import 'package:ridely/src/presentation/ui/screens/booking_screens/solo_ride_flow/solo_ride_in_progress_and_finish_screen.dart';
import 'package:ridely/src/presentation/ui/screens/driver_screens/driver_solo_ride_in_progress_and_finished_screen.dart';

import 'package:ridely/src/presentation/ui/templates/decorations/box_decoration_templates.dart';
import 'package:ridely/src/presentation/ui/templates/main_generic_templates/app_bars/app_bar.dart';
import 'package:ridely/src/presentation/ui/templates/main_generic_templates/app_buttons/buttons.dart';
import 'package:ridely/src/presentation/ui/templates/main_generic_templates/booking_widgets/map_widgets.dart';
import 'package:ridely/src/presentation/ui/templates/main_generic_templates/other_widgets/slider_for_bottom_navigation.dart';
import 'package:ridely/src/presentation/ui/templates/main_generic_templates/spacing_widgets.dart';
import 'package:ridely/src/presentation/ui/templates/ride_widgets/driver_ride_detail_widgets.dart';
import 'package:ridely/src/presentation/ui/templates/ride_widgets/ride_detail_widgets.dart';

import '../../templates/main_generic_templates/text_templates/display_text.dart';
import '../../templates/previous_rides_screens_widgets/user_details_container.dart';
import '../../templates/ride_widgets/ride_widget_buttons.dart';

class DriverSoloRideWaitingScreen extends StatefulWidget {
  const DriverSoloRideWaitingScreen({Key? key}) : super(key: key);
  static const routeName = '/driversoloridewaiting-screen';

  @override
  State<DriverSoloRideWaitingScreen> createState() =>
      _DriverSoloRideWaitingScreenState();
}

class _DriverSoloRideWaitingScreenState
    extends State<DriverSoloRideWaitingScreen> {
  int currentIndex = -1;
  TextEditingController pickupEnterController = TextEditingController();
  TextEditingController dropoffEnterController = TextEditingController();
  String image = "assets/images/LocationDistanceScreenMap.png";
  List namesList = ["Mini", "Go", "Comfort", "Mini"];

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
                Column(
                  children: [
                    Container(
                      // height: ScreenConfig.screenSizeHeight * 0.26,
                      width: ScreenConfig.screenSizeWidth * 0.9,
                      decoration: blueContainerTemplate(),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: ScreenConfig.screenSizeHeight * 0.02,
                            horizontal: ScreenConfig.screenSizeWidth * 0.05),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      height: 35,
                                      width: 35,
                                      decoration: squareButtonTemplate(radius: 8),
                                      child: Padding(
                                        padding: const EdgeInsets.all(3.0),
                                        child: Image.asset("assets/images/CarIconColored.png",
                                            fit: BoxFit.contain),
                                      ),
                                    ),
                                    spaceWidth(ScreenConfig.screenSizeWidth * 0.03),
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        displayText('Mini', ScreenConfig.theme.textTheme.button,
                                            width: 0.3),
                                        displayText(
                                            "1-8 mins",
                                            ScreenConfig.theme.textTheme.button
                                                ?.copyWith(fontSize: 9),
                                            width: 0.3),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            spaceHeight(ScreenConfig.screenSizeHeight * 0.01),
                            displayText(
                                "Please Hurry! Your Customer is Waiting",
                                ScreenConfig.theme.textTheme.button,
                                width: 0.8),
                            spaceHeight(ScreenConfig.screenSizeHeight * 0.01),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    userDetailsContainer("assets/images/UserProfileImage.png",
                                        "Altaf Ahmed", "4.9", true, false, " "),
                                    spaceHeight(ScreenConfig.screenSizeHeight * 0.02),
                                    // userDetailsContainer("assets/images/UserCarImage.png",
                                    //     "Honda Civic", "LXV 5675", false, true, "2019")
                                  ],
                                ),
                                SizedBox(
                                  width: ScreenConfig.screenSizeWidth * 0.22,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          smallSquareButton(
                                              "assets/images/PhoneIcon.png", () {}),
                                          smallSquareButton(
                                              "assets/images/EmailIcon.png", () {}),
                                        ],
                                      ),
                                      spaceHeight(ScreenConfig.screenSizeHeight * 0.01),
                                      displayText("15km Remaining",
                                          ScreenConfig.theme.textTheme.bodyText2,
                                          textAlign: TextAlign.center, width: 0.22),
                                      spaceHeight(ScreenConfig.screenSizeHeight * 0.01),
                                      GestureDetector(
                                        onTap: (){},
                                        child: Container(
                                          width: ScreenConfig.screenSizeWidth * 0.25,
                                          decoration: BoxDecoration(
                                              color: redFourthColor,
                                              borderRadius: const BorderRadius.all(Radius.circular(5)),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.grey.withOpacity(0.40),
                                                  offset: const Offset(0.0, 1.2), //(x,y)
                                                  blurRadius: 6.0,
                                                )
                                              ]),
                                          child: Padding(
                                              padding: const EdgeInsets.all(5.0),
                                              child: displayNoSizedText(
                                                  'Cancel Ride',
                                                  ScreenConfig.theme.textTheme.caption
                                                      ?.copyWith(color: ScreenConfig.theme.primaryColor,fontWeight: FontWeight.bold),
                                                  textAlign: TextAlign.center)),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                    spaceHeight(ScreenConfig.screenSizeHeight * 0.015),
                  ],
                ),
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
          Navigator.of(context)
              .pushNamed(DriverSoloRideInProgressAndFinishedScreen.routeName);
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
                      showAds: false,
                      search: [],
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
