import 'package:blog_app/core/usecase/usecase.dart';
import 'package:blog_app/features/auth/domain/usecases/user_login.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/user.dart';
import '../../domain/usecases/current_user.dart';
import '../../domain/usecases/user_sign_up.dart';

part 'auth_event.dart';

part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserSignUp _userSignUp;
  final UserLogin _userLogin;
  final CurrentUser _currentUser;

  AuthBloc({
    required UserSignUp userSignUp,
    required UserLogin userLogin,
    required CurrentUser currentUser,
  })
      : _userSignUp = userSignUp,
        _userLogin = userLogin,
        _currentUser = currentUser,
        super(AuthInitial()) {
    on<AuthSignUp>(_onAuthSignUp);
    on<AuthLogin>(_onAuthLogin);
    on<AuthIsUserLoggedIn>(_isUserLoggedIn);
  }

  void _isUserLoggedIn(AuthIsUserLoggedIn event,
      Emitter<AuthState> emit) async {
    final res = await _currentUser(NoParams());
    res.fold(
            (failure) => emit(AuthFailure(failure.message)),
            (user) {
              print(user.email);
          emit(
            AuthSuccess(user),
          );
        }
    );
  }

  void _onAuthSignUp(AuthSignUp event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final res = await _userSignUp(UserSignUpParams(
        name: event.name, email: event.email, password: event.password));

    res.fold((failure) => emit(AuthFailure(failure.message)),
            (user) => emit(AuthSuccess(user)));
  }

  void _onAuthLogin(AuthLogin event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final res = await _userLogin(
        UserLoginParams(email: event.email, password: event.password));

    res.fold((failure) => emit(AuthFailure(failure.message)),
            (user) => emit(AuthSuccess(user)));
  }
}
