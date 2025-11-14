import 'package:dio/dio.dart';
import 'package:smart_lock/core/api/api_endpoints.dart';

class DioInterceptor extends Interceptor {
  final Dio dioClient;

  DioInterceptor({required this.dioClient});

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    const key = ApiEndpoints.apiKeyHeader;
    options.headers['key'] = key;

    return handler.next(options);
  }
}
