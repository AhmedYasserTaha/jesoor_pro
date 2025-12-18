import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jesoor_pro/core/usecases/use_case.dart';
import 'package:jesoor_pro/core/utils/strings.dart';
import 'package:jesoor_pro/features/auth/domain/entities/category_entity.dart';
import 'package:jesoor_pro/features/auth/domain/usecases/complete_step2_use_case.dart';
import 'package:jesoor_pro/features/auth/domain/usecases/complete_step3_use_case.dart';
import 'package:jesoor_pro/features/auth/domain/usecases/forgot_password_reset_use_case.dart';
import 'package:jesoor_pro/features/auth/domain/usecases/forgot_password_send_otp_use_case.dart';
import 'package:jesoor_pro/features/auth/domain/usecases/get_categories_use_case.dart';
import 'package:jesoor_pro/features/auth/domain/usecases/get_category_children_use_case.dart';
import 'package:jesoor_pro/features/auth/domain/usecases/get_governorates_use_case.dart';
import 'package:jesoor_pro/features/auth/domain/usecases/login_send_otp_use_case.dart';
import 'package:jesoor_pro/features/auth/domain/usecases/login_verify_otp_use_case.dart';
import 'package:jesoor_pro/features/auth/domain/usecases/login_use_case.dart';
import 'package:jesoor_pro/features/auth/domain/usecases/signup_use_case.dart';
import 'package:jesoor_pro/features/auth/domain/usecases/send_otp_use_case.dart';
import 'package:jesoor_pro/features/auth/domain/usecases/verify_otp_use_case.dart';
import 'package:jesoor_pro/features/auth/presentation/cubit/auth_state.dart';
import 'package:jesoor_pro/features/auth/presentation/utils/grade_utils.dart';

class AuthCubit extends Cubit<AuthState> {
  final LoginUseCase loginUseCase;
  final LoginSendOtpUseCase loginSendOtpUseCase;
  final LoginVerifyOtpUseCase loginVerifyOtpUseCase;
  final SignupUseCase signupUseCase;
  final SendOtpUseCase sendOtpUseCase;
  final VerifyOtpUseCase verifyOtpUseCase;
  final ForgotPasswordSendOtpUseCase forgotPasswordSendOtpUseCase;
  final ForgotPasswordResetUseCase forgotPasswordResetUseCase;
  final CompleteStep2UseCase completeStep2UseCase;
  final CompleteStep3UseCase completeStep3UseCase;
  final GetCategoriesUseCase getCategoriesUseCase;
  final GetCategoryChildrenUseCase getCategoryChildrenUseCase;
  final GetGovernoratesUseCase getGovernoratesUseCase;

  AuthCubit({
    required this.loginUseCase,
    required this.loginSendOtpUseCase,
    required this.loginVerifyOtpUseCase,
    required this.signupUseCase,
    required this.sendOtpUseCase,
    required this.verifyOtpUseCase,
    required this.forgotPasswordSendOtpUseCase,
    required this.forgotPasswordResetUseCase,
    required this.completeStep2UseCase,
    required this.completeStep3UseCase,
    required this.getCategoriesUseCase,
    required this.getCategoryChildrenUseCase,
    required this.getGovernoratesUseCase,
  }) : super(const AuthState());

  // UI Interactions
  void togglePasswordVisibility() {
    emit(state.copyWith(isPasswordVisible: !state.isPasswordVisible));
  }

  void nextSignupStep() {
    // Only allow moving forward
    final nextStep = state.signupStep + 1;
    emit(state.copyWith(signupStep: nextStep));
  }

  void setSignupStep(int step) {
    // CRITICAL: Prevent reverting to earlier steps - only allow moving forward or staying same
    // Once we reach step 3 or higher, never allow going back to step 2 or lower
    if (state.signupStep >= 3 && step < 3) {
      // Don't allow going backwards from step 3+ - preserve current step
      return;
    }
    if (step < state.signupStep) {
      // Don't allow going backwards in general - preserve current step
      return;
    }
    emit(state.copyWith(signupStep: step));
  }

