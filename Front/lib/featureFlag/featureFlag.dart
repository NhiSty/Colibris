class FeatureFlag {
  final int id;
  final String name;
  bool value;

  FeatureFlag({
    required this.id,
    required this.name,
    required this.value,
  });

  factory FeatureFlag.fromJson(Map<String, dynamic> json) {
    return FeatureFlag(
      id: json['ID'] ?? 0,
      name: json['Name'] ?? '',
      value: json['Value'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ID': id,
      'Name': name,
      'Value': value,
    };
  }
}
