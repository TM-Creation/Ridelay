import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ridely/src/infrastructure/screen_config/screen_config.dart';
import 'package:ridely/src/presentation/ui/screens/booking_screens/ride_in_progress_and_finish_screen.dart';

import 'package:ridely/src/presentation/ui/templates/decorations/box_decoration_templates.dart';
import 'package:ridely/src/presentation/ui/templates/main_generic_templates/app_bars/app_bar.dart';
import 'package:ridely/src/presentation/ui/templates/main_generic_templates/app_buttons/buttons.dart';
import 'package:ridely/src/presentation/ui/templates/main_generic_templates/booking_widgets/map_widgets.dart';
import 'package:ridely/src/presentation/ui/templates/main_generic_templates/other_widgets/slider_for_bottom_navigation.dart';
import 'package:ridely/src/presentation/ui/templates/main_generic_templates/spacing_widgets.dart';
import 'package:ridely/src/presentation/ui/templates/main_generic_templates/text_templates/display_text.dart';
import 'package:ridely/src/presentation/ui/templates/ride_widgets/ride_detail_widgets.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:http/http.dart' as http;
import '../../config/theme.dart';
import '../../templates/previous_rides_screens_widgets/user_details_container.dart';
import '../../templates/ride_widgets/ride_widget_buttons.dart';
import '../driver_screens/driver_main_screen.dart';
import '../onboarding_screens/register_screens/passangerregistration.dart';

class RideWaitingScreen extends StatefulWidget {
  const RideWaitingScreen({Key? key}) : super(key: key);
  static const routeName = '/ridewaiting-screen';

  @override
  State<RideWaitingScreen> createState() => _RideWaitingScreenState();
}

class _RideWaitingScreenState extends State<RideWaitingScreen> {
  int currentIndex = -1;
  TextEditingController pickupEnterController = TextEditingController();
  TextEditingController dropoffEnterController = TextEditingController();
  String image = "assets/images/LocationDistanceScreenMap.png",
      distance = '',
      vahicle = '',
      duration = '',
      numberplate = '',
      drivername = '',
      vahiclename = '';
  double fare = 0;
  double driverraiting = 0.0;
  String ETA='';

  void didChangeDependencies() {
    super.didChangeDependencies();
    // Retrieve pickup and drop-off locations from arguments after dependencies change
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    if (args != null) {
      setState(() {
        pickupEnterController.text = args['pickupLocation']!;
        dropoffEnterController.text = args['dropoffLocation']!;
        drivername = args['driverName']!;
        driverraiting = args['driverRaiting']!;
        vahiclename = args['vahicleName']!;
        numberplate = args['vahicleNumberplate']!;
        fare = args['fare']!;
      });
    }
  }

  late IO.Socket socket2;
  late GoogleMapController _controller;
  Set<Polyline> _polylines = {};
  List<double> driverlivelocation = [];

  @override
  void initState() {
    initSocket();
    super.initState();
  }

