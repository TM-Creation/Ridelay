import 'package:flutter/material.dart';
import 'package:ridely/src/infrastructure/screen_config/screen_config.dart';
import 'package:ridely/src/presentation/ui/templates/decorations/box_decoration_templates.dart';
import 'package:ridely/src/presentation/ui/templates/main_generic_templates/app_bars/app_bar.dart';
import 'package:ridely/src/presentation/ui/templates/main_generic_templates/app_buttons/buttons.dart';
import 'package:ridely/src/presentation/ui/templates/main_generic_templates/other_widgets/space_line_between_two_text_fields.dart';
import 'package:ridely/src/presentation/ui/templates/main_generic_templates/spacing_widgets.dart';
import 'package:ridely/src/presentation/ui/templates/main_generic_templates/text_templates/display_text.dart';
import 'package:ridely/src/presentation/ui/templates/main_generic_templates/text_templates/generic_textfield.dart';
import 'package:ridely/src/presentation/ui/templates/previous_rides_screens_widgets/ratings_container.dart';
import 'package:ridely/src/presentation/ui/templates/previous_rides_screens_widgets/user_details_container.dart';

class PreviousRideDetailScreen extends StatefulWidget {
  const PreviousRideDetailScreen({Key? key}) : super(key: key);
  static const routeName = '/previousridedetail-screen';

  @override
  State<PreviousRideDetailScreen> createState() =>
      _PreviousRideDetailScreenState();
}

