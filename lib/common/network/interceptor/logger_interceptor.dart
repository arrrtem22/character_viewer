import 'package:character_viewer/common/common.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';

export 'base_interceptor.dart';

@injectable
class LoggerInterceptor extends Interceptor {
  LoggerInterceptor({
    required this.logger,
  });

  final Logger logger;

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) {
    logger.d('HTTP=>: [${options.method}] ${options.uri}'
        ' requestId: ${options.headers[AppHttpHeaders.requestId]}');
    handler.next(options);
  }

  @override
  // ignore: strict_raw_type
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    final options = response.requestOptions;
    logger.d('<=HTTP: [${options.method}] ${options.uri}'
        ' : ${response.statusCode} : ${response.data}'
        ' requestId: ${options.headers[AppHttpHeaders.requestId]}');
    super.onResponse(response, handler);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    final options = err.requestOptions;
    logger.e('<=HTTP ERROR: [${options.method}] ${options.uri}'
        ' : ${err.response?.statusCode ?? err}'
        ' : ${err.response?.data ?? '[NO-DATA]'}'
        ' requestId: ${options.headers[AppHttpHeaders.requestId]}');
    super.onError(err, handler);
  }
}
