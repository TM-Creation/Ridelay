import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
  String distance = '';
  int updatedfare=0;
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
        drivername = args['driverName']!;
        driverraiting = args['driverRaiting']!;
        vahiclename = args['vahicleName']!;
        numberplate = args['vahicleNumberplate']!;
        updatedfare = args['fare']!;
        rideid = args['rideid']!;
        driverid = args['driverID']!;
      });
    }
  }


  bool isdriveraccept = false, requestshow = false;
  String drivername='';
  double driverraiting=4.2;
  //String driverimage='';
  //String? vahicleimage;
  String vahiclename='';
  String numberplate='';
  List<Map<String, dynamic>> drivers = [];
  @override
  void initState(){
    initSocket();
    print("initState call");
    super.initState();
  }
  late IO.Socket socket;
  final String? id = PassId().id;
  var reqrideid = '';
  var driverid='';
  int counter=0;
  final LatLng? pickuplocation = pickanddrop().pickloc,
      dropofflocation = pickanddrop().droploc;
  initSocket() {
    print('Null or Empty Check: ${PassId().token} -- ${PassId().type} -- ${PassId().id}');
    socket.emit('registerPassenger', PassId().id);
    socket.on('rideAccepted', (data) {
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
  void sendridereq() {
    // Create payload
    final payload = {
      'passengerId': PassId().id,
      'pickupLocation': {'coordinates': pickanddrop().pickloc},
      'dropoffLocation': {'coordinates': pickanddrop().droploc},
      'fare': updatedfare,
      'distance':distance
    };
    print("${pickanddrop().pickloc} and 2nd is ${pickanddrop().droploc}");
    // Emit the 'rideRequest' event with the payload
    socket.emit('rideRequest', payload);
    print('Emitted rideRequest with payload: $payload');
    socket.on('rideRequested', (data) {
      print("data of riderequest $data");
    });
    isdriveraccept=true;
  }

//6654523062cc5411c069d411
  @override

  String typeofvahicle = '';
  void acceptstatus(String rideId,String driverId) {
    print("Ride ID and Driver ID is this: $rideId $driverid");
    final payload = {'rideId': reqrideid,
      'driverId':driverid};
    socket.emit('confirmRide', payload);
    print('Driver Accepted');
    Navigator.pushReplacementNamed(context, RideWaitingScreen.routeName,arguments: {
      "pickupLocation":pickupEnterController.text,
      "dropoffLocation": dropoffEnterController.text,
      "driverName":drivername,
      "driverRaiting":driverraiting,
      "vahicleName":vahiclename,
      "vahicleNumberplate":numberplate,
      "fare":updatedfare,
      "rideid":reqrideid,
      "driverID":driverid
    });
  }
  @override
  void dispose() {
    socket.off('rideAccepted');
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
                Text('Increase fare if any Driver is not Coming')
              ],
            ),
          ),
        ),
      );
    }
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
                              "assets/images/CircularIconButton.png",
                                  () {}),
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
                              "assets/images/PinPointIcon.png",
                                  () {}),
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
