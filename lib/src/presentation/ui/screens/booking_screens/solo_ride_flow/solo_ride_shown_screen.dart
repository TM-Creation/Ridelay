import 'package:flutter/material.dart';
import 'package:ridely/src/infrastructure/screen_config/screen_config.dart';
import 'package:ridely/src/presentation/ui/screens/booking_screens/solo_ride_flow/list_confirm_your_ride_screen.dart';

import 'package:ridely/src/presentation/ui/templates/decorations/box_decoration_templates.dart';
import 'package:ridely/src/presentation/ui/templates/main_generic_templates/app_bars/app_bar.dart';
import 'package:ridely/src/presentation/ui/templates/main_generic_templates/app_buttons/buttons.dart';
import 'package:ridely/src/presentation/ui/templates/main_generic_templates/booking_widgets/map_widgets.dart';
import 'package:ridely/src/presentation/ui/templates/main_generic_templates/other_widgets/slider_for_bottom_navigation.dart';
import 'package:ridely/src/presentation/ui/templates/main_generic_templates/spacing_widgets.dart';
import 'package:ridely/src/presentation/ui/templates/main_generic_templates/text_templates/display_text.dart';
import 'package:ridely/src/presentation/ui/templates/ride_widgets/ride_detail_widgets.dart';

class SoloRideShownScreen extends StatefulWidget {
  const SoloRideShownScreen({Key? key}) : super(key: key);
  static const routeName = '/solorideshown-screen';

  @override
  State<SoloRideShownScreen> createState() => _SoloRideShownScreenState();
}

class _SoloRideShownScreenState extends State<SoloRideShownScreen> {
  int currentIndex = -1;
  TextEditingController pickupEnterController = TextEditingController();
  TextEditingController dropoffEnterController = TextEditingController();
  String image = "assets/images/LocationDistanceScreenMap.png";
  List namesList = ["Mini", "Go", "Comfort", "Mini"];

  @override
  void initState() {
    pickupEnterController.text = "Gulberg Phase II";
    dropoffEnterController.text = "Bahria Town";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget bottomModalNonSlideable() {
      return Container(
        // height: ScreenConfig.screenSizeHeight * 0.43,
        width: ScreenConfig.screenSizeWidth,
        decoration: bottomModalTemplate(),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: SizedBox(
            width: ScreenConfig.screenSizeWidth * 0.9,
            child: Column(
              children: [
                sliderBar(),
                spaceHeight(ScreenConfig.screenSizeHeight * 0.02),
                displayText(
                    "Your found 4 riders to your locaton",
                    ScreenConfig.theme.textTheme.headline4
                        ?.copyWith(fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                    width: 0.9),
                spaceHeight(ScreenConfig.screenSizeHeight * 0.02),
                SizedBox(
                  height: ScreenConfig.screenSizeHeight * 0.27,
                  width: ScreenConfig.screenSizeWidth * 0.9,
                  child: SingleChildScrollView(
                    physics: const ClampingScrollPhysics(),
                    child: Column(
                      children: List.generate(4, (index) {
                        return rideDetailsWidget(
                            namesList[index], "Confirm Partner", context);
                      }),
                    ),
                  ),
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
      backgroundColor: Colors.white,
      appBar: GenericAppBars.appBarWithBackButtonOnly(context, false),
      body: GestureDetector(
        onTap: () {
          Navigator.of(context).pushNamed(ListConfirmYourRideScreen.routeName);
        },
        child: Stack(
          alignment: AlignmentDirectional.bottomCenter,
          children: [
            SizedBox(
              height: ScreenConfig.screenSizeHeight * 1.2,
              child: Column(
                children: [
                  MapScreen(
                      showAds: false,
                      showTextFields: true,
                      isFieldsReadOnly: true,
                      isFullScreen: false,
                      isShowMyLocationIcon: false,
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

                  // mapWidget(
                  //     isFieldsReadOnly: true,
                  //     isFullScreen: false,
                  //     isShowMyLocationIcon: false,
                  //     image: image,
                  //     hintFieldOne: "Pick-Up Location",
                  //     fieldOneButtonFunction: () {},
                  //     suffixIconFieldOne: SizedBox(
                  //       height: 60,
                  //       width: 50,
                  //       child: Row(
                  //         children: [
                  //           Buttons.smallSquareButton(
                  //               "assets/images/CircularIconButton.png", () {}),
                  //         ],
                  //       ),
                  //     ),
                  //     fieldOneController: pickupEnterController,
                  //     isDisplayFieldTwo: true,
                  //     hintFieldTwo: "Drop Off Location",
                  //     fieldTwoButtonFunction: () {},
                  //     suffixIconFieldTwo: SizedBox(
                  //       height: 60,
                  //       width: 50,
                  //       child: Row(
                  //         children: [
                  //           Buttons.smallSquareButton(
                  //               "assets/images/PinPointIcon.png", () {}),
                  //         ],
                  //       ),
                  //     ),
                  //     fieldTwoController: dropoffEnterController),
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
      ),
    );
  }
}
