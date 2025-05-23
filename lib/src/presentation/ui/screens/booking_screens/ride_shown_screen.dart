import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ridely/src/infrastructure/screen_config/screen_config.dart';
import 'package:ridely/src/models/base%20url.dart';
import 'package:ridely/src/presentation/ui/config/theme.dart';
import 'package:ridely/src/presentation/ui/screens/booking_screens/faraupdatescreen.dart';
import 'package:ridely/src/presentation/ui/screens/booking_screens/ride_waiting_screen.dart';
import 'package:ridely/src/presentation/ui/screens/driver_screens/driver_main_screen.dart';
import 'package:ridely/src/presentation/ui/screens/past_rides_screens/previous_rides_screen.dart';
import 'package:ridely/src/presentation/ui/templates/decorations/box_decoration_templates.dart';
import 'package:ridely/src/presentation/ui/templates/main_generic_templates/app_bars/app_bar.dart';
import 'package:ridely/src/presentation/ui/templates/main_generic_templates/app_buttons/buttons.dart';
import 'package:ridely/src/presentation/ui/templates/main_generic_templates/booking_widgets/map_widgets.dart';
import 'package:ridely/src/presentation/ui/templates/main_generic_templates/other_widgets/slider_for_bottom_navigation.dart';
import 'package:ridely/src/presentation/ui/templates/main_generic_templates/spacing_widgets.dart';
import 'package:ridely/src/presentation/ui/templates/main_generic_templates/text_templates/display_text.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import '../../templates/previous_rides_screens_widgets/user_details_container.dart';
import '../onboarding_screens/register_screens/passangerregistration.dart';

class RideShownScreen extends StatefulWidget {
  const RideShownScreen({Key? key}) : super(key: key);
  static const routeName = '/rideshown-screen';

  @override
  State<RideShownScreen> createState() => _RideShownScreenState();
}

