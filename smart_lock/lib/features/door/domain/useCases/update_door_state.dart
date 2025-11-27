import 'package:fpdart/fpdart.dart';
import 'package:smart_lock/core/error/failure.dart';
import 'package:smart_lock/core/useCases/use_case.dart';
import 'package:smart_lock/features/door/domain/repository/door_repository.dart';

class UpdateDoorState implements UseCase<void, UpdateDoorStateParams> {
  final DoorRepository doorRepository;

  UpdateDoorState({required this.doorRepository});

  @override
  Future<Either<Failure, void>> call(UpdateDoorStateParams params) async {
    return await doorRepository.updateDoorState(state: params.state);
  }
}

class UpdateDoorStateParams {
  final bool state;

  UpdateDoorStateParams({required this.state});
}
