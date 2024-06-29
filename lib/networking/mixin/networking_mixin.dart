import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'package:dungeoneers/networking/models/dg_network_result.dart';
import 'package:dungeoneers/networking/network.dart';

export 'package:dungeoneers/networking/networking_common.dart';
// A basic networking mixin for making CRUD calls. Uses containment to
// delegate the Network class property.

mixin NetworkingMixin {
  final _network = Network();

  Dio get dio {
    return _network.dio;
  }

  Future<DGNetworkResult> get(String url,
      {Map<String, dynamic>? params, Map<String, dynamic>? headers}) async {
    try {
      return _network.get(url, params: params, headers: headers);
    } catch (e) {
      rethrow;
    }
  }

  Future<DGNetworkResult> post(String url,
      {Map<String, dynamic>? params, Map<String, dynamic>? headers}) async {
    try {
      return _network.post(url, params: params, headers: headers);
    } catch (e) {
      rethrow;
    }
  }

  Future<DGNetworkResult> patch(String url,
      {Map<String, dynamic>? params, Map<String, dynamic>? headers}) async {
    try {
      return _network.patch(url, params: params, headers: headers);
    } catch (e) {
      rethrow;
    }
  }

  Future<DGNetworkResult> put(String url,
      {Map<String, dynamic>? params, Map<String, dynamic>? headers}) async {
    try {
      return _network.put(url, params: params, headers: headers);
    } catch (e) {
      rethrow;
    }
  }

  Future<DGNetworkResult> delete(String url,
      {Map<String, dynamic>? params, Map<String, dynamic>? headers}) async {
    try {
      return _network.delete(url, params: params, headers: headers);
    } catch (e) {
      rethrow;
    }
  }

  Future<String> downloadFile(String url, filename) async {
    try {
      return _network.downloadFile(url, filename);
    } catch (e) {
      rethrow;
    }
  }

  Future<String> downloadFileToPath(String url, String path) async {
    try {
      return _network.downloadFileToPath(url, path);
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> performHttpRequest(
    String api,
    HttpMethod method, {
    bool autoHandle = true,
    VoidCallback? callback,
    Map<String, dynamic>? params,
    Map<String, dynamic>? headers,
    String? errorTitle,
    String? errorText,
    bool Function()? isMounted,
  }) async {
    final result = await _network.performHttpRequest(api, method,
        autoHandle: autoHandle,
        callback: callback,
        params: params,
        headers: headers,
        isMounted: isMounted);
    return result;
  }
}
