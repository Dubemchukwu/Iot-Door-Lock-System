import 'package:fpdart/fpdart.dart';
import 'package:smart_lock/core/error/error_handler.dart';
import 'package:smart_lock/core/error/failure.dart';
import 'package:smart_lock/core/network/connection.dart';
import 'package:smart_lock/features/pin/data/dataSources/pin_remote_data_source.dart';
import 'package:smart_lock/features/pin/data/models/pin_dto.dart';
import 'package:smart_lock/features/pin/domain/repository/pin_repository.dart';

class PinRepositoryImpl implements PinRepository {
  final PinRemoteDataSource pinRemoteDataSource;
  final ConnectionChecker connectionChecker;
  PinRepositoryImpl({
    required this.pinRemoteDataSource,
    required this.connectionChecker,
  });

  @override
  Future<Either<Failure, PinDto>> getLockPin() async {
    final isConnected = await connectionChecker.isConnected;
    if (!isConnected) {
      return Left(Failure("Internet Connection is required"));
    }
    return await executeRepositoryOperation(() async {
      return await pinRemoteDataSource.getLockPin();
    });
  }

  @override
  Future<Either<Failure, void>> updateLockPin({required String pin}) async {
    final isConnected = await connectionChecker.isConnected;
    if (!isConnected) {
      return Left(Failure("Internet Connection is required"));
    }
    return await executeRepositoryOperation(() async {
      return await pinRemoteDataSource.updateLockPin(pin: pin);
    });
  }
}
