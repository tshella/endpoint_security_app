class PermissionsMonitorModel {
  final String message;

  PermissionsMonitorModel({required this.message});

  factory PermissionsMonitorModel.fromJson(Map<String, dynamic> json) {
    return PermissionsMonitorModel(
      message: json['message'],
    );
  }
}
