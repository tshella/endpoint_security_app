import 'dart:convert';
import 'package:http/http.dart' as http;

class FileIntegrityService {
  final String baseUrl = 'http://localhost:8080/api/file-integrity';

  Future<void> startIntegrityCheck(String filePath) async {
    final response = await http.post(
      Uri.parse('$baseUrl/start'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'filePath': filePath}),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to start file integrity check');
    }
  }

  Future<void> pauseIntegrityCheck() async {
    final response = await http.post(Uri.parse('$baseUrl/pause'));
    if (response.statusCode != 200) {
      throw Exception('Failed to pause file integrity check');
    }
  }

  Future<void> resumeIntegrityCheck() async {
    final response = await http.post(Uri.parse('$baseUrl/resume'));
    if (response.statusCode != 200) {
      throw Exception('Failed to resume file integrity check');
    }
  }

  Future<void> stopIntegrityCheck() async {
    final response = await http.post(Uri.parse('$baseUrl/stop'));
    if (response.statusCode != 200) {
      throw Exception('Failed to stop file integrity check');
    }
  }

  Future<int> getProgress() async {
    final response = await http.get(Uri.parse('$baseUrl/progress'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['progress'] is int) {
        return data['progress']; // Ensure it's an integer
      } else {
        throw Exception('Invalid progress format from server');
      }
    } else {
      throw Exception('Failed to get progress');
    }
  }
}
