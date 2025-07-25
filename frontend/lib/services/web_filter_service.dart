import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/web_filter_model.dart';

class WebFilterService {
  final String baseUrl = 'http://localhost:8080/api';

  Future<WebFilterModel> applyWebFilter(String url) async {
    final response = await http.post(
      Uri.parse('$baseUrl/web-filter'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'url': url}),
    );

    if (response.statusCode == 200) {
      return WebFilterModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to filter URL');
    }
  }
}