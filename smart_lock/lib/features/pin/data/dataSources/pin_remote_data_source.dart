import 'package:dio/dio.dart';
import 'package:smart_lock/core/api/api_endpoints.dart';
import 'package:smart_lock/core/error/error_handler.dart';
import 'package:smart_lock/core/error/exception.dart';
import 'package:smart_lock/features/pin/data/models/pin_dto.dart';

abstract interface class PinRemoteDataSource {
  Future<void> updateLockPin({required String pin});
  Future<PinDto> getLockPin();
}

class PinRemoteDataSourceImpl implements PinRemoteDataSource {
  final Dio dioClient;
  PinRemoteDataSourceImpl({required this.dioClient});


  @override
  Future<PinDto> getLockPin() async {
    try {
      final response = await dioClient.get(ApiEndpoints.pin);
      final responseData = await response.data;

      if (response.statusCode != 200) {
        throw ServerException("Invalid response");
      }

      if (responseData == null) {
        throw ServerException("DataLayer: pin response is null");
      }

      return PinDto.fromJson(responseData);
    } on DioException catch (err) {
      throw SErrorHandler.handleDioError(err);
    } catch (err) {
      throw ServerException(
        'DataLayer: Unexpected error occurred ${err.toString()}',
      );
    }
  }

  @override
  Future<void> updateLockPin({required String pin}) async {
    try {
      final response = await dioClient.post(
        ApiEndpoints.pin,
        data: {'pin': pin},
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
}
