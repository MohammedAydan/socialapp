import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:socialapp/common/admob.dart';
import 'package:socialapp/widgets/custom_primary_button.dart';

class SupportAppScreen extends StatefulWidget {
  static const String routeName = "/SupportApp";
  const SupportAppScreen({super.key});

  @override
  _SupportAppScreenState createState() => _SupportAppScreenState();
}

class _SupportAppScreenState extends State<SupportAppScreen> {
  InterstitialAd? _interstitialAd;
  bool _isInterstitialAdReady = false;

  @override
  void initState() {
    super.initState();
    _loadInterstitialAd();
  }

  void _loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId: AdMob.interstitialId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          _interstitialAd = ad;
          setState(() {
            _isInterstitialAdReady = true;
          });
        },
        onAdFailedToLoad: (LoadAdError error) {
          print('Failed to load an interstitial ad: ${error.message}');
          setState(() {
            _isInterstitialAdReady = false;
          });
        },
      ),
    );
  }

  void _showInterstitialAd() {
    if (_isInterstitialAdReady) {
      _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdShowedFullScreenContent: (InterstitialAd ad) {
          print('Ad showed.');
        },
        onAdDismissedFullScreenContent: (InterstitialAd ad) {
          print('Ad dismissed.');
          ad.dispose();
          _loadInterstitialAd(); // Load another ad after dismissal
        },
        onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
          print('Failed to show the ad: ${error.message}');
          ad.dispose();
          _loadInterstitialAd(); // Load another ad in case of failure
        },
      );
      _interstitialAd!.show();
    } else {
      print('Interstitial ad is not ready yet.');
    }
  }

  @override
  void dispose() {
    _interstitialAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Support App"),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Support App Screen"),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(20),
              child: CustomPrimaryButton(
                onPressed: _showInterstitialAd,
                text: "Show Ad",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
