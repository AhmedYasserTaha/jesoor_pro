import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:jesoor_pro/core/error/failures.dart';
import 'package:jesoor_pro/core/usecases/use_case.dart';
import 'package:jesoor_pro/features/auth/signup/domain/entities/user_entity.dart';
import 'package:jesoor_pro/features/auth/signup/domain/repositories/signup_repository.dart';

class SignupUseCase implements UseCase<UserEntity, SignupParams> {
  final SignupRepository repository;

  SignupUseCase({required this.repository});

  @override
  Future<Either<Failure, UserEntity>> call(SignupParams params) {
    return repository.signup(params);
  }
}

class SignupParams extends Equatable {
  final String username;
  final String email;
  final String password;
  final String parentPhone;
  final String? schoolName;
  final String? governorate;
  final String? educationSystem;
  final String? educationStage;
  final String? educationGrade;

  const SignupParams({
    required this.username,
    required this.email,
    required this.password,
    required this.parentPhone,
    this.schoolName,
    this.governorate,
    this.educationSystem,
    this.educationStage,
    this.educationGrade,
  });

  @override
  List<Object?> get props => [
    username,
    email,
    password,
    parentPhone,
    schoolName,
    governorate,
    educationSystem,
    educationStage,
    educationGrade,
  ];
}
