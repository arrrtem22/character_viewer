// coverage:ignore-file
import 'package:character_viewer/common/common.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

@module
abstract class ApiModule {
  @Named(DependencyName.cdn)
  Dio cdn(
    Config config,
    LoggerInterceptor logInterceptor,
  ) =>
      NetworkManager.getApiDioClient(
        baseUrl: config.cdnUrl,
        interceptors: [
          logInterceptor,
        ],
      );

  Dio dio(
    Config config,
    BaseInterceptor baseInterceptor,
    LoggerInterceptor logInterceptor,
    ErrorInterceptor errorInterceptor,
    JsonResponseInterceptor jsonResponseInterceptor,
  ) =>
      NetworkManager.getApiDioClient(
        baseUrl: config.endpoint,
        interceptors: [
          baseInterceptor,
          logInterceptor,
          errorInterceptor,
          jsonResponseInterceptor,
        ],
      );
}
