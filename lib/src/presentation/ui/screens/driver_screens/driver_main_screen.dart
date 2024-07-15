import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:ridely/src/infrastructure/screen_config/screen_config.dart';
import 'package:ridely/src/models/base%20url.dart';
import 'package:ridely/src/presentation/ui/config/theme.dart';
import 'package:ridely/src/presentation/ui/screens/booking_screens/location_selection_screen.dart';
import 'package:ridely/src/presentation/ui/screens/booking_screens/solo_ride_flow/vehicle_selection_screen.dart';
import 'package:ridely/src/presentation/ui/screens/driver_screens/transactionhistory.dart';
import 'package:ridely/src/presentation/ui/screens/driver_screens/wallet.dart';
import 'package:ridely/src/presentation/ui/screens/onboarding_screens/authentication_selection.dart';
import 'package:ridely/src/presentation/ui/screens/onboarding_screens/login.dart';
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
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:url_launcher/url_launcher.dart';

import '../../templates/previous_rides_screens_widgets/user_details_container.dart';
import '../../templates/ride_widgets/ride_widget_buttons.dart';
import '../booking_screens/solo_ride_flow/solo_ride_shown_screen.dart';
import '../onboarding_screens/register_screens/passangerregistration.dart';
import '../past_rides_screens/Driver_Previou_Ride_Screen.dart';
import 'driver_solo_ride_waiting_screen.dart';

class DriverRideSelectionScreen extends StatefulWidget {
  const DriverRideSelectionScreen({Key? key}) : super(key: key);
  static const routeName = '/driverRideselection-screen';

  @override
  State<DriverRideSelectionScreen> createState() =>
      _DriverRideSelectionScreenState();
}

class _DriverRideSelectionScreenState extends State<DriverRideSelectionScreen> {
  TextEditingController locationEnterController = TextEditingController();
  List namesList = ["Mini ", "Go", "Comfort", "Mini"];
  var datarespose = '';
  String passangerName = '';
  List<double> pick = [];
  List<double> drop = [];
  int fare = 10;
  int rideRequestCount = 0;
  String distance = '';
  String phonenumber = '';
  double raiting = 0.0;

  /*LatLng userlocation = LatLng(9.0, 7.9);*/
  List<Map<String, dynamic>> rides = [];

  @override
  void initState() {
    rideRequestCount==0;
    //_requestPermissionAndGetCurrentLocation();
    initSocket();
    super.initState();
  }

  /*Future<void> _requestPermissionAndGetCurrentLocation() async {
    // Check if location permission is granted
    print("1122Permission Start");
    var status = await Permission.location.request();
    if (status.isGranted) {
      // Get current position
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      print("1122Permission Accepted $position");
      userlocation = LatLng(position.latitude, position.longitude);
      setState(() {
        print("User Live Location in Pick Widget: $userlocation");
        userLiveLocation().userlivelocation=userlocation;
      });
    } else {
      print('Location permission denied');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Center(
            child: Text(
              'Please Give You Live Location',style: TextStyle(fontSize: 15,color: Colors.white),),
          ),
          backgroundColor: Colors.black,
          behavior: SnackBarBehavior.floating,
        ),
      );
      _requestPermissionAndGetCurrentLocation();
    }
  }*/
  late IO.Socket socket;

