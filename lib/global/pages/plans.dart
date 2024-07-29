import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pay/pay.dart';
import '../controllers/plans_controller.dart';
import '../models/plan_model.dart';
import '../widgets/plan_page.dart';

class Plans extends StatelessWidget {
  Plans({super.key});

  final controller = Get.put(PlansController());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 5,
            ),
            decoration: BoxDecoration(
              color: context.theme.colorScheme.tertiary,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text("${controller.currentPage.value + 1}/3"),
          ),
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
