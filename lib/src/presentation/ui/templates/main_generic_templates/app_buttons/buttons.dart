import 'package:flutter/material.dart';
import 'package:ridely/src/infrastructure/screen_config/screen_config.dart';
import 'package:ridely/src/presentation/ui/templates/decorations/box_decoration_templates.dart';
import 'package:ridely/src/presentation/ui/templates/main_generic_templates/spacing_widgets.dart';
import 'package:ridely/src/presentation/ui/templates/main_generic_templates/text_templates/display_text.dart';

class Buttons {
  static Widget splashScreenButton(String text, void Function() func) =>
      GestureDetector(
        onTap: func,
        child: Container(
          width: ScreenConfig.screenSizeWidth * 0.5,
          height: 40,
          decoration: BoxDecoration(
              color: ScreenConfig.theme.primaryColor,
              borderRadius: BorderRadius.circular(100.0)),
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: ScreenConfig.screenSizeWidth * 0.05),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  text,
                  style: ScreenConfig.theme.textTheme.headline6?.copyWith(
                      color: Colors.white, fontWeight: FontWeight.w300),
                ),
                const Icon(
                  Icons.arrow_forward,
                  color: Colors.white,
                  size: 20,
                )
              ],
            ),
          ),
        ),
      );
  static Widget backButton(BuildContext context, bool isIconCross) =>
      GestureDetector(
        onTap: () {
          Navigator.pop(context,"refresh");
        },
        child: Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
              color: ScreenConfig.theme.primaryColor,
              borderRadius: BorderRadius.circular(100.0)),
          child: Padding(
            padding: const EdgeInsets.all(6),
            child: Image.asset(
              isIconCross
                  ? "assets/images/CrossIcon.png"
                  : "assets/images/BackIcon.png",
            ),
          ),
        ),
      );
  static Widget crossSmallButton(BuildContext context, void Function() func) =>
      GestureDetector(
        onTap: func,
        child: Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
              color: ScreenConfig.theme.primaryColor,
              borderRadius: BorderRadius.circular(100.0)),
          child: Padding(
            padding: const EdgeInsets.all(5),
            child: Image.asset("assets/images/CrossIcon.png"),
          ),
        ),
      );
  static Widget forwardButton(BuildContext context, void Function() func) =>
      GestureDetector(
        onTap: func,
        child: Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
              color: ScreenConfig.theme.primaryColor,
              borderRadius: BorderRadius.circular(100.0)),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Image.asset(
              "assets/images/ForwardIcon.png",
            ),
          ),
        ),
      );
  static Widget getMyCurrentLocationButton() => GestureDetector(
        onTap: () {

        },
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.40),
                  offset: const Offset(0.0, 1.2), //(x,y)
                  blurRadius: 6.0,
                )
              ]),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Image.asset(
              "assets/images/GetMyCurrentLocationIcon.png",
            ),
          ),
        ),
      );
  static Widget smallSquareButton(
          String icon, void Function() searchFunction) =>
      GestureDetector(
        onTap: searchFunction,
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
              color: ScreenConfig.theme.primaryColor,
              borderRadius: BorderRadius.circular(8.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.40),
                  offset: const Offset(0.0, 1.2), //(x,y)
                  blurRadius: 6.0,
                )
              ]),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: SizedBox(
              height: 16,
              width: 16,
              child: Image.asset(
                icon,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
      );

  static Widget squareRideScreenButton(String image, String heading,
          String subHeading, void Function() func) =>
      GestureDetector(
        onTap: func,
        child: Container(
          width: ScreenConfig.screenSizeWidth * 0.37,
          decoration: squareButtonTemplate(),
          child: Column(
            children: [
              spaceHeight(ScreenConfig.screenSizeHeight * 0.03),
              SizedBox(
                height: 50,
                width: 60,
                child: Image.asset(
                  image,
                  fit: BoxFit.contain,
                ),
              ),
              spaceHeight(ScreenConfig.screenSizeHeight * 0.02),
              displayText(heading, ScreenConfig.theme.textTheme.headline4,
                  textAlign: TextAlign.center, width: 0.3),
              spaceHeight(ScreenConfig.screenSizeHeight * 0.002),
              displayText(subHeading, ScreenConfig.theme.textTheme.caption,
                  textAlign: TextAlign.center, width: 0.3),
              spaceHeight(ScreenConfig.screenSizeHeight * 0.02),
            ],
          ),
        ),
      );
  static Widget squareRideSelectionScreenButton(String image, String heading,
      String subHeading, void Function() func) =>
      GestureDetector(
        onTap: func,
        child: Container(
          width: ScreenConfig.screenSizeWidth * 0.28,
          decoration: squareButtonTemplate(),
          child: Column(
            children: [
              spaceHeight(ScreenConfig.screenSizeHeight * 0.03),
              SizedBox(
                height: 50,
                width: 60,
                child: Image.asset(
                  image,
                  fit: BoxFit.contain,
                ),
              ),
              spaceHeight(ScreenConfig.screenSizeHeight * 0.02),
              displayText(heading, ScreenConfig.theme.textTheme.headline4,
                  textAlign: TextAlign.center, width: 0.3),
              spaceHeight(ScreenConfig.screenSizeHeight * 0.002),
              displayText(subHeading, ScreenConfig.theme.textTheme.caption,
                  textAlign: TextAlign.center, width: 0.3),
              spaceHeight(ScreenConfig.screenSizeHeight * 0.02),
            ],
          ),
        ),
      );
  static Widget squareLargeSelectionScreenButton(String image, String heading,
          String subHeading, void Function() func) =>
      GestureDetector(
          onTap: func,
          child: Container(
            width: ScreenConfig.screenSizeWidth * 0.7,
            decoration: squareButtonTemplate(),
            child: Column(
              children: [
                spaceHeight(ScreenConfig.screenSizeHeight * 0.05),
                SizedBox(
                  height: 80,
                  width: 100,
                  child: Image.asset(
                    image,
                    fit: BoxFit.contain,
                  ),
                ),
                spaceHeight(ScreenConfig.screenSizeHeight * 0.02),
                displayText(heading, ScreenConfig.theme.textTheme.headline1,
                    textAlign: TextAlign.center, width: 0.3),
                spaceHeight(ScreenConfig.screenSizeHeight * 0.002),
                displayText(subHeading, ScreenConfig.theme.textTheme.headline3,
                    textAlign: TextAlign.center, width: 0.5),
                spaceHeight(ScreenConfig.screenSizeHeight * 0.05),
              ],
            ),
          ));
  static Widget longWidthButton(String text, void Function() func) =>
      GestureDetector(
        onTap: func,
        child: Container(
          width: ScreenConfig.screenSizeWidth * 0.9,
          height: 40,
          decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
                ScreenConfig.theme.primaryColor,
                ScreenConfig.theme.primaryColor,
              ]),
              borderRadius: BorderRadius.circular(19.0)),
          child: Center(
              child: Text(
            text,
            style: ScreenConfig.theme.textTheme.headline6
                ?.copyWith(color: Colors.white, fontWeight: FontWeight.w300),
          )),
        ),
      );
  static Widget fullWidthButton(
          {String? image,
          required Function() func,
          Color color = Colors.black,
          Color textColor = Colors.white,
          required String text,
          bool hasImage = false}) =>
      GestureDetector(
        onTap: func,
        child: Container(
          width: ScreenConfig.screenSizeWidth,
          height: ScreenConfig.screenSizeHeight * 0.06,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5.0),
            color: color,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              hasImage
                  ? Image.asset(
                      image!,
                      fit: BoxFit.fitWidth,
                      height: ScreenConfig.screenSizeHeight * 0.09,
                      width: ScreenConfig.screenSizeWidth * 0.08,
                    )
                  : const SizedBox(),
              SizedBox(
                width: ScreenConfig.screenSizeWidth * 0.02,
              ),
              Text(
                text,
                style: ScreenConfig.theme.textTheme.headline6
                    ?.copyWith(color: textColor),
              ),
            ],
          ),
        ),
      );

  static Widget fullwidthButton(
          {String? image,
          required Function() func,
          required String text,
          bool hasImage = false}) =>
      GestureDetector(
        onTap: func,
        child: Container(
          width: ScreenConfig.screenSizeWidth,
          height: ScreenConfig.screenSizeHeight * 0.05,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.green),
            borderRadius: BorderRadius.circular(5.0),
            color: const Color.fromARGB(255, 196, 210, 196),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              hasImage
                  ? Image.asset(
                      image!,
                      fit: BoxFit.fitWidth,
                      height: ScreenConfig.screenSizeHeight * 0.09,
                      width: ScreenConfig.screenSizeWidth * 0.08,
                    )
                  : const SizedBox(),
              SizedBox(
                width: ScreenConfig.screenSizeWidth * 0.02,
              ),
              Text(
                text,
                style: ScreenConfig.theme.textTheme.headline6
                    ?.copyWith(color: Colors.white),
              ),
            ],
          ),
        ),
      );
  static Widget blackLongWidthButton(String text, void Function() func) =>
      GestureDetector(
        onTap: func,
        child: Container(
          width: ScreenConfig.screenSizeWidth * 0.8,
          height: 43,
          decoration: BoxDecoration(
              gradient:
                  const LinearGradient(colors: [Colors.black, Colors.black]),
              borderRadius: BorderRadius.circular(19.0)),
          child: Center(
              child: Text(
            text,
            style: ScreenConfig.theme.textTheme.headline4
                ?.copyWith(color: Colors.white, fontWeight: FontWeight.w300),
          )),
        ),
      );
  static Widget largeButton(
          String text, String icon, void Function() func, Color iconColor,
          {AlignmentDirectional alignmentDirectional =
              AlignmentDirectional.center}) =>
      GestureDetector(
        onTap: func,
        child: Container(
          decoration: BoxDecoration(
              gradient: const LinearGradient(
                  colors: [Color(0xff202020), Color(0xff4A4A4A)]),
              borderRadius: BorderRadius.circular(19.0)),
          width: ScreenConfig.screenSizeWidth * 0.8,
          height: 80,
          child: Stack(
            alignment: AlignmentDirectional.center,
            // mainAxisAlignment: MainAxisAlignment.start,
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: Padding(
                  padding: const EdgeInsets.only(left: 40, right: 40),
                  child: Image(
                    image: AssetImage(icon),
                    width: 35,
                    height: 35,
                  ),
                ),
              ),
              // SizedBox(width: ScreenConfig.screenSizeWidth*0.05,),
              Text(
                text,
                style: ScreenConfig.theme.textTheme.headline6?.copyWith(
                    color: Colors.white, fontWeight: FontWeight.w300),
              ),
            ],
          ),
        ),
      );
  static Widget leftAlignedLargeButton(
          String text, String icon, void Function() func, Color iconColor,
          {AlignmentDirectional alignmentDirectional =
              AlignmentDirectional.center}) =>
      GestureDetector(
        onTap: func,
        child: Container(
          decoration: BoxDecoration(
              gradient: const LinearGradient(
                  colors: [Color(0xff202020), Color(0xff4A4A4A)]),
              borderRadius: BorderRadius.circular(19.0)),
          width: ScreenConfig.screenSizeWidth * 0.8,
          height: 80,
          child: Row(
            // alignment: AlignmentDirectional.center,
            // mainAxisAlignment: MainAxisAlignment.center,
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 40, right: 40),
                child: Image(
                  image: AssetImage(icon),
                  width: 25,
                  height: 25,
                ),
              ),
              const SizedBox(width: 24),
              Text(
                text,
                style: ScreenConfig.theme.textTheme.headline5?.copyWith(
                    color: Colors.white, fontWeight: FontWeight.w300),
              ),
            ],
          ),
        ),
      );
  static Widget mediumButton(String text, void Function() func, double width) =>
      GestureDetector(
        onTap: func,
        child: Container(
          width: ScreenConfig.screenSizeWidth * width,
          height: 40,
          decoration: BoxDecoration(
              color: Colors.black,
              // gradient: LinearGradient(colors: [Color(0xff202020),Color(0xff4A4A4A)]),
              borderRadius: BorderRadius.circular(19.0)),
          child: Center(
              child: Text(
            text,
            style: ScreenConfig.theme.textTheme.headline5
                ?.copyWith(color: Colors.white),
          )),
        ),
      );
  static Widget mediumButtonInverted(
          String text, void Function() func, double width) =>
      GestureDetector(
        onTap: func,
        child: Container(
          width: ScreenConfig.screenSizeWidth * width,
          height: 40,
          decoration: BoxDecoration(
              color: const Color(0xffF2F0FF).withOpacity(0.95),
              // gradient: LinearGradient(colors: [Color(0xff202020),Color(0xff4A4A4A)]),
              borderRadius: BorderRadius.circular(19.0)),
          child: Center(
              child: Text(
            text,
            style: ScreenConfig.theme.textTheme.headline6
                ?.copyWith(color: Colors.black),
          )),
        ),
      );
  static Widget mediumButtonWithColor(
          String text, void Function() func, double width,
          {Color color = Colors.black}) =>
      GestureDetector(
        onTap: func,
        child: Container(
          width: ScreenConfig.screenSizeWidth * width,
          height: 40,
          decoration: BoxDecoration(
              color: color,
              // gradient: LinearGradient(colors: [Color(0xff202020),Color(0xff4A4A4A)]),
              borderRadius: BorderRadius.circular(19.0)),
          child: Center(
              child: Text(
            text,
            style: ScreenConfig.theme.textTheme.headline6
                ?.copyWith(color: Colors.white),
          )),
        ),
      );
  static Widget verySmallButton(String text, void Function() func, double width,
          {Color color = Colors.black, Color textColor = Colors.white}) =>
      GestureDetector(
        onTap: func,
        child: Container(
          width: ScreenConfig.screenSizeWidth * width,
          height: 30,
          decoration: BoxDecoration(
              color: color,
              // gradient: LinearGradient(colors: [Color(0xff202020),Color(0xff4A4A4A)]),
              borderRadius: BorderRadius.circular(19.0)),
          child: Center(
              child: Text(
            text,
            style: ScreenConfig.theme.textTheme.bodyText2
                ?.copyWith(color: textColor, fontWeight: FontWeight.normal),
          )),
        ),
      );
  static Widget verySmallMediumTextButton(
          String text, void Function() func, double width,
          {Color color = Colors.black, Color textColor = Colors.white}) =>
      GestureDetector(
        onTap: func,
        child: Container(
          width: ScreenConfig.screenSizeWidth * width,
          height: 30,
          decoration: BoxDecoration(
              color: color,
              // gradient: LinearGradient(colors: [Color(0xff202020),Color(0xff4A4A4A)]),
              borderRadius: BorderRadius.circular(19.0)),
          child: Center(
              child: Text(
            text,
            style: ScreenConfig.theme.textTheme.bodyText1
                ?.copyWith(color: textColor, fontWeight: FontWeight.normal),
          )),
        ),
      );

  static Widget circularBlackbackgroundIconButton(
          IconData buttonIcon, void Function() func) =>
      Padding(
        padding: const EdgeInsets.fromLTRB(10.0, 6.0, 0.0, 6.0),
        child: GestureDetector(
          onTap: func,
          child: CircleAvatar(
            backgroundColor: Colors.black,
            child: Icon(
              buttonIcon,
              color: Colors.white,
            ),
          ),
        ),
      );
  static Widget dropdownSmallButton(
          String buttonTitle, void Function() func, IconData icon) =>
      GestureDetector(
        onTap: func,
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
            borderRadius: const BorderRadius.all(
              Radius.circular(19.0),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.only(
                left: 13.0, top: 6.0, bottom: 6.0, right: 6.5),
            child: Row(
              children: [
                Text(
                  buttonTitle,
                  style: ScreenConfig.theme.textTheme.bodyText2?.copyWith(
                      color: Colors.black, fontWeight: FontWeight.normal),
                ),
                const SizedBox(width: 5),
                Icon(icon, color: Colors.black, size: 15),
              ],
            ),
          ),
        ),
      );
}
