import 'package:fpdart/fpdart.dart';
import 'package:smart_lock/core/error/failure.dart';
import 'package:smart_lock/features/pin/domain/entities/pin.dart';

abstract interface class PinRepository {
  Future<Either<Failure, void>> updateLockPin({required String pin});

  Future<Either<Failure, Pin>> getLockPin();
}
