import 'package:dio/dio.dart';
import 'package:smart_lock/core/api/api_endpoints.dart';
import 'package:smart_lock/core/error/error_handler.dart';
import 'package:smart_lock/core/error/exception.dart';
import 'package:smart_lock/features/door/data/models/door_state_dto.dart';

abstract interface class DoorRemoteDataSource {
  Future<void> updateDoorState({required bool lock});

  Future<DoorStateDto> getDoorState();
}

class DoorRemoteDataSourceImpl implements DoorRemoteDataSource {
  final Dio dioClient;

  DoorRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<void> updateDoorState({required bool lock}) async {
    try {
      final response = await dioClient.post(
        ApiEndpoints.door,
        data: {'lock': lock},
      );

      if (response.statusCode == 200) {
        return;
      }
    } on DioException catch (err) {
      throw SErrorHandler.handleDioError(err);
    } catch (err) {
      throw ServerException(
        'DataLayer: Unexpected error occurred ${err.toString()}',
      );
    }
  }

  @override
  Future<DoorStateDto> getDoorState() async {
    try {
      final response = await dioClient.get(ApiEndpoints.door);

      if (response.statusCode != 200) {
        throw ServerException("Invalid response");
      }

      final responseData = await response.data;
      if (responseData == null) {
        throw ServerException("DataLayer: response data is null");
      }

      return DoorStateDto.fromJson(responseData);
    } on DioException catch (err) {
      throw SErrorHandler.handleDioError(err);
    } catch (err) {
      throw ServerException(
        'DataLayer: Unexpected error occurred ${err.toString()}',
      );
    }
  }
}
