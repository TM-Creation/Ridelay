import 'package:flutter/material.dart';
import 'package:ridely/src/infrastructure/screen_config/screen_config.dart';
import 'package:ridely/src/presentation/ui/screens/booking_screens/ride_selection_screen.dart';

import 'package:ridely/src/presentation/ui/templates/decorations/box_decoration_templates.dart';
import 'package:ridely/src/presentation/ui/templates/main_generic_templates/app_bars/app_bar.dart';
import 'package:ridely/src/presentation/ui/templates/main_generic_templates/app_buttons/buttons.dart';
import 'package:ridely/src/presentation/ui/templates/main_generic_templates/booking_widgets/map_widgets.dart';
import 'package:ridely/src/presentation/ui/templates/main_generic_templates/other_widgets/slider_for_bottom_navigation.dart';
import 'package:ridely/src/presentation/ui/templates/main_generic_templates/spacing_widgets.dart';
import 'package:ridely/src/presentation/ui/templates/ride_widgets/ride_detail_widgets.dart';

class RideRatingScreen extends StatefulWidget {
  const RideRatingScreen({Key? key}) : super(key: key);
  static const routeName = '/riderating-screen';

  @override
  State<RideRatingScreen> createState() => _RideRatingScreenState();
}

class _RideRatingScreenState extends State<RideRatingScreen> {
  TextEditingController pickupEnterController = TextEditingController();
  TextEditingController dropoffEnterController = TextEditingController();
  String image = "assets/images/RideFinishedScreenMap.png";

  @override
  Widget build(BuildContext context) {
    Widget bottomModalNonSlideable() {
      return Container(
        height: ScreenConfig.screenSizeHeight * 0.50,
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
                rideRatingWidget(context),
                spaceHeight(ScreenConfig.screenSizeHeight * 0.02),
                submitReviewPanelWidget(context),
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
      appBar: GenericAppBars.appBarWithBackButtonOnly(context, true),
      body: GestureDetector(
        onTap: () {
          Navigator.of(context).pushNamedAndRemoveUntil(
              RideSelectionScreen.routeName, ModalRoute.withName("/"));
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
                      check: true,
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
                  //     showAds: true,
                  //     showTextFields: false,
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
