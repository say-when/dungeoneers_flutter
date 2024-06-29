import 'network_error.dart';

class DGHttpException implements Exception {
  final String message;
  final NetworkError? error;

  DGHttpException(this.message, {this.error});

  int? get statusCode {
    return error?.statusCode;
  }

  NetworkErrorType? get errorType {
    return error?.type;
  }

  NetworkError? get networkError {
    return error;
  }

  bool isHttpError() {
    if (error != null && error!.isHttpError()) {
      return true;
    }
    return false;
  }

  String fullMessage() {
    int? statusCode = error?.statusCode;
    String? errMsg = error?.error.toString();
    if (statusCode != null && errMsg != null) {
      return '$message, code: $statusCode, error: $errMsg';
    } else {
      return toString();
    }
  }

  String? get errorMessage {
    return error?.message;
  }

  @override
  String toString() {
    return message;
  }

  String? getErrorMsgTitle() {
    if (error != null) {
      return error!.getErrorMsgTitle();
    }
    return null;
  }

  String? getErrorMsgText() {
    if (error != null) {
      return error!.getErrorMsgText();
    }
    return null;
  }
}
