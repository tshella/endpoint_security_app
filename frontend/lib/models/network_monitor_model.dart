class NetworkMonitorModel {
  final String message;

  NetworkMonitorModel({required this.message});

  factory NetworkMonitorModel.fromJson(Map<String, dynamic> json) {
    return NetworkMonitorModel(
      message: json['message'],
    );
  }
}
