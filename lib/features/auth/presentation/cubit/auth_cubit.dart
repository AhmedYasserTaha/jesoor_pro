import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jesoor_pro/features/auth/domain/usecases/login_use_case.dart';
import 'package:jesoor_pro/features/auth/domain/usecases/signup_use_case.dart';
import 'package:jesoor_pro/features/auth/domain/usecases/send_otp_use_case.dart';
import 'package:jesoor_pro/features/auth/domain/usecases/verify_otp_use_case.dart';
import 'package:jesoor_pro/features/auth/presentation/cubit/auth_state.dart';
import 'package:jesoor_pro/features/auth/presentation/utils/grade_utils.dart';

class AuthCubit extends Cubit<AuthState> {
  final LoginUseCase loginUseCase;
  final SignupUseCase signupUseCase;
  final SendOtpUseCase sendOtpUseCase;
  final VerifyOtpUseCase verifyOtpUseCase;

  AuthCubit({
    required this.loginUseCase,
    required this.signupUseCase,
    required this.sendOtpUseCase,
    required this.verifyOtpUseCase,
  }) : super(const AuthState());

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
    final grades = GradeUtils.getGradesForStage(stage);
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
  }

  // API Calls
  Future<void> sendOtp(String name, String phone) async {
    emit(state.copyWith(sendOtpStatus: AuthStatus.loading));
    final result = await sendOtpUseCase(
      SendOtpParams(name: name, phone: phone),
    );
    result.fold(
      (failure) => emit(
        state.copyWith(
          sendOtpStatus: AuthStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (_) => emit(
        state.copyWith(
          sendOtpStatus: AuthStatus.success,
          phone: phone, // Store phone for verification
        ),
      ),
    );
  }

  Future<void> verifyOtp(
    String otp,
    String deviceToken,
    String deviceLabel,
  ) async {
    if (state.phone == null) {
      emit(
        state.copyWith(
          verifyOtpStatus: AuthStatus.error,
          errorMessage: "Phone number is missing",
        ),
      );
      return;
    }
    emit(state.copyWith(verifyOtpStatus: AuthStatus.loading));
    final result = await verifyOtpUseCase(
      VerifyOtpParams(
        phone: state.phone!,
        otp: otp,
        deviceToken: deviceToken,
        deviceLabel: deviceLabel,
      ),
    );
    result.fold(
      (failure) => emit(
        state.copyWith(
          verifyOtpStatus: AuthStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (_) => emit(state.copyWith(verifyOtpStatus: AuthStatus.success)),
    );
  }

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
