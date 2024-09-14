import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

import 'package:dungeoneers/networking/network.dart';
import 'package:dungeoneers/providers/system_settings.dart';
import 'package:dungeoneers/services/logger.dart';
//import 'package:dungeoneers/theme/app_theme.dart';

enum TransactionState { deferred, failed, purchased, restored }

class DNGWebView extends StatefulWidget {
  const DNGWebView({super.key});

  @override
  State<DNGWebView> createState() => _DNGWebViewState();
}

class _DNGWebViewState extends State<DNGWebView> with WidgetsBindingObserver {
  late final WebViewController _controller;
  late SystemSettings _systemSettings;

  Brightness brightness =
      WidgetsBinding.instance.platformDispatcher.platformBrightness;

  @override
  void initState() {
    _systemSettings = Provider.of<SystemSettings>(context, listen: false);
    WidgetsBinding.instance.addObserver(this);

    super.initState();

    _systemSettings.addListener(_systemSettingsListener);

    late final PlatformWebViewControllerCreationParams params;
    if (WebViewPlatform.instance is WebKitWebViewPlatform) {
      params = WebKitWebViewControllerCreationParams(
        allowsInlineMediaPlayback: true,
        mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
      );
    } else {
      params = const PlatformWebViewControllerCreationParams();
    }
    _controller = WebViewController.fromPlatformCreationParams(params)
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0xFFFFFFFF));
    initPlatformState();
  }

  void _systemSettingsListener() {
    _controller.loadRequest(Uri.parse(_systemSettings.baseURL()));
  }

  @override
  void dispose() {
    _systemSettings.removeListener(_systemSettingsListener);
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangePlatformBrightness() {
    if (mounted) {
      setState(() {
        brightness =
            WidgetsBinding.instance.platformDispatcher.platformBrightness;
      });
    }
    super.didChangePlatformBrightness();
  }

  Future<void> initPlatformState() async {
    try {
      _controller
        ..clearCache()
        ..setUserAgent(Network.userAgent)
        ..setNavigationDelegate(
          NavigationDelegate(
            onProgress: (int progress) {
              // Update loading bar.
              //print('onProgress!');
            },
            onPageStarted: (String url) {
              //print('onPageStarted!');
              //setBackButtonState();
            },
            onPageFinished: (String url) {
              //print('onPageFinished!');
              //Network.copySessionCookies();
              //setBackButtonState();
              //setLightDarkMode();
            },
            onWebResourceError: (WebResourceError error) {},
            onNavigationRequest: (NavigationRequest request) {
              /*if (request.url.startsWith('https://www.youtube.com/')) {
                return NavigationDecision.prevent;
              }*/
              return NavigationDecision.navigate;
            },
          ),
        );
      //print('++++++DEBUG: Copying session cookie...');
      await _controller.clearLocalStorage();
      await _controller.clearCache();
      //print('++++++DEBUG: WebView is copying session cookies...');
      //await Network.copySessionCookies();
      //print('++++++DEBUG: WebView is done copying session cookies...');
      /*var cookie = await Network.getSessionCookie();
      if (cookie != null) {
        await WebViewCookieManager().setCookie(WebViewCookie(
            name: cookie.name,
            value: cookie.value,
            domain: API.baseURL,
            path: '/'));

        Map<String, String> header = {
          'Cookie': '${cookie.name}=${cookie.value}'
        };*/
      debugLog('Loading URL: ${_systemSettings.baseURL()}');
      _controller.loadRequest(Uri.parse(_systemSettings.baseURL()));
    } catch (err) {
      log('++++++ERROR: Could not create the WebView!');
    }
  }

  setLightDarkMode() {
    var funcName =
        brightness == Brightness.light ? 'setLightMode' : 'setDarkMode';
    var funct = 'if (typeof($funcName) == \'function\') { $funcName() }';
    _controller.runJavaScript(funct);
  }

  void makeCallback(String callback, String audioURL, bool param) {
    String javascriptCommand = "$callback('$audioURL', $param);";
    _controller.runJavaScript(javascriptCommand);
  }

  void makeStoreCallback(
      String callback,
      String productID,
      bool success,
      int qty,
      String? receipt,
      String? transactionID,
      String? error,
      TransactionState state) {
    // Start constructing the JavaScript function call
    var call = "$callback('$productID', $success, $qty";

    // Add the receipt if available, else add an empty string
    call += ", '${receipt ?? ''}'";

    // Add the transaction ID if available, else add an empty string
    call += ", '${transactionID ?? ''}'";

    // Add the error message if available, else add an empty string
    call += ", '${error ?? ''}'";

    // Add the transaction state's raw value
    call +=
        ", '${state.toString()}');"; // Assuming TransactionState is an enum and toString gives the correct string representation

    // Execute the JavaScript in the web view
    _controller.runJavaScript(call);
  }

  @override
  Widget build(BuildContext context) {
    debugLog('Building WebView...');
    //setLightDarkMode();
    var isTablet = MediaQuery.sizeOf(context).shortestSide >= 600;

    Widget webView = isTablet
        ? AspectRatio(
            aspectRatio: 4 / 3,
            child: WebViewWidget(
              controller: _controller,
            ),
          )
        : WebViewWidget(
            controller: _controller,
          );

    return SafeArea(
      child: webView,
    );
  }
}
