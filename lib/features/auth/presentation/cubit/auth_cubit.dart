import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jesoor_pro/features/auth/domain/usecases/login_use_case.dart';
import 'package:jesoor_pro/features/auth/domain/usecases/signup_use_case.dart';
import 'package:jesoor_pro/features/auth/presentation/cubit/auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final LoginUseCase loginUseCase;
  final SignupUseCase signupUseCase;

  AuthCubit({required this.loginUseCase, required this.signupUseCase})
    : super(const AuthState());

  // UI Interactions
  void togglePasswordVisibility() {
    emit(state.copyWith(isPasswordVisible: !state.isPasswordVisible));
  }

  void nextSignupStep() {
    emit(state.copyWith(signupStep: state.signupStep + 1));
  }

  void setSignupStep(int step) {
    emit(state.copyWith(signupStep: step));
  }

  void selectSystem(String system) {
    emit(state.copyWith(educationSystem: system, signupStep: 4));
  }

  void selectStage(String stage) {
    List<String> grades = [];
    if (stage == 'Primary') {
      grades = List.generate(6, (i) => '${i + 1} Primary');
    } else if (stage == 'Preparatory') {
      grades = List.generate(3, (i) => '${i + 1} Preparatory');
    } else if (stage == 'Secondary') {
      grades = List.generate(3, (i) => '${i + 1} Secondary');
    }
    emit(
      state.copyWith(
        educationStage: stage,
        availableGrades: grades,
        signupStep: 5,
      ),
    );
  }

  void selectGrade(String grade) {
    emit(state.copyWith(educationGrade: grade));
    // Trigger signup or just update state? Logic says finish here.
    // But we will let the UI call signup after this or trigger it here if full data is passed.
    // For now, just update state, UI calls signup.
  }

  // API Calls
  Future<void> login(String email, String password) async {
    emit(state.copyWith(status: AuthStatus.loading));
    final result = await loginUseCase(
      LoginParams(email: email, password: password),
    );
    result.fold(
      (failure) => emit(
        state.copyWith(status: AuthStatus.error, errorMessage: failure.message),
      ),
      (user) => emit(state.copyWith(status: AuthStatus.success, user: user)),
    );
  }

  Future<void> signup({
    required String username,
    required String email,
    required String password,
    required String parentPhone,
    String? schoolName,
    String? governorate,
  }) async {
    emit(state.copyWith(status: AuthStatus.loading));
    final result = await signupUseCase(
      SignupParams(
        username: username,
        email: email,
        password: password,
        parentPhone: parentPhone,
        schoolName: schoolName,
        governorate: governorate,
        educationSystem: state.educationSystem,
        educationStage: state.educationStage,
        educationGrade: state.educationGrade,
      ),
    );
    result.fold(
      (failure) => emit(
        state.copyWith(status: AuthStatus.error, errorMessage: failure.message),
      ),
      (user) => emit(state.copyWith(status: AuthStatus.success, user: user)),
    );
  }
}
