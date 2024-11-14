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
        /*drivername = args['driverName']!;
        driverraiting = args['driverRaiting']!;
        vahiclename = args['vahicleName']!;
        numberplate = args['vahicleNumberplate']!;
        updatedfare = args['fare']!;
        rideid = args['rideid']!;*/
        //driverid = args['driverID']!;
      });
    }
  }

  bool isdriveraccept = false, requestshow = false;
  String drivername = '';
  double driverraiting = 4.2;

  String driverimage = '';
  String? vahicleimage;
  String vahiclename = '';
  String numberplate = '';
  List<Map<String, dynamic>> drivers = [];

  @override
  void initState() {
    getprefdata();
    print("initState call");
    updatedfarefieldcontroller.text = '0';
    super.initState();
  }

  int counter = 0;

  late IO.Socket socket;

  Future<void> getprefdata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    id = await prefs.getString('uid');
    initSocket();
  }

  late final String? id;
  var reqrideid = '';
  var driverid = '';

  final LatLng? pickuplocation = pickanddrop().pickloc,
      dropofflocation = pickanddrop().droploc;

  initSocket() {
    print('Null or Empty Check: $id');
    //socket.emit('registerPassenger', PassId().id);
    socket.on('rideAccepted', (data) {
      print("$data ride is accept ");
      isdriveraccept = false;
      requestshow = true;
      Map<String, dynamic> driverData = {
        'driverName': data['driver']['name'],
        'driverRaiting': data['driver']['rating'],
        'vahicleName': data['vehicle']['name'],
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
          "vahicleName": vahiclename,
          "vahicleNumberplate": numberplate,
          "fare": updatedfare,
          "rideid": reqrideid,
          "driverID": driverid
        });
  }

  void sendridereq() {
    // Create payload
    final payload = {
      'passengerId': id,
      'pickupLocation': {'coordinates': pickanddrop().pickloc},
      'dropoffLocation': {'coordinates': pickanddrop().droploc},
      'fare': updatedfare,
      'distance': distance
    };
    print("${pickanddrop().pickloc} and 2nd is ${pickanddrop().droploc}");
    // Emit the 'rideRequest' event with the payload
    socket.emit('rideRequest', payload);
    print('Emitted rideRequest with payload: $payload');
    socket.on('rideRequested', (data) {
      print("data of riderequest $data");
    });
    //isdriveraccept=true;
  }

  @override
  void dispose() {
    //socket.off('rideAccepted');
    updatedfarefieldcontroller.dispose();
    if (mounted) {
      setState(() {});
    }
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("Counting $counter");
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
                Text(
                  'Increase fare if Driver is not Coming',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: ScreenConfig.screenSizeWidth * 0.04,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: ScreenConfig.screenSizeHeight * 0.02,
                ),
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
                  height: ScreenConfig.screenSizeHeight * 0.02,
                ),
                TextField(
                  controller: updatedfarefieldcontroller,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    border: InputBorder.none, // No borders
                  ),
                  style: TextStyle(fontSize: 20, color: Colors.black),
                  textAlign: TextAlign.center, // Center the text
                ),
                SizedBox(
                  height: ScreenConfig.screenSizeHeight * 0.02,
                ),
                GestureDetector(
                  onTap: () {
                    Get.snackbar(
                      'Fare Raised',
                      'You Fare RaisedSuccessfully',
                      snackPosition: SnackPosition.TOP,
                      backgroundColor: themeColor,
                      colorText: Colors.white,
                      margin: EdgeInsets.all(10),
                      duration: Duration(seconds: 3),
                    );
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
