import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class NetworkLogsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Network Logs'),
        leading: IconButton(
          icon: Icon(MdiIcons.arrowLeft), // Back button icon
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Center(
        child: Text(
          'No logs available yet.',
          style: Theme.of(context).textTheme.bodyMedium, // Updated for latest API
        ),
      ),
    );
  }
}
