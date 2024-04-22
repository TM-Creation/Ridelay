import 'package:flutter/material.dart';
import 'package:ridely/src/infrastructure/screen_config/screen_config.dart';
import 'package:ridely/src/presentation/ui/templates/main_generic_templates/app_bars/app_bar.dart';
import 'package:ridely/src/presentation/ui/templates/main_generic_templates/app_buttons/buttons.dart';
import 'package:ridely/src/presentation/ui/templates/main_generic_templates/other_widgets/space_line_between_two_text_fields.dart';
import 'package:ridely/src/presentation/ui/templates/main_generic_templates/spacing_widgets.dart';
import 'package:ridely/src/presentation/ui/templates/main_generic_templates/text_templates/display_text.dart';
import 'package:ridely/src/presentation/ui/templates/main_generic_templates/text_templates/generic_textfield.dart';
import 'package:ridely/src/presentation/ui/templates/ride_widgets/ride_detail_widgets.dart';

class ListConfirmYourRideScreen extends StatefulWidget {
  const ListConfirmYourRideScreen({Key? key}) : super(key: key);
  static const routeName = '/listconfirmyourride-screen';

  @override
  State<ListConfirmYourRideScreen> createState() =>
      _ListConfirmYourRideScreenState();
}

class _ListConfirmYourRideScreenState extends State<ListConfirmYourRideScreen> {
  TextEditingController pickupEnterController = TextEditingController();
  TextEditingController dropoffEnterController = TextEditingController();
  List namesList = ["Mini", "Go", "Comfort", "Mini"];
  @override
  void initState() {
    pickupEnterController.text = "Gulberg Phase II";
    dropoffEnterController.text = "Bahria Town";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: GenericAppBars.appBarWithBackButtonOnly(context, false),
      body: SizedBox(
        width: ScreenConfig.screenSizeWidth,
        child: Center(
            child: SizedBox(
                height: ScreenConfig.screenSizeHeight,
                width: ScreenConfig.screenSizeWidth * 0.9,
                child: SingleChildScrollView(
                    physics: const ClampingScrollPhysics(),
                    child: Column(
                      children: [
                        Column(
                          children: [
                            genericTextField(
                                "Pick-Up Location",
                                SizedBox(
                                  height: 60,
                                  width: 50,
                                  child: Row(
                                    children: [
                                      Buttons.smallSquareButton(
                                          "assets/images/CircularIconButton.png",
                                          () {}),
                                    ],
                                  ),
                                ),
                                pickupEnterController,
                                isReadOnly: true),
                            spaceHeight(10),
                            lineSeparatorTextFields(),
                            spaceHeight(10),
                            genericTextField(
                                "Drop Off Location",
                                SizedBox(
                                  height: 60,
                                  width: 50,
                                  child: Row(
                                    children: [
                                      Buttons.smallSquareButton(
                                          "assets/images/PinPointIcon.png",
                                          () {}),
                                    ],
                                  ),
                                ),
                                dropoffEnterController,
                                isReadOnly: true),
                          ],
                        ),
                        spaceHeight(ScreenConfig.screenSizeHeight * 0.04),
                        displayText(
                            "Confirm Your Ride Partner",
                            ScreenConfig.theme.textTheme.headline4
                                ?.copyWith(fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                            width: 0.9),
                        spaceHeight(ScreenConfig.screenSizeHeight * 0.02),
                        Column(
                          children: List.generate(4, (index) {
                            return rideDetailsWidget(
                                namesList[index], "Confirm Partner", context);
                          }),
                        ),
                      ],
                    )))),
      ),
    );
  }
}
