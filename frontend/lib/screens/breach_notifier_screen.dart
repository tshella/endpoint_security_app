import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class BreachNotifierScreen extends StatefulWidget {
  @override
  _BreachNotifierScreenState createState() => _BreachNotifierScreenState();
}

class _BreachNotifierScreenState extends State<BreachNotifierScreen> {
  String _statusMessage = "No notifications yet";

  // Dropdown selections
  int _selectedThreshold = 5; // Default threshold
  int _selectedTimeFrame = 300; // Default time frame in seconds (5 minutes)

  // Options for dropdowns
  final List<int> thresholdOptions = [1, 5, 10, 15, 20];
  final List<int> timeFrameOptions = [60, 300, 600, 1200, 1800]; // In seconds

  final String backendUrl = 'http://localhost:8080/api/breach-notifier';

  Future<void> _setThreshold() async {
    final url = Uri.parse(backendUrl);

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'action': 'setThreshold',
          'threshold': _selectedThreshold,
          'timeFrame': _selectedTimeFrame,
        }),
      );

      if (response.statusCode == 200) {
        setState(() {
          _statusMessage =
              "Threshold set to $_selectedThreshold, Time Frame: ${_selectedTimeFrame ~/ 60} minutes.";
        });
      } else {
        setState(() {
          _statusMessage =
              "Failed to set threshold. Server error: ${response.statusCode}";
        });
      }
    } catch (e) {
      setState(() {
        _statusMessage = "Error setting threshold: $e";
      });
    }
  }

  Future<void> _sendBreachNotification() async {
    final url = Uri.parse(backendUrl);

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'action': 'notifyBreach',
          'message': 'Data breach detected!',
        }),
      );

      if (response.statusCode == 200) {
        setState(() {
          _statusMessage = "Breach notification sent!";
        });
      } else {
        setState(() {
          _statusMessage =
              "Failed to send notification. Server error: ${response.statusCode}";
        });
      }
    } catch (e) {
      setState(() {
        _statusMessage = "Error sending notification: $e";
      });
    }
  }

  void _showFeedbackDialog({
    required IconData icon,
    required Color color,
    required String title,
    required String message,
  }) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          title: Row(
            children: [
              Icon(icon, color: color),
              SizedBox(width: 10),
              Text(title),
            ],
          ),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("OK", style: TextStyle(color: color)),
            ),
          ],
        );
      },
    );
  }

  void _showInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(MdiIcons.information, color: Theme.of(context).primaryColor),
              SizedBox(width: 10),
              Text('About Breach Notifier'),
            ],
          ),
          content: Text(
            'The Breach Notifier helps monitor and respond to potential data breaches. '
            'Configure thresholds for notifications and trigger alerts to address suspicious activities. '
            'Stay proactive in protecting sensitive data.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Breach Notifier"),
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: Icon(FontAwesomeIcons.arrowLeft),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: [
          IconButton(
            icon: Icon(MdiIcons.informationOutline),
            onPressed: () {
              _showInfoDialog(context);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Notification Settings",
                        style: theme.textTheme.titleMedium,
                      ),
                      SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: DropdownButtonFormField<int>(
                              value: _selectedThreshold,
                              items: thresholdOptions.map((value) {
                                return DropdownMenuItem<int>(
                                  value: value,
                                  child: Text(value.toString()),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  _selectedThreshold = value!;
                                });
                              },
                              decoration: InputDecoration(
                                labelText: "Threshold",
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: DropdownButtonFormField<int>(
                              value: _selectedTimeFrame,
                              items: timeFrameOptions.map((value) {
                                return DropdownMenuItem<int>(
                                  value: value,
                                  child: Text("${value ~/ 60} min"),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  _selectedTimeFrame = value!;
                                });
                              },
                              decoration: InputDecoration(
                                labelText: "Time Frame",
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed: () async {
                          await _setThreshold();
                          _showFeedbackDialog(
                            icon: MdiIcons.checkCircleOutline,
                            color: Colors.green,
                            title: "Settings Updated",
                            message: "Notification settings updated successfully.",
                          );
                        },
                        icon: Icon(MdiIcons.cogOutline),
                        label: Text("Set Notification Settings"),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Trigger Notification",
                        style: theme.textTheme.titleMedium,
                      ),
                      SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed: () async {
                          await _sendBreachNotification();
                          _showFeedbackDialog(
                            icon: MdiIcons.alertOutline,
                            color: Colors.redAccent,
                            title: "Notification Sent",
                            message: "Breach notification sent successfully.",
                          );
                        },
                        icon: Icon(MdiIcons.alert),
                        label: Text("Send Breach Notification"),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text(
                "Status: $_statusMessage",
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
