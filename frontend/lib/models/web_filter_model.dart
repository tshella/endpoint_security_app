class WebFilterModel {
  final String message;

  WebFilterModel({required this.message});

  factory WebFilterModel.fromJson(Map<String, dynamic> json) {
    return WebFilterModel(
      message: json['message'] ?? 'Unknown response',
    );
  }
}