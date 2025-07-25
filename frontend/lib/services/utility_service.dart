import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/utility_model.dart';

class UtilityService {
  final String baseUrl = 'http://localhost:8080/api';

  Future<UtilityModel> generatePassword(int length, bool includeSpecialChars) async {
    final response = await http.post(
      Uri.parse('$baseUrl/utility'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'length': length,
        'include_special_chars': includeSpecialChars,
      }),
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return UtilityModel.fromJson(jsonData);
    } else {
      throw Exception('Failed to generate password: ${response.statusCode}');
    }
  }
}
