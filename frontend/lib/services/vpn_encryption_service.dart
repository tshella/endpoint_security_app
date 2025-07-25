import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/vpn_encryption_model.dart';

class VpnEncryptionService {
  final String baseUrl = 'http://localhost:8080/api';

  Future<VpnEncryptionModel> initializeEncryption() async {
    final response = await http.post(Uri.parse('$baseUrl/vpn-encryption'));

    if (response.statusCode == 200) {
      return VpnEncryptionModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to initialize VPN encryption');
    }
  }
}
