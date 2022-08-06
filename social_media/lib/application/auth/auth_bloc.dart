import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';
import 'package:social_media/domain/failures/main_failures.dart';
import 'package:social_media/domain/models/user_model/user_model.dart';
import 'package:social_media/infrastructure/auth/auth_repo.dart';

part 'auth_event.dart';
part 'auth_state.dart';

@injectable
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepo _authRepo;
  AuthBloc(this._authRepo) : super(AuthInitial()) {
    on<LoginOrSignUp>((event, emit) async {
      emit(AuthLoading());

      await _authRepo.googleLogin().then((value) {
        value.fold((success) {
          emit(AuthSuccess(type: AuthMode.login, user: success));
        }, (fail) {
          emit(AuthError(fail));
        });
      });
    });
  }
}