  initSocket() {
    print(
        'Null or Empty Check: ${PassId().token} -- ${PassId().type} -- ${PassId().id}');
    socket = IO.io(baseulr().burl, <String, dynamic>{
      'transports': ['websocket'],
      'extraHeaders': {
        'authorization': PassId().token,
        'usertype': PassId().type
      },
      'autoConnect': false,
    });
    if (socket.connected) {
      print("Socket Already Connected");
    } else {
      socket.connect();
      socket.onConnect((_) {
        print("Server Connect with Socket");
        setState(() {
          socketconnection().socket = socket;
        });
      });
    }
    socket.emit('registerPassenger', PassId().id);
    socket.on('rideRequest', (data) {
      print("ridedata arrive $data");
      /*datarespose = data['_id'];
      print(" and id is=$datarespose");
      passangerName = data['passenger']['name'];
      phonenumber = data['passenger']['phone'];
      fare = data['fare'];
      pick =  (data['pickupLocation']['coordinates'] as List<dynamic>)
          .map((coordinate) => coordinate is int ? coordinate.toDouble() : coordinate as double)
          .toList();
      drop = (data['dropoffLocation']['coordinates'] as List<dynamic>)
          .map((coordinate) => coordinate is int ? coordinate.toDouble() : coordinate as double)
          .toList();
      distance = calculateDistance(pick[1], pick[0], drop[1], drop[0]);
      print(
          'Dynamic Data is: name=$passangerName, fare=$fare, distance=$distance');*/
      Map<String, dynamic> rideData = {
        'id': data['_id'],
        'passengerName': data['passenger']['name'],
        'phoneNumber': data['passenger']['phone'],
        'fare': data['fare'],
        'pickupLocation':
            (data['pickupLocation']['coordinates'] as List<dynamic>)
                .map((coordinate) => coordinate is int
                    ? coordinate.toDouble()
                    : coordinate as double)
                .toList(),
        'dropoffLocation':
            (data['dropoffLocation']['coordinates'] as List<dynamic>)
                .map((coordinate) => coordinate is int
                    ? coordinate.toDouble()
                    : coordinate as double)
                .toList(),
        'distance': calculateDistance(
          (data['pickupLocation']['coordinates'][1] as num).toDouble(),
          (data['pickupLocation']['coordinates'][0] as num).toDouble(),
          (data['dropoffLocation']['coordinates'][1] as num).toDouble(),
          (data['dropoffLocation']['coordinates'][0] as num).toDouble(),
        )
      };
      rides.add(rideData);
      print('Ride Data is Arrive in Map: $rideData');
      rideRequestCount++;
      setState(() {
        print("setstate is run");
      });
    });
    socket.on('rideCompleted', (data) {
      print(">>>>>$data");
      print(
          "data of eve: $pick $drop $passangerName $phonenumber $fare $distance");
      setState(() {
        rides==[];
      });
      Navigator.of(context)
          .pushNamed(DriverSoloRideWaitingScreen.routeName, arguments: {
        'pickuplocation': pick,
        'dropofflocation': drop,
        'passangername': passangerName,
        'passangerphone': phonenumber,
        'fare': fare,
        'rideId': datarespose,
        'name': passangerName,
        //'raiting':raiting,
        'passangerphone': phonenumber
      });
    });
  }

  bool isLoading = false;

