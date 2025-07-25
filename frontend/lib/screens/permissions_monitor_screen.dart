import 'package:flutter/material.dart';
import '../services/permissions_monitor_service.dart';
import '../models/permissions_monitor_model.dart';

class PermissionsMonitorScreen extends StatefulWidget {
  @override
  _PermissionsMonitorScreenState createState() => _PermissionsMonitorScreenState();
}

class _PermissionsMonitorScreenState extends State<PermissionsMonitorScreen> {
  final PermissionsMonitorService _service = PermissionsMonitorService();
  String _result = 'Press the button to check permissions.';

  void _checkPermissions() async {
    try {
      PermissionsMonitorModel response = await _service.checkPermissions();
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
      appBar: AppBar(title: Text('Permissions Monitor')),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(_result),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _checkPermissions,
                child: Text('Check Permissions'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
