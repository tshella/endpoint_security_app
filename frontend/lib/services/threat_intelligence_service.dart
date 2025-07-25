import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/threat_intelligence_model.dart';

class ThreatIntelligenceService {
  final String baseUrl = 'http://localhost:8080/api';

  Future<ThreatIntelligenceModel> fetchThreatIntel() async {
    final response = await http.get(Uri.parse('$baseUrl/threat-intelligence'));

    if (response.statusCode == 200) {
      return ThreatIntelligenceModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to fetch threat intelligence');
    }
  }
}