  initSocket() {
    IO.Socket socket = socketconnection().socket;
    setState(() {
      socket2 = socket;
    });
    socket.on('locationUpdate', (data) {
      print("Driver Live Location Reached $data");
      driverlivelocation = (data['location'] as List<dynamic>)
          .map((coordinate) =>
              coordinate is int ? coordinate.toDouble() : coordinate as double)
          .toList();
      setState(() {});
      print("driver live location is: $driverlivelocation");
      _updatePolyline();
    });
    socket.on('pickupRide', (data) {
      print('on is run correctly');
      Navigator.of(context)
          .pushNamed(RideInProgressAndFinishedScreen.routeName, arguments: {
        "pickupLocation":pickupEnterController.text,
        "dropoffLocation": dropoffEnterController.text,
        "driverName":drivername,
        "driverRaiting":driverraiting,
        "vahicleName":vahiclename,
        "vahicleNumberplate":numberplate,
        "fare":fare
      });
    });
  }
  String calculateDistance(double pickupLat, double pickupLon,
      double dropoffLat, double dropoffLon) {
    const double earthRadiusKm = 6371; // Earth's radius in kilometers

    double degreeToRadian(double degree) {
      return degree * pi / 180;
    }

    final double lat1Rad = degreeToRadian(pickupLat);
    final double lon1Rad = degreeToRadian(pickupLon);
    final double lat2Rad = degreeToRadian(dropoffLat);
    final double lon2Rad = degreeToRadian(dropoffLon);

    final double dLat = lat2Rad - lat1Rad;
    final double dLon = lon2Rad - lon1Rad;

    final double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(lat1Rad) * cos(lat2Rad) * sin(dLon / 2) * sin(dLon / 2);
    final double c = 2 * atan2(sqrt(a), sqrt(1 - a));

    double distanceKm = earthRadiusKm * c;
    distanceKm = distanceKm * 1.58500;
    return '${distanceKm.toStringAsFixed(2)} km';
  }
  Future<List<LatLng>> _getRoutePolylinePoints(
      LatLng origin, LatLng destination) async {
    String apiUrl =
        'https://maps.googleapis.com/maps/api/directions/json?origin=${origin.latitude},${origin.longitude}&destination=${destination.latitude},${destination.longitude}&key=AIzaSyAW34SKXZzfAUZYRkFqvMceV740PImrruE';

    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      List<LatLng> polylinePoints = [];

      // Extracting route polyline points from API response
      List steps = decoded['routes'][0]['legs'][0]['steps'];
      steps.forEach((step) {
        String points = step['polyline']['points'];
        List<LatLng> decodedPolylinePoints = decodeEncodedPolyline(points);
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

  @override
  void dispose() {
    // TODO: implement dispose
    socket2.off('locationUpdate');
    socket2.off('pickupRide');
    super.dispose();
  }
  Future<String> getTravelTime(double startLat, double startLng, double endLat, double endLng) async {
    final apiKey = 'AIzaSyAW34SKXZzfAUZYRkFqvMceV740PImrruE';
    final url = 'https://maps.googleapis.com/maps/api/directions/json'
        '?origin=$startLat,$startLng'
        '&destination=$endLat,$endLng'
        '&key=$apiKey';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final travelTime = data['routes'][0]['legs'][0]['duration']['text'];
      return travelTime;
    } else {
      throw Exception('Failed to get travel time: ${response.statusCode}');
    }
  }
  void _updatePolyline() {
    print(
        "roooola:  ${pickanddrop().pickloc} and ${LatLng(driverlivelocation[0], driverlivelocation[1])}");
    _getRoutePolylinePoints(pickanddrop().pickloc!,
            LatLng(driverlivelocation[0], driverlivelocation[1]))
        .then((polylinePoints) {
      if (mounted) {
        setState(() async{
          distance = calculateDistance(driverlivelocation[0],driverlivelocation[1], pickanddrop().pickloc!.latitude,pickanddrop().pickloc!.longitude);
          ETA=await getTravelTime(driverlivelocation[0],driverlivelocation[1], pickanddrop().pickloc!.latitude,pickanddrop().pickloc!.longitude);
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
                                        displayText('Vehicle', ScreenConfig.theme.textTheme.button,
                                            width: 0.3),
                                        displayText(
                                            "$ETA",
                                            ScreenConfig.theme.textTheme.button
                                                ?.copyWith(fontSize: 9),
                                            width: 0.3),
                                      ],
                                    ),
                                  ],
                                ),
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 5.0),
                                    child: displayText(
                                        "Rs. $fare",
                                        ScreenConfig.theme.textTheme.headline5
                                            ?.copyWith(fontWeight: FontWeight.bold),
                                        textAlign: TextAlign.end,
                                        width: 0.2),
                                  ),
                              ],
                            ),
                            spaceHeight(ScreenConfig.screenSizeHeight * 0.01),
                            displayText(
                                "Hold Tight ! Your Ride Is Coming",
                                ScreenConfig.theme.textTheme.button,
                                width: 0.8),
                            spaceHeight(ScreenConfig.screenSizeHeight * 0.01),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    userDetailsContainer("assets/images/UserProfileImage.png",
                                      "$drivername", "$driverraiting", true,),
                                    spaceHeight(ScreenConfig.screenSizeHeight * 0.02),
                                    userDetailsContainer("assets/images/UserCarImage.png",
                                      "$vahiclename", "$numberplate", false,)
                                  ],
                                ),
                                SizedBox(
                                  width: ScreenConfig.screenSizeWidth * 0.25,
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
                                      displayText("Driver $distance away",
                                          ScreenConfig.theme.textTheme.bodyText2,
                                          textAlign: TextAlign.center, width: 0.22),
                                      spaceHeight(ScreenConfig.screenSizeHeight * 0.01),
                                      GestureDetector(
                                        onTap: (){Navigator.pop(context);},
                                        child: Container(
                                          width: ScreenConfig.screenSizeWidth * 0.25,
                                          decoration: BoxDecoration(
                                              color: redFourthColor,
                                              borderRadius: const BorderRadius.all(Radius.circular(5)),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.grey.withOpacity(0.40),
                                                  offset: const Offset(0.0, 1.2), //(x,y)
                                                  blurRadius: 6.0,
                                                )
                                              ]),
                                          child: Padding(
                                              padding: const EdgeInsets.all(5.0),
                                              child: displayNoSizedText(
                                                  'Cancel Ride',
                                                  ScreenConfig.theme.textTheme.caption
                                                      ?.copyWith(color: Colors.white),
                                                  textAlign: TextAlign.center)),
                                        ),
                                      )
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
                ),
                spaceHeight(ScreenConfig.screenSizeHeight * 0.02),
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
          if (pickanddrop().pickloc != null && driverlivelocation.isNotEmpty)
            GoogleMap(
              initialCameraPosition: CameraPosition(
                target: pickanddrop().pickloc!,
                zoom: 15,
              ),
              markers: {
                Marker(
                  markerId: MarkerId('passangerpickup'),
                  position: pickanddrop().pickloc!,
                  infoWindow: InfoWindow(title: 'Passanger Pickup'),
                  icon: BitmapDescriptor.defaultMarkerWithHue(
                      BitmapDescriptor.hueRed),
                ),
                Marker(
                  markerId: MarkerId('driverlive'),
                  position:
                      LatLng(driverlivelocation[0], driverlivelocation[1]),
                  infoWindow: InfoWindow(title: 'Driver Location'),
                  icon: BitmapDescriptor.defaultMarkerWithHue(
                      BitmapDescriptor.hueBlue),
                ),
              },
              polylines: _polylines,
              onMapCreated: (GoogleMapController controller) {
                _controller = controller;
              },
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
