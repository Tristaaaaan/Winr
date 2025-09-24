import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:winr/common/utils/ad_helper.dart';

class InterstitialAdManager {
  static InterstitialAd? _interstitialAd;
  static bool _isAdLoaded = false;

  // 🔹 Make loadAd return a Future<bool>
  static Future<bool> loadAd() async {
    final completer = Completer<bool>();

    InterstitialAd.load(
      adUnitId: AdHelper.interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          _interstitialAd = ad;
          _isAdLoaded = true;

          _interstitialAd
              ?.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
              _isAdLoaded = false;
              loadAd(); // prepare next
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              ad.dispose();
              _isAdLoaded = false;
              loadAd(); // prepare next
            },
          );

          completer.complete(true);
        },
        onAdFailedToLoad: (error) {
          debugPrint("Interstitial failed to load: $error");
          _isAdLoaded = false;
          completer.complete(false);
        },
      ),
    );

    return completer.future;
  }

  static void showAd() {
    if (_isAdLoaded && _interstitialAd != null) {
      _interstitialAd?.show();
      _interstitialAd = null;
      _isAdLoaded = false;
    } else {
      debugPrint("Interstitial not ready yet.");
    }
  }

  Future<void> maybeShowInterstitial() async {
    final random = Random();
    final number = random.nextInt(10) + 1;
    debugPrint("Random number: $number");

    if (number <= 5) {
      if (!_isAdLoaded) {
        final success = await loadAd();
        if (!success) {
          debugPrint("Failed to load ad before showing.");
          return;
        }
      }
      showAd();
    } else {
      debugPrint("Ad not shown this time.");
    }
  }
}
