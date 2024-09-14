import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:dungeoneers/app/constants.dart';

class SystemSettings extends ChangeNotifier {
  int _appURLIndex = 0;

  int get appURLIndex => _appURLIndex;

  Future<void> storeAppURLIndex(int index) async {
    var prefs = await SharedPreferences.getInstance();
    await prefs.setInt(Constants.appURLIndexDefaultsKey, index);
  }

  void setAppURLIndex(int index) async {
    _appURLIndex = index;
    notifyListeners();
  }

  Future<int?> getStoredAppURLIndex() async {
    var prefs = await SharedPreferences.getInstance();
    var index = prefs.getInt(Constants.appURLIndexDefaultsKey);
    return index;
  }

  int getAppURLIndex() {
    return _appURLIndex;
  }

  String baseURL() {
    return Constants.appURLs[_appURLIndex];
  }
}
