import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:workmanager/workmanager.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';

class VpnScreen extends StatefulWidget {
  @override
  _VpnScreenState createState() => _VpnScreenState();
}

class _VpnScreenState extends State<VpnScreen> {
  bool _isVpnConnected = false;
  bool _isMonitoringEnabled = false;
  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    _initializeNotifications();
  }

  // Initialize notifications
  void _initializeNotifications() async {
    const initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    await _notificationsPlugin.initialize(initializationSettings);
  }

  // Show notification
  Future<void> _showNotification(String title, String body) async {
    const androidDetails = AndroidNotificationDetails(
      'vpn_channel',
      'VPN Notifications',
      importance: Importance.max,
      priority: Priority.high,
    );
    const notificationDetails = NotificationDetails(android: androidDetails);
    await _notificationsPlugin.show(0, title, body, notificationDetails);
  }

  // Connect to VPN
  void _connectVpn() {
    setState(() {
      _isVpnConnected = true;
    });
    _showNotification('VPN Connected', 'Your VPN connection is active.');
  }

  // Disconnect from VPN
  void _disconnectVpn() {
    setState(() {
      _isVpnConnected = false;
    });
    _showNotification('VPN Disconnected', 'Your VPN connection has been terminated.');
  }

  // Validate VPN Security
  void _validateVpnSecurity() {
    bool isSecure = (DateTime.now().millisecondsSinceEpoch % 100) > 20; // Simulate validation
    if (isSecure) {
      _showNotification('VPN Secure', 'Your VPN connection is secure.');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('VPN connection is secure!')),
      );
    } else {
      _showNotification('VPN Alert', 'Your VPN connection is not secure.');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('VPN connection validation failed!')),
      );
    }
  }

  // Start background monitoring
  void _toggleMonitoring(bool enabled) async {
    setState(() {
      _isMonitoringEnabled = enabled;
    });

    if (enabled) {
      await Workmanager().registerPeriodicTask(
        'vpn_monitor_task',
        'vpnMonitoring',
        frequency: const Duration(minutes: 15),
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('VPN Monitoring Enabled')),
      );
    } else {
      await Workmanager().cancelAll();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('VPN Monitoring Disabled')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(MdiIcons.arrowLeft),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('VPN Manager'),
        actions: [
          IconButton(
            icon: const Icon(MdiIcons.informationOutline),
            onPressed: () => _showInfoDialog(),
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const FaIcon(
                FontAwesomeIcons.shieldAlt,
                size: 80,
                color: Colors.blueAccent,
              ),
              const SizedBox(height: 20),
              Text(
                'VPN Status: ${_isVpnConnected ? 'Connected' : 'Disconnected'}',
                style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: _isVpnConnected ? _disconnectVpn : _connectVpn,
                icon: Icon(_isVpnConnected ? MdiIcons.lockOpen : MdiIcons.lock),
                label: Text(_isVpnConnected ? 'Disconnect VPN' : 'Connect VPN'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: _validateVpnSecurity,
                icon: const Icon(MdiIcons.checkDecagram),
                label: const Text('Validate Security'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
              ),
              const SizedBox(height: 20),
              SwitchListTile(
                title: const Text('Enable VPN Monitoring'),
                subtitle: const Text(
                  'Monitor VPN connection for unusual activity in the background.',
                ),
                value: _isMonitoringEnabled,
                onChanged: _toggleMonitoring,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Show Information Dialog
  void _showInfoDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(MdiIcons.informationOutline, color: Theme.of(context).primaryColor),
              const SizedBox(width: 10),
              const Text('About VPN Manager'),
            ],
          ),
          content: const Text(
            'The VPN Manager helps you connect and disconnect from your VPN, validate its security, '
            'and monitor for suspicious activity. Enable monitoring for continuous background checks.',
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
