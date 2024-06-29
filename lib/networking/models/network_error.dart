import 'package:dio/dio.dart';

// Our own APH network error type enum that just copies
// the underlying Dio version to abstract away the Dio
// specific stuff.
enum NetworkErrorType {
  /// Caused by a connection timeout.
  connectionTimeout,

  /// It occurs when url is sent timeout.
  sendTimeout,

  ///It occurs when receiving timeout.
  receiveTimeout,

  /// Caused by an incorrect certificate as configured by [ValidateCertificate].
  badCertificate,

  /// The [DioException] was caused by an incorrect status code as configured by
  /// [ValidateStatus].
  badResponse,

  /// When the request is cancelled, dio will throw a error with this type.
  cancel,

  /// Caused for example by a `xhr.onError` or SocketExceptions.
  connectionError,

  /// Default error type, Some other [Error]. In this case, you can use the
  /// [DioException.error] if it is not null.
  unknown,
}

// our own error class for network/http errors. Wraps the underlying
// DioError to abstract away the Dio specific stuff.
class NetworkError extends Error {
  final DioException _error;

  NetworkError(this._error);

  int? get statusCode {
    return _error.response?.statusCode;
  }

  Response? get response {
    return _error.response;
  }

  RequestOptions get requestOptions {
    return _error.requestOptions;
  }

  Object? get error {
    return _error.error;
  }

  String? get message {
    return _error.message;
  }

  bool isHttpError() {
    if (_error.response != null &&
        _error.response!.statusCode != null &&
        _error.response!.statusCode! >= 400) {
      return true;
    }
    return false;
  }

  NetworkErrorType get type {
    switch (_error.type) {
      case DioExceptionType.badCertificate:
        return NetworkErrorType.badCertificate;
      case DioExceptionType.badResponse:
        return NetworkErrorType.badResponse;
      case DioExceptionType.cancel:
        return NetworkErrorType.cancel;
      case DioExceptionType.connectionError:
        return NetworkErrorType.connectionError;
      case DioExceptionType.connectionTimeout:
        return NetworkErrorType.connectionTimeout;
      case DioExceptionType.receiveTimeout:
        return NetworkErrorType.receiveTimeout;
      case DioExceptionType.sendTimeout:
        return NetworkErrorType.sendTimeout;
      case DioExceptionType.unknown:
        return NetworkErrorType.unknown;
    }
  }

  @override
  StackTrace? get stackTrace {
    return _error.stackTrace;
  }

  @override
  String toString() {
    return _error.toString();
  }

  String? getErrorMsgTitle() {
    if (_error.response != null &&
        _error.response!.data != null &&
        _error.response!.data is Map<String, dynamic>) {
      var map = _error.response!.data as Map<String, dynamic>?;
      if (map != null && map.containsKey('title')) {
        return map['title'];
      }
    }
    return null;
  }

  String? getErrorMsgText() {
    if (_error.response != null &&
        _error.response!.data != null &&
        _error.response!.data is Map<String, dynamic>) {
      var map = _error.response!.data as Map<String, dynamic>?;
      if (map != null && map.containsKey('detail')) {
        return map['detail'];
      }
    }
    return null;
  }
}
