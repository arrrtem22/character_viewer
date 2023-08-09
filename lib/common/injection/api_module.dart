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
      ) =>
      NetworkManager.getApiDioClient(
        baseUrl: config.baseUrl,
        interceptors: [
          baseInterceptor,
          logInterceptor,
          errorInterceptor,
        ],
      );
}
