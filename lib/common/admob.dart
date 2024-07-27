import 'dart:io';

// class AdMob {
//   static String bannerId = Platform.isIOS ? "IOS-ID" : "ANDROID-ID";
//   static String nativeId = Platform.isIOS ? "IOS-ID" : "ANDROID-ID";
//   static String interstitialId = Platform.isIOS ? "IOS-ID" : "ANDROID-ID";
// }

class AdMob {
  static String bannerId = Platform.isIOS
      ? "ca-app-pub-7492523185817229/7702154485"
      : "ca-app-pub-7492523185817229/7042828873";
  static String nativeId = Platform.isIOS
      ? "ca-app-pub-7492523185817229/3898624939"
      : "ca-app-pub-7492523185817229/7754125378";

  static String interstitialId = Platform.isIOS
      ? "ca-app-pub-7492523185817229/3830659408"
      : "ca-app-pub-7492523185817229/5997657742";
}