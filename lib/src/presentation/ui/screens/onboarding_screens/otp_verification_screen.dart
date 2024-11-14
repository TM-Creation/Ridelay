import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ridely/src/infrastructure/screen_config/screen_config.dart';
import 'package:ridely/src/presentation/ui/config/debug_helper.dart';
import 'package:ridely/src/presentation/ui/screens/booking_screens/ride_rating_screen.dart';
import 'package:ridely/src/presentation/ui/screens/booking_screens/ride_selection_screen.dart';
import 'package:ridely/src/presentation/ui/screens/driver_screens/driver_main_screen.dart';
import 'package:ridely/src/presentation/ui/templates/main_generic_templates/app_bars/app_bar.dart';
import 'package:ridely/src/presentation/ui/templates/main_generic_templates/app_buttons/buttons.dart';
import 'package:ridely/src/presentation/ui/templates/main_generic_templates/spacing_widgets.dart';
import 'package:ridely/src/presentation/ui/templates/main_generic_templates/text_templates/display_text.dart';
import 'package:ridely/src/presentation/ui/templates/main_generic_templates/validator_widgets/error_text.dart';

class OTPVerificationScreen extends StatefulWidget {
  const OTPVerificationScreen({Key? key}) : super(key: key);
  static const routeName = '/otp-verification-screen';

  @override
  State<OTPVerificationScreen> createState() => _OTPVerificationScreenState();
}

