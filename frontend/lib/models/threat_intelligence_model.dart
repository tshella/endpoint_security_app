class ThreatIntelligenceModel {
  final String message;

  ThreatIntelligenceModel({required this.message});

  factory ThreatIntelligenceModel.fromJson(Map<String, dynamic> json) {
    return ThreatIntelligenceModel(
      message: json['message'],
    );
  }
}
