import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/anomaly_detection_model.dart';

class AnomalyDetectionService {
  final String baseUrl = 'http://localhost:8080/api';

  Future<AnomalyDetectionModel> detectAnomaly() async {
    final response = await http.get(Uri.parse('$baseUrl/anomaly-detector'));

    if (response.statusCode == 200) {
      return AnomalyDetectionModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to detect anomaly');
    }
  }
}
