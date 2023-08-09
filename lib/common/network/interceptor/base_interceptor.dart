import 'package:character_viewer/common/common.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:uuid/uuid.dart';

@injectable
class BaseInterceptor extends Interceptor {
  BaseInterceptor({
    required this.deviceInfoProvider,
    required this.requestIdProvider,
  });

  final DeviceInfoProvider deviceInfoProvider;
  final RequestIdProvider requestIdProvider;

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) {
    final deviceInfo = deviceInfoProvider.info;
    options.headers[AppHttpHeaders.deviceId] = deviceInfo.deviceId;
    options.headers[AppHttpHeaders.deviceOs] = deviceInfo.deviceOs;
    options.headers[AppHttpHeaders.requestId] =
        requestIdProvider.nextUniqueRequestId;
    handler.next(options);
  }

  @override
  void onResponse(
    Response<Object?> response,
    ResponseInterceptorHandler handler,
  ) {
    final data = response.data;
    final contentLength = response.headers.value(AppHttpHeaders.contentLength);

    /// this check is needed when the backend does not send data to the client,
    /// but dio displays that there is data and its type is a string.
    if (data is String && data.isEmpty && contentLength == '0') {
      response.data = null;
    }
    super.onResponse(response, handler);
  }
}

@singleton
class RequestIdProvider {
  final _requestUuidPrefix = const Uuid().v1();
  int _requestCount = 0;

  String get nextUniqueRequestId => '$_requestUuidPrefix:${_requestCount++}';
}
