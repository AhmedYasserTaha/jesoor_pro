import 'package:equatable/equatable.dart';
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
  ];
}
