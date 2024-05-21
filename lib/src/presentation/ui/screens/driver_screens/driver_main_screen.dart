import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ridely/src/infrastructure/screen_config/screen_config.dart';
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
            padding:  EdgeInsets.all(MediaQuery.sizeOf(context).width*0.04),
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
                        width:MediaQuery.sizeOf(context).width*0.03,
                        height: MediaQuery.sizeOf(context).height*0.03,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: MediaQuery.sizeOf(context).height*0.03,
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
                      borderRadius: BorderRadius.all( Radius.circular(50.0)),
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.sizeOf(context).height*0.01,
                ),
                Center(
                  child: Text("Moeen",style: TextStyle(
                      color: ScreenConfig.theme.primaryColor,
                      fontSize:  MediaQuery.sizeOf(context).width*0.062
                  ),),
                ),
                SizedBox(
                  height: MediaQuery.sizeOf(context).height*0.04,
                ),
                SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          Navigator.push(context, MaterialPageRoute(builder: (context) => Wallet(),));
                        },
                        child: const Text("Wallet"),
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      foregroundColor: Colors.white,
                      backgroundColor: ScreenConfig.theme.primaryColor,
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      textStyle:  TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize:  MediaQuery.sizeOf(context).width*0.04,
                          color: Colors.white
                      ),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)
                      ),
                    ),
                    ),),
                SizedBox(
                  height: MediaQuery.sizeOf(context).height*0.03,
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.push(context, MaterialPageRoute(builder: (context) => TransactionHistory(),));
                    },
                    child: const Text("Transaction History"),
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      foregroundColor: Colors.white,
                      backgroundColor: ScreenConfig.theme.primaryColor,
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      textStyle:  TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize:  MediaQuery.sizeOf(context).width*0.04,
                          color: Colors.white
                      ),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)
                      ),
                    ),
                  ),),
                SizedBox(
                  height: MediaQuery.sizeOf(context).height*0.03,
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () =>  null,
                    child: const Text("Ride History"),
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      foregroundColor: Colors.white,
                      backgroundColor: ScreenConfig.theme.primaryColor,
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      textStyle:  TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize:  MediaQuery.sizeOf(context).width*0.04,
                          color: Colors.white
                      ),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)
                      ),
                    ),
                  ),),
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
                    child: Column(children: [
                      Column(
                        children: [
                          spaceHeight(ScreenConfig.screenSizeHeight * 0.02),
                          Column(
                            children: List.generate(4, (index) {
                              return driverRideDetailsWidget(
                                  namesList[index], "Confirm Rider", context);
                            }),
                          ),
                        ],
                      )
                    ])),
              ),
            )));
  }
}
