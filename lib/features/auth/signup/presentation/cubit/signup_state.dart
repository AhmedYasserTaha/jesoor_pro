import 'package:equatable/equatable.dart';
import 'package:jesoor_pro/features/auth/signup/domain/entities/category_entity.dart';
import 'package:jesoor_pro/features/auth/signup/domain/entities/governorate_entity.dart';
import 'package:jesoor_pro/features/auth/signup/domain/entities/user_entity.dart';

enum SignupStatus { initial, loading, success, error, cached }

class SignupState extends Equatable {
  final SignupStatus status;
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
  final bool isCategoriesFromCache;

  // Governorates
  final List<GovernorateEntity> governorates;
  final SignupStatus getGovernoratesStatus;
  final bool isGovernoratesFromCache;

  // Step 2 & 3 Status
  final SignupStatus completeStep2Status;
  final SignupStatus completeStep3Status;
  final SignupStatus getCategoriesStatus;
  final SignupStatus getCategoryChildrenStatus;

  // OTP State
  final SignupStatus sendOtpStatus;
  final SignupStatus verifyOtpStatus;
  final String? phone;

  const SignupState({
    this.status = SignupStatus.initial,
    this.user,
    this.errorMessage,
    this.signupStep = 1,
    this.isPasswordVisible = true,
    this.educationSystem,
    this.educationStage,
    this.educationGrade,
    this.availableGrades = const [],
    this.categories = const [],
    this.selectedCategoryChildren = const [],
    this.selectedCategory,
    this.isCategoriesFromCache = false,
    this.governorates = const [],
    this.getGovernoratesStatus = SignupStatus.initial,
    this.isGovernoratesFromCache = false,
    this.completeStep2Status = SignupStatus.initial,
    this.completeStep3Status = SignupStatus.initial,
    this.getCategoriesStatus = SignupStatus.initial,
    this.getCategoryChildrenStatus = SignupStatus.initial,
    this.sendOtpStatus = SignupStatus.initial,
    this.verifyOtpStatus = SignupStatus.initial,
    this.phone,
  });

  SignupState copyWith({
    SignupStatus? status,
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
    bool? isCategoriesFromCache,
    List<GovernorateEntity>? governorates,
    SignupStatus? getGovernoratesStatus,
    bool? isGovernoratesFromCache,
    SignupStatus? completeStep2Status,
    SignupStatus? completeStep3Status,
    SignupStatus? getCategoriesStatus,
    SignupStatus? getCategoryChildrenStatus,
    SignupStatus? sendOtpStatus,
    SignupStatus? verifyOtpStatus,
    String? phone,
  }) {
    return SignupState(
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
      isCategoriesFromCache:
          isCategoriesFromCache ?? this.isCategoriesFromCache,
      governorates: governorates ?? this.governorates,
      getGovernoratesStatus:
          getGovernoratesStatus ?? this.getGovernoratesStatus,
      isGovernoratesFromCache:
          isGovernoratesFromCache ?? this.isGovernoratesFromCache,
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
    isCategoriesFromCache,
    governorates,
    getGovernoratesStatus,
    isGovernoratesFromCache,
    completeStep2Status,
    completeStep3Status,
    getCategoriesStatus,
    getCategoryChildrenStatus,
    sendOtpStatus,
    verifyOtpStatus,
    phone,
  ];
}
