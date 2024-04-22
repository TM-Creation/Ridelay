part of 'user_bloc.dart';

@immutable
abstract class UserState {}

class UserInitial extends UserState {}

class ShowSplashScreen extends UserState {}

class UserLoading extends UserState {}

class UserLoggedIn extends UserState {}
