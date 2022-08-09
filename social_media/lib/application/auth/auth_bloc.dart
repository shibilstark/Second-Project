import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/scheduler.dart';
import 'package:injectable/injectable.dart';
import 'package:social_media/application/profile/profile_cubit.dart';
import 'package:social_media/domain/failures/main_failures.dart';
import 'package:social_media/domain/models/user_model/user_model.dart';
import 'package:social_media/infrastructure/auth/auth_repo.dart';

part 'auth_event.dart';
part 'auth_state.dart';

@injectable
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepo authRepo;

  AuthBloc({required this.authRepo}) : super(AuthInitial()) {
    on<LoginOrSignUp>((event, emit) async {
      emit(AuthLoading());

      await authRepo.googleLogin().then((value) {
        value.fold((success) {
          emit(AuthSuccess(
            type: AuthMode.login,
          ));
        }, (fail) {
          emit(AuthError(fail));
        });
      });
    });
    on<LogOut>((event, emit) async {
      emit(AuthLoading());

      await authRepo.googleLogout().then((value) {
        value.fold((success) {
          emit(AuthSuccess(
            type: AuthMode.logout,
          ));
        }, (fail) {
          emit(AuthError(fail));
        });
      });
    });
  }
}
