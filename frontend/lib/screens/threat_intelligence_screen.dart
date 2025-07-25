import 'package:flutter/material.dart';
import '../services/threat_intelligence_service.dart';
import '../models/threat_intelligence_model.dart';

class ThreatIntelligenceScreen extends StatefulWidget {
  @override
  _ThreatIntelligenceScreenState createState() => _ThreatIntelligenceScreenState();
}

class _ThreatIntelligenceScreenState extends State<ThreatIntelligenceScreen> {
  final ThreatIntelligenceService _service = ThreatIntelligenceService();
  String _result = 'Press the button to update threat intelligence.';

  void _fetchThreatIntel() async {
    try {
      ThreatIntelligenceModel response = await _service.fetchThreatIntel();
      setState(() {
        _result = response.message;
      });
    } catch (e) {
      setState(() {
        _result = 'Error: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Threat Intelligence')),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(_result),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _fetchThreatIntel,
                child: Text('Update Threat Intelligence'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
