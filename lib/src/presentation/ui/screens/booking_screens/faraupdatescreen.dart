import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ridely/src/infrastructure/screen_config/screen_config.dart';
import 'package:ridely/src/models/base%20url.dart';
import 'package:ridely/src/presentation/ui/config/theme.dart';
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

class FareUpdateScreen extends StatefulWidget {
  const FareUpdateScreen({Key? key}) : super(key: key);
  static const routeName = '/fareupdate-screen';

  @override
  State<FareUpdateScreen> createState() => _FareUpdateScreenState();
}

class _FareUpdateScreenState extends State<FareUpdateScreen> {
  TextEditingController pickupEnterController = TextEditingController();
  TextEditingController dropoffEnterController = TextEditingController();
  TextEditingController updatedfarefieldcontroller = TextEditingController();
  String distance = '';
  int updatedfare = 0;
  String rideid = '';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Retrieve pickup and drop-off locations from arguments after dependencies change
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    if (args != null) {
      setState(() {
        pickupEnterController.text = args['pickupLocation']!;
        dropoffEnterController.text = args['dropoffLocation']!;
        updatedfarefieldcontroller.text = args['fare'].toString();
        updatedfare=args['fare'];
        distance = args['distance'];
        //rideid = args['rideid']!;
        /*drivername = args['driverName']!;
        driverraiting = args['driverRaiting']!;
        vahiclename = args['vahicleName']!;
        numberplate = args['vahicleNumberplate']!;
        updatedfare = args['fare']!;
        ;*/
        //driverid = args['driverID']!;
      });
    }
  }

  bool isdriveraccept = false, requestshow = false;
  String drivername = '';
  double driverraiting = 4.2;

  String driverimage = '';
  String vahicleimage='';
  String phone='';
  String vahiclename = '';
  String numberplate = '';
  List<Map<String, dynamic>> drivers = [];

  @override
  void initState() {
    getprefdata();
    print("initState call");
    super.initState();
  }

  int counter = 0;

  late IO.Socket socket;

  Future<void> getprefdata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    id = await prefs.getString('uid');
    token = await prefs.getString('utoken');
    type = await prefs.getString('utype');
    initSocket();
  }

  late final String? id,token,type;
  var reqrideid = '';
  var driverid = '';

  final LatLng? pickuplocation = pickanddrop().pickloc,
      dropofflocation = pickanddrop().droploc;

  initSocket() {
    print('Null or Empty Check: $id');
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
        socket.emit('registerPassenger', PassId().id);
      });
    }
    socket.on('rideAccepted', (data) {
      if (!mounted) return;
      print("$data ride is accept ");
      Map<String, dynamic> driverData = {
        'driverName': data['driver']['name'],
        'driverRaiting': data['driver']['rating'],
        'driverImage' : data['driver']['driverImage'],
        'diverPhone' : data['driver']['phone'],
        'vehicleName': data['vehicle']['name'],
        'vehicleImage' : data['vehicle']['vehicleImage'],
        'numberPlate': data['vehicle']['numberPlate'],
        'rideId': data['_id'],
        'driverId': data['driver']['_id'],
      };
      /*drivername=data['driver']['name'];
      //driverimage=data['driver']['driverImage'];
      driverraiting=data['driver']['rating'];
      //vahicleimage=data['vehicle']['vehicleImage'];
      vahiclename=data['vehicle']['name'];
      numberplate=data['vehicle']['numberPlate'];
      reqrideid = data['_id'];
      final driver=data['driver'];
      driverid=driver['_id'];*/
      drivers.add(driverData);
      counter++;
      isdriveraccept = false;
      requestshow = true;
      setState(() {
        print("check sestate");
      });
    });
  }

