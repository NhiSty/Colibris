// create a feature flag class with th property name and value

class FeatureFlag {
  final String name;
  final bool value;

  FeatureFlag({
    required this.name,
    required this.value,
  });

  factory FeatureFlag.fromJson(Map<String, dynamic> json) {
    return FeatureFlag(
      name: json['Name'],
      value: json['Value'],
    );
  }
}
