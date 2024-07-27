class PlanModel {
  final String name;
  final double? price;
  final bool? free;
  final List<FeaturePlan> features;

  PlanModel({
    required this.name,
    this.price,
    this.free = false,
    required this.features,
  });
}

class FeaturePlan {
  final String feature;
  final bool activeFeature;

  FeaturePlan({required this.feature, required this.activeFeature});
}
