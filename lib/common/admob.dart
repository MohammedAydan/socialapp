import 'dart:io';

class AdMob {
  static String bannerId = Platform.isIOS ? "IOS-ID" : "ANDROID-ID";
  static String nativeId = Platform.isIOS ? "IOS-ID" : "ANDROID-ID";
  static String interstitialId = Platform.isIOS ? "IOS-ID" : "ANDROID-ID";
}
