import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:ridely/src/presentation/bloc/user/user_bloc.dart';
import 'package:ridely/src/presentation/ui/config/routes.dart';
import 'package:ridely/src/presentation/ui/config/theme.dart';

import 'presentation/ui/screens/onboarding_screens/splash_screen.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => UserBloc()..add(CheckIfLoggedIn()),
        ),
      ],
      child: OverlaySupport(
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: apptheme,
          routes: routes,
          home: const SplashScreen(),
        ),
      ),
    );
  }
}
