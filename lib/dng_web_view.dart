import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'package:dungeoneers/app/api.dart';
import 'package:dungeoneers/networking/network.dart';
import 'package:dungeoneers/services/logger.dart';
//import 'package:dungeoneers/theme/app_theme.dart';

class DNGWebView extends StatefulWidget {
  const DNGWebView({super.key});

  @override
  State<DNGWebView> createState() => _DNGWebViewState();
}

class _DNGWebViewState extends State<DNGWebView> with WidgetsBindingObserver {
  late final WebViewController controller;

  Brightness brightness =
      WidgetsBinding.instance.platformDispatcher.platformBrightness;

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);

    super.initState();
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0xFFFFFFFF));
    initPlatformState();
  }

  @override
  void dispose() {
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
      controller
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
      await controller.clearLocalStorage();
      await controller.clearCache();
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

      controller.loadRequest(Uri.parse(API.baseURL));
    } catch (err) {
      log('++++++ERROR: Could not create the WebView!');
    }
  }

  setLightDarkMode() {
    var funcName =
        brightness == Brightness.light ? 'setLightMode' : 'setDarkMode';
    var funct = 'if (typeof($funcName) == \'function\') { $funcName() }';
    controller.runJavaScript(funct);
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
            controller: controller,
          ),
        )
        : WebViewWidget(
            controller: controller,
          );

    return SafeArea(
      child: webView,
    );
  }
}
