import 'package:flutter/material.dart';
import 'package:ridely/src/infrastructure/screen_config/screen_config.dart';
import 'package:ridely/src/presentation/ui/screens/booking_screens/solo_ride_flow/solo_ride_waiting_screen.dart';
import 'package:ridely/src/presentation/ui/screens/driver_screens/driver_solo_ride_waiting_screen.dart';
import 'package:ridely/src/presentation/ui/templates/decorations/box_decoration_templates.dart';
import 'package:ridely/src/presentation/ui/templates/main_generic_templates/spacing_widgets.dart';
import 'package:ridely/src/presentation/ui/templates/main_generic_templates/text_templates/display_text.dart';
import 'package:ridely/src/presentation/ui/templates/previous_rides_screens_widgets/user_details_container.dart';
import 'package:ridely/src/presentation/ui/templates/ride_widgets/ride_widget_buttons.dart';

Widget driverRideDetailsWidget(
    String name, String buttonType, BuildContext context) {
  return Column(
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
                          displayText(name, ScreenConfig.theme.textTheme.button,
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
                  if (buttonType == "Cancel Ride")
                    Padding(
                      padding: const EdgeInsets.only(bottom: 5.0),
                      child: displayText(
                          "Rs. 290",
                          ScreenConfig.theme.textTheme.headline5
                              ?.copyWith(fontWeight: FontWeight.bold),
                          textAlign: TextAlign.end,
                          width: 0.3),
                    ),
                ],
              ),
              spaceHeight(ScreenConfig.screenSizeHeight * 0.01),
              displayText(
                  buttonType == "Confirm Rider"
                      ? "You Found A Rider!"
                      : buttonType == "Cancel Ride"
                          ? "Please Hurry ! Your Customer is Waiting"
                          : " ",
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
                        driverRectangleSquareButton(buttonType, () {
                          if (buttonType == "Confirm Rider") {
                            Navigator.of(context).pushNamed(
                                DriverSoloRideWaitingScreen.routeName);
                          }
                          if (buttonType == "Cancel Ride") {
                            Navigator.of(context).pop();
                          }
                        }),
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
  );
}

Widget driverRideDetailsInProgressAndFinishedWidget(
    String name, BuildContext context) {
  return Column(
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
              displayText(
                  name,
                  ScreenConfig.theme.textTheme.headline1
                      ?.copyWith(color: Colors.white),
                  width: 0.8),
              spaceHeight(ScreenConfig.screenSizeHeight * 0.02),
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    displayText("Distance Remaining",
                        ScreenConfig.theme.textTheme.button,
                        width: 0.5),
                    displayText("5 km", ScreenConfig.theme.textTheme.button,
                        width: 0.3),
                  ]),
              spaceHeight(ScreenConfig.screenSizeHeight * 0.01),
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    displayText("ETA", ScreenConfig.theme.textTheme.button,
                        width: 0.5),
                    displayText("8 mins", ScreenConfig.theme.textTheme.button,
                        width: 0.3),
                  ]),
              spaceHeight(ScreenConfig.screenSizeHeight * 0.03),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  userDetailsContainer("assets/images/UserProfileImage.png",
                      "Altaf Ahmed", "4.9", true, false, " "),
                  spaceHeight(ScreenConfig.screenSizeHeight * 0.02),
                  // userDetailsContainer("assets/images/UserCarImage.png",
                  //     "Honda Civic", "LXV 5675", false, true, "2019")
                ],
              ),
            ],
          ),
        ),
      ),
      spaceHeight(ScreenConfig.screenSizeHeight * 0.015),
    ],
  );
}

Widget driverRideRatingWidget(BuildContext context) {
  return Column(
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
              displayText(
                  "Thank You For Riding With Ridelay!",
                  ScreenConfig.theme.textTheme.headline1?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.normal,
                      fontSize: 17),
                  width: 0.8),
              spaceHeight(ScreenConfig.screenSizeHeight * 0.02),
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    displayText("Total Payed Amount",
                        ScreenConfig.theme.textTheme.headline2,
                        width: 0.5),
                    displayText(
                        "Rs. 1290", ScreenConfig.theme.textTheme.headline2,
                        textAlign: TextAlign.end, width: 0.3),
                  ]),
              spaceHeight(ScreenConfig.screenSizeHeight * 0.02),
              displayText(
                  "Please Rate Our Rider",
                  ScreenConfig.theme.textTheme.headline1?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.normal,
                      fontSize: 17),
                  width: 0.8),
              spaceHeight(ScreenConfig.screenSizeHeight * 0.02),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  userDetailsMiniContainer(
                      "assets/images/UserProfileImage.png", "Altaf"),
                  spaceHeight(ScreenConfig.screenSizeHeight * 0.02),
                  // userDetailsMiniContainer(
                  //     "assets/images/UserCarImage.png", "Honda. C"),
                ],
              ),
            ],
          ),
        ),
      ),
      spaceHeight(ScreenConfig.screenSizeHeight * 0.015),
    ],
  );
}

Widget driverSubmitReviewPanelWidget(BuildContext context) {
  return Container(
    // height: ScreenConfig.screenSizeHeight * 0.26,
    width: ScreenConfig.screenSizeWidth * 0.9,
    decoration: blueContainerTemplate(),
    child: Padding(
      padding: EdgeInsets.symmetric(
          vertical: ScreenConfig.screenSizeHeight * 0.02,
          horizontal: ScreenConfig.screenSizeWidth * 0.05),
      child: Row(
        // crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          displayText(
              "Submit Review",
              ScreenConfig.theme.textTheme.headline1?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.normal,
                  fontSize: 17),
              width: 0.4),
          Row(
            children: [
              Container(
                  height: 33,
                  width: ScreenConfig.screenSizeWidth * 0.15,
                  decoration: redContainerTemplate(radius: 5),
                  child: Center(
                    child: displayNoSizedText(
                        "No", ScreenConfig.theme.textTheme.button),
                  )),
              const SizedBox(width: 5),
              Container(
                  height: 33,
                  width: ScreenConfig.screenSizeWidth * 0.15,
                  decoration: brownContainerTemplate(radius: 5),
                  child: Center(
                    child: displayNoSizedText(
                        "Yes", ScreenConfig.theme.textTheme.button),
                  )),
            ],
          )
        ],
      ),
    ),
  );
}
