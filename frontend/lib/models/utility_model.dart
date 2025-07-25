class UtilityModel {
  final String generatedPassword;

  UtilityModel({required this.generatedPassword});

  factory UtilityModel.fromJson(Map<String, dynamic> json) {
    return UtilityModel(
      generatedPassword: json['generated_password'] ?? '',
    );
  }
}
