import 'dart:io';

class AppHttpHeaders {
  static const authorization = HttpHeaders.authorizationHeader;
  static const deviceId = 'X-Device-ID';
  static const deviceOs = 'X-Device-OS';
  static const requestId = 'X-Request-ID';
  static const language = 'Accept-Language';
  static const contentLength = 'content-length';
}
