import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../services/browsing_monitor_service.dart';

class BrowsingMonitorScreen extends StatefulWidget {
  @override
  _BrowsingMonitorScreenState createState() => _BrowsingMonitorScreenState();
}

class _BrowsingMonitorScreenState extends State<BrowsingMonitorScreen> {
  final BrowsingMonitorService _service = BrowsingMonitorService();
  final TextEditingController _urlController = TextEditingController();
  String _statusMessage = 'Press the button to monitor browsing activity.';
  List<String> _checkedUrls = [];
  double _progress = 0.0;
  bool _isMonitoring = false;

  void _monitorBrowsing() async {
    setState(() {
      _isMonitoring = true;
      _statusMessage = 'Monitoring browsing activity...';
      _checkedUrls = [];
      _progress = 0.0;
    });

    try {
      // List of URLs to simulate monitoring
      final List<String> urlsToCheck = [
        "https://example.com",
        "https://malicious-site.com",
        "https://secure-site.org",
        "http://unsafe-site.net"
      ];

      for (int i = 0; i < urlsToCheck.length; i++) {
        await Future.delayed(Duration(seconds: 1)); // Simulate processing delay
        final url = urlsToCheck[i];
        final isMalicious = await _service.checkUrlReputation(url);

        setState(() {
          _checkedUrls.add("$url: ${isMalicious ? 'Malicious' : 'Safe'}");
          _progress = (i + 1) / urlsToCheck.length;
        });
      }

      setState(() {
        _statusMessage = 'Monitoring complete. See results below.';
      });

      _showFeedbackDialog(
        icon: MdiIcons.checkCircleOutline,
        color: Colors.green,
        title: 'Monitoring Complete',
        message: 'Browsing activity monitoring has finished successfully.',
      );
    } catch (e) {
      setState(() {
        _statusMessage = 'Error: $e';
        _progress = 0.0;
      });

      _showFeedbackDialog(
        icon: MdiIcons.alertCircleOutline,
        color: Colors.redAccent,
        title: 'Error',
        message: 'An error occurred while monitoring: $e',
      );
    } finally {
      setState(() {
        _isMonitoring = false;
      });
    }
  }

  void _checkSingleUrl() async {
    final url = _urlController.text.trim();

    if (url.isEmpty) {
      setState(() {
        _statusMessage = 'Please enter a URL to scan.';
      });
      return;
    }

    setState(() {
      _statusMessage = 'Scanning $url...';
    });

    try {
      final isMalicious = await _service.checkUrlReputation(url);

      setState(() {
        _statusMessage = isMalicious
            ? 'The URL "$url" is marked as malicious!'
            : 'The URL "$url" is safe.';
      });

      _showFeedbackDialog(
        icon: isMalicious ? MdiIcons.alertCircleOutline : MdiIcons.checkCircleOutline,
        color: isMalicious ? Colors.red : Colors.green,
        title: isMalicious ? 'Malicious URL Detected' : 'Safe URL',
        message: _statusMessage,
      );
    } catch (e) {
      setState(() {
        _statusMessage = 'Error scanning URL: $e';
      });

      _showFeedbackDialog(
        icon: MdiIcons.alertCircleOutline,
        color: Colors.redAccent,
        title: 'Error',
        message: 'An error occurred while scanning the URL: $e',
      );
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
              onPressed: () => Navigator.of(context).pop(),
              child: Text('OK', style: TextStyle(color: color)),
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
              Text('About Browsing Monitor'),
            ],
          ),
          content: Text(
            'The Browsing Monitor checks for malicious patterns or suspicious URLs '
            'in browsing activities. It analyzes browsing packets and alerts administrators '
            'when potential threats are detected. You can also manually scan a specific URL.',
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
        title: Text('Browsing Monitor'),
        leading: IconButton(
          icon: Icon(MdiIcons.arrowLeft), // Back button icon
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            FaIcon(
              FontAwesomeIcons.globe,
              size: 80,
              color: theme.primaryColor,
            ),
            SizedBox(height: 20),
            Text(
              'Browsing Monitor',
              style: theme.textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            TextField(
              controller: _urlController,
              decoration: InputDecoration(
                labelText: 'Enter URL to scan',
                border: OutlineInputBorder(),
                prefixIcon: Icon(MdiIcons.web),
              ),
              keyboardType: TextInputType.url,
              textInputAction: TextInputAction.done,
            ),
            SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _checkSingleUrl,
              icon: Icon(MdiIcons.searchWeb),
              label: Text('Scan URL'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
            SizedBox(height: 20),
            LinearProgressIndicator(
              value: _isMonitoring ? _progress : null,
              backgroundColor: Colors.grey[300],
              color: theme.primaryColor,
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _checkedUrls.length,
                itemBuilder: (context, index) {
                  final urlStatus = _checkedUrls[index];
                  return ListTile(
                    leading: Icon(
                      urlStatus.contains('Malicious')
                          ? MdiIcons.alertCircleOutline
                          : MdiIcons.checkCircleOutline,
                      color: urlStatus.contains('Malicious') ? Colors.red : Colors.green,
                    ),
                    title: Text(
                      urlStatus,
                      style: theme.textTheme.bodyMedium,
                    ),
                  );
                },
              ),
            ),
            ElevatedButton.icon(
              onPressed: _isMonitoring ? null : _monitorBrowsing,
              icon: _isMonitoring
                  ? CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      strokeWidth: 2,
                    )
                  : Icon(MdiIcons.web),
              label: Text(_isMonitoring ? 'Monitoring...' : 'Monitor Browsing'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
