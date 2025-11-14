import 'package:fpdart/fpdart.dart';
import 'package:smart_lock/core/error/failure.dart';
import 'package:smart_lock/features/door/domain/entities/door_state.dart';

abstract interface class DoorRepository {
  Future<Either<Failure, void>> updateDoorState({required bool lock});

  Future<Either<Failure, DoorState>> getDoorState();
}
