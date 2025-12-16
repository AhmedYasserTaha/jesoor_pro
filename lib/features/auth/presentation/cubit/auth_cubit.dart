import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jesoor_pro/core/usecases/use_case.dart';
import 'package:jesoor_pro/features/auth/domain/entities/category_entity.dart';
import 'package:jesoor_pro/features/auth/domain/usecases/complete_step2_use_case.dart';
import 'package:jesoor_pro/features/auth/domain/usecases/complete_step3_use_case.dart';
import 'package:jesoor_pro/features/auth/domain/usecases/get_categories_use_case.dart';
import 'package:jesoor_pro/features/auth/domain/usecases/get_category_children_use_case.dart';
import 'package:jesoor_pro/features/auth/domain/usecases/get_governorates_use_case.dart';
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
  final CompleteStep2UseCase completeStep2UseCase;
  final CompleteStep3UseCase completeStep3UseCase;
  final GetCategoriesUseCase getCategoriesUseCase;
  final GetCategoryChildrenUseCase getCategoryChildrenUseCase;
  final GetGovernoratesUseCase getGovernoratesUseCase;

  AuthCubit({
    required this.loginUseCase,
    required this.signupUseCase,
    required this.sendOtpUseCase,
    required this.verifyOtpUseCase,
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
      (_) => emit(
        state.copyWith(verifyOtpStatus: AuthStatus.success, errorMessage: null),
      ),
    );
  }

  void clearVerifyOtpError() {
    if (state.verifyOtpStatus == AuthStatus.error) {
      emit(
        state.copyWith(verifyOtpStatus: AuthStatus.initial, errorMessage: null),
      );
    }
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

  // Complete Step 2: Guardian info, school, governorate
  Future<void> completeStep2({
    required String guardianPhone,
    String? secondGuardianPhone,
    required String schoolName,
    required String governorate,
  }) async {
    emit(state.copyWith(completeStep2Status: AuthStatus.loading));
    final result = await completeStep2UseCase(
      CompleteStep2Params(
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
        ),
      ),
      (_) {
        emit(
          state.copyWith(
            completeStep2Status: AuthStatus.success,
            signupStep: 3, // Move to step 3 (categories)
          ),
        );
      },
    );
  }

  // Get Categories
  Future<void> getCategories() async {
    emit(state.copyWith(getCategoriesStatus: AuthStatus.loading));
    final result = await getCategoriesUseCase(NoParams());
    result.fold(
      (failure) => emit(
        state.copyWith(
          getCategoriesStatus: AuthStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (categories) => emit(
        state.copyWith(
          categories: categories,
          getCategoriesStatus: AuthStatus.success,
        ),
      ),
    );
  }

  // Get Category Children
  Future<void> getCategoryChildren(int categoryId) async {
    emit(state.copyWith(getCategoryChildrenStatus: AuthStatus.loading));
    final result = await getCategoryChildrenUseCase(
      GetCategoryChildrenParams(categoryId: categoryId),
    );
    result.fold(
      (failure) => emit(
        state.copyWith(
          getCategoryChildrenStatus: AuthStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (children) => emit(
        state.copyWith(
          selectedCategoryChildren: children,
          getCategoryChildrenStatus: AuthStatus.success,
          signupStep: 4, // Show children selection
        ),
      ),
    );
  }

  // Get Governorates
  Future<void> getGovernorates() async {
    emit(state.copyWith(getGovernoratesStatus: AuthStatus.loading));
    final result = await getGovernoratesUseCase(NoParams());
    result.fold(
      (failure) => emit(
        state.copyWith(
          getGovernoratesStatus: AuthStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (governorates) => emit(
        state.copyWith(
          governorates: governorates,
          getGovernoratesStatus: AuthStatus.success,
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
      emit(state.copyWith(selectedCategory: selected));
      // Fetch children from API instead of using local children
      getCategoryChildren(selected.id);
    }
  }

  // Complete Step 3: Select final category (child category)
  Future<void> completeStep3(int categoryId) async {
    emit(state.copyWith(completeStep3Status: AuthStatus.loading));
    final result = await completeStep3UseCase(
      CompleteStep3Params(categoryId: categoryId),
    );
    result.fold(
      (failure) => emit(
        state.copyWith(
          completeStep3Status: AuthStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (_) => emit(
        state.copyWith(
          completeStep3Status: AuthStatus.success,
          status: AuthStatus.success, // Registration complete
        ),
      ),
    );
  }
}
