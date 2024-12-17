import 'package:five_pointed_star/five_pointed_star.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:ridely/src/infrastructure/screen_config/screen_config.dart';
import 'package:ridely/src/presentation/ui/screens/booking_screens/ride_selection_screen.dart';
import 'package:ridely/src/presentation/ui/screens/booking_screens/solo_ride_flow/solo_ride_waiting_screen.dart';
import 'package:ridely/src/presentation/ui/screens/onboarding_screens/register_screens/passangerregistration.dart';
import 'package:ridely/src/presentation/ui/templates/decorations/box_decoration_templates.dart';
import 'package:ridely/src/presentation/ui/templates/main_generic_templates/spacing_widgets.dart';
import 'package:ridely/src/presentation/ui/templates/main_generic_templates/text_templates/display_text.dart';
import 'package:ridely/src/presentation/ui/templates/previous_rides_screens_widgets/user_details_container.dart';
import 'package:ridely/src/presentation/ui/templates/ride_widgets/ride_widget_buttons.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../../../models/base url.dart';
import '../../../../models/passenger_rating_model/passenger_to_driver_rating.dart';
import '../../config/theme.dart';
String feedBack = "";
int mycount = 0;
TextEditingController feedBackController = TextEditingController();
class RatiangStaric extends StatefulWidget {
  const RatiangStaric({key});

  @override
  State<RatiangStaric> createState() => _RatiangStaricState();
}

class _RatiangStaricState extends State<RatiangStaric> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        children: [
          FivePointedStar(
            onChange: (count) {
              setState(() {
                mycount = count;
              });
            },
          ),
        ],
      ),
    );
  }
}

Widget rideDetailsWidget(String name, String buttonType, BuildContext context) {
  return Column(
    children: [
      Container(
        // height: ScreenConfig.screenSizeHeight * 0.26,
        width: ScreenConfig.screenSizeWidth * 0.85,
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
                          displayText(name, ScreenConfig.theme.textTheme.labelLarge,
                              width: 0.3),
                          displayText(
                              "1-8 mins",
                              ScreenConfig.theme.textTheme.labelLarge
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
                          ScreenConfig.theme.textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                          textAlign: TextAlign.end,
                          width: 0.2),
                    ),
                ],
              ),
              spaceHeight(ScreenConfig.screenSizeHeight * 0.01),
              displayText(
                  buttonType == "Confirm Partner"
                      ? "You Found A Partner!"
                      : buttonType == "Cancel Ride"
                          ? "Hold Tight ! Your Ride Is Coming"
                          : " ",
                  ScreenConfig.theme.textTheme.labelLarge,
                  width: 0.8),
              spaceHeight(ScreenConfig.screenSizeHeight * 0.01),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      userDetailsContainer(
                        "assets/images/UserProfileImage.png",
                        "Altaf Ahmed",
                        "4.9",
                        true,
                      ),
                      spaceHeight(ScreenConfig.screenSizeHeight * 0.02),
                      userDetailsContainer(
                        "assets/images/UserCarImage.png",
                        "Honda Civic",
                        "LXV 5675",
                        false,
                      )
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
                            ScreenConfig.theme.textTheme.bodyMedium,
                            textAlign: TextAlign.center, width: 0.22),
                        spaceHeight(ScreenConfig.screenSizeHeight * 0.01),
                        rectangleSquareButton(buttonType, () {
                          if (buttonType == "Confirm Partner") {
                            Navigator.of(context)
                                .pushNamed(SoloRideWaitingScreen.routeName);
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

Widget rideDetailsInProgressAndFinishedWidget(
    String name,
    BuildContext context,
    String distance,
    String ETA,
    String drivername,
    double driverraiting,
    String vahiclename,
    String vehicleImage,
    String driverImage,
    String numberplate) {
  return Column(
    children: [
      Container(
        // height: ScreenConfig.screenSizeHeight * 0.26,
        width: ScreenConfig.screenSizeWidth * 0.85,
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
                  ScreenConfig.theme.textTheme.displayLarge
                      ?.copyWith(color: Colors.white),
                  width: 0.8),
              spaceHeight(ScreenConfig.screenSizeHeight * 0.02),
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    displayText("Distance Remaining",
                        ScreenConfig.theme.textTheme.labelLarge,
                        width: 0.4),
                    displayText(
                        "$distance", ScreenConfig.theme.textTheme.labelLarge,
                        width: 0.2),
                  ]),
              spaceHeight(ScreenConfig.screenSizeHeight * 0.01),
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    displayText(
                        "Estimated Time", ScreenConfig.theme.textTheme.labelLarge,
                        width: 0.4),
                    displayText("$ETA", ScreenConfig.theme.textTheme.labelLarge,
                        width: 0.2),
                  ]),
              spaceHeight(ScreenConfig.screenSizeHeight * 0.03),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  userDetailsContainer(
                    driverImage,
                    "$drivername",
                    "$driverraiting",
                    true,
                  ),
                  userDetailsContainer(
                    vehicleImage,
                    "$vahiclename",
                    "$numberplate",
                    false,
                  )
                ],
              ),
              spaceHeight(ScreenConfig.screenSizeHeight * 0.015),
              Center(
                child: GestureDetector(
                  onTap: (){},
                  child: Container(
                    width: ScreenConfig.screenSizeWidth *
                        0.5,
                    decoration: BoxDecoration(
                        color: thirdColor,
                        borderRadius:
                        const BorderRadius.all(
                            Radius.circular(5)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey
                                .withOpacity(0.40),
                            offset: const Offset(
                                0.0, 1.2), //(x,y)
                            blurRadius: 6.0,
                          )
                        ]),
                    child: Padding(
                        padding:
                        const EdgeInsets.all(5.0),
                        child: displayNoSizedText(
                            'Complete Your Ride Early',
                            ScreenConfig
                                .theme.textTheme.labelSmall
                                ?.copyWith(
                                color: ScreenConfig
                                    .theme
                                    .primaryColor,
                                fontWeight:
                                FontWeight.bold,fontSize: 10),
                            textAlign: TextAlign.center)),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      //spaceHeight(ScreenConfig.screenSizeHeight * 0.015),
    ],
  );
}

