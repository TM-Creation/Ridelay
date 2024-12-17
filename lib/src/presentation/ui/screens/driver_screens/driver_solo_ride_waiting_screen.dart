import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ridely/src/infrastructure/screen_config/screen_config.dart';
import 'package:ridely/src/models/googlemapapikey.dart';
import 'package:ridely/src/presentation/ui/config/theme.dart';
import 'package:ridely/src/presentation/ui/screens/booking_screens/solo_ride_flow/solo_ride_in_progress_and_finish_screen.dart';
import 'package:ridely/src/presentation/ui/screens/driver_screens/driver_main_screen.dart';
import 'package:ridely/src/presentation/ui/screens/driver_screens/driver_solo_ride_in_progress_and_finished_screen.dart';
import 'package:ridely/src/presentation/ui/screens/onboarding_screens/authentication_selection.dart';
import 'package:http/http.dart' as http;
import 'package:ridely/src/presentation/ui/templates/decorations/box_decoration_templates.dart';
import 'package:ridely/src/presentation/ui/templates/main_generic_templates/app_bars/app_bar.dart';
import 'package:ridely/src/presentation/ui/templates/main_generic_templates/app_buttons/buttons.dart';
import 'package:ridely/src/presentation/ui/templates/main_generic_templates/booking_widgets/map_widgets.dart';
import 'package:ridely/src/presentation/ui/templates/main_generic_templates/other_widgets/slider_for_bottom_navigation.dart';
import 'package:ridely/src/presentation/ui/templates/main_generic_templates/spacing_widgets.dart';
import 'package:ridely/src/presentation/ui/templates/ride_widgets/driver_ride_detail_widgets.dart';
import 'package:ridely/src/presentation/ui/templates/ride_widgets/ride_detail_widgets.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:url_launcher/url_launcher.dart';

import '../../templates/main_generic_templates/text_templates/display_text.dart';
import '../../templates/previous_rides_screens_widgets/user_details_container.dart';
import '../../templates/ride_widgets/ride_widget_buttons.dart';
import '../onboarding_screens/register_screens/passangerregistration.dart';

class DriverSoloRideWaitingScreen extends StatefulWidget {
  const DriverSoloRideWaitingScreen({Key? key}) : super(key: key);
  static const routeName = '/driversoloridewaiting-screen';

  @override
  State<DriverSoloRideWaitingScreen> createState() =>
      _DriverSoloRideWaitingScreenState();
}

