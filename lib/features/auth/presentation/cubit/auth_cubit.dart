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

  // Flags to prevent duplicate API calls
  bool _isFetchingCategories = false;
  bool _isFetchingGovernorates = false;
  bool _isRefreshingCategories = false;
  bool _isRefreshingGovernorates = false;

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
      (user) => emit(
        state.copyWith(
          status: AuthStatus.success,
          user: user,
          // Preserve education data after signup
          educationSystem: state.educationSystem,
          educationStage: state.educationStage,
          educationGrade: state.educationGrade,
        ),
      ),
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
      (_) {
        emit(
          state.copyWith(
            completeStep2Status: AuthStatus.success,
            errorMessage: null, // Clear error on success
            signupStep:
                3, // Move to step 3 (categories) - MUST be set together with success
          ),
        );
        // Load categories immediately when step 3 is reached
        // This will use cache-first strategy (fast if cached, fetch if not)
        getCategories();
      },
    );
  }

  // Get Categories with cache-first strategy
  Future<void> getCategories() async {
    // Prevent duplicate calls
    if (_isFetchingCategories) return;
    _isFetchingCategories = true;

    final stopwatch = Stopwatch()..start();

    // Only show loading if we don't have cached data
    final hasCachedData = state.categories.isNotEmpty;
    if (!hasCachedData) {
      emit(
        state.copyWith(
          getCategoriesStatus: AuthStatus.loading,
          errorMessage: null,
        ),
      );
    }

    final result = await getCategoriesUseCase(NoParams());
    stopwatch.stop();
    _isFetchingCategories = false;

    result.fold(
      (failure) {
        // If we have cached data and remote fails, keep showing cached data
        if (hasCachedData) {
          // Don't emit error - keep cached data visible
          return;
        }
        emit(
          state.copyWith(
            getCategoriesStatus: AuthStatus.error,
            errorMessage: failure.message,
          ),
        );
      },
      (categories) {
        // If data returned very quickly (< 100ms), it's likely from cache
        final isFromCache =
            stopwatch.elapsedMilliseconds < 100 || hasCachedData;

        emit(
          state.copyWith(
            categories: categories,
            getCategoriesStatus: isFromCache
                ? AuthStatus.cached
                : AuthStatus.success,
            isCategoriesFromCache: isFromCache,
            errorMessage: null,
          ),
        );

        // If data was from cache, refresh in background
        if (isFromCache) {
          _refreshCategoriesInBackground();
        }
      },
    );
  }

  // Background refresh for categories
  Future<void> _refreshCategoriesInBackground() async {
    // Prevent duplicate background refreshes
    if (_isRefreshingCategories) return;
    _isRefreshingCategories = true;

    final result = await getCategoriesUseCase(NoParams());
    result.fold(
      (_) {
        // Silently fail - don't update state on background refresh failure
      },
      (categories) {
        // Only update if data is different
        if (categories.length != state.categories.length ||
            categories.any((cat) => !state.categories.contains(cat))) {
          emit(
            state.copyWith(
              categories: categories,
              getCategoriesStatus: AuthStatus.success,
              isCategoriesFromCache: false,
            ),
          );
        }
      },
    );
  }

  // Get Category Children with cache-first strategy
  Future<void> getCategoryChildren(int categoryId) async {
    final stopwatch = Stopwatch()..start();

    // Check if we already have children for this category
    final hasCachedChildren =
        state.selectedCategoryChildren.isNotEmpty &&
        state.selectedCategory?.id == categoryId;

    // Only show loading if we don't have cached data
    if (!hasCachedChildren) {
      emit(state.copyWith(getCategoryChildrenStatus: AuthStatus.loading));
    }

    final result = await getCategoryChildrenUseCase(
      GetCategoryChildrenParams(categoryId: categoryId),
    );
    stopwatch.stop();

    result.fold(
      (failure) {
        // If we have cached data and remote fails, keep showing cached data
        if (hasCachedChildren) {
          // Don't emit error - keep cached data visible
          return;
        }
        emit(
          state.copyWith(
            getCategoryChildrenStatus: AuthStatus.error,
            errorMessage: failure.message,
          ),
        );
      },
      (children) {
        // If data returned very quickly (< 100ms), it's likely from cache
        final isFromCache =
            stopwatch.elapsedMilliseconds < 100 || hasCachedChildren;

        emit(
          state.copyWith(
            selectedCategoryChildren: children,
            getCategoryChildrenStatus: isFromCache
                ? AuthStatus.cached
                : AuthStatus.success,
            signupStep: 4, // Show children selection - moving forward is OK
          ),
        );

        // If data was from cache, refresh in background
        if (isFromCache) {
          _refreshCategoryChildrenInBackground(categoryId);
        }
      },
    );
  }

  // Background refresh for category children
  Future<void> _refreshCategoryChildrenInBackground(int categoryId) async {
    final result = await getCategoryChildrenUseCase(
      GetCategoryChildrenParams(categoryId: categoryId),
    );
    result.fold(
      (_) {
        // Silently fail - don't update state on background refresh failure
      },
      (children) {
        // Only update if data is different
        if (children.length != state.selectedCategoryChildren.length ||
            children.any(
              (child) => !state.selectedCategoryChildren.contains(child),
            )) {
          emit(
            state.copyWith(
              selectedCategoryChildren: children,
              getCategoryChildrenStatus: AuthStatus.success,
            ),
          );
        }
      },
    );
  }

  // Get Governorates with cache-first strategy
  Future<void> getGovernorates() async {
    // Prevent duplicate calls
    if (_isFetchingGovernorates) return;
    _isFetchingGovernorates = true;

    final stopwatch = Stopwatch()..start();

    // Only show loading if we don't have cached data
    final hasCachedData = state.governorates.isNotEmpty;
    if (!hasCachedData) {
      emit(state.copyWith(getGovernoratesStatus: AuthStatus.loading));
    }

    final result = await getGovernoratesUseCase(NoParams());
    stopwatch.stop();
    _isFetchingGovernorates = false;

    result.fold(
      (failure) {
        // If we have cached data and remote fails, keep showing cached data
        if (hasCachedData) {
          // Don't emit error - keep cached data visible
          return;
        }
        emit(
          state.copyWith(
            getGovernoratesStatus: AuthStatus.error,
            errorMessage: failure.message,
          ),
        );
      },
      (governorates) {
        // If data returned very quickly (< 100ms), it's likely from cache
        final isFromCache =
            stopwatch.elapsedMilliseconds < 100 || hasCachedData;

        emit(
          state.copyWith(
            governorates: governorates,
            getGovernoratesStatus: isFromCache
                ? AuthStatus.cached
                : AuthStatus.success,
            isGovernoratesFromCache: isFromCache,
          ),
        );

        // If data was from cache, refresh in background
        if (isFromCache) {
          _refreshGovernoratesInBackground();
        }
      },
    );
  }

  // Background refresh for governorates
  Future<void> _refreshGovernoratesInBackground() async {
    // Prevent duplicate background refreshes
    if (_isRefreshingGovernorates) return;
    _isRefreshingGovernorates = true;

    final result = await getGovernoratesUseCase(NoParams());
    result.fold(
      (_) {
        // Silently fail - don't update state on background refresh failure
      },
      (governorates) {
        // Only update if data is different
        if (governorates.length != state.governorates.length ||
            governorates.any((gov) => !state.governorates.contains(gov))) {
          emit(
            state.copyWith(
              governorates: governorates,
              getGovernoratesStatus: AuthStatus.success,
              isGovernoratesFromCache: false,
            ),
          );
        }
      },
    );
    _isRefreshingGovernorates = false;
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
