import 'package:flutter/material.dart';

const themeColor = Color(0xff003240);
const thirdColor = Color(0xffDAB666);
const redFourthColor = Color(0xffDA6666);

final apptheme = ThemeData(
  scaffoldBackgroundColor: const Color(0xfff2f0ff),
  primaryColor: themeColor,
  colorScheme: const ColorScheme(
      primary: themeColor,
      primaryContainer: themeColor,
      secondary: Colors.white,
      secondaryContainer: Colors.white,
      surface: Color(0xff707070),
      background: Colors.white,
      error: Colors.red,
      onPrimary: Colors.white,
      onSecondary: Colors.black,
      onSurface: Colors.black,
      onBackground: Colors.black,
      onError: Colors.white,
      brightness: Brightness.light),
  appBarTheme: const AppBarTheme(
    elevation: 0,
    color: Colors.transparent,
    iconTheme: IconThemeData(color: Colors.black),
  ),
  fontFamily: 'Poppins',
  // buttonTheme: const ButtonThemeData(
  //
  // ),
  textTheme: const TextTheme(
    headline1: TextStyle(
        fontSize: 20.0, fontWeight: FontWeight.bold, color: themeColor),
    headline2: TextStyle(
        fontSize: 15.0, fontWeight: FontWeight.bold, color: Colors.white),
    headline3: TextStyle(
        fontSize: 16.0,
        fontWeight: FontWeight.normal,
        color: Color(0xff707070)),
    headline4: TextStyle(
        fontWeight: FontWeight.normal, fontSize: 15, color: themeColor),
    headline5: TextStyle(
        fontWeight: FontWeight.normal, fontSize: 15, color: Color(0xff707070)),
    headline6: TextStyle(
        fontSize: 15, fontWeight: FontWeight.normal, color: Colors.black),
    bodyText1: TextStyle(
        fontSize: 12.0, fontWeight: FontWeight.normal, color: Colors.white),
    bodyText2: TextStyle(
        fontSize: 10.0, fontWeight: FontWeight.normal, color: Colors.white),
    caption: TextStyle(
        fontSize: 9.0, fontWeight: FontWeight.normal, color: Color(0xff707070)),
    // bodyMedium: TextStyle(color: Colors.black,fontSize: 20.0,),
    button: TextStyle(
        fontSize: 15, fontWeight: FontWeight.normal, color: Colors.white),
    overline: TextStyle(fontSize: 16, letterSpacing: 0),
  ),
  inputDecorationTheme: const InputDecorationTheme(
    hintStyle: TextStyle(fontSize: 20, color: Color(0xff828282)),
    labelStyle: TextStyle(color: themeColor),
    // border: InputBorder.none,
    // focusedBorder: InputBorder.none,
    // enabledBorder: InputBorder.none,
    // errorBorder: InputBorder.none,
    // disabledBorder: InputBorder.none,
  ),
  pageTransitionsTheme: const PageTransitionsTheme(builders: {
    TargetPlatform.iOS: ZoomPageTransitionsBuilder(),
  }),
);
