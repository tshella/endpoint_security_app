class VpnModel {
  final String message;

  VpnModel({required this.message});

  factory VpnModel.fromJson(Map<String, dynamic> json) {
    return VpnModel(
      message: json['message'],
    );
  }
}
