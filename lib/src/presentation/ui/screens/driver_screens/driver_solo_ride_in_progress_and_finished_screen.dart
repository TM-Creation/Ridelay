import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ridely/src/infrastructure/screen_config/screen_config.dart';
import 'package:ridely/src/presentation/ui/config/theme.dart';
import 'package:ridely/src/presentation/ui/screens/booking_screens/ride_rating_screen.dart';
import 'package:ridely/src/presentation/ui/screens/booking_screens/solo_ride_flow/solo_ride_rating_screen.dart';
import 'package:ridely/src/presentation/ui/screens/driver_screens/driver_main_screen.dart';
import 'package:ridely/src/presentation/ui/screens/driver_screens/driver_solo_ride_rating_screen.dart';
import 'package:ridely/src/presentation/ui/screens/onboarding_screens/authentication_selection.dart';
import 'package:ridely/src/presentation/ui/templates/decorations/box_decoration_templates.dart';
import 'package:ridely/src/presentation/ui/templates/main_generic_templates/app_bars/app_bar.dart';
import 'package:ridely/src/presentation/ui/templates/main_generic_templates/app_buttons/buttons.dart';
import 'package:ridely/src/presentation/ui/templates/main_generic_templates/booking_widgets/map_widgets.dart';
import 'package:ridely/src/presentation/ui/templates/main_generic_templates/other_widgets/slider_for_bottom_navigation.dart';
import 'package:ridely/src/presentation/ui/templates/main_generic_templates/spacing_widgets.dart';
import 'package:ridely/src/presentation/ui/templates/main_generic_templates/text_templates/display_text.dart';
import 'package:ridely/src/presentation/ui/templates/ride_widgets/driver_ride_detail_widgets.dart';
import 'package:ridely/src/presentation/ui/templates/ride_widgets/ride_detail_widgets.dart';
import 'package:http/http.dart' as http;
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../../templates/previous_rides_screens_widgets/user_details_container.dart';
class DriverSoloRideInProgressAndFinishedScreen extends StatefulWidget {
  const DriverSoloRideInProgressAndFinishedScreen({Key? key}) : super(key: key);
  static const routeName = '/driversolorideinprogressandfinished-screen';

  @override
  State<DriverSoloRideInProgressAndFinishedScreen> createState() =>
      _DriverSoloRideInProgressAndFinishedScreenState();
}

