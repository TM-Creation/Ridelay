import 'package:flutter/material.dart';
import 'package:ridely/src/infrastructure/screen_config/screen_config.dart';
import 'package:ridely/src/presentation/ui/templates/main_generic_templates/app_bars/app_bar.dart';
import 'package:ridely/src/presentation/ui/templates/main_generic_templates/spacing_widgets.dart';
import 'package:ridely/src/presentation/ui/templates/main_generic_templates/text_templates/display_text.dart';
import 'package:ridely/src/presentation/ui/templates/previous_rides_screens_widgets/previous_ride_container.dart';

class PreviousRidesScreen extends StatefulWidget {
  const PreviousRidesScreen({Key? key}) : super(key: key);
  static const routeName = '/previousrides-screen';

  @override
  State<PreviousRidesScreen> createState() => _PreviousRidesScreenState();
}

class _PreviousRidesScreenState extends State<PreviousRidesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 70),
          child: SizedBox(
            height: ScreenConfig.screenSizeHeight * 1.2,
            width: ScreenConfig.screenSizeWidth,
            child: SingleChildScrollView(
                child: Column(
              children: [
                displayText(
                  "Previous Rides",
                  ScreenConfig.theme.textTheme.displayLarge,
                ),
                spaceHeight(ScreenConfig.screenSizeHeight * 0.01),
                Column(
                  children: List.generate(4, (index) {
                    return const PreviousRideContainer();
                  }),
                )
              ],
            )),
          ),
        ),
      ),
    );
  }
}
