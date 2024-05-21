import 'package:flutter/material.dart';
import 'package:ridely/src/infrastructure/screen_config/screen_config.dart';
import 'package:ridely/src/presentation/ui/config/debug_helper.dart';
import 'package:ridely/src/presentation/ui/screens/onboarding_screens/login.dart';
import 'package:ridely/src/presentation/ui/screens/onboarding_screens/otp_verification_screen.dart';
import 'package:ridely/src/presentation/ui/screens/onboarding_screens/register_screens/choice_customer_driver.dart';
import 'package:ridely/src/presentation/ui/screens/onboarding_screens/register_screens/register_info_screen.dart';
import 'package:ridely/src/presentation/ui/templates/main_generic_templates/app_buttons/buttons.dart';
import 'package:ridely/src/presentation/ui/templates/main_generic_templates/spacing_widgets.dart';
import 'package:ridely/src/presentation/ui/templates/main_generic_templates/text_fields/phone_number_textfield.dart';
import 'package:ridely/src/presentation/ui/templates/main_generic_templates/text_templates/display_text.dart';

class LoginNumberEnterScreen extends StatefulWidget {
  static const routeName = '/loginNumberEnter-screen';
  const LoginNumberEnterScreen({Key? key}) : super(key: key);

  @override
  State<LoginNumberEnterScreen> createState() => _LoginNumberEnterScreenState();
}

class _LoginNumberEnterScreenState extends State<LoginNumberEnterScreen> {
  @override
  void initState() {
    errorValidatorShow = true;
    phoneNumberController = TextEditingController();
    super.initState();
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

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: Center(
        child: SizedBox(
          height: ScreenConfig.screenSizeHeight * 1.2,
          width: ScreenConfig.screenSizeWidth * 0.9,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  spaceHeight(ScreenConfig.screenSizeHeight * 0.15),
                  logoDisplay(),
                  spaceHeight(ScreenConfig.screenSizeHeight * 0.05),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  displayText(
                    "Login",
                    ScreenConfig.theme.textTheme.headline1
                        ?.copyWith(color: Colors.black.withOpacity(0.5)),
                  ),
                  spaceHeight(ScreenConfig.screenSizeHeight * 0.02),
                  displayText(
                      "Enter phone number with country extension. (e.g +921234567890)",
                      ScreenConfig.theme.textTheme.headline3),
                  spaceHeight(ScreenConfig.screenSizeHeight * 0.02),
                  const PhoneNumberTextField(),
                  spaceHeight(ScreenConfig.screenSizeHeight * 0.03),
                  Buttons.longWidthButton("Login", () {
                    if (!errorValidatorShow) {
                      DebugHelper.printAll("Initiate Print");

                      Navigator.pushNamed(
                          context, OTPVerificationScreen.routeName,
                          arguments: {'number': phoneNumberController.text});
                    }
                  }),
                  spaceHeight(ScreenConfig.screenSizeHeight * 0.02),
                  Buttons.splashScreenButton("Signup/Register", () {
                    Navigator.of(context)
                        .pushNamed(ChoiceCustomerDriverScreen.routeName);
                  }),
                  spaceHeight(ScreenConfig.screenSizeHeight * 0.02),
                  Buttons.splashScreenButton("Login", () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context)=>Login()));
                  }),
                  spaceHeight(ScreenConfig.screenSizeHeight * 0.03),
                ],
              ),
              spaceHeight(ScreenConfig.screenSizeHeight * 0.2),
            ],
          ),
        ),
      ),
    );
  }
}
