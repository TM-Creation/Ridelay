import 'package:five_pointed_star/five_pointed_star.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ridely/src/infrastructure/screen_config/screen_config.dart';
import 'package:ridely/src/presentation/ui/screens/past_rides_screens/driver_previous_ride_detail_screen.dart';
import 'package:ridely/src/presentation/ui/screens/past_rides_screens/previous_ride_detail_screen.dart';
import 'package:ridely/src/presentation/ui/templates/decorations/box_decoration_templates.dart';
import 'package:ridely/src/presentation/ui/templates/main_generic_templates/app_buttons/buttons.dart';
import 'package:ridely/src/presentation/ui/templates/main_generic_templates/spacing_widgets.dart';
import 'package:ridely/src/presentation/ui/templates/main_generic_templates/text_templates/display_text.dart';
import 'package:ridely/src/presentation/ui/templates/previous_rides_screens_widgets/ratings_container.dart';
import 'package:ridely/src/presentation/ui/templates/previous_rides_screens_widgets/user_details_container.dart';

class DriverPreviousRideContainer extends StatefulWidget {
  const DriverPreviousRideContainer({Key? key}) : super(key: key);

  @override
  State<DriverPreviousRideContainer> createState() =>
      _DriverPreviousRideContainerState();
}

class _DriverPreviousRideContainerState
    extends State<DriverPreviousRideContainer> {
  @override
  int mycount=3;
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Container(
        width: ScreenConfig.screenSizeWidth * 0.9,
        decoration: blueContainerTemplate(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 15),
          child: Center(
            child: SizedBox(
              width: ScreenConfig.screenSizeWidth * 0.8,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total Payed Amount',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: ScreenConfig.screenSizeWidth * 0.04),
                      ),
                      Text(
                        'Rs. 290',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: ScreenConfig.screenSizeWidth * 0.04),
                      ),
                    ],
                  ),
                  spaceHeight(ScreenConfig.screenSizeHeight * 0.02),
                  Container(
                    color: Colors.transparent,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: ScreenConfig.screenSizeWidth * 0.085,
                          height: ScreenConfig.screenSizeWidth * 0.085,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage("assets/images/UserProfileImage.png"), fit: BoxFit.cover),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(5)),
                          ),
                        ),
                        spaceWidth(ScreenConfig.screenSizeWidth * 0.02),
                        Text("Taha Ahmad",style: TextStyle(color: Colors.white,fontSize: ScreenConfig.screenSizeWidth*0.04),)
                      ],
                    ),
                  ),
                  spaceHeight(ScreenConfig.screenSizeHeight * 0.01),
                  SizedBox(
                    width: ScreenConfig.screenSizeWidth * 0.8,
                    child: Row(
                      children: [
                        displayText(
                          "Your rating",
                          ScreenConfig.theme.textTheme.bodyMedium,
                          width: 0.2,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            FivePointedStar(
                              defaultSelectedCount: mycount,
                              count: 5,
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  spaceHeight(ScreenConfig.screenSizeHeight * 0.02),
                  GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return  DriverPreviousRideDetailScreen();
                        },
                      );
                    },
                    child: Container(
                        height: ScreenConfig.screenSizeHeight * 0.05,
                        width: ScreenConfig.screenSizeWidth * 0.8,
                        decoration: squareButtonTemplate(),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  displayText(
                                    "Distance:",
                                    ScreenConfig.theme.textTheme.titleLarge,
                                    width: 0.25,
                                  ),
                                  displayText(
                                    "275 km",
                                    ScreenConfig.theme.textTheme.titleLarge,
                                    width: 0.2,
                                  ),
                                ],
                              ),
                              Buttons.forwardButton(context, () {})
                            ],
                          ),
                        )),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
