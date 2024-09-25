import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:dungeoneers/providers/system_settings.dart';
import 'package:dungeoneers/screens/dng_main_screen.dart';

abstract class DNGMainBase extends State<DNGMainScreen> {
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

  void loadDungeoneers() {}
  void clearWebCache() {}
  void showInAppRatingsAlert() {}
  void showDebugScreen() {}
  void openURL(String url) async {}
  // Placeholder methods for the various actions
  void purchaseInAppConsumable(String productID, int quantity, String name,
      String callback, String accountKey) {}
  void purchaseInAppOneTime(
      String productID, String callback, String accountKey) {}
  void showDebugViewController() {}
  void restorePurchases(
      {required String callback, required String accountKey}) {}
  void completedPurchase(String transactionID) {}
  void processTransactionsBeforeReady() {}
}
