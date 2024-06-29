import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:dungeoneers/main.dart';

AppLocalizations get tr {
  if (_tr == null) {
    _tr = navigatorKey.currentContext != null
        ? AppLocalizations.of(navigatorKey.currentContext!)
        : null;
    if (_tr == null) {
      throw Exception('AppLocalizations not found');
    }
  }
  return _tr!;
}

AppLocalizations? _tr; // global variable

class AppTranslations {
  static init(BuildContext context) {
    _tr = AppLocalizations.of(context);
  }
}