class _RideShownScreenState extends State<RideShownScreen> {
  TextEditingController pickupEnterController = TextEditingController();
  TextEditingController dropoffEnterController = TextEditingController();
  String image = "assets/images/LocationDistanceScreenMap.png", vahicle = '';
  List namesList = ["Mini", "Go", "Comfort"];
  int mini = 50, Go = 50, Comfort = 50;
  bool min = false, go = false, comfrt = false, rikshaw = false, bik = false;
  bool showConfirmYourRide = false;
  String distance = '', duration = '';
  double? totaldistance;
  int minifare = 0, gofare = 0, comfortfare = 0, rickshawfare = 0, bykefare = 0;
  int fare = 454;
  String ETA = '';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Retrieve pickup and drop-off locations from arguments after dependencies change
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, String>?;
    if (args != null) {
      setState(() {
        pickupEnterController.text = args['pickupLocation']!;
        dropoffEnterController.text = args['dropoffLocation']!;
        vahicle = args['vah']!;
        distance = args['distance']!;
        duration = args['duration']!;
        totaldistance =
            double.tryParse(distance.replaceAll(RegExp(r'[^0-9.]'), ''));
        minifare = (60 * totaldistance!).toInt();
        gofare = (70 * totaldistance!).toInt();
        comfortfare = (80 * totaldistance!).toInt();
        rickshawfare = (45 * totaldistance!).toInt();
        bykefare = (35 * totaldistance!).toInt();
        print(
            'Polyline error cheeek: ${pickupEnterController.text} ${dropoffEnterController.text}');
      });
    }
  }

  void assignFare() {
    setState(() {
      if (go) {
        fare = gofare;
      } else if (min) {
        fare = minifare;
      } else if (comfrt) {
        fare = comfortfare;
      } else if (rikshaw) {
        fare = rickshawfare;
      } else if (bik) {
        fare = bykefare;
      } else {
        fare = 0; // Default fare if no condition is true
      }
      sendridereq();
    });
  }

  bool isdriveraccept = false, requestshow = false;
  String drivername = '';
  double driverraiting = 4.2;

  //String driverimage='';
  //String? vahicleimage;
  String vahiclename = '';
  String numberplate = '';
  List<Map<String, dynamic>> drivers = [];

  @override
  void initState() {
    getprefdata();
    print("initState call");
    super.initState();
  }

  Future<void> getprefdata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    id = await prefs.getString('uid');
    token = await prefs.getString('utoken');
    type = await prefs.getString('utype');
    initSocket();
  }

  late IO.Socket socket;
  late final String? id;
  late final String? token;
  late final String? type;
  var reqrideid = '';
  var driverid = '';
  final LatLng? pickuplocation = pickanddrop().pickloc,
      dropofflocation = pickanddrop().droploc;

  initSocket() {
    print('Null or Empty Check: $token -- $type -- $id');
    socket = IO.io(baseulr().burl, <String, dynamic>{
      'transports': ['websocket'],
      'extraHeaders': {'authorization': token, 'usertype': type},
      'autoConnect': false,
    });
    if (socket.connected) {
      print('Socket Already Connected');
    } else {
      socket.connect();
      socket.onConnect((_) {
        print("Server Connect with Socket");
        setState(() {
          socketconnection().socket = socket;
        });
      });
    }
    socket.emit('registerPassenger', id);
    /*socket.on('rideAccepted', (data) {
      print("$data ride is accept ");
      isdriveraccept=false;
      requestshow=true;
      Map<String,dynamic> driverData={
        'driverName':data['driver']['name'],
        'driverRaiting':data['driver']['rating'],
        'vahicleName':data['vehicle']['name'],
        'numberPlate':data['vehicle']['numberPlate'],
        'rideId':data['_id'],
        'driverId':data['driver']['_id'],
      };

      */ /*  drivername=data['driver']['name'];
      //driverimage=data['driver']['driverImage'];
      driverraiting=data['driver']['rating'];
      //vahicleimage=data['vehicle']['vehicleImage'];
      vahiclename=data['vehicle']['name'];
      numberplate=data['vehicle']['numberPlate'];
      reqrideid = data['_id'];
      final driver=data['driver'];
      driverid=driver['_id']; */ /*
      drivers.add(driverData);
      counter++;
      setState(() {
        print("check sestate");
      });
    }); */
  }

  void sendridereq() {
    // Create payload
    final payload = {
      'passengerId': id,
      'pickupLocation': {'coordinates': pickanddrop().pickloc},
      'dropoffLocation': {'coordinates': pickanddrop().droploc},
      'fare': fare,
      'distance': distance
    };
    print("${pickanddrop().pickloc} and 2nd is ${pickanddrop().droploc}");
    // Emit the 'rideRequest' event with the payload
    socket.emit('rideRequest', payload);
    print('Emitted rideRequest with payload: $payload');
    socket.on('rideRequested', (data) {
      if (!mounted) return;
      print("data of riderequest $data");
      reqrideid=data['_id'];
      print('Ride Id is here $reqrideid');
      Navigator.pushReplacementNamed(context, FareUpdateScreen.routeName,
          arguments: {
            "pickupLocation": pickupEnterController.text,
            "dropoffLocation": dropoffEnterController.text,
            //"driverName":drivername,
            //"driverRaiting":driverraiting,
            //"vahicleName":vahiclename,
            //"vahicleNumberplate":numberplate,
            "fare": fare,
            "distance" : distance
            //"rideid": reqrideid,
            //"driverID":driverid
          });
    });

    //isdriveraccept=true;
  }
  @override
  void dispose() {
    socket.off('rideRequested'); // Remove the listener
    super.dispose();
  }

