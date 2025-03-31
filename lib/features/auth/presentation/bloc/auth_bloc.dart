import 'package:blog_app/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:blog_app/core/usecase/usecase.dart';
import 'package:blog_app/features/auth/domain/repository/auth_repository.dart';
import 'package:blog_app/features/auth/domain/usecases/user_login.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/common/entities/user.dart';
import '../../domain/usecases/current_user.dart';
import '../../domain/usecases/user_sign_up.dart';

part 'auth_event.dart';

part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserSignUp _userSignUp;
  final UserLogin _userLogin;
  final CurrentUser _currentUser;
  final AppUserCubit _appUserCubit;
  final AuthRepository _authRepository;

  AuthBloc({
    required UserSignUp userSignUp,
    required UserLogin userLogin,
    required CurrentUser currentUser,
    required AppUserCubit appUserCubit,
    required AuthRepository authRepository,
  })  : _userSignUp = userSignUp,
        _userLogin = userLogin,
        _currentUser = currentUser,
        _appUserCubit = appUserCubit,
        _authRepository = authRepository,
        super(AuthInitial()) {
    on<AuthEvent> ((_, emit) => emit(AuthInitial()));
    on<AuthSignUp>(_onAuthSignUp);
    on<AuthLogin>(_onAuthLogin);
    on<AuthIsUserLoggedIn>(_isUserLoggedIn);
    on<AuthLogOut>(_onLogout);
  }

  void _isUserLoggedIn(
      AuthIsUserLoggedIn event, Emitter<AuthState> emit) async {
    final res = await _currentUser(NoParams());
    res.fold(
      (failure) => emit(AuthFailure(failure.message)),
      (user) => _emitAuthSuccess(user, emit),
    );
  }

  void _onAuthSignUp(AuthSignUp event, Emitter<AuthState> emit) async {

    final res = await _userSignUp(UserSignUpParams(
        name: event.name, email: event.email, password: event.password));

    res.fold((failure) => emit(AuthFailure(failure.message)),
        (user) => _emitAuthSuccess(user, emit));
  }

  void _onAuthLogin(AuthLogin event, Emitter<AuthState> emit) async {

    emit(AuthLoading());
    final res = await _userLogin(
        UserLoginParams( email: event.email, password: event.password));

    res.fold((failure) => emit(AuthFailure(failure.message)),
          (user) => _emitAuthSuccess(user, emit),
    );
}
  void _emitAuthSuccess(User user, Emitter<AuthState> emit) {
    _appUserCubit.updateUser(user);
    emit(AuthSuccess(user));
  }
  void _onLogout(AuthLogOut event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final result = await _authRepository.logOut();
    result.fold(
          (failure) => emit(AuthFailure(failure.message)),
          (_) {
        _appUserCubit.updateUser(null);
        emit(Unauthenticated());
      },
    );
  }
}
