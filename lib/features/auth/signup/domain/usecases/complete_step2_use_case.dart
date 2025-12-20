import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:jesoor_pro/core/error/failures.dart';
import 'package:jesoor_pro/core/usecases/use_case.dart';
import 'package:jesoor_pro/features/auth/signup/domain/repositories/signup_repository.dart';

class CompleteStep2UseCase implements UseCase<void, CompleteStep2Params> {
  final SignupRepository repository;

  CompleteStep2UseCase({required this.repository});

  @override
  Future<Either<Failure, void>> call(CompleteStep2Params params) {
    return repository.completeStep2(params);
  }
}

class CompleteStep2Params extends Equatable {
  final String email;
  final String guardianPhone;
  final String? secondGuardianPhone;
  final String schoolName;
  final String governorate;

  const CompleteStep2Params({
    required this.email,
    required this.guardianPhone,
    this.secondGuardianPhone,
    required this.schoolName,
    required this.governorate,
  });

  @override
  List<Object?> get props => [
    email,
    guardianPhone,
    secondGuardianPhone,
    schoolName,
    governorate,
  ];
}
