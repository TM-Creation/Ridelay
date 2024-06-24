import 'dart:math';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ridely/src/infrastructure/screen_config/screen_config.dart';
import 'package:ridely/src/presentation/ui/screens/booking_screens/location_selection_screen.dart';
import 'package:ridely/src/presentation/ui/screens/booking_screens/solo_ride_flow/vehicle_selection_screen.dart';
import 'package:ridely/src/presentation/ui/screens/onboarding_screens/register_screens/passangerregistration.dart';
import 'package:ridely/src/presentation/ui/screens/past_rides_screens/previous_rides_screen.dart';
import 'package:ridely/src/presentation/ui/templates/decorations/box_decoration_templates.dart';
import 'package:ridely/src/presentation/ui/templates/main_generic_templates/app_bars/app_bar.dart';
import 'package:ridely/src/presentation/ui/templates/main_generic_templates/app_buttons/buttons.dart';
import 'package:ridely/src/presentation/ui/templates/main_generic_templates/booking_widgets/map_widgets.dart';
import 'package:ridely/src/presentation/ui/templates/main_generic_templates/other_widgets/slider_for_bottom_navigation.dart';
import 'package:ridely/src/presentation/ui/templates/main_generic_templates/spacing_widgets.dart';
import 'package:ridely/src/presentation/ui/templates/main_generic_templates/text_templates/display_text.dart';
import 'package:geolocator/geolocator.dart';

class RideSelectionScreen extends StatefulWidget {
  const RideSelectionScreen({Key? key}) : super(key: key);
  static const routeName = '/rideselection-screen';

  @override
  State<RideSelectionScreen> createState() => _RideSelectionScreenState();
}

class _RideSelectionScreenState extends State<RideSelectionScreen> {
  TextEditingController locationEnterController = TextEditingController();
  @override
  void initState() {
    super.initState();
  }
  List<Location> search=[];
  void searchupdate()async{
   final searchlocation=await locationFromAddress(locationEnterController.text);
    setState(() {
      search=searchlocation as List<Location>;
      print('$search search a gya');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.white,
      body: Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children: [
          MapScreen(
            check: false,
            isFieldsReadOnly: false,
            showTextFields: true,
            showAds: false,
            isShowMyLocationIcon: true,
            isFullScreen: false,
            search: search,
            image: "assets/images/RideSelectionScreenMap.png",
            hintFieldOne: "Search Location",
            fieldOneButtonFunction: () {},
            suffixIconFieldOne: SizedBox(
              height: 60,
              width: 50,
              child: Row(
                children: [
                  Buttons.smallSquareButton(
                      "assets/images/SearchIcon.png", () {
                        searchupdate();
                  }),
                ],
              ),
            ),
            fieldOneController: locationEnterController,
            isDisplayFieldTwo: false,
            hintFieldTwo: " ",
            fieldTwoButtonFunction: () {},
            suffixIconFieldTwo: SizedBox(
              height: 60,
              width: 50,
              child: Row(
                children: [
                  Buttons.smallSquareButton(
                      "assets/images/SearchIcon.png", () {

                  }),
                ],
              ),
            ),
            fieldTwoController: TextEditingController(),
          ),
          Container(
            height: ScreenConfig.screenSizeHeight * 0.35,
            width: ScreenConfig.screenSizeWidth,
            decoration: bottomModalTemplate(),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 15.0),
              child: Column(
                children: [
                  sliderBar(),
                  SizedBox(height: 20,),
                  spaceHeight(ScreenConfig.screenSizeHeight * 0.01),
                  SizedBox(
                    width: ScreenConfig.screenSizeWidth * 0.8,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Buttons.squareRideScreenButton(
                            "assets/images/RideButtonIcon.png",
                            "RIDE",
                            "Go for ride now", () {
                          Navigator.of(context)
                              .pushNamed(VehicleSelectionScreen.routeName);
                        }),
                        Buttons.squareRideScreenButton(
                            "assets/images/RideShareButtonIcon.png",
                            "SHARE A RIDE",
                            "Share a ride", () {
                          Navigator.of(context)
                              .pushNamed(LocationSelectionScreen.routeName);
                        }),
                      ],
                    ),
                  ),
                  spaceHeight(ScreenConfig.screenSizeHeight * 0.02),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(
                          context, PreviousRidesScreen.routeName);
                    },
                    child: Container(
                      height: ScreenConfig.screenSizeHeight * 0.05,
                      width: ScreenConfig.screenSizeWidth * 0.8,
                      decoration: squareButtonTemplate(),
                      child: Padding(
                        padding:
                        const EdgeInsets.only(left: 20.0, right: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                SizedBox(
                                  height:
                                  ScreenConfig.screenSizeHeight * 0.04,
                                  width: 25,
                                  child: Image.asset(
                                    "assets/images/YourPastTripsIcon.png",
                                    fit: BoxFit.contain,
                                  ),
                                ),
                                spaceWidth(
                                    ScreenConfig.screenSizeWidth * 0.03),
                                displayText(
                                    "YOUR PAST TRIPS",
                                    ScreenConfig.theme.textTheme.headline4,
                                    width: 0.5),
                              ],
                            ),
                            const Icon(
                              Icons.arrow_forward_ios,
                              size: 15,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  spaceHeight(ScreenConfig.screenSizeHeight * 0.02),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
