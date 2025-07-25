class AnomalyDetectionModel {
  final String message;
  final bool isAnomalous;
  final double value;

  AnomalyDetectionModel({
    required this.message,
    required this.isAnomalous,
    required this.value,
  });

  factory AnomalyDetectionModel.fromJson(Map<String, dynamic> json) {
    return AnomalyDetectionModel(
      message: json['message'],
      isAnomalous: json['is_anomalous'],
      value: json['value'].toDouble(),
    );
  }
}
