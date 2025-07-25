import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:file_picker/file_picker.dart'; // Add this package for file selection
import '../services/scanning_service.dart';
import '../models/scanner_model.dart';
import '../models/threat_data_model.dart';

class ScannerScreen extends StatefulWidget {
  @override
  _ScannerScreenState createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  final ScanningService _service = ScanningService();
  String _result = 'Press the button to start scanning.';
  bool _isScanning = false;
  double _scanProgress = 0.0;
  String _currentScanningItem = '';
  List<ThreatDataModel> _threats = [];

  void _startScan() async {
    setState(() {
      _isScanning = true;
      _scanProgress = 0.0;
      _currentScanningItem = 'Initializing...';
      _result = 'Scanning in progress...';
    });

    try {
      // Simulate progress updates
      for (int i = 1; i <= 100; i++) {
        await Future.delayed(Duration(milliseconds: 50), () {
          setState(() {
            _scanProgress = i / 100;
            _currentScanningItem = 'Scanning item $i of 100...'; // Update current item
          });
        });
      }

      final response = await _service.startSystemWideScan();
      setState(() {
        _result = response.message;
        _threats = response.threats;
      });

      _showScanResultsDialog();
    } catch (e) {
      setState(() {
        _result = 'Error: $e';
      });
    } finally {
      setState(() {
        _isScanning = false;
        _scanProgress = 0.0;
        _currentScanningItem = '';
      });
    }
  }

  void _stopScan() async {
    setState(() {
      _isScanning = false;
      _result = 'Scan stopped.';
      _scanProgress = 0.0;
      _currentScanningItem = '';
    });
    try {
      await _service.stopSystemWideScan();
    } catch (e) {
      setState(() {
        _result = 'Error stopping scan: $e';
      });
    }
  }

  void _scanFile() async {
    try {
      // Use FilePicker to select a file
      FilePickerResult? result = await FilePicker.platform.pickFiles();
      if (result != null && result.files.single.path != null) {
        String filePath = result.files.single.path!;
        setState(() {
          _result = 'Scanning file: $filePath';
        });

        final response = await _service.scanFile(filePath);
        setState(() {
          _result = response.message;
          if (response.isThreatDetected) {
            _threats.add(ThreatDataModel(filePath, 1));
          }
        });

        _showScanResultsDialog();
      }
    } catch (e) {
      setState(() {
        _result = 'Error scanning file: $e';
      });
    }
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
              Text('About Scanner'),
            ],
          ),
          content: Text(
            'The scanner performs a system-wide scan, real-time monitoring, and '
            'file-specific scans. It detects potential threats using multiple '
            'methods like pattern-based detection and heuristic analysis.',
          ),
          actions: [
            IconButton(
              icon: Icon(MdiIcons.arrowLeft),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }

  void _showScanResultsDialog() {
    if (_threats.isEmpty) {
      // Inform user no threats were found
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Scan Complete'),
            content: Text('No threats were found on your system.'),
            actions: [
              IconButton(
                icon: Icon(MdiIcons.arrowLeft),
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
              ),
            ],
          );
        },
      );
    } else {
      // Show threats and provide actions
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Threats Detected'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('The following threats were found:'),
                SizedBox(height: 8),
                ..._threats.map((threat) => ListTile(
                      title: Text(threat.name),
                      subtitle: Text('Occurrences: ${threat.count}'),
                    )),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  // Handle move to vault action
                  setState(() {
                    _result = 'Threats moved to vault.';
                    _threats.clear(); // Clear threats after moving to vault
                  });
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: Text('Move to Vault'),
              ),
              TextButton(
                onPressed: () {
                  // Handle delete action
                  setState(() {
                    _result = 'Threats permanently deleted.';
                    _threats.clear(); // Clear threats after deletion
                  });
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: Text('Delete Permanently'),
              ),
              IconButton(
                icon: Icon(MdiIcons.arrowLeft),
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Scanner'),
        leading: IconButton(
          icon: Icon(MdiIcons.arrowLeft),
          onPressed: () {
            Navigator.of(context).pop(); // Navigate back
          },
        ),
        actions: [
          IconButton(
            icon: Icon(MdiIcons.informationOutline),
            onPressed: () => _showInfoDialog(context),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Scan Status
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Scan Status',
                      style: theme.textTheme.titleMedium,
                    ),
                    SizedBox(height: 8),
                    Text(
                      _result,
                      style: theme.textTheme.bodyMedium,
                    ),
                    SizedBox(height: 8),
                    if (_isScanning) ...[
                      LinearProgressIndicator(value: _scanProgress),
                      SizedBox(height: 8),
                      Text(
                        _currentScanningItem,
                        style: theme.textTheme.bodySmall,
                      ),
                    ],
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
            // Threats Overview Chart
            Expanded(
              child: SfCartesianChart(
                title: ChartTitle(text: 'Threats Overview'),
                primaryXAxis: CategoryAxis(),
                series: <ChartSeries>[
                  BarSeries<ThreatDataModel, String>(
                    dataSource: _threats,
                    xValueMapper: (ThreatDataModel data, _) => data.name,
                    yValueMapper: (ThreatDataModel data, _) => data.count,
                    color: theme.colorScheme.primary,
                    dataLabelSettings: DataLabelSettings(isVisible: true),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            // Scan Actions
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton.icon(
                  onPressed: _isScanning ? null : _startScan,
                  icon: Icon(MdiIcons.play),
                  label: Text('Start Scan'),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: _isScanning ? _stopScan : null,
                  icon: Icon(MdiIcons.stop),
                  label: Text('Stop Scan'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: _scanFile,
                  icon: Icon(MdiIcons.fileOutline),
                  label: Text('Scan File'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
