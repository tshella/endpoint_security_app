import 'threat_data_model.dart';

class ScannerModel {
  final String message;
  final List<ThreatDataModel> threats;

  ScannerModel({
    required this.message,
    required this.threats,
  });

  factory ScannerModel.fromJson(Map<String, dynamic> json) {
    return ScannerModel(
      message: json['message'] as String,
      threats: (json['threats'] as List<dynamic>? ?? []) // Handle null or missing 'threats'
          .map((e) => ThreatDataModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  bool get isThreatDetected => threats.isNotEmpty;
}