//6654523062cc5411c069d411
  @override
  String typeofvahicle = '';

  /*void acceptstatus(String rideId,String driverId) {
    print("Ride ID and Driver ID is this: $rideId $driverid");
    final payload = {'rideId': reqrideid,
    'driverId':driverid};
    socket.emit('confirmRide', payload);
    print('Driver Accepted');
    Navigator.pushReplacementNamed(context, FareUpdateScreen.routeName,arguments: {
      "pickupLocation":pickupEnterController.text,
      "dropoffLocation": dropoffEnterController.text,
      "driverName":drivername,
      "driverRaiting":driverraiting,
      "vahicleName":vahiclename,
      "vahicleNumberplate":numberplate,
      "fare":fare,
      "rideid":reqrideid,
      "driverID":driverid
    });
  }*/
  @override
  Widget build(BuildContext context) {
    Widget confirmYourRideWidget(String typeofvahicle) {
      return Container(
        height: ScreenConfig.screenSizeHeight * 0.25,
        width: ScreenConfig.screenSizeWidth * 0.9,
        decoration: squareButtonTemplate(),
        child: SizedBox(
          width: ScreenConfig.screenSizeWidth * 0.8,
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: ScreenConfig.screenSizeWidth * 0.05),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                SizedBox(
                  height: ScreenConfig.screenSizeHeight * 0.23,
                  width: ScreenConfig.screenSizeWidth * 0.3,
                  child: Image.asset(
                    "assets/images/DriverAsset.png",
                    fit: BoxFit.contain,
                  ),
                ),
                SizedBox(
                  width: ScreenConfig.screenSizeWidth * 0.4,
                  height: ScreenConfig.screenSizeHeight * 0.25,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      spaceHeight(ScreenConfig.screenSizeHeight * 0.02),
                      Buttons.crossSmallButton(context, () {
                        setState(() {
                          showConfirmYourRide = false;
                          min = false;
                          go = false;
                          comfrt = false;
                          bik = false;
                          rikshaw = false;
                        });
                      }),
                      spaceHeight(ScreenConfig.screenSizeHeight * 0.03),
                      displayText(
                          "Please Confirm Your Ride",
                          ScreenConfig.theme.textTheme.displayLarge
                              ?.copyWith(fontWeight: FontWeight.bold),
                          textAlign: TextAlign.start,
                          width: 0.4),
                      spaceHeight(ScreenConfig.screenSizeHeight * 0.02),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                showConfirmYourRide = false;
                                min = false;
                                go = false;
                                comfrt = false;
                                bik = false;
                                rikshaw = false;
                              });
                            },
                            child: Container(
                              height: 25,
                              width: ScreenConfig.screenSizeWidth * 0.19,
                              decoration: redContainerTemplate(radius: 5),
                              child: Center(
                                child: displayText("CANCEL",
                                    ScreenConfig.theme.textTheme.labelLarge,
                                    width: 0.15, textAlign: TextAlign.center),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              /*Navigator.of(context).pushNamed(
                                RideWaitingScreen.routeName,
                                arguments: {
                                  'pickupLocation': pickupEnterController.text,
                                  'dropoffLocation':
                                      dropoffEnterController.text,
                                  'vah': typeofvahicle,
                                  'distance': distance,
                                  'duration': distance
                                },
                              );*/
                              assignFare();
                            },
                            child: Container(
                              height: 25,
                              width: ScreenConfig.screenSizeWidth * 0.2,
                              decoration: blueContainerTemplate(radius: 5),
                              child: Center(
                                child: displayText("CONFIRM",
                                    ScreenConfig.theme.textTheme.labelLarge,
                                    width: 0.2, textAlign: TextAlign.center),
                              ),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      );
    }

    Widget bottomModalNonSlideable() {
      return Container(
        height: ScreenConfig.screenSizeHeight * 0.34,
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
                  height: ScreenConfig.screenSizeHeight * 0.24,
                  width: ScreenConfig.screenSizeWidth * 0.8,
                  child: vahicle == "car"
                      ? SingleChildScrollView(
                          physics: const ClampingScrollPhysics(),
                          child: Column(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    showConfirmYourRide = true;
                                    min = !min;
                                    go = false;
                                    comfrt = false;
                                    typeofvahicle = "Mini";
                                    print("$typeofvahicle");
                                  });
                                  if (min == false) {
                                    setState(() {
                                      showConfirmYourRide = false;
                                    });
                                  }
                                },
                                child: Column(
                                  children: [
                                    Container(
                                      height:
                                          ScreenConfig.screenSizeHeight * 0.07,
                                      width: ScreenConfig.screenSizeWidth * 0.9,
                                      decoration: min == false
                                          ? blueContainerTemplate()
                                          : greyContainerTemplate(),
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 2.0,
                                            horizontal:
                                                ScreenConfig.screenSizeWidth *
                                                    0.05),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Row(
                                              children: [
                                                Container(
                                                  height: 35,
                                                  width: 35,
                                                  decoration:
                                                      squareButtonTemplate(
                                                          radius: 8),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            3.0),
                                                    child: Image.asset(
                                                        "assets/images/CarIconColored.png",
                                                        fit: BoxFit.contain),
                                                  ),
                                                ),
                                                spaceWidth(ScreenConfig
                                                        .screenSizeWidth *
                                                    0.03),
                                                Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    displayText(
                                                        namesList[0],
                                                        ScreenConfig.theme
                                                            .textTheme.labelLarge,
                                                        width: 0.3),
                                                    displayText(
                                                        "$duration",
                                                        ScreenConfig.theme
                                                            .textTheme.labelLarge
                                                            ?.copyWith(
                                                                fontSize: 15),
                                                        width: 0.3),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 5.0),
                                              child: displayText(
                                                  "RS. $minifare",
                                                  min
                                                      ? ScreenConfig.theme
                                                          .textTheme.labelLarge
                                                          ?.copyWith(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold)
                                                      : ScreenConfig.theme
                                                          .textTheme.titleMedium
                                                          ?.copyWith(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                  textAlign: TextAlign.end,
                                                  width: 0.2),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    spaceHeight(
                                        ScreenConfig.screenSizeHeight * 0.015),
                                  ],
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    showConfirmYourRide = true;
                                    min = false;
                                    go = !go;
                                    comfrt = false;
                                    typeofvahicle = "Go";
                                    print("$typeofvahicle");
                                  });
                                  if (go == false) {
                                    setState(() {
                                      showConfirmYourRide = false;
                                    });
                                  }
                                },
                                child: Column(
                                  children: [
                                    Container(
                                      height:
                                          ScreenConfig.screenSizeHeight * 0.07,
                                      width: ScreenConfig.screenSizeWidth * 0.9,
                                      decoration: go == false
                                          ? blueContainerTemplate()
                                          : greyContainerTemplate(),
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 2.0,
                                            horizontal:
                                                ScreenConfig.screenSizeWidth *
                                                    0.05),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Row(
                                              children: [
                                                Container(
                                                  height: 35,
                                                  width: 35,
                                                  decoration:
                                                      squareButtonTemplate(
                                                          radius: 8),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            3.0),
                                                    child: Image.asset(
                                                        "assets/images/CarIconColored.png",
                                                        fit: BoxFit.contain),
                                                  ),
                                                ),
                                                spaceWidth(ScreenConfig
                                                        .screenSizeWidth *
                                                    0.03),
                                                Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    displayText(
                                                        namesList[1],
                                                        ScreenConfig.theme
                                                            .textTheme.labelLarge,
                                                        width: 0.3),
                                                    displayText(
                                                        "$duration",
                                                        ScreenConfig.theme
                                                            .textTheme.labelLarge
                                                            ?.copyWith(
                                                                fontSize: 15),
                                                        width: 0.3),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 5.0),
                                              child: displayText(
                                                  "RS. $gofare",
                                                  go
                                                      ? ScreenConfig.theme
                                                          .textTheme.labelLarge
                                                          ?.copyWith(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold)
                                                      : ScreenConfig.theme
                                                          .textTheme.titleMedium
                                                          ?.copyWith(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                  textAlign: TextAlign.end,
                                                  width: 0.2),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    spaceHeight(
                                        ScreenConfig.screenSizeHeight * 0.015),
                                  ],
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    showConfirmYourRide = true;
                                    min = false;
                                    go = false;
                                    comfrt = !comfrt;
                                    typeofvahicle = "Comfort";
                                    print("$typeofvahicle");
                                  });
                                  if (comfrt == false) {
                                    setState(() {
                                      showConfirmYourRide = false;
                                    });
                                  }
                                },
                                child: Column(
                                  children: [
                                    Container(
                                      height:
                                          ScreenConfig.screenSizeHeight * 0.07,
                                      width: ScreenConfig.screenSizeWidth * 0.9,
                                      decoration: comfrt == false
                                          ? blueContainerTemplate()
                                          : greyContainerTemplate(),
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 2.0,
                                            horizontal:
                                                ScreenConfig.screenSizeWidth *
                                                    0.05),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Row(
                                              children: [
                                                Container(
                                                  height: 35,
                                                  width: 35,
                                                  decoration:
                                                      squareButtonTemplate(
                                                          radius: 8),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            3.0),
                                                    child: Image.asset(
                                                        "assets/images/CarIconColored.png",
                                                        fit: BoxFit.contain),
                                                  ),
                                                ),
                                                spaceWidth(ScreenConfig
                                                        .screenSizeWidth *
                                                    0.03),
                                                Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    displayText(
                                                        namesList[2],
                                                        ScreenConfig.theme
                                                            .textTheme.labelLarge,
                                                        width: 0.3),
                                                    displayText(
                                                        "$duration",
                                                        ScreenConfig.theme
                                                            .textTheme.labelLarge
                                                            ?.copyWith(
                                                                fontSize: 15),
                                                        width: 0.3),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 5.0),
                                              child: displayText(
                                                  "RS. $comfortfare",
                                                  comfrt
                                                      ? ScreenConfig.theme
                                                          .textTheme.labelLarge
                                                          ?.copyWith(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold)
                                                      : ScreenConfig.theme
                                                          .textTheme.titleMedium
                                                          ?.copyWith(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                  textAlign: TextAlign.end,
                                                  width: 0.2),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    spaceHeight(
                                        ScreenConfig.screenSizeHeight * 0.015),
                                  ],
                                ),
                              )
                            ],
                          ),
                        )
                      : vahicle == "rickshaw"
                          ? GestureDetector(
                              onTap: () {
                                setState(() {
                                  showConfirmYourRide = !showConfirmYourRide;
                                  rikshaw = !rikshaw;
                                  typeofvahicle = "Rickshaw";
                                  print("$typeofvahicle");
                                });
                              },
                              child: Column(
                                children: [
                                  Container(
                                    height:
                                        ScreenConfig.screenSizeHeight * 0.07,
                                    width: ScreenConfig.screenSizeWidth * 0.9,
                                    decoration: rikshaw == false
                                        ? blueContainerTemplate()
                                        : greyContainerTemplate(),
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 2.0,
                                          horizontal:
                                              ScreenConfig.screenSizeWidth *
                                                  0.05),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Row(
                                            children: [
                                              Container(
                                                height: 35,
                                                width: 35,
                                                decoration:
                                                    squareButtonTemplate(
                                                        radius: 8),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(3.0),
                                                  child: Image.asset(
                                                      "assets/images/CarIconColored.png",
                                                      fit: BoxFit.contain),
                                                ),
                                              ),
                                              spaceWidth(
                                                  ScreenConfig.screenSizeWidth *
                                                      0.03),
                                              Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  displayText(
                                                      "Rickshaw",
                                                      ScreenConfig.theme
                                                          .textTheme.labelLarge,
                                                      width: 0.3),
                                                  displayText(
                                                      "$duration",
                                                      ScreenConfig.theme
                                                          .textTheme.labelLarge
                                                          ?.copyWith(
                                                              fontSize: 15),
                                                      width: 0.3),
                                                ],
                                              ),
                                            ],
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 5.0),
                                            child: displayText(
                                                "RS. $rickshawfare",
                                                rikshaw
                                                    ? ScreenConfig
                                                        .theme.textTheme.labelLarge
                                                        ?.copyWith(
                                                            fontWeight:
                                                                FontWeight.bold)
                                                    : ScreenConfig.theme
                                                        .textTheme.titleMedium
                                                        ?.copyWith(
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                textAlign: TextAlign.end,
                                                width: 0.2),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  spaceHeight(
                                      ScreenConfig.screenSizeHeight * 0.015),
                                ],
                              ),
                            )
                          : vahicle == "bike"
                              ? GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      showConfirmYourRide =
                                          !showConfirmYourRide;
                                      bik = !bik;
                                      typeofvahicle = "Bike";
                                      print("$typeofvahicle");
                                    });
                                  },
                                  child: Column(
                                    children: [
                                      Container(
                                        height: ScreenConfig.screenSizeHeight *
                                            0.07,
                                        width:
                                            ScreenConfig.screenSizeWidth * 0.9,
                                        decoration: bik == false
                                            ? blueContainerTemplate()
                                            : greyContainerTemplate(),
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 2.0,
                                              horizontal:
                                                  ScreenConfig.screenSizeWidth *
                                                      0.05),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              Row(
                                                children: [
                                                  Container(
                                                    height: 35,
                                                    width: 35,
                                                    decoration:
                                                        squareButtonTemplate(
                                                            radius: 8),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              3.0),
                                                      child: Image.asset(
                                                          "assets/images/CarIconColored.png",
                                                          fit: BoxFit.contain),
                                                    ),
                                                  ),
                                                  spaceWidth(ScreenConfig
                                                          .screenSizeWidth *
                                                      0.03),
                                                  Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      displayText(
                                                          "Bike",
                                                          ScreenConfig.theme
                                                              .textTheme.labelLarge,
                                                          width: 0.3),
                                                      displayText(
                                                          "$duration",
                                                          ScreenConfig.theme
                                                              .textTheme.labelLarge
                                                              ?.copyWith(
                                                                  fontSize: 15),
                                                          width: 0.3),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    bottom: 5.0),
                                                child: displayText(
                                                    "RS. $bykefare",
                                                    bik
                                                        ? ScreenConfig.theme
                                                            .textTheme.labelLarge
                                                            ?.copyWith(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold)
                                                        : ScreenConfig.theme
                                                            .textTheme.titleMedium
                                                            ?.copyWith(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                    textAlign: TextAlign.end,
                                                    width: 0.2),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      spaceHeight(
                                          ScreenConfig.screenSizeHeight *
                                              0.015),
                                    ],
                                  ),
                                )
                              : Container(),
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
      /* backgroundColor:
          requestshow ? ScreenConfig.theme.primaryColor : Colors.white,*/
      body: /*isdriveraccept
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: themeColor,),
                  SizedBox(height: 20),
                  Text('Finding Driver...',
                      style: TextStyle(
                          color: themeColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 15)),
                ],
              ),
            )
          : requestshow
              ? Center(
                  child: Container(
                    height: ScreenConfig.screenSizeHeight * 0.95,
                    width: ScreenConfig.screenSizeWidth * 0.9,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10)),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 15),
                      child: SingleChildScrollView(
                        child: Column(
                          children: List.generate(drivers.length, (index) {
                            final driver = drivers[index];
                            return Column(
                              children: [
                                Container(
                                  height: ScreenConfig.screenSizeHeight * 0.2,
                                  width: ScreenConfig.screenSizeWidth * 0.83,
                                  decoration: blueContainerTemplate(),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0, vertical: 15),
                                    child: Center(
                                      child: SizedBox(
                                        width:
                                            ScreenConfig.screenSizeWidth * 0.75,
                                        child: Column(
                                          children: [
                                            spaceHeight(
                                                ScreenConfig.screenSizeHeight *
                                                    0.02),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Container(
                                                  color: Colors.transparent,
                                                  child: Row(
                                                    children: [
                                                      Container(
                                                        width: ScreenConfig
                                                            .screenSizeWidth *
                                                            0.12,
                                                        height: ScreenConfig
                                                            .screenSizeWidth *
                                                            0.12,
                                                        decoration:
                                                        BoxDecoration(
                                                          borderRadius:
                                                          const BorderRadius
                                                              .all(Radius
                                                              .circular(
                                                              5)),
                                                        ),
                                                        child: Image.asset('assets/images/UserProfileImage.png',fit: BoxFit.cover,),
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
                                                            "${driver['driverName']}",
                                                            style: TextStyle(
                                                                fontSize:
                                                                ScreenConfig
                                                                    .screenSizeWidth *
                                                                    0.03),
                                                          ),
                                                          Text(
                                                            "${driver['driverRaiting']} *",
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
                                                ),Container(
                                                  color: Colors.transparent,
                                                  child: Row(
                                                    children: [
                                                      Container(
                                                        width: ScreenConfig
                                                            .screenSizeWidth *
                                                            0.12,
                                                        height: ScreenConfig
                                                            .screenSizeWidth *
                                                            0.12,
                                                        decoration:
                                                        BoxDecoration(
                                                          borderRadius:
                                                          const BorderRadius
                                                              .all(Radius
                                                              .circular(
                                                              5)),
                                                        ),
                                                          child: Image.asset('assets/images/UserCarImage.png',fit: BoxFit.cover,)
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
                                                            "${driver['vahicleName']}",
                                                            style: TextStyle(
                                                                fontSize:
                                                                ScreenConfig
                                                                    .screenSizeWidth *
                                                                    0.03),
                                                          ),
                                                          Text(
                                                            "${driver['numberPlate']}",
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
                                              ],
                                            ),
                                            spaceHeight(
                                                ScreenConfig.screenSizeHeight *
                                                    0.02),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.only(top: 8),
                                              child: GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    */ /*'driverName':data['driver']['name'],
                                                    'driverRaiting':data['driver']['rating'],
                                                    'vahicleName':data['vehicle']['name'],
                                                    'numberPlate':data['vehicle']['numberPlate'],
                                                    'rideId':data['_id'],
                                                    'driverId':data['driver']['_id'],*/ /*
                                                    drivername=driver['driverName'];
                                                    driverraiting=driver['driverRaiting'];
                                                    vahiclename=driver['vahicleName'];
                                                    numberplate=driver['numberPlate'];
                                                    reqrideid=driver['rideId'];
                                                    driverid=driver['driverId'];
                                                  });
                                                  acceptstatus(driver['rideId'],driver['driverId']);
                                                },
                                                child: Container(
                                                    height: 40,
                                                    width: ScreenConfig.screenSizeWidth * 0.7,
                                                    decoration: BoxDecoration(
                                                        color: Colors.green,
                                                        borderRadius:
                                                            BorderRadius
                                                                .all(Radius
                                                                    .circular(
                                                                        10)),
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: Colors
                                                                .grey
                                                                .withOpacity(
                                                                    0.40),
                                                            offset: const Offset(
                                                                0.0,
                                                                1.2), //(x,y)
                                                            blurRadius: 6.0,
                                                          )
                                                        ]),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets
                                                              .symmetric(
                                                              horizontal:
                                                                  10.0,
                                                              vertical: 5),
                                                      child: Center(
                                                          child: Text(
                                                        "Accept",
                                                        style: TextStyle(
                                                            fontSize: 14),
                                                      )),
                                                    )),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                              ],
                            );
                          }),
                        ),
                      ),
                    ),
                  ),
                )
              : */
          Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children: [
          SizedBox(
            height: ScreenConfig.screenSizeHeight * 1.2,
            child: Column(
              children: [
                MapScreen(
                    search: [],
                    showAds: false,
                    showTextFields: true,
                    isFieldsReadOnly: true,
                    isFullScreen: false,
                    autoupdatepolyline: true,
                    isShowMyLocationIcon: false,
                    check: true,
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
                spaceHeight(
                  ScreenConfig.screenSizeHeight * 0.2,
                )
              ],
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (showConfirmYourRide) confirmYourRideWidget(typeofvahicle),
              spaceHeight(ScreenConfig.screenSizeHeight * 0.04),
              bottomModalNonSlideable(),
            ],
          )
        ],
      ),
    );
  }
}
