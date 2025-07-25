import 'package:flutter/material.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:workmanager/workmanager.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../services/network_monitor_service.dart';
import '../models/network_monitor_model.dart';
import 'network_logs_screen.dart';

// Background task callback
void backgroundTaskCallback() {
  debugPrint("Background network monitoring is running.");
}

class NetworkMonitorScreen extends StatefulWidget {
  @override
  _NetworkMonitorScreenState createState() => _NetworkMonitorScreenState();
}

class _NetworkMonitorScreenState extends State<NetworkMonitorScreen> {
  final NetworkMonitorService _service = NetworkMonitorService();
  String _result = 'Press the button to monitor network activity.';
  bool _isMonitoring = false;
  bool _isBackgroundMonitoringEnabled = false;

  /// Start manual monitoring
  void _startMonitoring() async {
    setState(() {
      _isMonitoring = true;
    });

    try {
      NetworkMonitorModel response = await _service.monitorNetwork();
      setState(() {
        _result = response.message;
      });
    } catch (e) {
      setState(() {
        _result = 'Error: $e';
      });
    } finally {
      setState(() {
        _isMonitoring = false;
      });
    }
  }

  /// Enable or disable background monitoring
  void _toggleBackgroundMonitoring(bool enabled) async {
    setState(() {
      _isBackgroundMonitoringEnabled = enabled;
    });

    if (enabled) {
      if (Theme.of(context).platform == TargetPlatform.android) {
        await AndroidAlarmManager.periodic(
          const Duration(minutes: 15),
          0, // Unique ID for the alarm
          backgroundTaskCallback,
          wakeup: true,
        );
        setState(() {
          _result = 'Background monitoring enabled.';
        });
      } else if (Theme.of(context).platform == TargetPlatform.iOS) {
        await Workmanager().registerPeriodicTask(
          'network_monitoring_task',
          'networkMonitoring',
          frequency: const Duration(minutes: 15),
        );
        setState(() {
          _result = 'Background monitoring enabled.';
        });
      }
    } else {
      if (Theme.of(context).platform == TargetPlatform.android) {
        await AndroidAlarmManager.cancel(0);
      } else if (Theme.of(context).platform == TargetPlatform.iOS) {
        await Workmanager().cancelAll();
      }
      setState(() {
        _result = 'Background monitoring disabled.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Network Monitor'),
        leading: IconButton(
          icon: const Icon(MdiIcons.arrowLeft),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(MdiIcons.informationOutline),
            onPressed: () {
              _showInfoDialog(context);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FaIcon(
              FontAwesomeIcons.networkWired,
              size: 80,
              color: theme.primaryColor,
            ),
            const SizedBox(height: 20),
            Text(
              'Network Monitor',
              style: theme.textTheme.titleLarge,
            ),
            const SizedBox(height: 20),
            Text(
              _result,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyLarge,
            ),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: _isMonitoring ? null : _startMonitoring,
              icon: _isMonitoring
                  ? const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      strokeWidth: 2,
                    )
                  : const Icon(MdiIcons.monitorCellphone),
              label: Text(_isMonitoring ? 'Monitoring...' : 'Start Monitoring'),
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
            const SizedBox(height: 20),
            const Divider(),
            SwitchListTile(
              title: const Text('Enable Background Monitoring'),
              subtitle: const Text(
                'Monitor network activity even when the app is closed.',
              ),
              value: _isBackgroundMonitoringEnabled,
              onChanged: _toggleBackgroundMonitoring,
            ),
            const Divider(),
            _buildLogDetails(context),
          ],
        ),
      ),
    );
  }

  Widget _buildLogDetails(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).primaryColor.withOpacity(0.2),
          child: Icon(
            MdiIcons.fileDocument,
            color: Theme.of(context).primaryColor,
          ),
        ),
        title: const Text('View Logs'),
        subtitle: const Text('See suspicious activity logs.'),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NetworkLogsScreen(),
            ),
          );
        },
      ),
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
              const SizedBox(width: 10),
              const Text('About Network Monitor'),
            ],
          ),
          content: const Text(
            'The Network Monitor tracks suspicious activities such as '
            'connections to known malicious IPs or abnormal ports. It logs any '
            'unusual activity for further review.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
}
