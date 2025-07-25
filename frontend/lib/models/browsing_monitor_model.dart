class BrowsingMonitorModel {
  final String message;

  BrowsingMonitorModel({required this.message});

  factory BrowsingMonitorModel.fromJson(Map<String, dynamic> json) {
    return BrowsingMonitorModel(
      message: json['message'],
    );
  }
}
