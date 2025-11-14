import 'package:fpdart/fpdart.dart';
import 'package:smart_lock/core/error/error_handler.dart';
import 'package:smart_lock/core/error/failure.dart';
import 'package:smart_lock/core/network/connection.dart';
import 'package:smart_lock/features/door/data/dataSources/door_remote_data_source.dart';
import 'package:smart_lock/features/door/data/models/door_state_dto.dart';
import 'package:smart_lock/features/door/domain/repository/door_repository.dart';

class DoorRepositoryImpl implements DoorRepository {
  final DoorRemoteDataSource doorRemoteDataSource;
  final ConnectionChecker connectionChecker;
  DoorRepositoryImpl({
    required this.doorRemoteDataSource,
    required this.connectionChecker,
  });

  @override
  Future<Either<Failure, DoorStateDto>> getDoorState() async {
    final isConnected = await connectionChecker.isConnected;
    if (!isConnected) {
      return Left(Failure("Internet Connection is required"));
    }
    return await executeRepositoryOperation(() async {
      return await doorRemoteDataSource.getDoorState();
    });
  }

  @override
  Future<Either<Failure, void>> updateDoorState({required bool lock}) async {
    final isConnected = await connectionChecker.isConnected;
    if (!isConnected) {
      return Left(Failure("Internet Connection is required"));
    }
    return await executeRepositoryOperation(() async {
      return await doorRemoteDataSource.updateDoorState(lock: lock);
    });
  }
}
