part of 'login_bloc.dart';

@immutable
abstract class LoginEvent {}

class TryLoginEvent extends LoginEvent {
  final String userLogin;
  final String userPassword;

  TryLoginEvent({required this.userLogin, required this.userPassword});
}

class LogoutEvent extends LoginEvent {}
