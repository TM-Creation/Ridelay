import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ridely/src/infrastructure/screen_config/screen_config.dart';
import 'package:ridely/src/models/base%20url.dart';
import 'package:ridely/src/presentation/ui/config/theme.dart';
import 'package:ridely/src/presentation/ui/screens/booking_screens/location_selection_screen.dart';
import 'package:ridely/src/presentation/ui/screens/booking_screens/solo_ride_flow/vehicle_selection_screen.dart';
import 'package:ridely/src/presentation/ui/screens/driver_screens/transactionhistory.dart';
import 'package:ridely/src/presentation/ui/screens/driver_screens/wallet.dart';
import 'package:ridely/src/presentation/ui/screens/past_rides_screens/previous_rides_screen.dart';
import 'package:ridely/src/presentation/ui/templates/decorations/box_decoration_templates.dart';
import 'package:ridely/src/presentation/ui/templates/main_generic_templates/app_bars/app_bar.dart';
import 'package:ridely/src/presentation/ui/templates/main_generic_templates/app_buttons/buttons.dart';
import 'package:ridely/src/presentation/ui/templates/main_generic_templates/booking_widgets/map_widgets.dart';
import 'package:ridely/src/presentation/ui/templates/main_generic_templates/other_widgets/slider_for_bottom_navigation.dart';
import 'package:ridely/src/presentation/ui/templates/main_generic_templates/spacing_widgets.dart';
import 'package:ridely/src/presentation/ui/templates/main_generic_templates/text_templates/display_text.dart';
import 'package:ridely/src/presentation/ui/templates/ride_widgets/driver_ride_detail_widgets.dart';
import 'package:ridely/src/presentation/ui/templates/ride_widgets/ride_detail_widgets.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../../templates/previous_rides_screens_widgets/user_details_container.dart';
import '../../templates/ride_widgets/ride_widget_buttons.dart';
import '../onboarding_screens/register_screens/passangerregistration.dart';
import 'dart:math';

class DriverRideSelectionScreen extends StatefulWidget {
  const DriverRideSelectionScreen({Key? key}) : super(key: key);
  static const routeName = '/driverRideselection-screen';

  @override
  State<DriverRideSelectionScreen> createState() =>
      _DriverRideSelectionScreenState();
}

class _DriverRideSelectionScreenState extends State<DriverRideSelectionScreen> {
  TextEditingController locationEnterController = TextEditingController();
  List namesList = ["Mini", "Go", "Comfort", "Mini"];
  var _rideID = '',
      _passangerName = '',
      _passangerRaiting = '',
      _passangerridefare = '',
      _passangerphone = '',
      _passangerId = '';
  String distance='';
  LatLng pick=LatLng(32.00, 33.22);
  LatLng drop=LatLng(32.00, 33.22);
  int rideRequestCount = 0;
  String name = '';

  @override
  void initState() {
    initSocket();
    super.initState();
  }

  late IO.Socket socket;

  initSocket() {
    socket =
        IO.io('https://92f9-110-93-223-135.ngrok-free.app', <String, dynamic>{
      'transports': ['websocket'],
      'extraHeaders': {
        'authorization': PassId().token,
        'usertype': PassId().type
      },
      'autoConnect': false,
    });
    socket.connect();
    socket.onConnect((_) {
      print("Server Connect with Socket");
    });
    socket.emit('registerPassenger', PassId().id);
    socket.on('rideRequest', (data) {
      rideRequestCount++;
      print("ridedata arrive $data");
      _rideID = data['_id'];
      var passangerdata = data['passenger'];
      _passangerId
      _passangerName = passangerdata['name'];
      _passangerridefare = data['fare'];
      var pickloc=data['pickupLocation'];
      pick=pickloc['coordinates'];
      var droploc=data['dropoffLocation'];
      drop=droploc['coordinates'];
      distance= calculateDistance(pick.latitude, pick.longitude, drop.latitude, drop.longitude);
      print('dynamic data');
      setState(() {
        print("setstate is run");
      });
    });
    socket.on('rideCompleted', (data) {
      print(">>>>>$data");
    });
  }

