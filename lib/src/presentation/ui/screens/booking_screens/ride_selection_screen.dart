import 'dart:math';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ridely/src/infrastructure/screen_config/screen_config.dart';
import 'package:ridely/src/presentation/ui/screens/booking_screens/location_selection_screen.dart';
import 'package:ridely/src/presentation/ui/screens/booking_screens/solo_ride_flow/vehicle_selection_screen.dart';
import 'package:ridely/src/presentation/ui/screens/onboarding_screens/authentication_selection.dart';
import 'package:ridely/src/presentation/ui/screens/onboarding_screens/login.dart';
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
import 'package:shared_preferences/shared_preferences.dart';

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
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: displayNoSizedText(
          "Welcome to Ridelay",
          ScreenConfig.theme.textTheme.headline4
              ?.copyWith(fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        centerTitle: true,
      ),
      drawer: Drawer(
        backgroundColor: Colors.white,
        width: MediaQuery.sizeOf(context).width * 0.6,
        child: Padding(
          padding: EdgeInsets.all(MediaQuery.sizeOf(context).width * 0.04),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    onPressed: Navigator.of(context).pop,
                    icon: Image.asset(
                      "assets/images/CrossIcon.png",
                      color: ScreenConfig.theme.primaryColor,
                      width: MediaQuery.sizeOf(context).width * 0.03,
                      height: MediaQuery.sizeOf(context).height * 0.03,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: MediaQuery.sizeOf(context).height * 0.03,
              ),
              Center(
                child: Text(
                  "Moeen",
                  style: TextStyle(
                      color: ScreenConfig.theme.primaryColor,
                      fontSize: MediaQuery.sizeOf(context).width * 0.062),
                ),
              ),
              SizedBox(
                height: MediaQuery.sizeOf(context).height * 0.04,
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: ()async{
                    SharedPreferences prefs = await SharedPreferences.getInstance();
                    prefs.setBool('isLoggedIn', false);
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>AuthenticationSelection()));
                  },
                  child: const Text("Logout"),
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    foregroundColor: Colors.white,
                    backgroundColor: ScreenConfig.theme.primaryColor,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    textStyle: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: MediaQuery.sizeOf(context).width * 0.04,
                        color: Colors.white),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
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
            height: ScreenConfig.screenSizeHeight * 0.34,
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
