import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/scanner_model.dart';

class ScanningService {
  final String baseUrl = 'http://localhost:8080/api';

  /// Perform a system-wide scan
  Future<ScannerModel> startSystemWideScan() async {
    try {
      final response = await http.post(Uri.parse('$baseUrl/scanner'));

      if (response.statusCode == 200) {
        return ScannerModel.fromJson(json.decode(response.body));
      } else {
        throw Exception(
            'Failed to start system-wide scan. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error during system-wide scan: $e');
    }
  }

  /// Stop an ongoing system-wide scan
  Future<void> stopSystemWideScan() async {
    try {
      final response = await http.delete(Uri.parse('$baseUrl/scanner'));

      if (response.statusCode != 200) {
        throw Exception(
            'Failed to stop the system-wide scan. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error while stopping the scan: $e');
    }
  }

  /// Scan a single file for malware
  Future<ScannerModel> scanFile(String filePath) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/scanner/file'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'filePath': filePath}),
      );

      if (response.statusCode == 200) {
        return ScannerModel.fromJson(json.decode(response.body));
      } else {
        throw Exception(
            'Failed to scan file. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error during file scan: $e');
    }
  }

  /// Perform a real-time scan (placeholder for actual API endpoint)
  Future<ScannerModel> performRealTimeScan() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/real-time-scan'));

      if (response.statusCode == 200) {
        return ScannerModel.fromJson(json.decode(response.body));
      } else {
        throw Exception(
            'Failed to perform real-time scan. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error during real-time scan: $e');
    }
  }

  /// Perform sandbox analysis of a file
  Future<ScannerModel> performSandboxAnalysis(String filePath) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/sandbox-analysis'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'filePath': filePath}),
      );

      if (response.statusCode == 200) {
        return ScannerModel.fromJson(json.decode(response.body));
      } else {
        throw Exception(
            'Failed to perform sandbox analysis. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error during sandbox analysis: $e');
    }
  }
}
