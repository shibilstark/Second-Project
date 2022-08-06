part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {
  final String type;
  final UserModel user;

  AuthSuccess({required this.type, required this.user});
  @override
  List<Object> get props => [type];
}

class AuthError extends AuthState {
  MainFailures fail;

  AuthError(this.fail);
  @override
  List<Object> get props => [fail];
}
