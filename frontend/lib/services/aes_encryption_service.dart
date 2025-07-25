import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/aes_encryption_model.dart';

class AesEncryptionService {
  final String baseUrl = 'http://localhost:8080/api';

  Future<AesEncryptionModel> initializeEncryption() async {
    final response = await http.get(Uri.parse('$baseUrl/aes-encryption'));

    if (response.statusCode == 200) {
      return AesEncryptionModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to initialize AES encryption');
    }
  }
}
