import 'dart:io';

class AdHelper {
  static String get bannedAdUnitId {
    if (Platform.isAndroid) {
      return "ca-app-pub-3940256099942544/9214589741"; // test ca-app-pub-3940256099942544/9214589741 orig ca-app-pub-8645104543342243/1438353830
    } else if (Platform.isIOS) {
      return "";
    } else {
      throw UnsupportedError("Unsupported platform");
    }
  }
}
