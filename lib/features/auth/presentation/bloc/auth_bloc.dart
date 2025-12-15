import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jesoor_pro/features/auth/domain/usecases/login_use_case.dart';
import 'package:jesoor_pro/features/auth/domain/usecases/signup_use_case.dart';
import 'package:jesoor_pro/features/auth/presentation/bloc/auth_event.dart';
import 'package:jesoor_pro/features/auth/presentation/bloc/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase loginUseCase;
  final SignupUseCase signupUseCase;

  AuthBloc({required this.loginUseCase, required this.signupUseCase})
    : super(AuthInitial()) {
    on<LoginEvent>(_onLogin);
    on<SignupEvent>(_onSignup);
  }

  Future<void> _onLogin(LoginEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final result = await loginUseCase(
      LoginParams(email: event.email, password: event.password),
    );
    result.fold(
      (failure) => emit(AuthError(message: failure.message)),
      (user) => emit(AuthSuccess(user: user)),
    );
  }

  Future<void> _onSignup(SignupEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final result = await signupUseCase(
      SignupParams(
        username: event.username,
        email: event.email,
        password: event.password,
      ),
    );
    result.fold(
      (failure) => emit(AuthError(message: failure.message)),
      (user) => emit(AuthSuccess(user: user)),
    );
  }
}