//6654523062cc5411c069d411
  @override
  String typeofvahicle = '';

  void acceptstatus(String rideId, String driverId) {
    print("Ride ID and Driver ID is this: $rideId $driverid");
    final payload = {'rideId': reqrideid, 'driverId': driverid};
    socket.emit('confirmRide', payload);
    print('Driver Accepted');
    Navigator.pushReplacementNamed(context, RideWaitingScreen.routeName,
        arguments: {
          "pickupLocation": pickupEnterController.text,
          "dropoffLocation": dropoffEnterController.text,
          "driverName": drivername,
          "driverRaiting": driverraiting,
          "driverImage": driverimage,
          "driverPhone" : phone,
          "vahicleName": vahiclename,
          "vehicleImage" : vahicleimage,
          "vahicleNumberplate": numberplate,
          "fare": updatedfare,
          "rideid": reqrideid,
          "driverID": driverid
        });
  }
  final _formKey = GlobalKey<FormState>();
  void sendridereq() {
    // Create payload
    final payload = {
      'passengerId': id,
      'pickupLocation': {'coordinates': pickanddrop().pickloc},
      'dropoffLocation': {'coordinates': pickanddrop().droploc},
      'fare': updatedfare,
      'distance': distance
    };
    socket.emit('rideRequest', payload);
    print('Emitted rideRequest with payload: $payload');
    socket.on('rideRequested', (data) {
      print("data of riderequest $data");
      reqrideid=data['_id'];
      drivers=[];
    });
    //isdriveraccept=true;
  }

  @override
  void dispose() {
    //socket.off('rideAccepted');
    updatedfarefieldcontroller.dispose();
    socket.off('rideAccepted');
    if (mounted) {
      setState(() {});
    }
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("Counting ${drivers.length}");
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
                GestureDetector(
                  onTap: () {
                    int currentValue =
                        int.tryParse(updatedfarefieldcontroller.text) ?? 0;
                    currentValue += 5;
                    setState(() {
                      updatedfarefieldcontroller.text = currentValue.toString();
                    });
                  },
                  child: Container(
                    height: ScreenConfig.screenSizeWidth * 0.12,
                    width: ScreenConfig.screenSizeWidth * 0.23,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: CupertinoColors.activeGreen),
                    child: Center(
                        child: Text(
                      '+5',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: ScreenConfig.screenSizeWidth * 0.06),
                    )),
                  ),
                ),
                SizedBox(
                  height: ScreenConfig.screenSizeHeight * 0.01,
                ),

                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: themeColor,width: 2),
                    borderRadius: BorderRadius.circular(10)
                  ),
                  width: MediaQuery.sizeOf(context).width*0.3,
                  child: TextFormField(
                    controller: updatedfarefieldcontroller,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      errorStyle: TextStyle(fontSize: 10),
                      border: InputBorder.none, // No borders
                    ),
                    style: TextStyle(fontSize: 20, color: Colors.black),
                    textAlign: TextAlign.center, // Center the text
                  ),
                ),
                SizedBox(
                  height: ScreenConfig.screenSizeHeight * 0.01,
                ),
                GestureDetector(
                  onTap: () {
                    if(updatedfarefieldcontroller.text.isNotEmpty){
                      if(int.tryParse(updatedfarefieldcontroller.text)! < (updatedfare-((updatedfare*5)/100))){
                        setState(() {
                          updatedfarefieldcontroller.text=(updatedfare-((updatedfare*5)/100)).toString();
                        });
                        Get.snackbar(
                          'Fare must be',
                          '${updatedfarefieldcontroller.text}',
                          snackPosition: SnackPosition.TOP,
                          backgroundColor: themeColor,
                          colorText: Colors.white,
                          margin: EdgeInsets.all(10),
                          duration: Duration(seconds: 3),
                        );
                      }else{
                        updatedfare=int.tryParse(updatedfarefieldcontroller.text)!;
                        print('Updated Fare is here $updatedfare');
                        Get.snackbar(
                          'Fare Raised',
                          'You Fare Raised Successfully',
                          snackPosition: SnackPosition.TOP,
                          backgroundColor: themeColor,
                          colorText: Colors.white,
                          margin: EdgeInsets.all(10),
                          duration: Duration(seconds: 3),
                        );
                        sendridereq();
                      }
                    }else{
                      Get.snackbar(
                        'Alert!',
                        'Enter Fare',
                        snackPosition: SnackPosition.TOP,
                        backgroundColor: themeColor,
                        colorText: Colors.white,
                        margin: EdgeInsets.all(10),
                        duration: Duration(seconds: 3),
                      );
                    }
                  },
                  child: Container(
                    height: ScreenConfig.screenSizeWidth * 0.13,
                    width: ScreenConfig.screenSizeWidth * 0.8,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: themeColor),
                    child: Center(
                        child: Text(
                      'Raise Fare',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: ScreenConfig.screenSizeWidth * 0.05),
                    )),
                  ),
                )
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      resizeToAvoidBottomInset: true,
      extendBodyBehindAppBar: true,
      body: Stack(
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
                    image: '',
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
          if(requestshow) Padding(
            padding: const EdgeInsets.only(top: 15),
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
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
                                          width: ScreenConfig.screenSizeWidth * 0.12,
                                            height: ScreenConfig.screenSizeWidth * 0.12,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(8), // Adjust the radius as needed
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.grey.withOpacity(0.3), // Optional shadow
                                                  blurRadius: 4,
                                                  offset: Offset(2, 2),
                                                ),
                                              ],
                                            ),
                                            clipBehavior: Clip.hardEdge, // Ensures the child respects the rounded corners
                                            child: Image.network(
                                              driver['driverImage'],
                                              fit: BoxFit.cover,
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
                                                width: ScreenConfig.screenSizeWidth * 0.12,
                                                height: ScreenConfig.screenSizeWidth * 0.12,
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(8), // Adjust the radius as needed
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.grey.withOpacity(0.3), // Optional shadow
                                                      blurRadius: 4,
                                                      offset: Offset(2, 2),
                                                    ),
                                                  ],
                                                ),
                                                clipBehavior: Clip.hardEdge, // Ensures the child respects the rounded corners
                                                child: Image.network(
                                                  driver['vehicleImage'],
                                                  fit: BoxFit.cover,
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
                                                    "${driver['vehicleName']}",
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
                                            /*'driverName':data['driver']['name'],
                                            'driverRaiting':data['driver']['rating'],
                                            'vahicleName':data['vehicle']['name'],
                                            'numberPlate':data['vehicle']['numberPlate'],
                                            'rideId':data['_id'],
                                            'driverId':data['driver']['_id'],*/
                                            drivername=driver['driverName'];
                                            driverraiting=driver['driverRaiting'].toDouble();
                                            vahiclename=driver['vehicleName'];
                                            numberplate=driver['numberPlate'];
                                            driverimage=driver['driverImage'];
                                            vahicleimage=driver['vehicleImage'];
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
