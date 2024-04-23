import 'package:flutter/material.dart';
import 'package:ridely/src/infrastructure/screen_config/screen_config.dart';
import 'package:ridely/src/presentation/ui/screens/booking_screens/ride_selection_screen.dart';
import 'package:ridely/src/presentation/ui/screens/onboarding_screens/login_number_screen.dart';
import 'package:ridely/src/presentation/ui/templates/main_generic_templates/app_buttons/buttons.dart';
import 'package:ridely/src/presentation/ui/templates/main_generic_templates/spacing_widgets.dart';
import 'package:ridely/src/presentation/ui/templates/main_generic_templates/text_templates/display_text.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingCardsScreen extends StatefulWidget {
  const OnboardingCardsScreen({Key? key}) : super(key: key);
  static const routeName = '/onboardingcards-screen';

  @override
  State<OnboardingCardsScreen> createState() => _OnboardingCardsScreenState();
}

class _OnboardingCardsScreenState extends State<OnboardingCardsScreen> {
  int currentOnboardingImage = 0;

  void decrementCount() {
    if (currentOnboardingImage >= 0 && currentOnboardingImage <= 2) {
      currentOnboardingImage = currentOnboardingImage - 1;
      setState(() {});
    }
  }

  void incrementCount() {
    if (currentOnboardingImage >= 0 && currentOnboardingImage <= 2) {
      currentOnboardingImage = currentOnboardingImage + 1;
      setState(() {});
    }
    if (currentOnboardingImage == 3) {
      Navigator.pushReplacementNamed(context, LoginNumberEnterScreen.routeName);
      // Navigator.pushNamed(context, RideSelectionScreen.routeName);
    }
  }
  @override
  void initState() {
    super.initState();
    _checkFirstTime();
  }

  void _checkFirstTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool firstTime = prefs.getBool('first_time') ?? true;
    if (!firstTime) {
      // User has already seen the intro, navigate to login page
      Navigator.pushReplacementNamed(
          context,LoginNumberEnterScreen.routeName);
    }
  }

  void _nextPage() {
    _saveFirstTime();
    Navigator.pushReplacementNamed(
        context,LoginNumberEnterScreen.routeName);
  }

  void _saveFirstTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('first_time', false);
  }

  @override
  Widget build(BuildContext context) {
    Widget logoDisplay() {
      return SizedBox(
        height: 130,
        child: Image.asset(
          "assets/images/SplashScreenLogo.png",
          fit: BoxFit.contain,
        ),
      );
    }

    Widget dotIndicators(int currentIndex) {
      return SizedBox(
        width: ScreenConfig.screenSizeWidth * 0.08,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(3, (index) {
            return CircleAvatar(
              backgroundColor: index <= currentIndex
                  ? ScreenConfig.theme.primaryColor
                  : Colors.black.withOpacity(0.1),
              radius: 4,
            );
          }),
        ),
      );
    }

    return WillPopScope(
        onWillPop: () async {
          decrementCount();
          return false;
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Center(
            child: SizedBox(
              height: ScreenConfig.screenSizeHeight * 1.2,
              width: ScreenConfig.screenSizeWidth * 0.9,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  spaceHeight(ScreenConfig.screenSizeHeight * 0.03),
                  logoDisplay(),
                  spaceHeight(ScreenConfig.screenSizeHeight * 0.05),
                  displayText(
                    "Need a quick ride",
                    ScreenConfig.theme.textTheme.headline2
                        ?.copyWith(color: Colors.black.withOpacity(0.5)),
                  ),
                  spaceHeight(ScreenConfig.screenSizeHeight * 0.02),
                  displayText(
                      "Let's book a ride with us and we are ready to go.",
                      ScreenConfig.theme.textTheme.headline3),
                  spaceHeight(ScreenConfig.screenSizeHeight * 0.03),
                  dotIndicators(currentOnboardingImage),
                  spaceHeight(ScreenConfig.screenSizeHeight * 0.05),
                  SizedBox(
                    height: ScreenConfig.screenSizeHeight * 0.3,
                    width: ScreenConfig.screenSizeWidth,
                    child: Image.asset(
                      currentOnboardingImage == 0
                          ? "assets/images/SplashCar.png"
                          : currentOnboardingImage == 1
                              ? "assets/images/SplashRickshaw.png"
                              : "assets/images/SplashBike.png",
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                  spaceHeight(ScreenConfig.screenSizeHeight * 0.02),
                  Buttons.splashScreenButton("Let's get rides", () {
                    incrementCount();
                    if(currentOnboardingImage==3){
                      _nextPage();
                    }
                  }),
                  spaceHeight(ScreenConfig.screenSizeHeight * 0.03),
                ],
              ),
            ),
          ),
        ));
  }
}
