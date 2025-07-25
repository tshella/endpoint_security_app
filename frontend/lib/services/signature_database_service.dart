import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/signature_database_model.dart';

class SignatureDatabaseService {
  final String baseUrl = 'http://localhost:8080/api';

  Future<SignatureDatabaseModel> loadSignatures() async {
    final response = await http.get(Uri.parse('$baseUrl/signature-database'));

    if (response.statusCode == 200) {
      return SignatureDatabaseModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load signatures: ${response.reasonPhrase}');
    }
  }

  Future<void> addSignature(String signature) async {
    final response = await http.post(
      Uri.parse('$baseUrl/signature-database/add'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'signature': signature}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to add signature: ${response.reasonPhrase}');
    }
  }
}
