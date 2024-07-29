import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:socialapp/global/models/plan_model.dart';
import 'package:socialapp/widgets/custom_primary_button.dart';

class PlanPage extends StatelessWidget {
  const PlanPage({
    super.key,
    required this.planModel,
    this.payButton,
  });

  final PlanModel planModel;
  final Widget? payButton;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(40),
      child: Center(
        child: Container(
          width: 400,
          height: 500,
          decoration: BoxDecoration(
            color: context.theme.colorScheme.tertiary,
            borderRadius: BorderRadius.circular(20),
            border: planModel.name.toLowerCase().contains("pro")
                ? Border.all(width: 1, color: Get.theme.colorScheme.primary)
                : null,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                spreadRadius: 5,
              ),
            ],
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                planModel.name,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Center(
                child: Image.asset(
                  "assets/icons/logo-v2.png",
                  width: 100,
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: planModel.features.length,
                  itemBuilder: (context, i) {
                    FeaturePlan feature = planModel.features[i];
                    return _buildFeatureRow(
                      feature.feature,
                      feature.activeFeature,
                    );
                  },
                ),
              ),
              const SizedBox(width: 10),
              Center(
                child: Text(
                  "${planModel.price}\$",
                  style: TextStyle(
                    color: Get.theme.colorScheme.primary,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              planModel.free == true
                  ? const CustomPrimaryButton(text: "Free")
                  : payButton != null
                      ? payButton!
                      : const CustomPrimaryButton(text: "Free"),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureRow(String featureText, bool status) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            featureText,
            style: const TextStyle(fontSize: 16),
          ),
          status
              ? const Icon(Icons.verified_rounded, color: Colors.blueAccent)
              : Icon(Icons.close_rounded, color: Get.theme.colorScheme.primary)
        ],
      ),
    );
  }
}
