import 'package:fpdart/fpdart.dart';
import 'package:smart_lock/core/error/failure.dart';
import 'package:smart_lock/core/useCases/use_case.dart';
import 'package:smart_lock/features/control/domain/repository/control_repository.dart';

class ToggleManualControl implements UseCase<void, ToggleManualControlParams> {
  final ControlRepository controlRepository;
  ToggleManualControl({required this.controlRepository});

  @override
  Future<Either<Failure, void>> call(ToggleManualControlParams params) async {
    return await controlRepository.toggleManualControl(state: params.state);
  }
}

class ToggleManualControlParams {
  final bool state;

  ToggleManualControlParams({required this.state});
}
