import 'package:flutter/material.dart';
import 'package:ridely/src/infrastructure/screen_config/screen_config.dart';
import 'package:ridely/src/presentation/ui/screens/booking_screens/location_selection_screen.dart';
import 'package:ridely/src/presentation/ui/screens/booking_screens/solo_ride_flow/vehicle_selection_screen.dart';
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
        appBar: GenericAppBars.appBarWithBackButtonAndTitle(
            "Confirm Your Ride Partner", context, false),
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
