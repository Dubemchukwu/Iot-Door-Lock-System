import 'package:dio/dio.dart';
import 'package:smart_lock/core/api/api_endpoints.dart';
import 'package:smart_lock/core/error/error_handler.dart';
import 'package:smart_lock/core/error/exception.dart';
import 'package:smart_lock/features/control/data/model/manual_control_dto.dart';

abstract interface class ControlRemoteDataSource {
  Future<void> toggleManualControl({required bool state});
  Future<ManualControlDto> getManualControlStatus();
}

class ControlRemoteDataSourceImpl implements ControlRemoteDataSource {
  final Dio dioClient;
  ControlRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<ManualControlDto> getManualControlStatus() async {
    try {
      final response = await dioClient.get(ApiEndpoints.manualControl);
      final responseData = await response.data;

      if (response.statusCode != 200) {
        throw ServerException("Invalid response");
      }

      if (responseData == null) {
        throw ServerException("Response is null");
      }
      return ManualControlDto.fromJson(responseData);
    } on DioException catch (e) {
      throw SErrorHandler.handleDioError(e);
    } catch (e) {
      throw ServerException(
        'DataLayer: Unexpected error occurred ${e.toString()}',
      );
    }
  }

  @override
  Future<void> toggleManualControl({required bool state}) async {
    try {
      final response = await dioClient.post(
        ApiEndpoints.manualControl,
        data: {'state': state},
      );

      if (response.statusCode == 200) {
        return;
      }
    } on DioException catch (e) {
      throw SErrorHandler.handleDioError(e);
    } catch (e) {
      throw ServerException(
        'DataLayer: Unexpected error occurred ${e.toString()}',
      );
    }
  }
}
