import 'package:dio/dio.dart';

class NetworkManager {
  NetworkManager._();

  static Dio getApiDioClient({
    required Uri baseUrl,
    List<Interceptor> interceptors = const [],
  }) =>
      _getDioClient(
        baseUrl: baseUrl,
        interceptors: interceptors,
      );

  static Dio _getDioClient({
    required Uri baseUrl,
    int connectTimeout = 20000,
    int receiveTimeout = 20000,
    int sendTimeout = 20000,
    List<Interceptor> interceptors = const [],
    String? contentType,
  }) {
    final options = BaseOptions(
      connectTimeout: connectTimeout,
      receiveTimeout: receiveTimeout,
      sendTimeout: sendTimeout,
      contentType: contentType,
    )..baseUrl = baseUrl.toString();

    final dio = Dio(options);

    dio.interceptors.addAll(interceptors);

    return dio;
  }
}
