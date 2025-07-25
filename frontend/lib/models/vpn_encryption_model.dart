class VpnEncryptionModel {
  final String message;

  VpnEncryptionModel({required this.message});

  factory VpnEncryptionModel.fromJson(Map<String, dynamic> json) {
    return VpnEncryptionModel(
      message: json['message'],
    );
  }
}
