import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:smart_lock/core/error/exception.dart';
import 'package:smart_lock/core/error/failure.dart';

class SErrorHandler {
  static Exception handleDioError(DioException e) {
    if (e.response != null) {
      switch (e.response?.statusCode) {
        case 400:
          return ServerException(
            'Bad request: ${e.response?.data['message'] ?? 'Invalid input provided.'}',
          );
        case 401:
          return AuthException(
            'Unauthorized: ${e.response?.data['message'] ?? 'Invalid credentials. Please check your username and password.'}',
          );
        case 403:
          return AuthException(
            'Forbidden: ${e.response?.data['message'] ?? 'You do not have permission to access this resource.'}',
          );
        case 404:
          return ServerException(
            'Not found: ${e.response?.data['message'] ?? 'The requested resource could not be found.'}',
          );
        case 500:
          return ServerException(
            'Internal server error: ${e.response?.data['message'] ?? 'An unexpected error occurred on the server.'}',
          );
        default:
          return ServerException(
            'Unexpected error: ${e.response?.data['message'] ?? 'An unknown error occurred.'}',
          );
      }
    } else if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout) {
      return NetworkException('Network timeout, please try again later.');
    } else if (e.type == DioExceptionType.badResponse) {
      return ServerException('Unexpected response from server.');
    } else {
      return ServerException(
        'Unexpected error: ${e.message ?? 'An unknown error occurred.'}',
      );
    }
  }

  static Failure mapExceptionToFailure(Exception exception) {
    if (exception is ServerException) {
      return Failure(exception.message);
    } else if (exception is AuthException) {
      return Failure(exception.message);
    } else if (exception is NetworkException) {
      return Failure(exception.message);
    } else {
      return Failure('An unknown error occurred.');
    }
  }
}

Future<Either<Failure, T>> executeRepositoryOperation<T>(
  Future<T> Function() operation,
) async {
  try {
    final result = await operation();
    return right(result);
  } on ServerException catch (e) {
    return left(Failure(e.message));
  } on AuthException catch (e) {
    return left(Failure(e.message));
  } on NetworkException catch (e) {
    return left(Failure(e.message));
  } catch (e) {
    return left(
      Failure('Domain layer: An unexpected error occurred: ${e.toString()}'),
    );
  }
}
