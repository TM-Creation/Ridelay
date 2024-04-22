import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ridely/src/infrastructure/local_storage/local_storage.dart';
import 'package:ridely/src/infrastructure/screen_config/screen_config.dart';
import 'package:ridely/src/presentation/bloc/user/user_bloc.dart';
import 'package:ridely/src/presentation/ui/screens/onboarding_screens/onboarding_cards_screen.dart';

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
  }

  initialize() async {
    await Storage.initialize();
  }

  @override
  Widget build(BuildContext context) {
    ScreenConfig().init(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocListener<UserBloc, UserState>(
          listener: (context, state) {
            if (state is UserLoggedIn) {
              //   BlocProvider.of<BankBloc>(context).add(GetAllBanks());
              //  Navigator.of(context)
              //       .pushReplacementNamed(MainDashboard.routeName);
            } else if (state is UserInitial) {
              Navigator.of(context)
                  .pushReplacementNamed(OnboardingCardsScreen.routeName);
            }
          },
          child: Center(
            child: SizedBox(
              height: 130,
              width: 130,
              child: Image.asset(
                "assets/images/SplashScreenLogo.png",
                fit: BoxFit.contain,
              ),
            ),
          )),
    );
  }
}
