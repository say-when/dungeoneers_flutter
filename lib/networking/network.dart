import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
//import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
//import 'package:webview_flutter/webview_flutter.dart';

//import 'package:dungeoneers/app/api.dart';
import 'package:dungeoneers/app/i18n.dart';
import 'package:dungeoneers/main.dart';
import 'package:dungeoneers/networking/models/dg_network_result.dart';
import 'package:dungeoneers/networking/networking_common.dart';
import 'package:dungeoneers/networking/models/network_error.dart';
import 'package:dungeoneers/networking/models/dg_http_exception.dart';
import 'package:dungeoneers/providers/system_info.dart';
import 'package:dungeoneers/services/logger.dart';

export 'package:dungeoneers/networking/networking_common.dart';

class Network {
  final _dio = Dio();
  static final cookieJar = CookieJar();
  static final userAgent =
      Provider.of<SystemInfo>(navigatorKey.currentContext!).userAgent;

  Network() {
    //var baseURL = '${API.baseURL}${API.apiURL}';
    // _dio.options.baseUrl = baseURL;
    //// _dio.interceptors.add(CookieManager(cookieJar));
    /*_dio.interceptors.add(
      InterceptorsWrapper(
        /*onRequest: (RequestOptions options, RequestInterceptorHandler handler) {
          print('REQUEST[${options.method}] => PATH: ${options.path}');
          print('DATA: ${options.data}');
          print('HEADERS: ${options.headers}');
          return handler.next(options); //continue
        },*/
        /*onResponse: (Response response, ResponseInterceptorHandler handler) {
          print(
              'RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}');
          print('DATA: ${response.data}');
          return handler.next(response); // continue
        },*/
       onError: (DioException e, handler) async {
          if (e.response?.statusCode == 401) {
            // If a 401 response is received, try to refresh the session
            // Get rid of existing _session_id...
            debugLog('401 error received, attempting to refresh session...');
            e.requestOptions.headers['cookie'] = '';
            try {
              debugLog('Refreshing session...');
              await _refreshSession();
              debugLog('Session was successfully refreshed...');
            } catch (error) {
              // If the refresh fails, logout the user
              var provider = Provider.of<Auth>(navigatorKey.currentContext!,
                  listen: false);
              debugLog('Session could not be refreshed...logging out');
              provider.logout();
              return;
            }
            // Repeat the request with the updated header
            return handler.resolve(await dio.fetch(e.requestOptions));
          }
          return handler.next(e);
        },
      ),
    );*/
    _setHeaders();
    checkForCharlesProxy(_dio);
  }

  Network.external(); // For use outside our domain that don't use baseURL

  Dio get dio {
    return _dio;
  }

  void checkForCharlesProxy(Dio dio) {
    // USE: flutter run --dart-define=CHARLES_PROXY_IP=192.168.1.28
    // to enable Charles Proxy debugging
    var charlesIp = const String.fromEnvironment('CHARLES_PROXY_IP');
    if (charlesIp.isNotEmpty) {
      dio.httpClientAdapter = IOHttpClientAdapter(
        createHttpClient: () {
          final client = HttpClient();
          client.findProxy = (uri) {
            // Proxy all request to localhost:8888.
            // Be aware, the proxy should went through you running device,
            // not the host platform.
            return 'PROXY localhost:8888';
          };
          client.badCertificateCallback =
              (X509Certificate cert, String host, int port) => true;
          return client;
        },
      );
    }
  }

  // Set any custom header defaults here...
  _setHeaders() {
    //print("Setting headers...userAgent: ${Network.userAgent}");
    var customHeaders = {
      'User-Agent': Network.userAgent,
      //'content-type': 'application/json; charset=utf-8',
    };
    _dio.options.headers.addAll(customHeaders);
  }

  /*Future<void> _refreshSession() async {
    var currentContext = navigatorKey.currentContext;
    if (currentContext != null) {
      var provider =
          Provider.of<Auth>(navigatorKey.currentContext!, listen: false);
      // Only refresh session if we've got the store username
      // and password in our secure keychain storage...
      var username = await provider.username;
      var password = await provider.password;
      if (username != null && password != null) {
        try {
          await provider.softLogin(username: username, password: password);
        } catch (e) {
          rethrow;
        }
      } else {
        provider.logout();
      }
    } else {
      // For debugging...
      debugLog('_refreshSession: currentContext was null!');
    }
  }*/

  //
  // Network Calls
  //
  Future<DGNetworkResult> get(String url,
      {Map<String, dynamic>? params, Map<String, dynamic>? headers}) async {
    try {
      final response = await _dio.get(url,
          queryParameters: params, options: Options(headers: headers));
      final result = DGNetworkResult(response);
      return result;
    } on DioException catch (e) {
      debugLog('++++++ERROR: ${e.toString()}');
      throw NetworkError(e);
    } on Error catch (e) {
      debugLog('++++++ERROR: ${e.toString()}');
      rethrow;
    }
  }

  Future<DGNetworkResult> post(String url,
      {Map<String, dynamic>? params, Map<String, dynamic>? headers}) async {
    try {
      final response = await _dio.post(url,
          data: params, options: Options(headers: headers));
      final result = DGNetworkResult(response);
      return result;
    } on DioException catch (e) {
      debugLog('++++++ERROR: ${e.toString()}');
      throw NetworkError(e);
    } on Error catch (e) {
      debugLog('++++++ERROR: ${e.toString()}');
      rethrow;
    }
  }

  Future<DGNetworkResult> patch(String url,
      {Map<String, dynamic>? params, Map<String, dynamic>? headers}) async {
    try {
      final response = await _dio.patch(url,
          data: params, options: Options(headers: headers));
      final result = DGNetworkResult(response);
      return result;
    } on DioException catch (e) {
      debugLog('++++++ERROR: ${e.toString()}');
      throw NetworkError(e);
    } on Error catch (e) {
      debugLog('++++++ERROR: ${e.toString()}');
      rethrow;
    }
  }

  Future<DGNetworkResult> put(String url,
      {Map<String, dynamic>? params, Map<String, dynamic>? headers}) async {
    try {
      final response =
          await _dio.put(url, data: params, options: Options(headers: headers));
      final result = DGNetworkResult(response);
      return result;
    } on DioException catch (e) {
      debugLog('++++++ERROR: ${e.toString()}');
      throw NetworkError(e);
    } on Error catch (e) {
      debugLog('++++++ERROR: ${e.toString()}');
      rethrow;
    }
  }

  Future<DGNetworkResult> delete(String url,
      {Map<String, dynamic>? params, Map<String, dynamic>? headers}) async {
    try {
      final response = await _dio.delete(url,
          queryParameters: params, options: Options(headers: headers));
      final result = DGNetworkResult(response);
      return result;
    } on DioException catch (e) {
      debugLog('++++++ERROR: ${e.toString()}');
      throw NetworkError(e);
    } on Error catch (e) {
      debugLog('++++++ERROR: ${e.toString()}');
      rethrow;
    }
  }

  Future<String> downloadFile(String url, filename) async {
    Directory? directory;
    directory = await getApplicationDocumentsDirectory();
    String dirPath = directory.path;
    File saveFile = File('$dirPath/$filename');

    try {
      await _dio.download(url, saveFile.path);
      return saveFile.path;
    } on DioException catch (e) {
      debugLog('++++++ERROR: ${e.toString()}');
      throw NetworkError(e);
    } on Error catch (e) {
      debugLog('++++++ERROR: ${e.toString()}');
      rethrow;
    }
  }

  Future<String> downloadFileToPath(String url, String path) async {
    File saveFile = File(path);

    try {
      await _dio.download(url, saveFile.path);
      return saveFile.path;
    } on DioException catch (e) {
      debugLog('++++++ERROR: ${e.toString()}');
      throw NetworkError(e);
    } on Error catch (e) {
      debugLog('++++++ERROR: ${e.toString()}');
      rethrow;
    }
  }

  Future<dynamic> performHttpRequest(String api, HttpMethod method,
      {BuildContext? context,
      bool autoHandle = true,
      VoidCallback? callback,
      Map<String, dynamic>? params,
      Map<String, dynamic>? headers,
      String? errorTitle,
      String? errorText,
      bool Function()? isMounted}) async {
    try {
      DGNetworkResult result;
      switch (method) {
        case HttpMethod.get:
          result = await get(api, params: params, headers: headers);
          break;
        case HttpMethod.post:
          result = await post(api, params: params, headers: headers);
          break;
        case HttpMethod.put:
          result = await put(api, params: params, headers: headers);
          break;
        case HttpMethod.patch:
          result = await patch(api, params: params, headers: headers);
          break;
        case HttpMethod.delete:
          result = await delete(api, params: params, headers: headers);
          break;
      }

      return result;
    } catch (e) {
      if (autoHandle) {
        String? title = errorTitle;
        String? msg = errorText;

        if (errorTitle == null && errorText == null) {
          title = tr.systemErrorTitle;
          msg = tr.systemErrorText;

          if (e is DGHttpException) {
            title = (e).getErrorMsgTitle();
            msg = (e).getErrorMsgText();
          } else if (e is NetworkError) {
            title = (e).getErrorMsgTitle();
            msg = (e).getErrorMsgText();
          }

          title ??= tr.systemErrorTitle;
          msg ??= tr.systemErrorText;
        }
        // Handle error
        if (isMounted != null && !isMounted()) return null;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (isMounted != null && isMounted()) {
            showDialog(
              context: context!,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text(title!),
                  content: Text(msg!),
                  actions: [
                    TextButton(
                      child: Text(tr.ok),
                      onPressed: () {
                        Navigator.of(context).pop();
                        if (callback != null) {
                          callback();
                        }
                      },
                    ),
                  ],
                );
              },
            );
          }
        });
        return null;
      } else {
        return e;
      }
    }
  }
}
