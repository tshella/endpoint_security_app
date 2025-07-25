import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/browsing_monitor_model.dart';

class BrowsingMonitorService {
  final String _baseUrl = 'http://localhost:8080/api/browsing-monitor';

  /// Simulates monitoring browsing activity
  Future<BrowsingMonitorModel> monitorBrowsing() async {
    final url = Uri.parse('$_baseUrl/monitor');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return BrowsingMonitorModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to monitor browsing activity');
    }
  }

  /// Checks the reputation of a given URL
  Future<bool> checkUrlReputation(String urlToCheck) async {
    final url = Uri.parse('$_baseUrl/check-url');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'url': urlToCheck}),
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      return responseData['isMalicious'] as bool;
    } else {
      throw Exception('Failed to check URL reputation');
    }
  }
}
