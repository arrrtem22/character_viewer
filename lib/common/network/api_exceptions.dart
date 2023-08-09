import 'package:dio/dio.dart';

abstract class ApiException {
  const ApiException();
}

class BaseApiException extends DioError implements ApiException {
  BaseApiException({
    required DioError dioError,
    required this.errorCode,
    this.details,
  }) : super(
          requestOptions: dioError.requestOptions,
          response: dioError.response,
          type: dioError.type,
          error: dioError.error,
        );

  /// Server-specific error code
  final String errorCode;

  /// Detailed debug info.
  final String? details;

  /// Debug message
  @override
  String get message => details?.toString() ?? error?.toString() ?? '';

  @override
  String toString() => 'BaseApiException{error: $error, details: $details}';

  factory BaseApiException.parse(
    DioError err, {
    bool hasConnection = false,
  }) {
    if (!hasConnection) {
      return NetworkConnectionException(dioError: err);
    }

    if (err.response?.data is Map) {
      final errorType = err.response!.data['error'];
      final errorDetails = err.response!.data['details'];
      // final data = err.response!.data['data'];

      switch (errorType) {
        case 'invalid-request':
          return InvalidRequestException(
            dioError: err,
            details: errorDetails,
          );
        default:
          return BaseApiException(
            dioError: err,
            errorCode: errorType,
            details: errorDetails,
          );
      }
    }

    return BaseApiException(
      dioError: err,
      errorCode: 'unknown',
      details: 'Unknown error',
    );
  }
}

class NetworkConnectionException extends BaseApiException {
  NetworkConnectionException({
    required super.dioError,
    super.errorCode = 'network-connection',
    super.details,
  });
}

class InvalidRequestException extends BaseApiException {
  InvalidRequestException({
    required super.dioError,
    super.errorCode = 'invalid-request',
    super.details,
  });
}