class _DriverSoloRideInProgressAndFinishedScreenState
    extends State<DriverSoloRideInProgressAndFinishedScreen> {
  int currentIndex = -1;
  TextEditingController pickupEnterController = TextEditingController();
  TextEditingController dropoffEnterController = TextEditingController();
  String image = "assets/images/LocationDistanceScreenMap.png";
  List namesList = ["Mini", "Go", "Comfort", "Mini"];
  List<double>? drop = [];
  String rideId='';
  late GoogleMapController _controller;
  Set<Polyline> _polylines = {};
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Retrieve pickup and drop-off locations from arguments after dependencies change
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    if (args != null) {
      setState(() {
        drop = args['dropofflocation']!;
        rideId=args['rideId'];
        print("data of eve 2: $drop");
      });
    }
    _initLocationService();
  }
  LatLng driverlocation=LatLng(0.0,0.0);
  @override
  void initState() {
    pickupEnterController.text = "Gulberg Phase II";
    dropoffEnterController.text = "Bahria Town";
    driverlocation=userLiveLocation().userlivelocation!;
    super.initState();
  }
  Future<void> _initLocationService() async {
    _updatePolyline();
    _trackDriverLocation();
  }
  IO.Socket socket=socketconnection().socket;
  Future<List<LatLng>> _getRoutePolylinePoints(LatLng origin, LatLng destination) async {
    String apiUrl = 'https://maps.googleapis.com/maps/api/directions/json?origin=${origin.latitude},${origin.longitude}&destination=${destination.latitude},${destination.longitude}&key=AIzaSyAW34SKXZzfAUZYRkFqvMceV740PImrruE';

    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      List<LatLng> polylinePoints = [];

      // Extracting route polyline points from API response
      List steps = decoded['routes'][0]['legs'][0]['steps'];
      steps.forEach((step) {
        String points = step['polyline']['points'];
        List<LatLng> decodedPolylinePoints =
        decodeEncodedPolyline(points);
        polylinePoints.addAll(decodedPolylinePoints);
      });

      return polylinePoints;
    } else {
      throw Exception('Failed to load route');
    }
  }

  List<LatLng> decodeEncodedPolyline(String encoded) {
    List<LatLng> polylinePoints = [];
    int index = 0, len = encoded.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int b, shift = 0, result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dlng;

      double latitude = lat / 1E5;
      double longitude = lng / 1E5;
      polylinePoints.add(LatLng(latitude, longitude));
    }
    return polylinePoints;
  }

  void _updatePolyline() {
    _getRoutePolylinePoints(driverlocation,LatLng(drop![1], drop![0]))
        .then((polylinePoints) {
      if(mounted){
        setState(() {
          _polylines = {
            Polyline(
              polylineId: PolylineId('route'),
              points: polylinePoints,
              color: Colors.red,
              width: 5,
            )
          };
        });
      }
      /*_controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
          target: _driverLocation,
          zoom: 13.0,
        ),
      ));*/
    }).catchError((e) {
      print('Error fetching route: $e');
    });
  }
  void _trackDriverLocation(){
    Geolocator.getPositionStream().listen((Position position) {
      if(mounted){
        setState(() {
          driverlocation = LatLng(position.latitude, position.longitude);
          _updatePolyline();
        });
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    Widget bottomModalNonSlideable() {
      return Container(
        height: ScreenConfig.screenSizeHeight * 0.32,
        width: ScreenConfig.screenSizeWidth,
        decoration: bottomModalTemplate(),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: SizedBox(
            width: ScreenConfig.screenSizeWidth * 0.9,
            child: Column(
              children: [
                sliderBar(),
                spaceHeight(ScreenConfig.screenSizeHeight * 0.02),
                Column(
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
                                'Your Ride Is In Progress',
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
                                      width: 0.4),
                                  displayText("5 km", ScreenConfig.theme.textTheme.button,
                                      width: 0.2),
                                ]),
                            spaceHeight(ScreenConfig.screenSizeHeight * 0.01),
                            Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  displayText("ETA", ScreenConfig.theme.textTheme.button,
                                      width: 0.4),
                                  displayText("8 mins", ScreenConfig.theme.textTheme.button,
                                      width: 0.2),
                                ]),
                            spaceHeight(ScreenConfig.screenSizeHeight * 0.03),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    userDetailsContainer("assets/images/UserProfileImage.png",
                                        "Altaf Ahmed", "4.9", true,),
                                    spaceHeight(ScreenConfig.screenSizeHeight * 0.02),
                                    // userDetailsContainer("assets/images/UserCarImage.png",
                                    //     "Honda Civic", "LXV 5675", false, true, "2019")
                                  ],
                                ),
                                GestureDetector(
                                  onTap: () {
                                    socket.emit('completeRide',{'rideId':rideId});
                                    Navigator.of(context)
                                        .pushNamed(DriverSoloRideRatingScreen.routeName);
                                  },
                                  child: Container(
                                    width: ScreenConfig.screenSizeWidth *
                                        0.25,
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
                                            'Ride Complete',
                                            ScreenConfig
                                                .theme.textTheme.caption
                                                ?.copyWith(
                                                color: ScreenConfig
                                                    .theme
                                                    .primaryColor,
                                                fontWeight:
                                                FontWeight.bold),
                                            textAlign: TextAlign.center)),
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    spaceHeight(ScreenConfig.screenSizeHeight * 0.015),
                  ],
                ),
                spaceHeight(ScreenConfig.screenSizeHeight * 0.02),
                Text('If you Drop the Passenger click on Ride Complete Button',style: TextStyle(color: Colors.white,fontSize: ScreenConfig.screenSizeWidth*0.022),),
                // userDetailsContainer("assets/images/UserCarImage.png",
                //     "Honda Civic", "LXV 5675", false, true, "2019")
                spaceHeight(
                    ScreenConfig.screenSizeHeight * 0.01),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.white,
      body: Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: driverlocation,
              zoom: 15,
            ),
            markers: {
              Marker(
                markerId: MarkerId('driver'),
                position: driverlocation,
                infoWindow: InfoWindow(title: 'Your Live Location'),
                icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
              ),
              Marker(
                markerId: MarkerId('passngerdrop'),
                position: LatLng(drop![1], drop![0]),
                infoWindow: InfoWindow(title: 'Passanger Drop Location'),
                icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
              ),
            },
            polylines: _polylines,
            onMapCreated: (GoogleMapController controller) {
              _controller = controller;
            },
          ),
          spaceHeight(
            ScreenConfig.screenSizeHeight * 0.2,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              spaceHeight(ScreenConfig.screenSizeHeight * 0.04),
              bottomModalNonSlideable(),
            ],
          )
        ],
      ),
    );
  }
}
