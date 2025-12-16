import 'package:equatable/equatable.dart';
import 'package:jesoor_pro/features/auth/domain/entities/category_entity.dart';
import 'package:jesoor_pro/features/auth/domain/entities/governorate_entity.dart';
import 'package:jesoor_pro/features/auth/domain/entities/user_entity.dart';

enum AuthStatus { initial, loading, success, error }

class AuthState extends Equatable {
  final AuthStatus status;
  final UserEntity? user;
  final String? errorMessage;

  // UI State
  final int signupStep;
  final bool isPasswordVisible;
  final String? educationSystem;
  final String? educationStage;
  final String? educationGrade;
  final List<String> availableGrades;

  // Categories
  final List<CategoryEntity> categories;
  final List<CategoryEntity> selectedCategoryChildren;
  final CategoryEntity? selectedCategory;

  // Governorates
  final List<GovernorateEntity> governorates;
  final AuthStatus getGovernoratesStatus;

  // Step 2 & 3 Status
  final AuthStatus completeStep2Status;
  final AuthStatus completeStep3Status;
  final AuthStatus getCategoriesStatus;
  final AuthStatus getCategoryChildrenStatus;

  // OTP State
  final AuthStatus sendOtpStatus;
  final AuthStatus verifyOtpStatus;
  final String? phone;

  const AuthState({
    this.status = AuthStatus.initial,
    this.user,
    this.errorMessage,
    this.signupStep = 1,
    this.isPasswordVisible = true, // Default true as per UI (obscure = true)
    this.educationSystem,
    this.educationStage,
    this.educationGrade,
    this.availableGrades = const [],
    this.categories = const [],
    this.selectedCategoryChildren = const [],
    this.selectedCategory,
    this.governorates = const [],
    this.getGovernoratesStatus = AuthStatus.initial,
    this.completeStep2Status = AuthStatus.initial,
    this.completeStep3Status = AuthStatus.initial,
    this.getCategoriesStatus = AuthStatus.initial,
    this.getCategoryChildrenStatus = AuthStatus.initial,
    this.sendOtpStatus = AuthStatus.initial,
    this.verifyOtpStatus = AuthStatus.initial,
    this.phone,
  });

  AuthState copyWith({
    AuthStatus? status,
    UserEntity? user,
    String? errorMessage,
    int? signupStep,
    bool? isPasswordVisible,
    String? educationSystem,
    String? educationStage,
    String? educationGrade,
    List<String>? availableGrades,
    List<CategoryEntity>? categories,
    List<CategoryEntity>? selectedCategoryChildren,
    CategoryEntity? selectedCategory,
    List<GovernorateEntity>? governorates,
    AuthStatus? getGovernoratesStatus,
    AuthStatus? completeStep2Status,
    AuthStatus? completeStep3Status,
    AuthStatus? getCategoriesStatus,
    AuthStatus? getCategoryChildrenStatus,
    AuthStatus? sendOtpStatus,
    AuthStatus? verifyOtpStatus,
    String? phone,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: user ?? this.user,
      errorMessage: errorMessage ?? this.errorMessage,
      signupStep: signupStep ?? this.signupStep,
      isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
      educationSystem: educationSystem ?? this.educationSystem,
      educationStage: educationStage ?? this.educationStage,
      educationGrade: educationGrade ?? this.educationGrade,
      availableGrades: availableGrades ?? this.availableGrades,
      categories: categories ?? this.categories,
      selectedCategoryChildren:
          selectedCategoryChildren ?? this.selectedCategoryChildren,
      selectedCategory: selectedCategory,
      governorates: governorates ?? this.governorates,
      getGovernoratesStatus:
          getGovernoratesStatus ?? this.getGovernoratesStatus,
      completeStep2Status: completeStep2Status ?? this.completeStep2Status,
      completeStep3Status: completeStep3Status ?? this.completeStep3Status,
      getCategoriesStatus: getCategoriesStatus ?? this.getCategoriesStatus,
      getCategoryChildrenStatus:
          getCategoryChildrenStatus ?? this.getCategoryChildrenStatus,
      sendOtpStatus: sendOtpStatus ?? this.sendOtpStatus,
      verifyOtpStatus: verifyOtpStatus ?? this.verifyOtpStatus,
      phone: phone ?? this.phone,
    );
  }

  @override
  List<Object?> get props => [
    status,
    user,
    errorMessage,
    signupStep,
    isPasswordVisible,
    educationSystem,
    educationStage,
    educationGrade,
    availableGrades,
    categories,
    selectedCategoryChildren,
    selectedCategory,
    governorates,
    getGovernoratesStatus,
    completeStep2Status,
    completeStep3Status,
    getCategoriesStatus,
    getCategoryChildrenStatus,
    sendOtpStatus,
    verifyOtpStatus,
    phone,
  ];
}
