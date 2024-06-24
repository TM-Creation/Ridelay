import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
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
  String vahicle = '';
  @override
  List<Location> search = [];
  void searchupdate() async {
    final searchlocation =
        await locationFromAddress(locationEnterController.text);
    setState(() {
      search = searchlocation as List<Location>;
      print('$search search a gya');
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.white,
      body: Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children: [
          MapScreen(
              check: false,
              showAds: false,
              showTextFields: true,
              isFieldsReadOnly: false,
              isShowMyLocationIcon: true,
              isFullScreen: false,
              search: search,
              image: "assets/images/RideSelectionScreenMap.png",
              hintFieldOne: "Enter Location",
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
                      searchupdate();
                    }),
                  ],
                ),
              ),
              fieldTwoController: TextEditingController()),
          Container(
            height: ScreenConfig.screenSizeHeight * 0.33,
            width: ScreenConfig.screenSizeWidth,
            decoration: bottomModalTemplate(),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 15.0),
              child: Column(
                children: [
                  sliderBar(),
                  SizedBox(height: 20,),
                  spaceHeight(ScreenConfig.screenSizeHeight * 0.01),
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
                        Buttons.squareRideSelectionScreenButton(
                            "assets/images/CarButtonIcon.png",
                            "CAR",
                            "Upto 3 persons", () {
                          Navigator.of(context).pushNamed(
                              LocationSelectionScreen.routeName,
                              arguments: vahicle = 'car');
                        }),
                        Buttons.squareRideSelectionScreenButton(
                            "assets/images/rikshawbuttonicon.png",
                            "Rickshaw",
                            "Upto 1 Person Ride", () {
                          Navigator.of(context).pushNamed(
                              LocationSelectionScreen.routeName,
                              arguments: vahicle = 'rickshaw');
                        }),
                        Buttons.squareRideSelectionScreenButton(
                            "assets/images/BikeButtonIcon.png",
                            "BIKE",
                            "One Person Ride", () {
                          Navigator.of(context).pushNamed(
                              LocationSelectionScreen.routeName,
                              arguments: vahicle = 'bike');
                        }),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
