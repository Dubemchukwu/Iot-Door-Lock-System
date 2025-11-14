import 'package:fpdart/fpdart.dart';
import 'package:smart_lock/core/error/failure.dart';
import 'package:smart_lock/core/useCases/use_case.dart';
import 'package:smart_lock/features/pin/domain/repository/pin_repository.dart';

class UpdateLockPin implements UseCase<void, UpdateLockPinParams> {
  final PinRepository pinRepository;

  UpdateLockPin({required this.pinRepository});

  @override
  Future<Either<Failure, void>> call(UpdateLockPinParams params) async {
    return await pinRepository.updateLockPin(pin: params.pin);
  }
}

class UpdateLockPinParams {
  final String pin;

  UpdateLockPinParams({required this.pin});
}
