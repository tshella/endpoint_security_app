import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../services/anomaly_detection_service.dart';
import '../models/anomaly_detection_model.dart';

class AnomalyDetectionScreen extends StatefulWidget {
  @override
  _AnomalyDetectionScreenState createState() => _AnomalyDetectionScreenState();
}

class _AnomalyDetectionScreenState extends State<AnomalyDetectionScreen> {
  final AnomalyDetectionService _service = AnomalyDetectionService();
  String _result = 'Press the button to check for anomalies.';
  bool _isDetecting = false;
  bool _isDetectionEnabled = false; // Toggle state for detection
  List<ChartData> _normalData = []; // Normal activity data
  List<ChartData> _anomalousData = []; // Anomalous activity data

  void _detectAnomaly() async {
    if (!_isDetectionEnabled) {
      _showFeedbackDialog(
        icon: MdiIcons.alertCircleOutline,
        color: Colors.orange,
        title: 'Detection Disabled',
        message: 'Please enable anomaly detection to proceed.',
      );
      return;
    }

    setState(() {
      _isDetecting = true;
    });

    try {
      AnomalyDetectionModel response = await _service.detectAnomaly();
      setState(() {
        _result = response.message;
        // Simulate adding data to the lists
        if (response.isAnomalous) {
          _anomalousData.add(ChartData(_anomalousData.length, response.value));
        } else {
          _normalData.add(ChartData(_normalData.length, response.value));
        }
      });

      _showFeedbackDialog(
        icon: response.isAnomalous ? MdiIcons.alertCircle : MdiIcons.checkCircleOutline,
        color: response.isAnomalous ? Colors.red : Colors.green,
        title: response.isAnomalous ? 'Anomaly Detected' : 'Detection Complete',
        message: response.message,
      );
    } catch (e) {
      setState(() {
        _result = 'Error: $e';
      });

      _showFeedbackDialog(
        icon: MdiIcons.alertCircleOutline,
        color: Colors.redAccent,
        title: 'Error',
        message: 'An error occurred while detecting anomalies: $e',
      );
    } finally {
      setState(() {
        _isDetecting = false;
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
              Text('About Anomaly Detection'),
            ],
          ),
          content: Text(
            'The Anomaly Detection feature analyzes user activities and identifies '
            'deviations from normal behavior patterns. It uses statistical methods '
            'to compute anomalies based on thresholds, helping detect potential issues.',
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

  Widget _buildGraph() {
    return SfCartesianChart(
      title: ChartTitle(text: 'Activity Analysis'),
      legend: Legend(isVisible: true),
      primaryXAxis: NumericAxis(
        title: AxisTitle(text: 'Time'),
      ),
      primaryYAxis: NumericAxis(
        title: AxisTitle(text: 'Value'),
      ),
      series: <ChartSeries>[
        LineSeries<ChartData, int>(
          name: 'Normal Activity',
          dataSource: _normalData,
          xValueMapper: (ChartData data, _) => data.time,
          yValueMapper: (ChartData data, _) => data.value,
          color: Colors.green,
        ),
        LineSeries<ChartData, int>(
          name: 'Anomalous Activity',
          dataSource: _anomalousData,
          xValueMapper: (ChartData data, _) => data.time,
          yValueMapper: (ChartData data, _) => data.value,
          color: Colors.red,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Anomaly Detection'),
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: Icon(MdiIcons.arrowLeft),
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
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              FaIcon(
                FontAwesomeIcons.chartLine,
                size: 80,
                color: theme.primaryColor,
              ),
              SizedBox(height: 20),
              Text(
                'Anomaly Detection',
                style: theme.textTheme.headlineSmall!.copyWith(color: Colors.blueGrey),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              SwitchListTile(
                title: Text(
                  'Enable Anomaly Detection',
                  style: theme.textTheme.bodyLarge,
                ),
                value: _isDetectionEnabled,
                onChanged: (bool value) {
                  setState(() {
                    _isDetectionEnabled = value;
                  });
                },
                secondary: Icon(MdiIcons.toggleSwitch),
              ),
              SizedBox(height: 20),
              _buildGraph(),
              SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: _isDetecting ? null : _detectAnomaly,
                icon: _isDetecting
                    ? CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        strokeWidth: 2,
                      )
                    : Icon(MdiIcons.magnify),
                label: Text(_isDetecting ? 'Detecting...' : 'Detect Anomaly'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  backgroundColor: Colors.blueAccent,
                ),
              ),
              SizedBox(height: 20),
              Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                color: Colors.grey[900],
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    _result,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyMedium!.copyWith(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ChartData {
  final int time;
  final double value;

  ChartData(this.time, this.value);
}
