import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:socialapp/common/admob.dart';

class BannerAdWidget extends StatelessWidget {
  const BannerAdWidget({super.key, required this.id});
  final int id;

  @override
  Widget build(BuildContext context) {
    final BannerAdController controller = Get.put(
      BannerAdController(),
      tag: "ADMOB-AD-ID-$id-BannerAd",
    );

    return Obx(() {
      if (controller.isAdLoaded.isTrue) {
        return !controller.hideAd.value
            ? Container(
                padding: const EdgeInsets.all(10),
                margin: const EdgeInsets.symmetric(vertical: 5),
                decoration: BoxDecoration(
                  color: context.theme.colorScheme.tertiary,
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        IconButton(
                          onPressed: () {
                            controller.hideAd(true);
                          },
                          icon: const Icon(Icons.close_rounded),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.only(top: 10),
                      width: double.infinity,
                      height: 60, // Height of the BannerAd
                      child: AdWidget(ad: controller.bannerAd.value!),
                    ),
                  ],
                ),
              )
            : const SizedBox();
      }

      return !controller.hideAd.value
          ? Container(
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.symmetric(vertical: 5),
              decoration: BoxDecoration(
                color: context.theme.colorScheme.tertiary,
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      IconButton(
                        onPressed: () {
                          controller.hideAd(true);
                        },
                        icon: const Icon(Icons.close_rounded),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.only(top: 10),
                    width: double.infinity,
                    // height: 60, // Height of the BannerAd
                    // child: const Center(child: CircularProgressIndicator()),
                  ),
                ],
              ),
            )
          : const SizedBox();
    });
  }
}

class BannerAdController extends GetxController {
  Rx<BannerAd?> bannerAd = Rx<BannerAd?>(null);
  RxBool isAdLoaded = false.obs;
  RxBool hideAd = false.obs;

  @override
  void onInit() {
    super.onInit();
    _loadBannerAd();
  }

  void _loadBannerAd() {
    bannerAd.value = BannerAd(
      adUnitId: AdMob.bannerId, // Use your banner ad unit ID
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          isAdLoaded(true);
          print('Banner ad loaded successfully.');
        },
        onAdFailedToLoad: (ad, error) {
          print("Banner ad failed to load: $error");
          ad.dispose();
        },
        onAdOpened: (ad) => print('Banner ad opened.'),
        onAdClosed: (ad) => print('Banner ad closed.'),
        onAdImpression: (ad) => print('Banner ad impression.'),
        onAdClicked: (ad) => print('Banner ad clicked.'),
      ),
    );
    bannerAd.value!.load();
  }

  @override
  void dispose() {
    bannerAd.value?.dispose();
    super.dispose();
  }
}
