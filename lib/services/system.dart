import 'dart:io' show Platform;
import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

import 'package:dungeoneers/app/constants.dart';

class System {
  static Future<String> get documentDirectory async {
    final dir = await getApplicationDocumentsDirectory();
    return dir.path;
  }

  static Future<String> get libraryDirectory async {
    if (Platform.isIOS) {
      final dir = await getLibraryDirectory();
      return dir.path;
    } else {
      final dir = await getApplicationDocumentsDirectory();
      return dir.path;
    }
  }

  static Future<String> get soundsDirectory async {
    final dir = await getApplicationDocumentsDirectory();
    return p.join(dir.path, "Sounds");
  }

  static Future<String> get bundleDirectory async {
    final dir = await getApplicationSupportDirectory();
    return dir.path;
  }

  static Future<String> get tempDirectory async {
    final dir = await getTemporaryDirectory();
    return dir.path;
  }

  static Future<String> appName() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.appName;
  }

  static Future<String> packageName() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.packageName;
  }

  static Future<String> version() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.version;
  }

  static Future<String> buildNumber() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.buildNumber;
  }

  static Future<String> getDevice() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      return iosInfo.utsname.machine;
    } else if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      return androidInfo.device;
    } else {
      return 'unknown';
    }
  }

  static Future<String> getSdkIntOrSystemVersion() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      return iosInfo.systemVersion;
    } else if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      return androidInfo.version.sdkInt.toString();
    } else {
      return 'unknown';
    }
  }

  static Future<String> getReleaseOrSystemVersion() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      return iosInfo.systemVersion;
    } else if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      return androidInfo.version.release;
    } else {
      return 'unknown';
    }
  }

  static Future<bool> isAndroidTablet() async {
    final deviceInfoPlugin = DeviceInfoPlugin();
    var androidInfo = await deviceInfoPlugin.androidInfo;

    // Check if the device has the tablet feature
    if (androidInfo.systemFeatures.contains('android.hardware.type.tablet')) {
      return true;
    }

    // Fallback: Check the screen size
    final view = ui.PlatformDispatcher.instance.views.first;
    final size = view.physicalSize / view.devicePixelRatio;
    final diagonal =
        math.sqrt(size.width * size.width + size.height * size.height);
    final isTablet = diagonal > 1100.0; // Adjust the threshold as needed

    return isTablet;
  }

  static Future<String> architecture() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

    if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      var strMachine = 'unknown';
      var strVersion = 'unknown';
      var machine = iosInfo.utsname.machine;
      strMachine = machine;
      strVersion = iosInfo.systemVersion.replaceAll('.', '_');

      var str = "($strMachine; OS $strVersion; iOS)";
      return str;
    } else if (Platform.isAndroid) {
      bool isTablet = await System.isAndroidTablet();
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      var device = androidInfo.device;
      var model = androidInfo.model;
      var sdkInt = androidInfo.version.sdkInt;
      var release = androidInfo.version.release;

      return '(${device.contains('emulator') ? device : model}; Android ${isTablet ? 'Tablet' : 'Phone'} $release.$sdkInt)';
    } else {
      return '(unknown; unknown; unknown)';
    }
  }

  static Future<String> getUserAgentString() async {
    var appName = Constants.appTitle; //await System.appName();
    var version = await System.version();
    var build = await System.buildNumber();
    var architecture = await System.architecture();
    //let userAgent = "\(Constants.apiUserAgent) \(version!) rv:\(build!) (\(device!); \(os))"
    return '$appName $version rv:$build $architecture'; // Temporarily set as a constant
  }

  static Future<String> getCurrentTimezone() async {
    final String currentTimeZone = await FlutterTimezone.getLocalTimezone();
    return currentTimeZone;
  }
}
