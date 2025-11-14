import 'package:fpdart/fpdart.dart';
import 'package:smart_lock/core/common/params/no_params.dart';
import 'package:smart_lock/core/error/failure.dart';
import 'package:smart_lock/core/useCases/use_case.dart';
import 'package:smart_lock/features/pin/domain/entities/pin.dart';
import 'package:smart_lock/features/pin/domain/repository/pin_repository.dart';

class GetLockPin implements UseCase<Pin, NoParams> {
  final PinRepository pinRepository;
  GetLockPin({required this.pinRepository});

  @override
  Future<Either<Failure, Pin>> call(NoParams params) async {
    return await pinRepository.getLockPin();
  }
}
