import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Constants {
  static const stagingDomain = 'https://staging.dungeoneers.com';
  static const localhost = 'localhost';
  static const productionURL = 'https://www.dungeoneers.com';
  static const developerURL = 'http://erebor.dungeoneers.com';

  static const enableCrashlyticsCollection = kReleaseMode;
  static const appTitle = 'Dungeoneers';
  static const deviceType = 'device';
  static const platform = 'platform';
  static const gmtDeltaSecs = 'gmt_delta_secs';
  static const deviceID = 'device_id';
  static const countryCode = 'country';
  static const timeZone = 'time_zone';
  static const appURLIndexDefaultsKey = 'kAppURLIndexDefaultsKey';
  static const appURLs = [
    productionURL,
    stagingDomain,
    developerURL
  ];

  static const backgroundColor = Colors.black;
  static const msgTestScriptMessage = "testScriptMessage";
  static const msgClearWebCache = "clearWebCache";
  static const msgLoadDungeoneers = "loadDungeoneers";
  static const msgReloadPage = "reloadPage";
  static const msgFullReload = "fullReload";
  static const msgInAppConsumable = "inAppConsumable";
  static const msgInAppOneTime = "inAppOneTime";
  static const msgShowDebugView = "showDebugView";
  static const msgRestorePurchases = "restorePurchases";
  static const msgConfirmPurchase = "confirmPurchase";
  static const msgInitializePurchases = "initializePurchases";
  static const msgShowRatingsAlert = "showRatingsAlert";
  static const msgRequestReview = "requestReview";
  static const msgOpenURL = "openURL";
}
