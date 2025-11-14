import 'package:fpdart/fpdart.dart';
import 'package:smart_lock/core/common/params/no_params.dart';
import 'package:smart_lock/core/error/failure.dart';
import 'package:smart_lock/core/useCases/use_case.dart';
import 'package:smart_lock/features/door/domain/entities/door_state.dart';
import 'package:smart_lock/features/door/domain/repository/door_repository.dart';

class GetDoorState implements UseCase<DoorState, NoParams> {
  final DoorRepository doorRepository;

  GetDoorState({required this.doorRepository});

  @override
  Future<Either<Failure, DoorState>> call(NoParams params) async {
    return await doorRepository.getDoorState();
  }
}
