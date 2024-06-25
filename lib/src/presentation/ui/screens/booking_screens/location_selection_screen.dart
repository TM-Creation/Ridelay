import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ridely/src/infrastructure/screen_config/screen_config.dart';
import 'package:ridely/src/presentation/ui/screens/booking_screens/ride_shown_screen.dart';
import 'package:ridely/src/presentation/ui/templates/decorations/box_decoration_templates.dart';
import 'package:ridely/src/presentation/ui/templates/main_generic_templates/app_bars/app_bar.dart';
import 'package:ridely/src/presentation/ui/templates/main_generic_templates/app_buttons/buttons.dart';
import 'package:ridely/src/presentation/ui/templates/main_generic_templates/booking_widgets/map_widgets.dart';
import 'package:ridely/src/presentation/ui/templates/main_generic_templates/text_templates/display_text.dart';

class LocationSelectionScreen extends StatefulWidget {
  final void Function(Directions?)? onInfoReceived;
   LocationSelectionScreen({Key? key,  this.onInfoReceived}) : super(key: key);
  static const routeName = '/locationselection-screen';

  @override
  State<LocationSelectionScreen> createState() =>
      _LocationSelectionScreenState();
}
Directions? distance;
void onInfoReceived(Directions? info) {
  distance=info;
}
class _LocationSelectionScreenState extends State<LocationSelectionScreen> {
  TextEditingController pickupEnterController = TextEditingController();
  TextEditingController dropoffEnterController = TextEditingController();
  GoogleMapController? _mapController;
  String? showDistance;
  String image = "assets/images/RideSelectionScreenMap.png";
  bool isShowbottomButton = false;

  @override
  void dispose(){
    distance=null;
    super.dispose();
  }
  void update(){
   setState(() {
     final distanceString = distance?.totalDistance ?? "";
     final distanceNumeric = double.tryParse(distanceString.replaceAll(RegExp(r'[^0-9.]'), '')) ?? 0;
     if(distanceNumeric <= 50){
       showDistance=distanceString;
     }
   });
 }
  List<Location> search=[];

  @override
  Widget build(BuildContext context) {
    String argument = (ModalRoute.of(context)!.settings.arguments as String?)!;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.white,
      body: Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children: [
          MapScreen(
            search: [],
              isFieldsReadOnly: false,
              showAds: false,
              showTextFields: true,
              check: false,
              isFullScreen: true,
              isShowMyLocationIcon: false,
              autoupdatepolyline: false,
              image: image,
              hintFieldOne: "Pick-Up Location",
              fieldButtonFunction: update,
              fieldOneButtonFunction: (){},
              suffixIconFieldOne: SizedBox(
                height: 60,
                width: 50,
                child: Row(
                  children: [
                    Buttons.smallSquareButton(
                        "assets/images/CircularIconButton.png", () {
                    }),
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

          if (true)
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                    height: 40,
                    width: ScreenConfig.screenSizeWidth * 0.9,
                    decoration: squareButtonTemplate(),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              displayText(
                                "Distance:",
                                ScreenConfig.theme.textTheme.headline5,
                                width: 0.3,
                              ),
                              displayText(
                                "${distance?.totalDistance ?? ""}",
                                ScreenConfig.theme.textTheme.headline4,
                                width: 0.2,
                              ),
                            ],
                          ),
                          GestureDetector(
                            onTap: () {
                              if (pickupEnterController.text != '' &&
                                  dropoffEnterController.text != '') {
                                if( double.tryParse(distance!.totalDistance.replaceAll(RegExp(r'[^0-9.]'), ''))!<60){
                                  print("${distance!.totalDuration} duration");
                                  Navigator.of(context).pushNamed(
                                    RideShownScreen.routeName,
                                    arguments: {
                                      'pickupLocation':
                                      pickupEnterController.text,
                                      'dropoffLocation':
                                      dropoffEnterController.text,
                                      'vah':argument,
                                      'distance':distance!.totalDistance,
                                      'duration':distance!.totalDuration
                                    },
                                  );
                                }
                                else{
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Center(
                                        child: Text(
                                          'Please Select Below 60KM Distance',style: TextStyle(fontSize: 15,color: Colors.white),),
                                      ),
                                      backgroundColor: Colors.black,
                                      behavior: SnackBarBehavior.floating,
                                    ),
                                  );
                                }

                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Center(
                                      child: Text(
                                        'Please Select Pick-Up & Drop Off Location',style: TextStyle(fontSize: 15,color: Colors.white),),
                                    ),
                                    backgroundColor: Colors.black,
                                    behavior: SnackBarBehavior.floating,
                                  ),
                                );
                              }
                            },
                            child: Container(
                              height: 30,
                              width: ScreenConfig.screenSizeWidth * 0.25,
                              decoration: blueContainerTemplate(radius: 5),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 4.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    displayNoSizedText(
                                      "Let's Go",
                                      ScreenConfig.theme.textTheme.button,
                                    ),
                                    SizedBox(
                                      width: 20,
                                      child: Image.asset(
                                          "assets/images/GetMyCurrentLocationIconWhite.png",
                                          fit: BoxFit.contain),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    )),
                SizedBox(height: ScreenConfig.screenSizeHeight * 0.03)
              ],
            ),
        ],
      ),
    );
  }
}
