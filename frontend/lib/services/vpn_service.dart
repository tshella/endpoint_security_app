import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/vpn_model.dart';

class VpnService {
  final String baseUrl = 'http://localhost:8080/api';

  Future<VpnModel> manageVpn() async {
    final response = await http.get(Uri.parse('$baseUrl/vpn'));

    if (response.statusCode == 200) {
      return VpnModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to manage VPN');
    }
  }
}
