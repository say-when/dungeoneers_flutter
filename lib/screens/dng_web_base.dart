import 'package:dungeoneers/screens/dng_web_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:dungeoneers/providers/system_settings.dart';
import 'package:dungeoneers/services/logger.dart';

abstract class DNGWebBase extends State<DNGWebView> {
  late WebViewController controller;
  late SystemSettings systemSettings;

  // Used on startup to catch any transactions that are sent to
  // us before the server calls initializePurchases
  List<String> failedTransactions = [];
  Map<String, dynamic> completedTransactions = {};
  var isReadyForPurchases = false; // Is the server ready for purchases?
  var isRestoringPurchases = false;
  String?
      restoreCallback; // For now, this will be the same as the purchases callback.
  String? purchasesCallback;

  void loadDungeoneers() {
    controller.loadRequest(Uri.parse(systemSettings.baseURL()));
  }

  clearWebCache() {
    controller.clearCache();
  }

  void openURL(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      log('++++++ERROR: Could not launch $url');
    }
  }
}