  void previousSignupStep() {
    // Allow going back from steps 3, 4, 5
    if (state.signupStep > 1 && state.signupStep <= 5) {
      final previousStep = state.signupStep - 1;
      emit(state.copyWith(signupStep: previousStep));
    }
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
      (failure) {
        // Check if the error indicates phone is already registered
        // Be very specific - only check for clear indicators of duplicate/registered phone
        final errorMessage = failure.message.toLowerCase().trim();

        // Only consider it a registered phone error if the message clearly indicates it
        final isPhoneRegistered =
            // English patterns
            errorMessage.contains('phone number already exists') ||
            errorMessage.contains('phone already registered') ||
            errorMessage.contains('phone is already taken') ||
            errorMessage.contains('phone already exists') ||
            errorMessage.contains('phone number is already registered') ||
            errorMessage.contains('phone number already taken') ||
            (errorMessage.contains('phone') &&
                errorMessage.contains('already') &&
                (errorMessage.contains('exists') ||
                    errorMessage.contains('registered') ||
                    errorMessage.contains('taken'))) ||
            // Arabic patterns
            errorMessage.contains('الرقم مسجل') ||
            errorMessage.contains('الرقم موجود') ||
            errorMessage.contains('الرقم مكرر') ||
            errorMessage.contains('رقم الهاتف مسجل') ||
            errorMessage.contains('رقم الهاتف موجود') ||
            (errorMessage.contains('رقم') &&
                (errorMessage.contains('مسجل') ||
                    errorMessage.contains('موجود') ||
                    errorMessage.contains('مكرر')));

        final displayMessage = isPhoneRegistered
            ? Strings.phoneAlreadyRegistered
            : failure.message;

        emit(
          state.copyWith(
            sendOtpStatus: AuthStatus.error,
            errorMessage: displayMessage,
          ),
        );
      },
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
          errorMessage: "رقم الهاتف مفقود",
        ),
      );
      return;
    }
    // Clear previous error
    emit(
      state.copyWith(verifyOtpStatus: AuthStatus.loading, errorMessage: null),
    );
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
      (token) => emit(
        state.copyWith(verifyOtpStatus: AuthStatus.success, errorMessage: null),
        // Token is already stored in repository, no need to store here
      ),
    );
  }

  void clearSendOtpError() {
    if (state.sendOtpStatus == AuthStatus.error) {
      emit(
        state.copyWith(sendOtpStatus: AuthStatus.initial, errorMessage: null),
      );
    }
  }

  void clearVerifyOtpError() {
    if (state.verifyOtpStatus == AuthStatus.error) {
      emit(
        state.copyWith(verifyOtpStatus: AuthStatus.initial, errorMessage: null),
      );
    }
  }

  void clearLoginSendOtpError() {
    if (state.loginSendOtpStatus == AuthStatus.error) {
      emit(
        state.copyWith(
          loginSendOtpStatus: AuthStatus.initial,
          errorMessage: null,
        ),
      );
    }
  }

  void clearLoginVerifyOtpError() {
    if (state.loginVerifyOtpStatus == AuthStatus.error) {
      emit(
        state.copyWith(
          loginVerifyOtpStatus: AuthStatus.initial,
          errorMessage: null,
        ),
      );
    }
  }

  Future<void> login(String phone, String password) async {
    emit(state.copyWith(status: AuthStatus.loading));
    final result = await loginUseCase(
      LoginParams(
        email: phone,
        password: password,
      ), // Using phone as email for now
    );
    result.fold(
      (failure) => emit(
        state.copyWith(status: AuthStatus.error, errorMessage: failure.message),
      ),
      (user) => emit(state.copyWith(status: AuthStatus.success, user: user)),
    );
  }

  // Login with OTP flow
  Future<void> loginSendOtp(String phone) async {
    emit(state.copyWith(loginSendOtpStatus: AuthStatus.loading));
    final result = await loginSendOtpUseCase(LoginSendOtpParams(phone: phone));
    result.fold(
      (failure) => emit(
        state.copyWith(
          loginSendOtpStatus: AuthStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (_) => emit(
        state.copyWith(
          loginSendOtpStatus: AuthStatus.success,
          loginPhone: phone,
        ),
      ),
    );
  }

  Future<void> loginVerifyOtp(
    String otp,
    String deviceToken,
    String deviceLabel,
  ) async {
    if (state.loginPhone == null) {
      emit(
        state.copyWith(
          loginVerifyOtpStatus: AuthStatus.error,
          errorMessage: "رقم الهاتف مفقود",
        ),
      );
      return;
    }
    emit(
      state.copyWith(
        loginVerifyOtpStatus: AuthStatus.loading,
        errorMessage: null,
      ),
    );
    final result = await loginVerifyOtpUseCase(
      LoginVerifyOtpParams(
        phone: state.loginPhone!,
        otp: otp,
        deviceToken: deviceToken,
        deviceLabel: deviceLabel,
      ),
    );
    result.fold(
      (failure) => emit(
        state.copyWith(
          loginVerifyOtpStatus: AuthStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (user) => emit(
        state.copyWith(
          loginVerifyOtpStatus: AuthStatus.success,
          status: AuthStatus.success,
          user: user,
        ),
      ),
    );
  }

  // Forgot Password flow
  Future<void> forgotPasswordSendOtp(String phone) async {
    emit(state.copyWith(forgotPasswordSendOtpStatus: AuthStatus.loading));
    final result = await forgotPasswordSendOtpUseCase(
      ForgotPasswordSendOtpParams(phone: phone),
    );
    result.fold(
      (failure) => emit(
        state.copyWith(
          forgotPasswordSendOtpStatus: AuthStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (_) => emit(
        state.copyWith(
          forgotPasswordSendOtpStatus: AuthStatus.success,
          loginPhone: phone, // Reuse loginPhone for forgot password
        ),
      ),
    );
  }

  Future<void> forgotPasswordReset(
    String otp,
    String newPassword,
    String confirmPassword,
  ) async {
    if (state.loginPhone == null) {
      emit(
        state.copyWith(
          forgotPasswordResetStatus: AuthStatus.error,
          errorMessage: "رقم الهاتف مفقود",
        ),
      );
      return;
    }
    emit(state.copyWith(forgotPasswordResetStatus: AuthStatus.loading));
    final result = await forgotPasswordResetUseCase(
      ForgotPasswordResetParams(
        phone: state.loginPhone!,
        otp: otp,
        newPassword: newPassword,
        confirmPassword: confirmPassword,
      ),
    );
    result.fold(
      (failure) => emit(
        state.copyWith(
          forgotPasswordResetStatus: AuthStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (_) =>
          emit(state.copyWith(forgotPasswordResetStatus: AuthStatus.success)),
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

  // Complete Step 2: Guardian info, school, governorate
  Future<void> completeStep2({
    required String email,
    required String guardianPhone,
    String? secondGuardianPhone,
    required String schoolName,
    required String governorate,
  }) async {
    emit(
      state.copyWith(
        completeStep2Status: AuthStatus.loading,
        errorMessage: null, // Clear previous error
      ),
    );
    final result = await completeStep2UseCase(
      CompleteStep2Params(
        email: email,
        guardianPhone: guardianPhone,
        secondGuardianPhone: secondGuardianPhone,
        schoolName: schoolName,
        governorate: governorate,
      ),
    );
    result.fold(
      (failure) => emit(
        state.copyWith(
          completeStep2Status: AuthStatus.error,
          errorMessage: failure.message,
          // Preserve signupStep on error - don't revert
        ),
      ),
      (_) => emit(
        state.copyWith(
          completeStep2Status: AuthStatus.success,
          errorMessage: null, // Clear error on success
          signupStep:
              3, // Move to step 3 (categories) - MUST be set together with success
        ),
      ),
    );
  }

  // Get Categories
  Future<void> getCategories() async {
    emit(
      state.copyWith(
        getCategoriesStatus: AuthStatus.loading,
        errorMessage: null, // Clear previous error
        // Preserve signupStep - never override it
      ),
    );
    final result = await getCategoriesUseCase(NoParams());
    result.fold(
      (failure) => emit(
        state.copyWith(
          getCategoriesStatus: AuthStatus.error,
          errorMessage: failure.message,
          // Preserve signupStep - never override it
        ),
      ),
      (categories) => emit(
        state.copyWith(
          categories: categories,
          getCategoriesStatus: AuthStatus.success,
          errorMessage: null, // Clear error on success
          // Preserve signupStep - never override it
        ),
      ),
    );
  }

  // Get Category Children
  Future<void> getCategoryChildren(int categoryId) async {
    emit(
      state.copyWith(
        getCategoryChildrenStatus: AuthStatus.loading,
        // Preserve signupStep - never override it unless moving forward
      ),
    );
    final result = await getCategoryChildrenUseCase(
      GetCategoryChildrenParams(categoryId: categoryId),
    );
    result.fold(
      (failure) => emit(
        state.copyWith(
          getCategoryChildrenStatus: AuthStatus.error,
          errorMessage: failure.message,
          // Preserve signupStep - never override it on error
        ),
      ),
      (children) => emit(
        state.copyWith(
          selectedCategoryChildren: children,
          getCategoryChildrenStatus: AuthStatus.success,
          signupStep: 4, // Show children selection - moving forward is OK
        ),
      ),
    );
  }

  // Get Governorates
  Future<void> getGovernorates() async {
    emit(
      state.copyWith(
        getGovernoratesStatus: AuthStatus.loading,
        // Preserve signupStep - never override it
      ),
    );
    final result = await getGovernoratesUseCase(NoParams());
    result.fold(
      (failure) => emit(
        state.copyWith(
          getGovernoratesStatus: AuthStatus.error,
          errorMessage: failure.message,
          // Preserve signupStep - never override it
        ),
      ),
      (governorates) => emit(
        state.copyWith(
          governorates: governorates,
          getGovernoratesStatus: AuthStatus.success,
          // Preserve signupStep - never override it
        ),
      ),
    );
  }

  // Select Category (parent category, then fetch children from API)
  void selectCategory(dynamic category) {
    // category can be CategoryEntity or int (id)
    CategoryEntity? selected;
    if (category is int) {
      selected = state.categories.firstWhere(
        (cat) => cat.id == category,
        orElse: () => state.categories.first,
      );
    } else if (category is CategoryEntity) {
      selected = category;
    }

    if (selected != null) {
      emit(
        state.copyWith(
          selectedCategory: selected,
          // Preserve signupStep - never override it
        ),
      );
      // Fetch children from API instead of using local children
      getCategoryChildren(selected.id);
    }
  }

  // Complete Step 3: Select final category (child category)
  Future<void> completeStep3(int categoryId) async {
    emit(
      state.copyWith(
        completeStep3Status: AuthStatus.loading,
        // Preserve signupStep - never override it
      ),
    );
    final result = await completeStep3UseCase(
      CompleteStep3Params(categoryId: categoryId),
    );
    result.fold(
      (failure) => emit(
        state.copyWith(
          completeStep3Status: AuthStatus.error,
          errorMessage: failure.message,
          // Preserve signupStep - never override it on error
        ),
      ),
      (_) => emit(
        state.copyWith(
          completeStep3Status: AuthStatus.success,
          status: AuthStatus.success, // Registration complete
          // Preserve signupStep - never override it
        ),
      ),
    );
  }
}
