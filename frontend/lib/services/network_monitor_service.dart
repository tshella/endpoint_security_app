import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/network_monitor_model.dart';

class NetworkMonitorService {
  final String baseUrl = 'http://localhost:8080/api';

  Future<NetworkMonitorModel> monitorNetwork() async {
    final response = await http.get(Uri.parse('$baseUrl/network-monitor'));

    if (response.statusCode == 200) {
      return NetworkMonitorModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to monitor network');
    }
  }
}
