import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ridely/src/infrastructure/local_storage/local_storage.dart';
import 'package:ridely/src/infrastructure/screen_config/screen_config.dart';
import 'package:ridely/src/presentation/bloc/user/user_bloc.dart';
import 'package:ridely/src/presentation/ui/screens/booking_screens/ride_selection_screen.dart';
import 'package:ridely/src/presentation/ui/screens/driver_screens/driver_main_screen.dart';
import 'package:ridely/src/presentation/ui/screens/onboarding_screens/authentication_selection.dart';
import 'package:ridely/src/presentation/ui/screens/onboarding_screens/onboarding_cards_screen.dart';
import 'package:ridely/src/presentation/ui/screens/onboarding_screens/register_screens/driver_registration.dart';
import 'package:ridely/src/presentation/ui/screens/onboarding_screens/register_screens/passangerregistration.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);
  static const routeName = '/splash-screen';

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkFirstTime();
  }
  void _checkFirstTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool firstTime = prefs.getBool('first_time') ?? true;
    String isLogin= prefs.getString('islogin') ?? '';
    String uid=prefs.getString('uid') ?? '';
    String utoken=prefs.getString('utoken') ?? '';
    String utype=prefs.getString('utype') ?? '';
    String driveid=prefs.getString('driverid') ?? '';
    Future.delayed(Duration(seconds: 3),() async {
      if (!firstTime) {
        Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );
        userLiveLocation().userlivelocation=LatLng(position.latitude, position.longitude);
        if(isLogin.isNotEmpty){
          if(isLogin=='passenger'){
            setState(() {
              PassId().id=uid;
              PassId().token=utoken;
              PassId().type=utype;
            });
            Navigator.pushReplacementNamed(
                context,RideSelectionScreen.routeName);
          }
          else if(isLogin=='driver'){
            setState(() {
              PassId().id=uid;
              PassId().token=utoken;
              PassId().type=utype;
            });
            Navigator.pushReplacementNamed(
                context,DriverRideSelectionScreen.routeName);
          }else{
            setState(() {
              driverId().driverid=driveid;
            });
            Navigator.pushReplacementNamed(
                context,AuthenticationSelection.routeName);
          }
        }
        else{
          Navigator.pushReplacementNamed(
              context,AuthenticationSelection.routeName);
        }
      }else{
        Navigator.of(context)
            .pushReplacementNamed(OnboardingCardsScreen.routeName);
      }
    });
  }
  initialize() async {
    await Storage.initialize();
  }

  @override
  Widget build(BuildContext context) {
    ScreenConfig().init(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SizedBox(
          height: 130,
          width: 130,
          child: Image.asset(
            "assets/images/SplashScreenLogo.png",
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
