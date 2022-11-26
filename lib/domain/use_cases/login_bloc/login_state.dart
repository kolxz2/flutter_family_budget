part of 'login_bloc.dart';

@immutable
abstract class LoginState {}

class UnLoginState extends LoginState {}

class IsLoginState extends LoginState {
  final String name;
  final String surname;
  final String patronymic;
  final String password;
  final bool isAdmin;

  IsLoginState(
      {required this.name,
      required this.surname,
      required this.patronymic,
      required this.password,
      required this.isAdmin});
}
