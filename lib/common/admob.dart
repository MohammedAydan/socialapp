// import 'dart:io';

// class AdMob {
//   static String bannerId = Platform.isIOS ? "IOS-ID" : "ANDROID-ID";
//   static String nativeId = Platform.isIOS ? "IOS-ID" : "ANDROID-ID";
//   static String interstitialId = Platform.isIOS ? "IOS-ID" : "ANDROID-ID";
// }

import 'dart:io';

import 'package:flutter_dotenv/flutter_dotenv.dart';

class AdMob {
  static String bannerId = Platform.isIOS
      ? dotenv.env['ANDROID_ADMOB_BANNER_ID'] ?? ""
      : dotenv.env['IOS_ADMOB_BANNER_ID'] ?? "";

  static String nativeId = Platform.isIOS
      ? dotenv.env['ANDROID_ADMOB_NATIVE_ID'] ?? ""
      : dotenv.env['IOS_ADMOB_NATIVE_ID'] ?? "";

  static String interstitialId = Platform.isIOS
      ? dotenv.env['ANDROID_ADMOB_INTERSTITIAL_ID'] ?? ""
      : dotenv.env['IOS_ADMOB_INTERSTITIAL_ID'] ?? "";
}
