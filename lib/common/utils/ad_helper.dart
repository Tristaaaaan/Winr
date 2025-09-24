import 'dart:io';

import 'package:winr/config/app_config.dart';
import 'package:winr/config/app_environments.dart';

class AdHelper {
  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      if (AppConfig.environment == Flavors.development) {
        return "ca-app-pub-3940256099942544/6300978111";
      }
      return "ca-app-pub-8645104543342243/1438353830"; // test ca-app-pub-3940256099942544/9214589741 orig ca-app-pub-8645104543342243/1438353830
    } else if (Platform.isIOS) {
      return "";
    } else {
      throw UnsupportedError("Unsupported platform");
    }
  }

  static String get interstitialAdUnitId {
    if (Platform.isAndroid) {
      if (AppConfig.environment == Flavors.development) {
        return "ca-app-pub-3940256099942544/1033173712";
      }
      return "ca-app-pub-8645104543342243/5521903228"; // test ca-app-pub-3940256099942544/1033173712 orig ca-app-pub-8645104543342243/5521903228
    } else if (Platform.isIOS) {
      return "";
    } else {
      throw UnsupportedError("Unsupported platform");
    }
  }
}
