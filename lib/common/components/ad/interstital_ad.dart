import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:winr/common/utils/ad_helper.dart';

class InterstitialAdManager {
  static InterstitialAd? _interstitialAd;
  static bool _isAdLoaded = false;

  /// Load interstitial
  static void loadAd() {
    InterstitialAd.load(
      adUnitId: AdHelper.interstitialAdUnitId, // replace with your test/live ID
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          _interstitialAd = ad;
          _isAdLoaded = true;

          // Clean up when dismissed
          _interstitialAd
              ?.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
              _isAdLoaded = false;
              loadAd(); // preload the next ad
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              ad.dispose();
              _isAdLoaded = false;
              loadAd();
            },
          );
        },
        onAdFailedToLoad: (LoadAdError error) {
          debugPrint('Interstitial failed to load: $error');
          _isAdLoaded = false;
        },
      ),
    );
  }

  /// Show interstitial if available
  static void showAd() {
    if (_isAdLoaded && _interstitialAd != null) {
      _interstitialAd?.show();
      _interstitialAd = null;
      _isAdLoaded = false;
    } else {
      debugPrint('Interstitial not ready yet.');
    }
  }

  // Example: 30% chance to show ad (if random number <= 3)
  void maybeShowInterstitial() {
    final random = Random();
    final number = random.nextInt(10) + 1; // gives 1–10
    debugPrint("Random number: $number");

    if (number <= 3) {
      // 30% chance
      InterstitialAdManager.showAd();
    } else {
      debugPrint("Ad not shown this time.");
    }
  }
}
