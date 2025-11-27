import 'package:fpdart/fpdart.dart';
import 'package:smart_lock/core/error/failure.dart';
import 'package:smart_lock/features/control/domain/entities/manual_control.dart';

abstract interface class ControlRepository {
  Future<Either<Failure, void>> toggleManualControl({required bool lock});

  Future<Either<Failure, ManualControl>> getManualControlSate();
}
