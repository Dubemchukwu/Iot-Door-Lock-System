import 'package:fpdart/fpdart.dart';
import 'package:smart_lock/core/error/error_handler.dart';
import 'package:smart_lock/core/error/failure.dart';
import 'package:smart_lock/core/network/connection.dart';
import 'package:smart_lock/features/control/data/dataSources/control_remote_data_source.dart';
import 'package:smart_lock/features/control/data/model/manual_control_dto.dart';
import 'package:smart_lock/features/control/domain/repository/control_repository.dart';

class ControlRepositoryImpl implements ControlRepository {
  final ControlRemoteDataSource controlRemoteDataSource;
  final ConnectionChecker connectionChecker;

  ControlRepositoryImpl({
    required this.controlRemoteDataSource,
    required this.connectionChecker,
  });

  @override
  Future<Either<Failure, ManualControlDto>> getManualControlSate() async {
    final isConnected = await connectionChecker.isConnected;
    if (!isConnected) {
      return Left(Failure("Internet Connection is required"));
    }
    return await executeRepositoryOperation(() async {
      return await controlRemoteDataSource.getManualControlStatus();
    });
  }

  @override
  Future<Either<Failure, void>> toggleManualControl({
    required bool lock,
  }) async {
    final isConnected = await connectionChecker.isConnected;
    if (!isConnected) {
      return Left(Failure("Internet Connection is required"));
    }
    return await executeRepositoryOperation(() async {
      return await controlRemoteDataSource.toggleManualControl(lock: lock);
    });
  }
}
