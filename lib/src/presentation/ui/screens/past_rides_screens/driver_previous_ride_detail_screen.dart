import 'package:five_pointed_star/five_pointed_star.dart';
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

class DriverPreviousRideDetailScreen extends StatelessWidget {
  const DriverPreviousRideDetailScreen({Key? key}) : super(key: key);

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

    int mycount = 2;
    return AlertDialog(
      content: SizedBox(
        child: SingleChildScrollView(
          child: Column(
            children: [
              spaceHeight(ScreenConfig.screenSizeHeight * 0.03),
              Container(
                width: ScreenConfig.screenSizeWidth * 0.9,
                decoration: blueContainerTemplate(),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    child: SizedBox(
                      width: ScreenConfig.screenSizeWidth * 0.8,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10, right: 10),
                        child: Column(
                          children: [
                            Container(
                              width: ScreenConfig.screenSizeWidth * 0.2,
                              height: ScreenConfig.screenSizeWidth * 0.2,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage(
                                        "assets/images/UserProfileImage.png"),
                                    fit: BoxFit.cover),
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(5)),
                              ),
                            ),
                            spaceHeight(ScreenConfig.screenSizeHeight * 0.01),
                            Text(
                              "Taha Ahmad",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize:
                                      ScreenConfig.screenSizeWidth * 0.04),
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
                            priceShow("Distance", "18 Km"),
                            spaceHeight(ScreenConfig.screenSizeHeight * 0.01),
                            priceShow("Time", "35 Min"),
                            spaceHeight(ScreenConfig.screenSizeHeight * 0.01),
                            priceShow("Fare", "Rs 50"),
                            spaceHeight(ScreenConfig.screenSizeHeight * 0.02),
                            lineSeparatorColored(Colors.white,
                                ScreenConfig.screenSizeWidth * 0.8),
                            spaceHeight(ScreenConfig.screenSizeHeight * 0.03),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  height: 30,
                                  decoration: squareButtonTemplate(radius: 5),
                                  child: Center(
                                    child: displayText(
                                        "Your Rating",
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
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                FivePointedStar(
                                  defaultSelectedCount: mycount,
                                  count: 5,
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              spaceHeight(ScreenConfig.screenSizeHeight * 0.03),
            ],
          ),
        ),
      ),
    );
  }
}
