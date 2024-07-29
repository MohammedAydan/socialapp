import 'package:get/get.dart';
import 'package:pay/pay.dart';
import 'package:socialapp/features/auth/controllers/auth_controller.dart';
import 'package:socialapp/global/models/pay_result.dart';
import 'package:socialapp/main.dart';
import 'package:socialapp/widgets/loading.dart';

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