Widget rideRatingWidget(BuildContext context, int fare,String drivername) {
  return Column(
    children: [
      Container(
        // height: ScreenConfig.screenSizeHeight * 0.26,
        width: ScreenConfig.screenSizeWidth * 0.85,
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
                  ScreenConfig.theme.textTheme.displayLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.normal,
                      fontSize: 17),
                  width: 0.8),
              spaceHeight(ScreenConfig.screenSizeHeight * 0.02),
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    displayText(
                        "Total Payed Amount",
                        ScreenConfig.theme.textTheme.displayLarge?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.normal,
                            fontSize: 15),
                        width: 0.4),
                    displayText(
                        "Rs. $fare", ScreenConfig.theme.textTheme.displayMedium,
                        textAlign: TextAlign.end, width: 0.3),
                  ]),
              spaceHeight(ScreenConfig.screenSizeHeight * 0.02),
              displayText(
                  "Please Rate Our Captain And Give Feedback",
                  ScreenConfig.theme.textTheme.displayLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.normal,
                      fontSize: 17),
                  width: 0.8),
              spaceHeight(ScreenConfig.screenSizeHeight * 0.02),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      userDetailsMiniContainer(
                          "assets/images/UserProfileImage.png", "$drivername"),
                      RatiangStaric()
                    ],
                  ),
                  spaceHeight(ScreenConfig.screenSizeHeight * 0.02),
                  Container(
                    width: ScreenConfig.screenSizeWidth * 0.9,
                    height: 60,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.40),
                            offset: const Offset(0.0, 1.2), //(x,y)
                            blurRadius: 6.0,
                          )
                        ]),
                    child: TextFormField(
                        onChanged: (value) {
                          feedBack = value;
                        },
                        textInputAction: TextInputAction.done,
                        textAlign: TextAlign.start,
                        keyboardType: TextInputType.text,
                        controller: feedBackController,
                        decoration: InputDecoration(
                            hintText: "Enter FeedBack",
                            hintStyle: ScreenConfig.theme.textTheme.titleMedium,
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.all(20)),
                        style: ScreenConfig.theme.textTheme.titleMedium),
                  ),
                  // Add FeedBack Input Field
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


Widget submitReviewPanelWidget(BuildContext context,String rideid,String driverid) {
  Future<void> submitReview(FeedbackModel feedbackModel) async {
    print("Function Run");
    baseulr burl = baseulr();
    final String url = '${burl.burl}/api/v1/feedback';
    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(feedbackModel.toJson()),
    );
    if (response.statusCode == 200) {
      print('Review submitted successfully');
      Get.snackbar(
        'Thanks for Ride with Ridelay',
        'Your Review Submitted Successfully',
        snackPosition: SnackPosition.TOP,
        backgroundColor: themeColor,
        colorText: Colors.white,
        margin: EdgeInsets.all(10),
        duration: Duration(seconds: 3),
      );
      Navigator.of(context).pushNamedAndRemoveUntil(
        VehicleSelectionScreen.routeName,(Route<dynamic> route) => false,);
    } else {
      print('Failed to submit review: ${response.statusCode} ${response.body}');
      Get.snackbar(
        'Server Error',
        'Server Not Found',
        snackPosition: SnackPosition.TOP,
        backgroundColor: themeColor,
        colorText: Colors.white,
        margin: EdgeInsets.all(10),
        duration: Duration(seconds: 3),
      );
    }
  }
  return Container(
    // height: ScreenConfig.screenSizeHeight * 0.26,
    width: ScreenConfig.screenSizeWidth * 0.85,
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
              ScreenConfig.theme.textTheme.displayLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.normal,
                  fontSize: 17),
              width: 0.3),
          Row(
            children: [
              GestureDetector(
                onTap: (){
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    VehicleSelectionScreen.routeName,(Route<dynamic> route) => false,);
                },
                child: Container(
                    height: 33,
                    width: ScreenConfig.screenSizeWidth * 0.15,
                    decoration: redContainerTemplate(radius: 5),
                    child: Center(
                      child: displayNoSizedText(
                          "No", ScreenConfig.theme.textTheme.labelLarge),
                    )),
              ),
              const SizedBox(width: 5),
              GestureDetector(
                onTap: () async {
                  print("feedBackTesting ${feedBack.toString()}");
                  print("Staric print $mycount");
                  FeedbackModel feedbackModel = FeedbackModel(
                    ride: rideid,
                    passenger: PassId().id!,
                    driver: driverid,
                    rating: mycount,
                    feedback: feedBack,
                  );
                  await submitReview(feedbackModel);
                },
                child: Container(
                    height: 33,
                    width: ScreenConfig.screenSizeWidth * 0.15,
                    decoration: brownContainerTemplate(radius: 5),
                    child: Center(
                      child: displayNoSizedText(
                          "Yes", ScreenConfig.theme.textTheme.labelLarge),
                    )),
              ),
            ],
          )
        ],
      ),
    ),
  );
}
