import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ridely/src/infrastructure/screen_config/screen_config.dart';
import 'package:ridely/src/presentation/ui/screens/booking_screens/ride_shown_screen.dart';
import 'package:ridely/src/presentation/ui/screens/past_rides_screens/previous_rides_screen.dart';
import 'package:ridely/src/presentation/ui/templates/decorations/box_decoration_templates.dart';
import 'package:ridely/src/presentation/ui/templates/main_generic_templates/app_bars/app_bar.dart';
import 'package:ridely/src/presentation/ui/templates/main_generic_templates/app_buttons/buttons.dart';
import 'package:ridely/src/presentation/ui/templates/main_generic_templates/booking_widgets/map_widgets.dart';
import 'package:ridely/src/presentation/ui/templates/main_generic_templates/other_widgets/slider_for_bottom_navigation.dart';
import 'package:ridely/src/presentation/ui/templates/main_generic_templates/spacing_widgets.dart';
import 'package:ridely/src/presentation/ui/templates/main_generic_templates/text_templates/display_text.dart';

class LocationSelectionScreen extends StatefulWidget {
  const LocationSelectionScreen({Key? key}) : super(key: key);
  static const routeName = '/locationselection-screen';

  @override
  State<LocationSelectionScreen> createState() =>
      _LocationSelectionScreenState();
}

class _LocationSelectionScreenState extends State<LocationSelectionScreen> {
  TextEditingController pickupEnterController = TextEditingController();
  TextEditingController dropoffEnterController = TextEditingController();
  GoogleMapController? _mapController;
  String image = "assets/images/RideSelectionScreenMap.png";
  bool isShowbottomButton = false;
  void updateState() {
    setState(() {
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.white,
      appBar: GenericAppBars.appBarWithBackButtonOnly(context, false),
      body: SizedBox(
        height: ScreenConfig.screenSizeHeight * 1.0,
        child: GestureDetector(
          onTap: () {
            setState(() {
              pickupEnterController.text = "Gulberg Phase II";
              dropoffEnterController.text = "Bahria Town";
              image = "assets/images/LocationDistanceScreenMap.png";
              isShowbottomButton = true;
            });
          },
          child: Stack(
            alignment: AlignmentDirectional.bottomCenter,
            children: [
              mapWidget(
                  isFullScreen: true,
                  fieldButtonFunction: updateState,
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
              if (true)
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                        height: 40,
                        width: ScreenConfig.screenSizeWidth * 0.9,
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
                                    "Total Distance:",
                                    ScreenConfig.theme.textTheme.headline5,
                                    width: 0.3,
                                  ),
                                  displayText(
                                    "17 km",
                                    ScreenConfig.theme.textTheme.headline4,
                                    width: 0.2,
                                  ),
                                ],
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.of(context)
                                      .pushNamed(RideShownScreen.routeName);
                                },
                                child: Container(
                                  height: 30,
                                  width: ScreenConfig.screenSizeWidth * 0.25,
                                  decoration: blueContainerTemplate(radius: 5),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 4.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        displayNoSizedText(
                                          "Let's Go",
                                          ScreenConfig.theme.textTheme.button,
                                        ),
                                        SizedBox(
                                          width: 20,
                                          child: Image.asset(
                                              "assets/images/GetMyCurrentLocationIconWhite.png",
                                              fit: BoxFit.contain),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        )),
                    SizedBox(height: ScreenConfig.screenSizeHeight * 0.03)
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
