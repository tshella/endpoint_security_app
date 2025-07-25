class SignatureDatabaseModel {
  final String message;
  final List<String> signatures;

  SignatureDatabaseModel({required this.message, required this.signatures});

  factory SignatureDatabaseModel.fromJson(Map<String, dynamic> json) {
    return SignatureDatabaseModel(
      message: json['message'],
      signatures: List<String>.from(json['signatures']),
    );
  }
}
