import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:socialapp/common/admob.dart';

class NativeAdWidget extends StatelessWidget {
  const NativeAdWidget({super.key, required this.id});
  final int id;

  @override
  Widget build(BuildContext context) {
    final NativeAdController controller = Get.put(
      NativeAdController(),
      tag: "ADMOB-AD-ID-$id-NativeAd",
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
                      height: 150,
                      child: AdWidget(ad: controller.nativeAd.value!),
                    ),
                  ],
                ),
              )
            : const SizedBox();
      }

      return const SizedBox();
    });
  }
}

class NativeAdController extends GetxController {
  Rx<NativeAd?> nativeAd = Rx<NativeAd?>(null);
  RxBool isAdLoaded = false.obs;
  RxBool hideAd = false.obs;

  @override
  void onInit() {
    super.onInit();
    _loadNativeAd();
  }

  void _loadNativeAd() {
    nativeAd.value = NativeAd(
      adUnitId: AdMob.nativeId,
      factoryId: 'listTile',
      nativeTemplateStyle: NativeTemplateStyle(
        templateType: TemplateType.small,
      ),
      nativeAdOptions: NativeAdOptions(),
      request: const AdRequest(),
      listener: NativeAdListener(
        onAdLoaded: (ad) {
          isAdLoaded(true);
          print('Native ad loaded successfully.');
        },
        onAdFailedToLoad: (ad, error) {
          print("Native ad failed to load: $error");
          ad.dispose();
        },
        onAdOpened: (ad) => print('Native ad opened.'),
        onAdClosed: (ad) => print('Native ad closed.'),
        onAdImpression: (ad) => print('Native ad impression.'),
        onAdClicked: (ad) => print('Native ad clicked.'),
      ),
    );
    nativeAd.value!.load();
  }

  @override
  void dispose() {
    nativeAd.value?.dispose();
    super.dispose();
  }
}