class _PreviousRideDetailScreenState extends State<PreviousRideDetailScreen> {
  TextEditingController dummyController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    Widget priceShow(String text1, String text2) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          displayNoSizedText(
            text1,
            ScreenConfig.theme.textTheme.button,
          ),
          displayNoSizedText(
            text2,
            ScreenConfig.theme.textTheme.button,
          ),
        ],
      );
    }

    Widget priceShowBold(String text1, String text2) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          displayNoSizedText(
            text1,
            ScreenConfig.theme.textTheme.bodyText2
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          displayNoSizedText(
            text2,
            ScreenConfig.theme.textTheme.bodyText2
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
        ],
      );
    }

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: GenericAppBars.appBarWithBackButtonOnly(context, true),
        body: SizedBox(
          height: ScreenConfig.screenSizeHeight * 1.2,
          width: ScreenConfig.screenSizeWidth,
          child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: Column(
              children: [
                Container(
                  width: ScreenConfig.screenSizeWidth * 0.9,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.40),
                        offset: const Offset(0.0, 1.2), //(x,y)
                        blurRadius: 6.0,
                      )
                    ],
                  ),
                  child: TextFormField(
                    readOnly: true,
                    textInputAction: TextInputAction.done,
                    textAlign: TextAlign.start,
                    keyboardType: TextInputType.text,
                    controller: TextEditingController(),
                    decoration: InputDecoration(
                      hintText: '',
                      hintStyle: ScreenConfig.theme.textTheme.headline5,
                      suffixIcon: SizedBox(
                        height: 60,
                        width: 50,
                        child: Row(
                          children: [
                            Buttons.smallSquareButton(
                                "assets/images/CircularIconButton.png", () {}),
                          ],
                        ),
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.all(20),
                    ),
                    style: ScreenConfig.theme.textTheme.headline5,
                  ),
                ),
                spaceHeight(10),
                lineSeparatorTextFields(),
                spaceHeight(10),
                Container(
                  width: ScreenConfig.screenSizeWidth * 0.9,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.40),
                        offset: const Offset(0.0, 1.2), //(x,y)
                        blurRadius: 6.0,
                      )
                    ],
                  ),
                  child: TextFormField(
                    readOnly: true,
                    textInputAction: TextInputAction.done,
                    textAlign: TextAlign.start,
                    keyboardType: TextInputType.text,
                    controller: TextEditingController(),
                    decoration: InputDecoration(
                      hintText: '',
                      hintStyle: ScreenConfig.theme.textTheme.headline5,
                      suffixIcon: SizedBox(
                        height: 60,
                        width: 50,
                        child: Row(
                          children: [
                            Buttons.smallSquareButton(
                                "assets/images/PinPointIcon.png", () {}),
                          ],
                        ),
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.all(20),
                    ),
                    style: ScreenConfig.theme.textTheme.headline5,
                  ),
                ),
                spaceHeight(ScreenConfig.screenSizeHeight * 0.03),
                Container(
                  width: ScreenConfig.screenSizeWidth * 0.9,
                  decoration: blueContainerTemplate(),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20.0),
                      child: SizedBox(
                        width: ScreenConfig.screenSizeWidth * 0.8,
                        child: Column(
                          children: [
                            Row(
                              children: [
                                userDetailsContainer(
                                    "assets/images/UserProfileImage.png",
                                    "Altaf Ahmed",
                                    "4.9",
                                    true,
                                    false,
                                    " "),
                                userDetailsContainer(
                                    "assets/images/UserCarImage.png",
                                    "Honda Civic",
                                    "LXV 5675",
                                    false,
                                    true,
                                    "2019")
                              ],
                            ),
                            spaceHeight(ScreenConfig.screenSizeHeight * 0.03),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                displayText(
                                    "Ride Time",
                                    ScreenConfig.theme.textTheme.bodyText1
                                        ?.copyWith(fontWeight: FontWeight.bold),
                                    width: 0.2),
                                Row(
                                  children: [
                                    displayNoSizedText(
                                      "13.00 hrs",
                                      ScreenConfig.theme.textTheme.bodyText1
                                          ?.copyWith(
                                              fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.right,
                                    ),
                                    displayNoSizedText(
                                      "  to  ",
                                      ScreenConfig.theme.textTheme.bodyText1,
                                    ),
                                    displayNoSizedText(
                                        "14.00 hrs",
                                        ScreenConfig.theme.textTheme.bodyText1
                                            ?.copyWith(
                                                fontWeight: FontWeight.bold),
                                        textAlign: TextAlign.right),
                                  ],
                                )
                              ],
                            ),
                            spaceHeight(ScreenConfig.screenSizeHeight * 0.02),
                            lineSeparatorColored(Colors.white,
                                ScreenConfig.screenSizeWidth * 0.8),
                            spaceHeight(ScreenConfig.screenSizeHeight * 0.03),
                            displayText(
                              "Reciept",
                              ScreenConfig.theme.textTheme.headline2,
                              width: ScreenConfig.screenSizeWidth * 0.8,
                            ),
                            spaceHeight(ScreenConfig.screenSizeHeight * 0.02),
                            priceShow("Base Fare", "Rs 50"),
                            spaceHeight(ScreenConfig.screenSizeHeight * 0.01),
                            priceShow("Distance (17Km)", "Rs 50"),
                            spaceHeight(ScreenConfig.screenSizeHeight * 0.01),
                            priceShow("Time(35 Min)", "Rs 50"),
                            spaceHeight(ScreenConfig.screenSizeHeight * 0.01),
                            priceShow("Fare", "Rs 50"),
                            spaceHeight(ScreenConfig.screenSizeHeight * 0.01),
                            priceShow("Promo", "Rs 50"),
                            spaceHeight(ScreenConfig.screenSizeHeight * 0.01),
                            priceShow("Total Fare", "Rs 50"),
                            spaceHeight(ScreenConfig.screenSizeHeight * 0.02),
                            lineSeparatorColored(Colors.white,
                                ScreenConfig.screenSizeWidth * 0.8),
                            spaceHeight(ScreenConfig.screenSizeHeight * 0.02),
                            priceShowBold("Amount Payed", "Rs 290"),
                            spaceHeight(ScreenConfig.screenSizeHeight * 0.03),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  height: 30,
                                  decoration: squareButtonTemplate(radius: 5),
                                  child: Center(
                                    child: displayText(
                                        "Your rating",
                                        ScreenConfig.theme.textTheme.bodyText2
                                            ?.copyWith(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 11,
                                                color: ScreenConfig
                                                    .theme.primaryColor),
                                        textAlign: TextAlign.center,
                                        width: 0.3),
                                  ),
                                ),
                              ],
                            ),
                            spaceHeight(ScreenConfig.screenSizeHeight * 0.01),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [ratingsContainer(30, 5)],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                spaceHeight(ScreenConfig.screenSizeHeight * 0.03),
              ],
            ),
          ),
        ));
  }
}
