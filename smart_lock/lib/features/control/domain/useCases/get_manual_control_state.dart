import 'package:fpdart/fpdart.dart';
import 'package:smart_lock/core/common/params/no_params.dart';
import 'package:smart_lock/core/error/failure.dart';
import 'package:smart_lock/core/useCases/use_case.dart';
import 'package:smart_lock/features/control/domain/entities/manual_control.dart';
import 'package:smart_lock/features/control/domain/repository/control_repository.dart';

class GetManualControlState implements UseCase<ManualControl, NoParams> {
  final ControlRepository controlRepository;

  GetManualControlState({required this.controlRepository});

  @override
  Future<Either<Failure, ManualControl>> call(NoParams params) async {
    return await controlRepository.getManualControlSate();
  }
}
