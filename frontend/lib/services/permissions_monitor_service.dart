import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/permissions_monitor_model.dart';

class PermissionsMonitorService {
  final String baseUrl = 'http://localhost:8080/api';

  Future<PermissionsMonitorModel> checkPermissions() async {
    final response = await http.get(Uri.parse('$baseUrl/permissions-monitor'));

    if (response.statusCode == 200) {
      return PermissionsMonitorModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to check permissions');
    }
  }
}
