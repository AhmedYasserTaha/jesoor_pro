import 'package:dartz/dartz.dart';
import 'package:jesoor_pro/core/error/failures.dart';
import 'package:jesoor_pro/features/auth/domain/repositories/auth_repository.dart';
import 'package:jesoor_pro/core/usecases/use_case.dart';

class SendOtpUseCase implements UseCase<void, SendOtpParams> {
  final AuthRepository repository;

  SendOtpUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(SendOtpParams params) async {
    return await repository.sendOtp(params.name, params.phone);
  }
}

class SendOtpParams {
  final String name;
  final String phone;

  SendOtpParams({required this.name, required this.phone});
}
