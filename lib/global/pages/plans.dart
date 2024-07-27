import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pay/pay.dart';
import 'package:socialapp/features/auth/controllers/auth_controller.dart';
import 'package:socialapp/features/auth/models/user_model.dart';
import 'package:socialapp/global/pages/models/pay_result.dart';
import 'package:socialapp/main.dart';
import 'package:socialapp/widgets/loading.dart';

import 'models/plan_model.dart';
import 'widgets/plan_page.dart';

class Plans extends StatelessWidget {
  Plans({super.key});

  final controller = Get.put(PlansController());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: AppBar(
          title: Text("${controller.currentPage.value + 1}/3"),
          centerTitle: true,
        ),
        body: PageView(
          controller: PageController(keepPage: true),
          onPageChanged: controller.onPageChanged,
          clipBehavior: Clip.antiAlias,
          dragStartBehavior: DragStartBehavior.start,
          padEnds: false,
          children: [
            PlanPage(
              payButton: payButton(0),
              planModel: PlanModel(
                name: "Free plan",
                price: 0,
                free: true,
                features: _buildFeaturePlans(
                  [true, true, false, false, false, false],
                ),
              ),
            ),
            PlanPage(
              payButton: payButton(5),
              planModel: PlanModel(
                name: "Basic plan",
                price: 5,
                features: _buildFeaturePlans(
                  [true, true, true, true, true, false],
                ),
              ),
            ),
            PlanPage(
              payButton: payButton(19.99),
              planModel: PlanModel(
                name: "Pro plan",
                price: 19.99,
                features: _buildFeaturePlans(
                  [true, true, true, true, true, true],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<FeaturePlan> _buildFeaturePlans(List<bool> featuresStatus) {
    return List.generate(
      featuresStatus.length,
      (index) => FeaturePlan(
        feature: "pf${index + 1}".tr,
        activeFeature: featuresStatus[index],
      ),
    );
  }

  Widget payButton(double price) {
    if (controller.isPaymentConfigurationLoaded.isTrue) {
      return GooglePayButton(
        onPaymentResult: controller.onPaymentResult,
        paymentConfiguration: controller.paymentConfiguration.value!,
        paymentItems: [
          PaymentItem(
            label: 'Total',
            amount: price.toStringAsFixed(2),
            status: PaymentItemStatus.final_price,
          ),
        ],
        buttonProvider: PayProvider.google_pay,
        type: GooglePayButtonType.subscribe,
        cornerRadius: 13,
        theme: Get.isDarkMode
            ? GooglePayButtonTheme.dark
            : GooglePayButtonTheme.light,
        onError: (error) {
          print("Payment Error: $error");
        },
      );
    }
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}

class PlansController extends GetxController {
  RxInt currentPage = 0.obs;
  RxBool isPaymentConfigurationLoaded = false.obs;
  Rx<PaymentConfiguration?> paymentConfiguration = Rx(null);
  final AuthController authController = Get.find<AuthController>();

  void onPageChanged(int pageIndex) => currentPage(pageIndex);

  void getPaymentConfiguration() async {
    try {
      isPaymentConfigurationLoaded(false);
      final paymentConfiguration_ = await PaymentConfiguration.fromAsset(
          "default_google_pay_config.json");
      paymentConfiguration(paymentConfiguration_);
    } catch (e) {
      print("Error loading payment configuration: $e");
    } finally {
      isPaymentConfigurationLoaded(true);
    }
  }

  void onPaymentResult(Map<String, dynamic> res) async {
    try {
      showLoading();
      PaymentMethodData result = PaymentMethodData.fromJson(res);
      DateTime now = DateTime.now();
      DateTime subscriptionEndDate = now.add(const Duration(days: 30));
      print(".......res.......");
      print(res);

      final updateData = {
        "subscription_start_date": now,
        "subscription_end_date": subscriptionEndDate,
        "subscribe_data": result.toJson(),
      };

      if (currentPage.value == 1) {
        await supabase.from("users").update({
          ...updateData,
          "free_plan": false,
          "basic_plan": true,
          "plus_plan": false,
        }).eq("user_id", supabase.auth.currentUser!.id);

        authController.user(
          authController.user.value!
            ..freePlan = false
            ..basicPlan = true
            ..plusPlan = false
            ..subscriptionStartDate = now
            ..subscriptionEndDate = subscriptionEndDate
            ..subscribeData = result,
        );
      } else if (currentPage.value == 2) {
        await supabase.from("users").update({
          ...updateData,
          "free_plan": false,
          "basic_plan": false,
          "plus_plan": true,
        }).eq("user_id", supabase.auth.currentUser!.id);

        authController.user(
          authController.user.value!
            ..freePlan = false
            ..basicPlan = false
            ..plusPlan = true
            ..subscriptionStartDate = now
            ..subscriptionEndDate = subscriptionEndDate
            ..subscribeData = result,
        );
      }
    } catch (e) {
      print("Payment Result Error: $e");
    } finally {
      Get.back();
      Get.back();
    }
  }

  @override
  void onInit() {
    super.onInit();
    getPaymentConfiguration();
  }
}
