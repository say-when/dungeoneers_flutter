import 'package:dungeoneers/screens/dng_main_base.dart';
import 'package:flutter/material.dart';

import 'package:dungeoneers/services/logger.dart';

enum TransactionState {
  deferred,
  failed,
  purchased,
  restored,
}

mixin JavaScriptCallbackMixin on DNGMainBase {
  void makeCallbackForPurchase(
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
        ", '${state.name}');"; // Assuming TransactionState is an enum and toString gives the correct string representation

    // Execute the JavaScript in the web view
    controller.runJavaScript(call);
  }

  void handleMessage(String name, dynamic body) {
    switch (name) {
      case 'msgTestScriptMessage':
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Test Script Message'),
              content: Text('$body'),
              actions: <Widget>[
                TextButton(
                  child: const Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
        break;
      case 'msgClearWebCache':
        controller.clearCache();
        break;
      case 'msgLoadDungeoneers':
        loadDungeoneers();
        break;
      case 'msgReloadPage':
        controller.reload();
        break;
      case 'msgFullReload':
        controller.clearCache();
        controller.reload();
        break;
      case 'msgInAppConsumable':
        var productID = body['product_id'];
        var quantity = body['quantity'];
        var name = body['name'];
        var callback = body['callback'];
        var accountKey = body['account_key'];
        purchaseInAppConsumable(
            productID, quantity, name, callback, accountKey);
        break;
      case 'msgInAppOneTime':
        var productID = body['product_id'];
        var callback = body['callback'];
        var accountKey = body['account_key'];
        purchaseInAppOneTime(productID, callback, accountKey);
        break;
      case 'msgShowDebugView':
        showDebugScreen();
        break;
      case 'msgRestorePurchases':
        var accountKey = body['account_key'];
        if (purchasesCallback != null) {
          restorePurchases(
              callback: purchasesCallback!, accountKey: accountKey);
        }
        break;
      case 'msgConfirmPurchase':
        var transactionID = body['transaction_id'];
        completedPurchase(transactionID);
        break;
      case 'msgInitializePurchases':
        var callback = body['callback'];
        purchasesCallback = callback;
        if (!isReadyForPurchases) {
          isReadyForPurchases = true;
          processTransactionsBeforeReady();
        }
        break;
      case 'msgShowRatingsAlert':
        showInAppRatingsAlert();
        break;
      case 'msgOpenURL':
        var url = body['url'];
        openURL(url);
        break;
      default:
        debugLog("Reached default in the handleMessage switch block");
        break;
    }
  }
}
