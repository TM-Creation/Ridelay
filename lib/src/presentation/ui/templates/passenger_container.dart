import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ridely/src/infrastructure/screen_config/screen_config.dart';
import 'package:ridely/src/presentation/ui/screens/past_rides_screens/previous_ride_detail_screen.dart';
import 'package:ridely/src/presentation/ui/templates/decorations/box_decoration_templates.dart';
import 'package:ridely/src/presentation/ui/templates/main_generic_templates/app_buttons/buttons.dart';
import 'package:ridely/src/presentation/ui/templates/main_generic_templates/spacing_widgets.dart';
import 'package:ridely/src/presentation/ui/templates/main_generic_templates/text_templates/display_text.dart';
import 'package:ridely/src/presentation/ui/templates/previous_rides_screens_widgets/ratings_container.dart';
import 'package:ridely/src/presentation/ui/templates/previous_rides_screens_widgets/user_details_container.dart';

class PassengerContainer extends StatefulWidget {
  const PassengerContainer({Key? key}) : super(key: key);

  @override
  State<PassengerContainer> createState() => _PassengerContainerState();
}

class _PassengerContainerState extends State<PassengerContainer> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: GestureDetector(
        onTap: () {
          // Navigator.of(context).pushNamed(PreviousRideDetailScreen.routeName);
        },
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
                    spaceHeight(ScreenConfig.screenSizeHeight * 0.02),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        userDetailsContainer(
                            "assets/images/UserProfileImage.png",
                            "Altaf Ahmed",
                            "4.9",
                            true),
                        userDetailsContainer("assets/images/UserCarImage.png",
                            "Honda Civic", "LXV 5675", false)
                      ],
                    ),
                    spaceHeight(ScreenConfig.screenSizeHeight * 0.02),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () => null,
                          child: Container(
                              height: 40,
                              width: ScreenConfig.screenSizeWidth * 0.3,
                              decoration: BoxDecoration(
                                  color: Colors.green,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.40),
                                      offset: const Offset(0.0, 1.2), //(x,y)
                                      blurRadius: 6.0,
                                    )
                                  ]),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0, vertical: 5),
                                child: Center(child: Text("Accept",style: TextStyle(
                                  fontSize: 14
                                ),)),
                              )),
                        ),
                        GestureDetector(
                          onTap: () => null,
                          child: Container(
                              height: 40,
                              width: ScreenConfig.screenSizeWidth * 0.3,
                              decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.40),
                                      offset: const Offset(0.0, 1.2), //(x,y)
                                      blurRadius: 6.0,
                                    )
                                  ]),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0, vertical: 5),
                                child: Center(child: Text("Deny",style: TextStyle(
                                    fontSize: 14
                                ),)),
                              )),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
