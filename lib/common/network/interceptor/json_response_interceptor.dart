import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

@Injectable()
class JsonResponseInterceptor extends Interceptor {
  // very strange api
  @override
  void onResponse(
      Response<dynamic> response, ResponseInterceptorHandler handler) {
    response.data = json.decode(response.data);
    super.onResponse(response, handler);
  }
}
