import 'package:dio/dio.dart';

import 'package:dungeoneers/app/i18n.dart';
import 'package:dungeoneers/networking/models/dg_http_exception.dart';

// An APH result class that wraps the Dio response and provides some
// convenience methods, based on the iOS Swift version.
class DGNetworkResult {
  Map<String, dynamic>? _map;
  List<dynamic>? _list;
  final Response<dynamic>? _response;

  DGNetworkResult(this._response) {
    if (_response != null && _response.data != null) {
      if (_response.data is Map<String, dynamic>) {
        _map = _response.data as Map<String, dynamic>;
      } else if (_response.data is List<dynamic>) {
        _list = _response.data as List<dynamic>;
      }
    }
  }

  Response<dynamic>? get response {
    return _response;
  }

  int? get statusCode {
    return _response?.statusCode;
  }

  String? get statusMessage {
    return _response?.statusMessage;
  }

  Map<String, dynamic> get jsonMap {
    if (isMap()) {
      return _map!;
    }
    throw DGHttpException(tr.invalidResultData);
  }

  List<dynamic> get jsonList {
    if (isList()) {
      return _list!;
    }
    throw DGHttpException(tr.invalidResultData);
  }

  bool isList() {
    return _list == null ? false : true;
  }

  bool isMap() {
    return _map == null ? false : true;
  }

  bool isEmpty() {
    if (_map == null && _list == null) {
      return true;
    } else {
      return false;
    }
  }
}
