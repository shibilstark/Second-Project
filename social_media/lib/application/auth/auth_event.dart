part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class LoginOrSignUp extends AuthEvent {}

class LogOut extends AuthEvent {}

class AuthMode {
  static final login = "login";
  static final logout = "logout";
}
