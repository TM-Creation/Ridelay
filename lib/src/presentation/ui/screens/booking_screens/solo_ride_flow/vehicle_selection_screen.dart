import 'package:flutter/material.dart';
import 'package:ridely/src/infrastructure/screen_config/screen_config.dart';
import 'package:ridely/src/presentation/ui/screens/booking_screens/location_selection_screen.dart';
import 'package:ridely/src/presentation/ui/screens/booking_screens/solo_ride_flow/location_selection_solo_screen.dart';
import 'package:ridely/src/presentation/ui/screens/past_rides_screens/previous_rides_screen.dart';
import 'package:ridely/src/presentation/ui/templates/decorations/box_decoration_templates.dart';
import 'package:ridely/src/presentation/ui/templates/main_generic_templates/app_bars/app_bar.dart';
import 'package:ridely/src/presentation/ui/templates/main_generic_templates/app_buttons/buttons.dart';
import 'package:ridely/src/presentation/ui/templates/main_generic_templates/booking_widgets/map_widgets.dart';
import 'package:ridely/src/presentation/ui/templates/main_generic_templates/other_widgets/slider_for_bottom_navigation.dart';
import 'package:ridely/src/presentation/ui/templates/main_generic_templates/spacing_widgets.dart';
import 'package:ridely/src/presentation/ui/templates/main_generic_templates/text_templates/display_text.dart';

class VehicleSelectionScreen extends StatefulWidget {
  const VehicleSelectionScreen({Key? key}) : super(key: key);
  static const routeName = '/vehicleselection-screen';

  @override
  State<VehicleSelectionScreen> createState() => _VehicleSelectionScreenState();
}

class _VehicleSelectionScreenState extends State<VehicleSelectionScreen> {
  TextEditingController locationEnterController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.white,
      appBar: GenericAppBars.appBarWithBackButtonOnly(context, false),
      body: Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children: [
          SizedBox(
            height: ScreenConfig.screenSizeHeight * 1.2,
            child: Column(
              children: [
                mapWidget(
                    isShowMyLocationIcon: true,
                    isFullScreen: false,
                    image: "assets/images/RideSelectionScreenMap.png",
                    hintFieldOne: "Enter Location",
                    fieldOneButtonFunction: () {},
                    suffixIconFieldOne: SizedBox(
                      height: 60,
                      width: 50,
                      child: Row(
                        children: [
                          Buttons.smallSquareButton(
                              "assets/images/SearchIcon.png", () {}),
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
                              "assets/images/SearchIcon.png", () {}),
                        ],
                      ),
                    ),
                    fieldTwoController: TextEditingController()),
                spaceHeight(
                  ScreenConfig.screenSizeHeight * 0.2,
                )
              ],
            ),
          ),
          Container(
            height: ScreenConfig.screenSizeHeight * 0.37,
            width: ScreenConfig.screenSizeWidth,
            decoration: bottomModalTemplate(),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: SizedBox(
                width: ScreenConfig.screenSizeWidth * 0.9,
                child: Column(
                  children: [
                    sliderBar(),
                    spaceHeight(ScreenConfig.screenSizeHeight * 0.03),
                    displayText(
                        "SELECT ACCORDING TO YOUR NEED",
                        ScreenConfig.theme.textTheme.headline4
                            ?.copyWith(fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                        width: 0.9),
                    spaceHeight(ScreenConfig.screenSizeHeight * 0.03),
                    SizedBox(
                      width: ScreenConfig.screenSizeWidth * 0.9,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Buttons.squareRideScreenButton(
                              "assets/images/CarButtonIcon.png",
                              "CAR",
                              "Upto 3 persons", () {
                            Navigator.of(context).pushNamed(
                                LocationSelectionSoloScreen.routeName);
                          }),
                          Buttons.squareRideScreenButton(
                              "assets/images/BikeButtonIcon.png",
                              "BIKE",
                              "One Person Ride", () {
                            Navigator.of(context).pushNamed(
                                LocationSelectionSoloScreen.routeName);
                          }),
                        ],
                      ),
                    ),
                    spaceHeight(ScreenConfig.screenSizeHeight * 0.02),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
