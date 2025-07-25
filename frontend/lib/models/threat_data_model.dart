class ThreatDataModel {
  final String name;
  final int count;

  ThreatDataModel(this.name, this.count);

  factory ThreatDataModel.fromJson(Map<String, dynamic> json) {
    return ThreatDataModel(
      json['name'] as String,
      json['count'] as int,
    );
  }
}