class _DriverSoloRideWaitingScreenState
    extends State<DriverSoloRideWaitingScreen> {
  int currentIndex = -1;
  String image = "assets/images/LocationDistanceScreenMap.png";
  List namesList = ["Mini", "Go", "Comfort", "Mini"];
  LatLng? driverlocation = LatLng(0.0, 0.0);
  List<double>? pick = [];
  List<double>? drop = [];
  String? passangername = '';
  String? passangerphone = '';
  int? fare = 0;
  String? distance = '';
  String rideId = '';
  double raiting = 0.0;
  late GoogleMapController _controller;
  Set<Polyline> _polylines = {};
  late LatLng _driverLocation;
  String ETA = '';
  double distanceValue=0;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Retrieve pickup and drop-off locations from arguments after dependencies change
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    if (args != null) {
      setState(() {
        pick = args['pickuplocation']!;
        drop = args['dropofflocation']!;
        fare = args['fare']!;
        passangername = args['name']!;
        //raiting=args['raiting'];
        passangerphone = args['passangerphone']!;
        rideId = args['rideId'];
        print(
            "data of eve 2: $pick $drop $passangername $passangerphone $fare $distance $rideId");
      });
    }
    _initLocationService();
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

  @override
  void initState() {
    driverlocation = userLiveLocation().userlivelocation;
    initsocket();
    super.initState();
  }

  IO.Socket socket = socketconnection().socket;
  void initsocket(){
    socket.on('cancelRide', (data){
      print('Ride Canceled $data');
      Get.snackbar(
        'Ride Canceled',
        'Ride is Canceled by Passenger',
        snackPosition: SnackPosition.TOP,
        backgroundColor: themeColor,
        colorText: Colors.white,
        margin: EdgeInsets.all(10),
        duration: Duration(seconds: 3),
      );
      Navigator.pop(context);
    });
  }
  Future<void> _initLocationService() async {
    setState(() {
      _driverLocation = driverlocation!;
    });
    socket.emit('locationUpdate', {'location': _driverLocation});
    _updatePolyline();
    _trackDriverLocation();
  }

  Future<List<LatLng>> _getRoutePolylinePoints(
      LatLng origin, LatLng destination) async {
    String apiUrl =
        'https://maps.googleapis.com/maps/api/directions/json?origin=${origin.latitude},${origin.longitude}&destination=${destination.latitude},${destination.longitude}&key=${GoogleMapKey().googlemapkey}';

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

  Future<String> getTravelTime(
      double startLat, double startLng, double endLat, double endLng) async {
    final apiKey = '${GoogleMapKey().googlemapkey}';
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
    print("roooola: $_driverLocation and ${LatLng(pick![1], pick![0])}");
    _getRoutePolylinePoints(_driverLocation, LatLng(pick![1], pick![0]))
        .then((polylinePoints) {
      if (mounted) {
        setState(() async {
          distance = calculateDistance(_driverLocation.latitude,
              _driverLocation.longitude, pick![1], pick![0]);
          ETA = await getTravelTime(driverlocation!.latitude,
              driverlocation!.longitude, pick![1], pick![0]);
          RegExp regExp = RegExp(r"[\d.]+");
          String? match = regExp.stringMatch(distance!);

          if (match != null) {
            // Convert the extracted string to a double
            distanceValue = double.parse(match);
            print(distanceValue); // Output: 0.01
          } else {
            print("No match found");
          }
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
  StreamSubscription<Position>? _positionStreamSubscription;
  void _trackDriverLocation() {
    if (stopemit==false) {
      _positionStreamSubscription = Geolocator.getPositionStream().listen((Position position) {
        if (mounted) {
          setState(() {
            print("Location Emited Continue");
            _driverLocation = LatLng(position.latitude, position.longitude);
            socket.emit('updatedLocation', {'location': _driverLocation});
            _updatePolyline();
          });
        }
      });
    }
    else{
      print("Emit Stoped");
    }
  }
 @override
  void dispose() {
    // TODO: implement dispose
   socket.off('cancelRide');
   _positionStreamSubscription?.cancel();
    super.dispose();
  }
  void _launchCaller(String phoneNumber) async {
    final Uri url = Uri(scheme: 'tel', path: phoneNumber);
    await launchUrl(url);
  }

  bool stopemit = false;

  @override
  Widget build(BuildContext context) {
    Widget bottomModalNonSlideable() {
      return Container(
        //height: ScreenConfig.screenSizeHeight * 0.36,
        width: double.infinity,
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
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      height: 35,
                                      width: 35,
                                      decoration:
                                          squareButtonTemplate(radius: 8),
                                      child: Padding(
                                        padding: const EdgeInsets.all(3.0),
                                        child: Image.asset(
                                            "assets/images/CarIconColored.png",
                                            fit: BoxFit.contain),
                                      ),
                                    ),
                                    spaceWidth(
                                        ScreenConfig.screenSizeWidth * 0.03),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        displayText('Mini',
                                            ScreenConfig.theme.textTheme.labelLarge,
                                            width: 0.3),
                                        displayText(
                                            "$ETA",
                                            ScreenConfig.theme.textTheme.labelLarge
                                                ?.copyWith(fontSize: 9),
                                            width: 0.3),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            spaceHeight(ScreenConfig.screenSizeHeight * 0.01),
                            displayText(
                                "Please Hurry! Your Customer is Waiting",
                                ScreenConfig.theme.textTheme.labelLarge,
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
                                    /*userDetailsContainer(
                                        "assets/images/UserProfileImage.png",
                                        passangername!,
                                        fare!,
                                        true,),*/
                                    Container(
                                      color: Colors.transparent,
                                      child: Row(
                                        children: [
                                          Container(
                                            width:
                                                ScreenConfig.screenSizeWidth *
                                                    0.085,
                                            height:
                                                ScreenConfig.screenSizeWidth *
                                                    0.085,
                                            decoration: BoxDecoration(
                                              image: DecorationImage(
                                                  image: AssetImage(
                                                      'assets/images/UserProfileImage.png'),
                                                  fit: BoxFit.cover),
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(5)),
                                            ),
                                          ),
                                          spaceWidth(
                                              ScreenConfig.screenSizeWidth *
                                                  0.02),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  displayText(
                                                    passangername!,
                                                    ScreenConfig.theme.textTheme
                                                        .bodyMedium,
                                                    width: 0.2,
                                                  ),
                                                ],
                                              ),
                                              displayText(
                                                "Fare:  $fare",
                                                ScreenConfig
                                                    .theme.textTheme.bodyMedium,
                                                width: 0.22,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    spaceHeight(
                                        ScreenConfig.screenSizeHeight * 0.01),
                                    Text(
                                      'If you pick the Passenger\nclick on Below Button',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize:
                                              ScreenConfig.screenSizeWidth *
                                                  0.025),
                                    ),
                                    // userDetailsContainer("assets/images/UserCarImage.png",
                                    //     "Honda Civic", "LXV 5675", false, true, "2019")
                                    spaceHeight(
                                        ScreenConfig.screenSizeHeight * 0.01),
                                    GestureDetector(
                                      onTap: () {
                                        print("Distance Value Is: $distanceValue $distance");
                                        if(distanceValue<=0.1){
                                          setState(() {
                                            stopemit = true;
                                          });
                                          _positionStreamSubscription?.cancel();
                                          socket.emit(
                                              'pickupRide', {'rideId': rideId});
                                          Navigator.of(context).pushReplacementNamed(
                                              DriverSoloRideInProgressAndFinishedScreen
                                                  .routeName,
                                              arguments: {
                                                'pickuplocation': pick,
                                                'dropofflocation': drop,
                                                'passangername': passangername,
                                                'passangerphone': passangerphone,
                                                'fare': fare,
                                                'rideId': rideId,
                                              });
                                        }
                                        else{
                                          Get.snackbar(
                                            'Warning!',
                                            'Your are not on Passenger Pickup Location',
                                            snackPosition: SnackPosition.TOP,
                                            backgroundColor: themeColor,
                                            colorText: Colors.white,
                                            margin: EdgeInsets.all(10),
                                            duration: Duration(seconds: 3),
                                          );
                                        }
                                      },
                                      child: Container(
                                        width:
                                            ScreenConfig.screenSizeWidth * 0.25,
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
                                            padding: const EdgeInsets.all(5.0),
                                            child: displayNoSizedText(
                                                'Passanger Picked',
                                                ScreenConfig
                                                    .theme.textTheme.bodyMedium
                                                    ?.copyWith(
                                                        color: ScreenConfig
                                                            .theme.primaryColor,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                textAlign: TextAlign.center)),
                                      ),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  width: ScreenConfig.screenSizeWidth * 0.20,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          smallSquareButton(
                                              "assets/images/PhoneIcon.png",
                                              () {
                                            _launchCaller(passangerphone!);
                                          }),
                                          smallSquareButton(
                                              "assets/images/EmailIcon.png",
                                              () {}),
                                        ],
                                      ),
                                      spaceHeight(
                                          ScreenConfig.screenSizeHeight * 0.01),
                                      displayText(
                                          "$distance Remaining",
                                          ScreenConfig
                                              .theme.textTheme.bodyMedium,
                                          textAlign: TextAlign.center,
                                          width: 0.22),
                                      spaceHeight(
                                          ScreenConfig.screenSizeHeight *
                                              0.023),
                                      GestureDetector(
                                        onTap: () {
                                          socket.emit('cancelRide',{'rideId':rideId});
                                          Navigator.pop(context);
                                        },
                                        child: Container(
                                          width: ScreenConfig.screenSizeWidth *
                                              0.25,
                                          decoration: BoxDecoration(
                                              color: redFourthColor,
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
                                                  'Cancel Ride',
                                                  ScreenConfig
                                                      .theme.textTheme.bodyMedium
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
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: driverlocation!,
              zoom: 15,
            ),
            markers: {
              Marker(
                markerId: MarkerId('driver'),
                position: _driverLocation,
                infoWindow: InfoWindow(title: 'Yoyr Live Location'),
                icon: BitmapDescriptor.defaultMarkerWithHue(
                    BitmapDescriptor.hueBlue),
              ),
              Marker(
                markerId: MarkerId('passngerpick'),
                position: LatLng(pick![1], pick![0]),
                infoWindow: InfoWindow(title: 'Passanger Pickup'),
                icon: BitmapDescriptor.defaultMarkerWithHue(
                    BitmapDescriptor.hueRed),
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
