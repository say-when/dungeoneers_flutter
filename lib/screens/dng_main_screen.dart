import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

import 'package:dungeoneers/mixins/javascript_callback_mixin.dart';
import 'package:dungeoneers/networking/network.dart';
import 'package:dungeoneers/providers/system_info.dart';
import 'package:dungeoneers/providers/system_settings.dart';
import 'package:dungeoneers/screens/debug_screen.dart';
import 'package:dungeoneers/screens/dng_main_base.dart';
import 'package:dungeoneers/services/logger.dart';
//import 'package:dungeoneers/theme/app_theme.dart';

class DNGMainScreen extends StatefulWidget {
  const DNGMainScreen({super.key});

  @override
  State<DNGMainScreen> createState() => _DNGMainScreenState();
}

class _DNGMainScreenState extends DNGMainBase
    with WidgetsBindingObserver, JavaScriptCallbackMixin {
  final InAppReview _inAppReview = InAppReview.instance;
  Brightness brightness =
      WidgetsBinding.instance.platformDispatcher.platformBrightness;
  late bool isTablet;

  @override
  void initState() {
    super.initState();

    isTablet = Provider.of<SystemInfo>(context, listen: false).isTablet;
    systemSettings = Provider.of<SystemSettings>(context, listen: false);
    WidgetsBinding.instance.addObserver(this);

    systemSettings.addListener(_systemSettingsListener);

    late final PlatformWebViewControllerCreationParams params;
    if (WebViewPlatform.instance is WebKitWebViewPlatform) {
      params = WebKitWebViewControllerCreationParams(
        allowsInlineMediaPlayback: true,
        mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
      );
    } else {
      params = const PlatformWebViewControllerCreationParams();
    }

    controller = WebViewController.fromPlatformCreationParams(params)
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0xFFFFFFFF));

    initPlatformState();

    // Test DebugScreen...
    /*Future.delayed(const Duration(seconds: 2), () {
      //showDebugScreen();
      showInAppRatingsAlert();
    });*/
  }

  void _systemSettingsListener() {
    loadDungeoneers();
  }

  @override
  void dispose() {
    systemSettings.removeListener(_systemSettingsListener);
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
    //    'Dungeoneers 2.0.0 rv:91 (iPad14,9; 18.0)'; //Network.userAgent;
    var userAgent = Network.userAgent;
    log(userAgent);
    try {
      await controller.clearLocalStorage();
      await controller.clearCache();
      controller
        ..enableZoom(false)
        ..setUserAgent(userAgent)
        ..setNavigationDelegate(
          NavigationDelegate(
            onWebResourceError: (WebResourceError error) {},
            onPageFinished: (url) {
              /*controller.runJavaScript(
                  "document.querySelector('meta[name=viewport]').setAttribute('content', 'width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no');");*/
            },
            onNavigationRequest: (NavigationRequest request) {
              return NavigationDecision.navigate;
            },
          ),
        );
      debugLog('Loading URL: ${systemSettings.baseURL()}');
      loadDungeoneers();
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
  void loadDungeoneers() {
    controller.loadRequest(Uri.parse(systemSettings.baseURL()));
  }

  @override
  clearWebCache() {
    controller.clearCache();
  }

  @override
  showDebugScreen() {
    if (Platform.isIOS) {
      showCupertinoDialog(
          context: context,
          builder: (BuildContext context) {
            return const DebugScreen();
          });
    } else if (Platform.isAndroid) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return const DebugScreen();
          });
    }
  }

  @override
  void openURL(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      log('++++++ERROR: Could not launch $url');
    }
  }

  @override
  Future<void> showInAppRatingsAlert() async {
    if (await _inAppReview.isAvailable()) {
      await _inAppReview.requestReview();
    }
  }

  void openStoreListing() async {
    final url = Platform.isIOS
        ? 'https://apps.apple.com/app/1233004509' // Replace with your app's App Store URL
        : 'https://play.google.com/store/apps/details?id=YOUR_APP_ID'; // Replace with your app's Play Store URL

    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      log('++++++ERROR: Could not launch $url');
    }
  }

  //
  // Build Method
  //
  @override
  Widget build(BuildContext context) {
    debugLog('Building WebView...');
    //setLightDarkMode();

    Widget webView = isTablet
        ? AspectRatio(
            aspectRatio: 4 / 3,
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.red, width: 2),
              ),
              child: WebViewWidget(
                controller: controller,
              ),
            ),
          )
        : WebViewWidget(
            controller: controller,
          );

    return webView;
  }
}
