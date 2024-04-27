import 'package:flutter/cupertino.dart';
import 'package:ridely/src/presentation/ui/screens/booking_screens/location_selection_screen.dart';
import 'package:ridely/src/presentation/ui/screens/booking_screens/ride_in_progress_and_finish_screen.dart';
import 'package:ridely/src/presentation/ui/screens/booking_screens/ride_rating_screen.dart';
import 'package:ridely/src/presentation/ui/screens/booking_screens/ride_selection_screen.dart';
import 'package:ridely/src/presentation/ui/screens/booking_screens/ride_shown_screen.dart';
import 'package:ridely/src/presentation/ui/screens/booking_screens/ride_waiting_screen.dart';
import 'package:ridely/src/presentation/ui/screens/booking_screens/solo_ride_flow/list_confirm_your_ride_screen.dart';
import 'package:ridely/src/presentation/ui/screens/booking_screens/solo_ride_flow/location_selection_solo_screen.dart';
import 'package:ridely/src/presentation/ui/screens/booking_screens/solo_ride_flow/solo_ride_in_progress_and_finish_screen.dart';
import 'package:ridely/src/presentation/ui/screens/booking_screens/solo_ride_flow/solo_ride_rating_screen.dart';
import 'package:ridely/src/presentation/ui/screens/booking_screens/solo_ride_flow/solo_ride_shown_screen.dart';
import 'package:ridely/src/presentation/ui/screens/booking_screens/solo_ride_flow/solo_ride_waiting_screen.dart';
import 'package:ridely/src/presentation/ui/screens/booking_screens/solo_ride_flow/vehicle_selection_screen.dart';
import 'package:ridely/src/presentation/ui/screens/driver_screens/driver_main_screen.dart';
import 'package:ridely/src/presentation/ui/screens/driver_screens/driver_solo_ride_in_progress_and_finished_screen.dart';
import 'package:ridely/src/presentation/ui/screens/driver_screens/driver_solo_ride_rating_screen.dart';
import 'package:ridely/src/presentation/ui/screens/driver_screens/driver_solo_ride_waiting_screen.dart';
import 'package:ridely/src/presentation/ui/screens/onboarding_screens/login_number_screen.dart';
import 'package:ridely/src/presentation/ui/screens/onboarding_screens/onboarding_cards_screen.dart';
import 'package:ridely/src/presentation/ui/screens/onboarding_screens/otp_verification_screen.dart';
import 'package:ridely/src/presentation/ui/screens/onboarding_screens/register_screens/choice_customer_driver.dart';
import 'package:ridely/src/presentation/ui/screens/onboarding_screens/register_screens/register_driver_vehicle_info_screen.dart';
import 'package:ridely/src/presentation/ui/screens/onboarding_screens/register_screens/register_info_screen.dart';
import 'package:ridely/src/presentation/ui/screens/onboarding_screens/splash_screen.dart';
import 'package:ridely/src/presentation/ui/screens/past_rides_screens/previous_ride_detail_screen.dart';
import 'package:ridely/src/presentation/ui/screens/past_rides_screens/previous_rides_screen.dart';

final Map<String, Widget Function(BuildContext)> routes = {
  SplashScreen.routeName: (ctx) => const SplashScreen(),
  OnboardingCardsScreen.routeName: (ctx) => const OnboardingCardsScreen(),
  LoginNumberEnterScreen.routeName: (ctx) => const LoginNumberEnterScreen(),
  OTPVerificationScreen.routeName: (ctx) => const OTPVerificationScreen(),
  RegisterInfoScreen.routeName: (ctx) => const RegisterInfoScreen(),
  RegisterDriverVehicleInfoScreen.routeName: (ctx) =>
      const RegisterDriverVehicleInfoScreen(),
  ChoiceCustomerDriverScreen.routeName: (ctx) =>
      const ChoiceCustomerDriverScreen(),
  RideSelectionScreen.routeName: (ctx) => const RideSelectionScreen(),
  DriverRideSelectionScreen.routeName: (ctx) =>
      const DriverRideSelectionScreen(),
  VehicleSelectionScreen.routeName: (ctx) => const VehicleSelectionScreen(),
  LocationSelectionScreen.routeName: (ctx) => LocationSelectionScreen(
  ),
  LocationSelectionSoloScreen.routeName: (ctx) =>
      const LocationSelectionSoloScreen(),
  RideShownScreen.routeName: (ctx) => const RideShownScreen(),
  SoloRideShownScreen.routeName: (ctx) => const SoloRideShownScreen(),
  RideWaitingScreen.routeName: (ctx) => const RideWaitingScreen(),
  SoloRideWaitingScreen.routeName: (ctx) => const SoloRideWaitingScreen(),
  DriverSoloRideWaitingScreen.routeName: (ctx) =>
      const DriverSoloRideWaitingScreen(),
  RideInProgressAndFinishedScreen.routeName: (ctx) =>
      const RideInProgressAndFinishedScreen(),
  SoloRideInProgressAndFinishedScreen.routeName: (ctx) =>
      const SoloRideInProgressAndFinishedScreen(),
  DriverSoloRideInProgressAndFinishedScreen.routeName: (ctx) =>
      const DriverSoloRideInProgressAndFinishedScreen(),
  RideRatingScreen.routeName: (ctx) => const RideRatingScreen(),
  SoloRideRatingScreen.routeName: (ctx) => const SoloRideRatingScreen(),
  DriverSoloRideRatingScreen.routeName: (ctx) =>
      const DriverSoloRideRatingScreen(),
  ListConfirmYourRideScreen.routeName: (ctx) =>
      const ListConfirmYourRideScreen(),
  PreviousRidesScreen.routeName: (ctx) => const PreviousRidesScreen(),
  PreviousRideDetailScreen.routeName: (ctx) => const PreviousRideDetailScreen(),
};
