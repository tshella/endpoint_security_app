import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../services/signature_database_service.dart';
import '../models/signature_database_model.dart';

class SignatureDatabaseScreen extends StatefulWidget {
  @override
  _SignatureDatabaseScreenState createState() =>
      _SignatureDatabaseScreenState();
}

class _SignatureDatabaseScreenState extends State<SignatureDatabaseScreen> {
  final SignatureDatabaseService _service = SignatureDatabaseService();
  late Future<SignatureDatabaseModel> _futureSignatures;

  // Mock detection gauge and pie chart data
  double _detectionGaugeValue = 100;
  final List<_ChartData> _chartData = [
    _ChartData('Valid', 0),
    _ChartData('Tampered', 0),
  ];

  String _statusMessage = 'Loading file integrity status...';
  bool _hasTamperingDetected = false;

  @override
  void initState() {
    super.initState();
    _loadSignatures();
  }

  Future<void> _loadSignatures() async {
    try {
      final data = await _service.loadSignatures();
      final tamperedCount = data.signatures.where((sig) => sig.contains("tampered")).length;
      final validCount = data.signatures.length - tamperedCount;

      setState(() {
        _statusMessage = tamperedCount > 0
            ? 'Tampering detected in $tamperedCount files!'
            : 'All files are secure.';
        _hasTamperingDetected = tamperedCount > 0;
        _chartData[0] = _ChartData('Valid', validCount.toDouble());
        _chartData[1] = _ChartData('Tampered', tamperedCount.toDouble());
        _detectionGaugeValue =
            (validCount / data.signatures.length * 100).clamp(0, 100);
      });
    } catch (e) {
      setState(() {
        _statusMessage = 'Error loading data: $e';
        _hasTamperingDetected = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(MdiIcons.arrowLeft),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('Signature Database'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Signature Monitoring Status',
              style: theme.textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            FaIcon(
              FontAwesomeIcons.database,
              size: 80,
              color: theme.primaryColor,
            ),
            const SizedBox(height: 20),
            Text(
              _statusMessage,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: _hasTamperingDetected ? Colors.red : Colors.green,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            Expanded(
              child: SfCircularChart(
                title: ChartTitle(text: 'File Integrity'),
                legend: Legend(isVisible: true),
                series: <CircularSeries>[
                  PieSeries<_ChartData, String>(
                    dataSource: _chartData,
                    xValueMapper: (_ChartData data, _) => data.label,
                    yValueMapper: (_ChartData data, _) => data.value,
                    dataLabelSettings: DataLabelSettings(isVisible: true),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: SfRadialGauge(
                axes: <RadialAxis>[
                  RadialAxis(
                    minimum: 0,
                    maximum: 100,
                    ranges: <GaugeRange>[
                      GaugeRange(
                        startValue: 0,
                        endValue: 50,
                        color: Colors.red,
                      ),
                      GaugeRange(
                        startValue: 50,
                        endValue: 75,
                        color: Colors.orange,
                      ),
                      GaugeRange(
                        startValue: 75,
                        endValue: 100,
                        color: Colors.green,
                      ),
                    ],
                    pointers: <GaugePointer>[
                      NeedlePointer(value: _detectionGaugeValue),
                    ],
                    annotations: <GaugeAnnotation>[
                      GaugeAnnotation(
                        widget: Text(
                          '$_detectionGaugeValue%',
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        angle: 90,
                        positionFactor: 0.5,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _loadSignatures,
              icon: Icon(MdiIcons.refresh),
              label: Text('Rescan Files'),
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChartData {
  final String label;
  final double value;

  _ChartData(this.label, this.value);
}
