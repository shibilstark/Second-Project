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

  AuthSuccess({required this.type});
  @override
  List<Object> get props => [type];
}

class AuthError extends AuthState {
  MainFailures fail;

  AuthError(this.fail);
  @override
  List<Object> get props => [fail];
}
