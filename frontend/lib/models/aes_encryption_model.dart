class AesEncryptionModel {
  final String message;

  AesEncryptionModel({required this.message});

  factory AesEncryptionModel.fromJson(Map<String, dynamic> json) {
    return AesEncryptionModel(
      message: json['message'],
    );
  }
}
