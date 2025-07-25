import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/breach_notifier_model.dart';

class BreachNotifierService {
  final String baseUrl = 'http://localhost:8080/api';

  Future<BreachNotifierModel> notifyBreach() async {
    final response = await http.get(Uri.parse('$baseUrl/breach-notifier'));

    if (response.statusCode == 200) {
      return BreachNotifierModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to notify breach');
    }
  }
}
