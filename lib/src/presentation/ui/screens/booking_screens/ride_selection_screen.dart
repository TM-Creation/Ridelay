import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ridely/src/infrastructure/screen_config/screen_config.dart';
import 'package:ridely/src/presentation/ui/screens/booking_screens/location_selection_screen.dart';
import 'package:ridely/src/presentation/ui/screens/booking_screens/solo_ride_flow/vehicle_selection_screen.dart';
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
  GoogleMapController? _mapController;
  LatLng? _userLocation;
  @override
  void initState() {
    super.initState();
    _getLocationPermission();
  }
  @override
  Future<void> _getLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permission is denied.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permission is permanently denied, we cannot request permissions.');
    }

    _showUserLocation();
  }

  void _showUserLocation() async {
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    setState(() {
      _userLocation = LatLng(position.latitude, position.longitude);
    });

    if (_mapController != null) {
      _mapController!.animateCamera(CameraUpdate.newLatLngZoom(
        _userLocation!,
        15.0,
      ));
    }
  }


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
                MapScreen(
                  isFieldsReadOnly: false,
                  showTextFields: true,
                  showAds: false,
                  userLocation: _userLocation,
                  isShowMyLocationIcon: true,
                  isFullScreen: false,
                  image: "assets/images/RideSelectionScreenMap.png",
                  hintFieldOne: "Search Location",
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
                  fieldTwoController: TextEditingController(),
                ),

                // mapWidget(
                //   userLocation: _userLocation,
                //   isShowMyLocationIcon: true,
                //   isFullScreen: false,
                //   image: "assets/images/RideSelectionScreenMap.png",
                //   hintFieldOne: "Search Location",
                //   fieldOneButtonFunction: () {},
                //   suffixIconFieldOne: SizedBox(
                //     height: 60,
                //     width: 50,
                //     child: Row(
                //       children: [
                //         Buttons.smallSquareButton(
                //             "assets/images/SearchIcon.png", () {}),
                //       ],
                //     ),
                //   ),
                //   fieldOneController: locationEnterController,
                //   isDisplayFieldTwo: false,
                //   hintFieldTwo: " ",
                //   fieldTwoButtonFunction: () {},
                //   suffixIconFieldTwo: SizedBox(
                //     height: 60,
                //     width: 50,
                //     child: Row(
                //       children: [
                //         Buttons.smallSquareButton(
                //             "assets/images/SearchIcon.png", () {}),
                //       ],
                //     ),
                //   ),
                //   fieldTwoController: TextEditingController(),
                // ),
                spaceHeight(
                  ScreenConfig.screenSizeHeight * 0.2,
                ),
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
                    SizedBox(
                      width: ScreenConfig.screenSizeWidth * 0.9,
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
                    spaceHeight(ScreenConfig.screenSizeHeight * 0.04),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(
                            context, PreviousRidesScreen.routeName);
                      },
                      child: Container(
                        height: ScreenConfig.screenSizeHeight * 0.05,
                        width: ScreenConfig.screenSizeWidth * 0.9,
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
            ),
          )
        ],
      ),
    );
  }
}
