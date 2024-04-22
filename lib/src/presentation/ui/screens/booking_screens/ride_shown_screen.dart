import 'package:flutter/material.dart';
import 'package:ridely/src/infrastructure/screen_config/screen_config.dart';
import 'package:ridely/src/presentation/ui/screens/booking_screens/ride_waiting_screen.dart';
import 'package:ridely/src/presentation/ui/screens/past_rides_screens/previous_rides_screen.dart';
import 'package:ridely/src/presentation/ui/templates/decorations/box_decoration_templates.dart';
import 'package:ridely/src/presentation/ui/templates/main_generic_templates/app_bars/app_bar.dart';
import 'package:ridely/src/presentation/ui/templates/main_generic_templates/app_buttons/buttons.dart';
import 'package:ridely/src/presentation/ui/templates/main_generic_templates/booking_widgets/map_widgets.dart';
import 'package:ridely/src/presentation/ui/templates/main_generic_templates/other_widgets/slider_for_bottom_navigation.dart';
import 'package:ridely/src/presentation/ui/templates/main_generic_templates/spacing_widgets.dart';
import 'package:ridely/src/presentation/ui/templates/main_generic_templates/text_templates/display_text.dart';

class RideShownScreen extends StatefulWidget {
  const RideShownScreen({Key? key}) : super(key: key);
  static const routeName = '/rideshown-screen';

  @override
  State<RideShownScreen> createState() => _RideShownScreenState();
}

class _RideShownScreenState extends State<RideShownScreen> {
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
        height: ScreenConfig.screenSizeHeight * 0.39,
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
                Container(
                  height: 35,
                  width: 35,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    image: DecorationImage(
                        image: AssetImage("assets/images/AppIcon.png"),
                        fit: BoxFit.contain),
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                  ),
                ),
                spaceHeight(ScreenConfig.screenSizeHeight * 0.02),
                SizedBox(
                  height: ScreenConfig.screenSizeHeight * 0.24,
                  width: ScreenConfig.screenSizeWidth * 0.9,
                  child: SingleChildScrollView(
                    physics: const ClampingScrollPhysics(),
                    child: Column(
                      children: List.generate(4, (index) {
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              currentIndex = index;
                            });
                          },
                          child: Column(
                            children: [
                              Container(
                                height: ScreenConfig.screenSizeHeight * 0.07,
                                width: ScreenConfig.screenSizeWidth * 0.9,
                                decoration: currentIndex == index
                                    ? greyContainerTemplate()
                                    : blueContainerTemplate(),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 2.0,
                                      horizontal:
                                          ScreenConfig.screenSizeWidth * 0.05),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            height: 35,
                                            width: 35,
                                            decoration:
                                                squareButtonTemplate(radius: 8),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(3.0),
                                              child: Image.asset(
                                                  "assets/images/CarIconColored.png",
                                                  fit: BoxFit.contain),
                                            ),
                                          ),
                                          spaceWidth(
                                              ScreenConfig.screenSizeWidth *
                                                  0.03),
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              displayText(
                                                  namesList[index],
                                                  ScreenConfig
                                                      .theme.textTheme.button,
                                                  width: 0.3),
                                              displayText(
                                                  "1-8 mins",
                                                  ScreenConfig
                                                      .theme.textTheme.button
                                                      ?.copyWith(fontSize: 9),
                                                  width: 0.3),
                                            ],
                                          ),
                                        ],
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 5.0),
                                        child: displayText(
                                            "Rs. 290",
                                            currentIndex == index
                                                ? ScreenConfig
                                                    .theme.textTheme.button
                                                    ?.copyWith(
                                                        fontWeight:
                                                            FontWeight.bold)
                                                : ScreenConfig
                                                    .theme.textTheme.headline5
                                                    ?.copyWith(
                                                        fontWeight:
                                                            FontWeight.bold),
                                            textAlign: TextAlign.end,
                                            width: 0.3),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              spaceHeight(
                                  ScreenConfig.screenSizeHeight * 0.015),
                            ],
                          ),
                        );
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

    Widget confirmYourRideWidget() {
      return Container(
        height: ScreenConfig.screenSizeHeight * 0.25,
        width: ScreenConfig.screenSizeWidth * 0.9,
        decoration: squareButtonTemplate(),
        child: SizedBox(
          width: ScreenConfig.screenSizeWidth * 0.8,
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: ScreenConfig.screenSizeWidth * 0.05),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                SizedBox(
                  height: ScreenConfig.screenSizeHeight * 0.23,
                  width: ScreenConfig.screenSizeWidth * 0.3,
                  child: Image.asset(
                    "assets/images/DriverAsset.png",
                    fit: BoxFit.contain,
                  ),
                ),
                SizedBox(
                  width: ScreenConfig.screenSizeWidth * 0.4,
                  height: ScreenConfig.screenSizeHeight * 0.25,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      spaceHeight(ScreenConfig.screenSizeHeight * 0.02),
                      Buttons.crossSmallButton(context, () {
                        setState(() {
                          currentIndex = -1;
                        });
                      }),
                      spaceHeight(ScreenConfig.screenSizeHeight * 0.03),
                      displayText(
                          "Please Confirm Your Ride",
                          ScreenConfig.theme.textTheme.headline1
                              ?.copyWith(fontWeight: FontWeight.bold),
                          textAlign: TextAlign.start,
                          width: 0.4),
                      spaceHeight(ScreenConfig.screenSizeHeight * 0.02),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                currentIndex = -1;
                              });
                            },
                            child: Container(
                              height: 25,
                              width: ScreenConfig.screenSizeWidth * 0.19,
                              decoration: redContainerTemplate(radius: 5),
                              child: Center(
                                child: displayText("CANCEL",
                                    ScreenConfig.theme.textTheme.button,
                                    width: 0.15, textAlign: TextAlign.center),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context)
                                  .pushNamed(RideWaitingScreen.routeName);
                            },
                            child: Container(
                              height: 25,
                              width: ScreenConfig.screenSizeWidth * 0.2,
                              decoration: blueContainerTemplate(radius: 5),
                              child: Center(
                                child: displayText("CONFIRM",
                                    ScreenConfig.theme.textTheme.button,
                                    width: 0.2, textAlign: TextAlign.center),
                              ),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                )
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
      body: Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children: [
          SizedBox(
            height: ScreenConfig.screenSizeHeight * 1.2,
            child: Column(
              children: [
                mapWidget(
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
                spaceHeight(
                  ScreenConfig.screenSizeHeight * 0.2,
                )
              ],
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (currentIndex != -1) confirmYourRideWidget(),
              spaceHeight(ScreenConfig.screenSizeHeight * 0.04),
              bottomModalNonSlideable(),
            ],
          )
        ],
      ),
    );
  }
}