class _OTPVerificationScreenState extends State<OTPVerificationScreen> {
  late Timer _timer;
  int _start = 30;
  bool resendOption = false;
  late TextEditingController otpController;
  String number = '';
  bool progres=false;
  final _formKey = GlobalKey<FormState>();
  bool error = false;

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0) {
          setState(() {
            resendOption = true;
            timer.cancel();
          });
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }

  void reStartTimer() {
    _start = 30;
    setState(() {
      resendOption = false;
    });
    startTimer();
  }

  @override
  void initState() {
    super.initState();
    otpController = TextEditingController();
    startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map;
    number = args['number'];
    // PreferredSizeWidget _displayAppbar() => MyAppbar(
    //       title: 'OTP Verification',
    //       hasTitle: true,
    //       hasBackButton: true,
    //       leadingIconData: Icons.arrow_back_ios,
    //       actions: const [],
    //     );

    // Widget _displayBodyText({required String text}) => Padding(
    //       padding: const EdgeInsets.only(top: 15.0),
    //       child: IntroBody(
    //         body: text,
    //       ),
    //     );

    Widget _displayBodyText2({required String text}) => Text(text,
        textAlign: TextAlign.center,
        style: ScreenConfig.theme.textTheme.bodyLarge?.copyWith(
            color: Colors.black,
            wordSpacing: 1.0,
            // fontSize: 14,
            fontWeight: FontWeight.normal));

    Widget _displayTextField() => Form(
          key: _formKey,
          child: SizedBox(
            width: ScreenConfig.screenSizeWidth * 0.6,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  keyboardType: const TextInputType.numberWithOptions(),
                  controller: otpController,
                  cursorColor: ScreenConfig.theme.primaryColor,
                  style: ScreenConfig.theme.textTheme.displayLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: ScreenConfig.theme.primaryColor),
                  textAlign: TextAlign.center,
                  validator: (value) {
                    if (value == null || value.length < 6) {
                      return 'OTP is not valid';
                    } else if (otpController.text.isEmpty) {
                      return 'OTP can not be empty';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: ScreenConfig.theme.primaryColor)),
                    hintText: '000000',
                    hintStyle: ScreenConfig.theme.textTheme.displayLarge?.copyWith(
                        fontWeight: FontWeight.w600, color: Colors.grey),
                  ),
                  onChanged: (val) {
                    if (val.length < 6 || otpController.text.isEmpty) {
                      setState(() {
                        error = true;
                      });
                    }
                    if (val.length == 6) {
                      FocusScope.of(context).unfocus();
                      setState(() {
                        error = false;
                      });
                    } else if (val.length > 6) {
                      otpController.text = '';
                      setState(() {
                        error = false;
                      });
                    }
                  },
                ),
              ],
            ),
          ),
        );

    Widget _displayTimer() => _start == 0
        ? GestureDetector(
            onTap: () {
              reStartTimer();
            },
            child: displayText(
                "Resend OTP", ScreenConfig.theme.textTheme.titleLarge,
                textAlign: TextAlign.center))
        : displayText(
            _start < 10 ? 'Resend OTP 0:0$_start' : 'Resend OTP 0:$_start',
            ScreenConfig.theme.textTheme.titleMedium,
            textAlign: TextAlign.center);

    Widget _displayButton() => SizedBox(
        width: ScreenConfig.screenSizeWidth * 0.9,
        child: Buttons.longWidthButton(progres
            ? Container(
            height: 20,
            width: 20,
            child: CircularProgressIndicator(color: Colors.white,))
            : Text(
          'Continue',
          style: ScreenConfig.theme.textTheme.titleSmall?.copyWith(
              color: Colors.white, fontWeight: FontWeight.w300),
        ), () {
          if (otpController.text.length == 6 && otpController.text.isNotEmpty) {
            setState(() {
              error == false;
            });
            if (args['number'] == "+923321357777") {
              DebugHelper.printAll("IsDriver");
              Navigator.of(context)
                  .pushReplacementNamed(VehicleSelectionScreen.routeName);
            } else {
              DebugHelper.printAll("IsCustomer");
              Navigator.of(context)
                  .pushReplacementNamed(VehicleSelectionScreen.routeName);
            }

            // //TODO: FOR TEST VERSIONS ONLY FIX IN PRODUCTION
            // if (otpController.text == "1234") {
            //   if (state is OtpSent) {
            //     BlocProvider.of<DriverBloc>(context).add(
            //         OtpVerification(
            //             number: args['number'], otp: state.otp));
            //   }
            // } else {
            //   BlocProvider.of<DriverBloc>(context).add(
            //       OtpVerification(
            //           number: args['number'],
            //           otp: otpController.text));
            // }
          } else {
            setState(() {
              error = true;
            });
          }
        }));

    Widget _displayBodyText() => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            displayText(
              "OTP Verification",
              ScreenConfig.theme.textTheme.displayLarge
                  ?.copyWith(color: Colors.black.withOpacity(0.5)),
            ),
            spaceHeight(ScreenConfig.screenSizeHeight * 0.01),
            displayText(
                'We have sent OTP to', ScreenConfig.theme.textTheme.titleSmall),
            spaceHeight(ScreenConfig.screenSizeHeight * 0.01),
            displayText(
              args['number'],
              ScreenConfig.theme.textTheme.titleLarge
                  ?.copyWith(fontWeight: FontWeight.w600),
            ),
            spaceHeight(ScreenConfig.screenSizeHeight * 0.01),
            displayText('Please enter 6 digit verification code below',
                ScreenConfig.theme.textTheme.titleSmall),
            spaceHeight(ScreenConfig.screenSizeHeight * 0.01),
          ],
        );

    Widget _displayBody() => SizedBox(
          width: ScreenConfig.screenSizeWidth,
          child: Center(
            child: SizedBox(
              width: ScreenConfig.screenSizeWidth * 0.9,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  _displayBodyText(),
                  _displayTextField(),
                  if (error)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child:
                          errorValidator('OTP is not valid', TextAlign.center),
                    ),
                  spaceHeight(ScreenConfig.screenSizeHeight * 0.02),
                  _displayTimer()
                ],
              ),
            ),
          ),
        );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: GenericAppBars.appBarWithBackButtonOnly(context, false),
      body: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: _displayBody()),
      floatingActionButton: _displayButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
