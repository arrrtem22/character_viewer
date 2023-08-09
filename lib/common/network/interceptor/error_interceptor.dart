import 'package:character_viewer/common/common.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

@injectable
class ErrorInterceptor extends Interceptor {
  ErrorInterceptor({
    required InternetConnectionChecker connectionChecker,
  }) : _connectionChecker = connectionChecker;

  final InternetConnectionChecker _connectionChecker;

  @override
  Future<void> onError(DioError err, ErrorInterceptorHandler handler) async {
    final hasConnection = await _connectionChecker.hasConnection;
    return super.onError(
      BaseApiException.parse(err, hasConnection: hasConnection),
      handler,
    );
  }
}