  void startLoading() {
    setState(() {
      isLoading = true;
    });

    // Simulating a 3-second delay
    Future.delayed(Duration(seconds: 10), () {
      if (isLoading == true) {
        setState(() {
          isLoading = false;
          rides==[];
        });
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    socket.off('rideRequest');
    socket.off('rideCompleted');
    super.dispose();
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

  void acceptrides(String rideId) {
    print("Ride is is this this: $rideId");
    final payload = {'rideId': rideId, 'driverId': PassId().id};
    socket.emit('acceptRide', payload);
  }

  void _launchCaller(String phoneNumber) async {
    final Uri url = Uri(scheme: 'tel', path: phoneNumber);
    await launchUrl(url);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: ()async{
          return false;
        },
        child: Scaffold(
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
                padding:
                    EdgeInsets.all(MediaQuery.sizeOf(context).width * 0.04),
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
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                                  DriverPreviousRidesScreen()));
                        },
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
                    SizedBox(
                      height: MediaQuery.sizeOf(context).height * 0.04,
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          await prefs.remove('islogin');
                          await prefs.remove('uid');
                          await prefs.remove('utoken');
                          await prefs.remove('utype');
                          Navigator.pushReplacement(context,
                              MaterialPageRoute(builder: (context) => Login()));
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
            body: isLoading
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(
                          color: themeColor,
                        ),
                        SizedBox(height: 20),
                        Text("Wait for Passange's Responce"),
                      ],
                    ),
                  )
                : SizedBox(
                    width: ScreenConfig.screenSizeWidth,
                    child: Center(
                      child: SizedBox(
                        height: ScreenConfig.screenSizeHeight,
                        width: ScreenConfig.screenSizeWidth * 0.9,
                        child: SingleChildScrollView(
                            physics: const ClampingScrollPhysics(),
                            child: Column(
                              children: [
                                spaceHeight(
                                    ScreenConfig.screenSizeHeight * 0.02),
                                Column(
                                  children:
                                      List.generate(rides.length, (index) {
                                    final ride = rides[index];
                                    return Column(
                                      children: [
                                        Container(
                                          // height: ScreenConfig.screenSizeHeight * 0.26,
                                          width: ScreenConfig.screenSizeWidth *
                                              0.9,
                                          decoration: blueContainerTemplate(),
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: ScreenConfig
                                                        .screenSizeHeight *
                                                    0.02,
                                                horizontal: ScreenConfig
                                                        .screenSizeWidth *
                                                    0.05),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                displayText(
                                                    "You Found A Passenger!",
                                                    ScreenConfig
                                                        .theme.textTheme.button,
                                                    width: 0.8),
                                                spaceHeight(ScreenConfig
                                                        .screenSizeHeight *
                                                    0.025),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        Container(
                                                          color: Colors
                                                              .transparent,
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
                                                                      fit: BoxFit
                                                                          .cover),
                                                                  borderRadius:
                                                                      const BorderRadius
                                                                          .all(
                                                                          Radius.circular(
                                                                              5)),
                                                                ),
                                                              ),
                                                              spaceWidth(
                                                                  ScreenConfig
                                                                          .screenSizeWidth *
                                                                      0.03),
                                                              Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Text(
                                                                    "${ride['passengerName']}",
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            ScreenConfig.screenSizeWidth *
                                                                                0.03),
                                                                  ),
                                                                  Text(
                                                                    "Rating: 4.2 *",
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            ScreenConfig.screenSizeWidth *
                                                                                0.03),
                                                                  ),
                                                                  Text(
                                                                    "Distance: ${ride['distance']}",
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            ScreenConfig.screenSizeWidth *
                                                                                0.03),
                                                                  ),
                                                                  Text(
                                                                    "Fare: ${ride['fare']}",
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            ScreenConfig.screenSizeWidth *
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
                                                      width: ScreenConfig
                                                              .screenSizeWidth *
                                                          0.22,
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        children: [
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              smallSquareButton(
                                                                  "assets/images/PhoneIcon.png",
                                                                  () {
                                                                _launchCaller(ride[
                                                                    'phoneNumber']);
                                                              }),
                                                              smallSquareButton(
                                                                  "assets/images/EmailIcon.png",
                                                                  () {}),
                                                            ],
                                                          ),
                                                          spaceHeight(ScreenConfig
                                                                  .screenSizeHeight *
                                                              0.035),
                                                          GestureDetector(
                                                            onTap: () {
                                                              setState(() {
                                                                pick = ride[
                                                                    'pickupLocation'];
                                                                drop = ride[
                                                                    'dropoffLocation'];
                                                                passangerName =
                                                                    ride[
                                                                        'passengerName'];
                                                                phonenumber = ride[
                                                                    'phoneNumber'];
                                                                fare = ride[
                                                                    'fare'];
                                                                datarespose =
                                                                    ride['id'];
                                                              });
                                                              acceptrides(
                                                                  ride['id']);
                                                              startLoading();
                                                            },
                                                            child: Container(
                                                              width: ScreenConfig
                                                                      .screenSizeWidth *
                                                                  0.25,
                                                              decoration: BoxDecoration(
                                                                  color:
                                                                      thirdColor,
                                                                  borderRadius:
                                                                      const BorderRadius
                                                                          .all(
                                                                          Radius.circular(
                                                                              5)),
                                                                  boxShadow: [
                                                                    BoxShadow(
                                                                      color: Colors
                                                                          .grey
                                                                          .withOpacity(
                                                                              0.40),
                                                                      offset: const Offset(
                                                                          0.0,
                                                                          1.2),
                                                                      //(x,y)
                                                                      blurRadius:
                                                                          6.0,
                                                                    )
                                                                  ]),
                                                              child: Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .all(
                                                                          5.0),
                                                                  child: displayNoSizedText(
                                                                      'Confirm Ride',
                                                                      ScreenConfig
                                                                          .theme
                                                                          .textTheme
                                                                          .caption
                                                                          ?.copyWith(
                                                                              color: ScreenConfig
                                                                                  .theme.primaryColor,
                                                                              fontWeight: FontWeight
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
                                            ScreenConfig.screenSizeHeight *
                                                0.015),
                                      ],
                                    );
                                  }),
                                ),
                              ],
                            )),
                      ),
                    ))));
  }
}

class socketconnection {
  static final socketconnection _instance = socketconnection._internal();

  factory socketconnection() {
    return _instance;
  }

  socketconnection._internal();

  late IO.Socket socket;
}