  @override
  void dispose() {
    socket.off('rideRequest');
    socket.off('rideCompleted');
    socket.disconnect();
    super.dispose();
  }

  void acceptrides() {
    final payload = {'rideId': _rideID, 'driverId': PassId().id};
    socket.emit('acceptRide', payload);
  }

  String calculateDistance(
      double pickupLat, double pickupLon, double dropoffLat, double dropoffLon,
      {String unit = 'km'}) {
    const earthRadiusKm = 6371; // Earth's radius in kilometers
    const earthRadiusMiles = 3958.8; // Earth's radius in miles

    double degreeToRadian(double degree) {
      return degree * pi / 180;
    }

    final lat1Rad = degreeToRadian(pickupLat);
    final lon1Rad = degreeToRadian(pickupLon);
    final lat2Rad = degreeToRadian(dropoffLat);
    final lon2Rad = degreeToRadian(dropoffLon);

    final dLat = lat2Rad - lat1Rad;
    final dLon = lon2Rad - lon1Rad;

    final a = sin(dLat / 2) * sin(dLat / 2) +
        cos(lat1Rad) * cos(lat2Rad) * sin(dLon / 2) * sin(dLon / 2);
    final c = 2 * atan2(sqrt(a), sqrt(1 - a));

    final distanceKm = earthRadiusKm * c;
    final distanceMiles = earthRadiusMiles * c;

    if (unit == 'miles') {
      return '${distanceMiles.toStringAsFixed(2)} miles';
    } else {
      return '${distanceKm.toStringAsFixed(2)} km';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: displayNoSizedText(
            "Confirm Your Ride Partner",
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
                  child: Container(
                    width: 70.0,
                    height: 70.0,
                    decoration: BoxDecoration(
                      color: const Color(0xff7c94b6),
                      image: DecorationImage(
                        image: AssetImage('assets/images/AppIcon.png'),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(50.0)),
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.sizeOf(context).height * 0.01,
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
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Wallet(),
                          ));
                    },
                    child: const Text("Wallet"),
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
                SizedBox(
                  height: MediaQuery.sizeOf(context).height * 0.03,
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TransactionHistory(),
                          ));
                    },
                    child: const Text("Transaction History"),
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
                SizedBox(
                  height: MediaQuery.sizeOf(context).height * 0.03,
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => null,
                    child: const Text("Ride History"),
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
        body: SizedBox(
            width: ScreenConfig.screenSizeWidth,
            child: Center(
              child: SizedBox(
                height: ScreenConfig.screenSizeHeight,
                width: ScreenConfig.screenSizeWidth * 0.9,
                child: SingleChildScrollView(
                    physics: const ClampingScrollPhysics(),
                    child: Column(
                      children: [
                        spaceHeight(ScreenConfig.screenSizeHeight * 0.02),
                        Column(
                          children: List.generate(rideRequestCount, (index) {
                            return Column(
                              children: [
                                Container(
                                  // height: ScreenConfig.screenSizeHeight * 0.26,
                                  width: ScreenConfig.screenSizeWidth * 0.9,
                                  decoration: blueContainerTemplate(),
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical:
                                            ScreenConfig.screenSizeHeight *
                                                0.02,
                                        horizontal:
                                            ScreenConfig.screenSizeWidth *
                                                0.05),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        displayText("You Found A Passenger!",
                                            ScreenConfig.theme.textTheme.button,
                                            width: 0.8),
                                        spaceHeight(
                                            ScreenConfig.screenSizeHeight *
                                                0.025),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Container(
                                                  color: Colors.transparent,
                                                  child: Row(
                                                    children: [
                                                      Container(
                                                        width: ScreenConfig
                                                                .screenSizeWidth *
                                                            0.15,
                                                        height: ScreenConfig
                                                                .screenSizeWidth *
                                                            0.15,
                                                        decoration:
                                                            BoxDecoration(
                                                          image: DecorationImage(
                                                              image: AssetImage(
                                                                  'assets/images/UserProfileImage.png'),
                                                              fit:
                                                                  BoxFit.cover),
                                                          borderRadius:
                                                              const BorderRadius
                                                                  .all(Radius
                                                                      .circular(
                                                                          5)),
                                                        ),
                                                      ),
                                                      spaceWidth(ScreenConfig
                                                              .screenSizeWidth *
                                                          0.03),
                                                      Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            "Taha Ahmad",
                                                            style: TextStyle(
                                                                fontSize:
                                                                    ScreenConfig
                                                                            .screenSizeWidth *
                                                                        0.03),
                                                          ),
                                                          Text(
                                                            "Rating: * 5.1",
                                                            style: TextStyle(
                                                                fontSize:
                                                                    ScreenConfig
                                                                            .screenSizeWidth *
                                                                        0.03),
                                                          ),
                                                          Text(
                                                            "Distance: ",
                                                            style: TextStyle(
                                                                fontSize:
                                                                    ScreenConfig
                                                                            .screenSizeWidth *
                                                                        0.03),
                                                          ),
                                                          Text(
                                                            "Fare: ",
                                                            style: TextStyle(
                                                                fontSize:
                                                                    ScreenConfig
                                                                            .screenSizeWidth *
                                                                        0.03),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                spaceHeight(ScreenConfig
                                                        .screenSizeHeight *
                                                    0.02),
                                                // userDetailsContainer("assets/images/UserCarImage.png",
                                                //     "Honda Civic", "LXV 5675", false, true, "2019")
                                              ],
                                            ),
                                            SizedBox(
                                              width:
                                                  ScreenConfig.screenSizeWidth *
                                                      0.22,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      smallSquareButton(
                                                          "assets/images/PhoneIcon.png",
                                                          () {}),
                                                      smallSquareButton(
                                                          "assets/images/EmailIcon.png",
                                                          () {}),
                                                    ],
                                                  ),
                                                  spaceHeight(ScreenConfig
                                                          .screenSizeHeight *
                                                      0.01),
                                                  displayText(
                                                      "15km Remaining",
                                                      ScreenConfig.theme
                                                          .textTheme.bodyText2,
                                                      textAlign:
                                                          TextAlign.center,
                                                      width: 0.22),
                                                  spaceHeight(ScreenConfig
                                                          .screenSizeHeight *
                                                      0.01),
                                                  GestureDetector(
                                                    onTap: () {
                                                      acceptrides();
                                                    },
                                                    child: Container(
                                                      width: ScreenConfig
                                                              .screenSizeWidth *
                                                          0.25,
                                                      decoration: BoxDecoration(
                                                          color: thirdColor,
                                                          borderRadius:
                                                              const BorderRadius
                                                                  .all(Radius
                                                                      .circular(
                                                                          5)),
                                                          boxShadow: [
                                                            BoxShadow(
                                                              color: Colors.grey
                                                                  .withOpacity(
                                                                      0.40),
                                                              offset:
                                                                  const Offset(
                                                                      0.0, 1.2),
                                                              //(x,y)
                                                              blurRadius: 6.0,
                                                            )
                                                          ]),
                                                      child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(5.0),
                                                          child: displayNoSizedText(
                                                              'Confirm Ride',
                                                              ScreenConfig
                                                                  .theme
                                                                  .textTheme
                                                                  .caption
                                                                  ?.copyWith(
                                                                      color: ScreenConfig
                                                                          .theme
                                                                          .primaryColor,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold),
                                                              textAlign:
                                                                  TextAlign
                                                                      .center)),
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
                                spaceHeight(
                                    ScreenConfig.screenSizeHeight * 0.015),
                              ],
                            );
                          }),
                        ),
                      ],
                    )),
              ),
            )));
  }
}
