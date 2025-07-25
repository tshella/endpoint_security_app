import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import '../main.dart'; // Import ThemeProvider
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'anomaly_detection_screen.dart';
import 'breach_notifier_screen.dart';
import 'browsing_monitor_screen.dart';
import 'file_integrity_screen.dart';
import 'network_monitor_screen.dart';
import 'scanner_screen.dart';
import 'signature_database_screen.dart';
import 'threat_intelligence_screen.dart';
import 'utility_screen.dart';
import 'vpn_encryption_screen.dart';
import 'vpn_screen.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  bool _isGridVisible = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 200), () {
      setState(() {
        _isGridVisible = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final backgroundColor = Theme.of(context).colorScheme.surface.withOpacity(0.45);
    final textColor = Theme.of(context).colorScheme.onSurface;

    int crossAxisCount = screenWidth < 600 ? 2 : (screenWidth < 900 ? 3 : 4);

    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
        actions: [
          Switch(
            value: themeProvider.themeMode == ThemeMode.dark,
            onChanged: (value) {
              themeProvider.toggleTheme();
            },
          ),
        ],
        iconTheme: IconThemeData(color: textColor),
      ),
      body: Stack(
        children: [
          // Parallax Background
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: MediaQuery.of(context).size.height,
            child: IgnorePointer(
              child: Center(
                child: Opacity(
                  opacity: 0.15,
                  child: Text(
                    'Tshella i Technologies',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Orbitron',
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
              ),
            ),
          ),
          // Main Content
          Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.only(bottom: 150), // Reserve space for footer
                  child: Column(
                    children: [
                      // Dashboard Grid
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: GridView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: crossAxisCount,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                            childAspectRatio: 3 / 2,
                          ),
                          itemCount: dashboardItems.length,
                          itemBuilder: (context, index) {
                            final item = dashboardItems[index];
                            return AnimatedOpacity(
                              opacity: _isGridVisible ? 1 : 0,
                              duration: Duration(milliseconds: 500 + index * 100),
                              child: _buildDashboardCard(
                                context,
                                title: item['title'],
                                icon: item['icon'],
                                screen: item['screen'],
                                backgroundColor: backgroundColor,
                                textColor: textColor,
                              ),
                            );
                          },
                        ),
                      ),
                      Divider(height: 32, thickness: 2),
                    ],
                  ),
                ),
              ),
              // Resized Sticky Footer with Gauge and Stats
              Container(
                height: 120, // Reduced height for footer
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: Offset(0, -4),
                    ),
                  ],
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Gauge
                    Flexible(
                      flex: 1,
                      child: SfRadialGauge(
                        axes: <RadialAxis>[
                          RadialAxis(
                            minimum: 0,
                            maximum: 100,
                            radiusFactor: 0.6, // Adjusted gauge size for smaller height
                            ranges: <GaugeRange>[
                              GaugeRange(
                                startValue: 0,
                                endValue: 50,
                                color: Colors.green.withOpacity(0.8),
                              ),
                              GaugeRange(
                                startValue: 50,
                                endValue: 80,
                                color: Colors.orange.withOpacity(0.8),
                              ),
                              GaugeRange(
                                startValue: 80,
                                endValue: 100,
                                color: Colors.red.withOpacity(0.8),
                              ),
                            ],
                            pointers: <GaugePointer>[
                              NeedlePointer(
                                value: 65,
                                needleColor: Theme.of(context).colorScheme.primary,
                              ),
                            ],
                            annotations: <GaugeAnnotation>[
                              GaugeAnnotation(
                                widget: Text(
                                  '65%',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: textColor,
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
                    SizedBox(width: 16), // Add spacing between gauge and chart
                    // Usage Overview Chart
                    Flexible(
                      flex: 2,
                      child: SfCircularChart(
                        title: ChartTitle(
                          text: 'Usage Overview',
                          textStyle: TextStyle(fontSize: 12, color: textColor),
                        ),
                        legend: Legend(
                          isVisible: true,
                          position: LegendPosition.bottom,
                          textStyle: TextStyle(color: textColor, fontSize: 10),
                        ),
                        series: <CircularSeries>[
                          PieSeries<ChartData, String>(
                            dataSource: [
                              ChartData('Anomaly Detection', 30, Colors.blue),
                              ChartData('File Integrity', 20, Colors.green),
                              ChartData('Threat Intelligence', 10, Colors.orange),
                            ],
                            xValueMapper: (ChartData data, _) => data.category,
                            yValueMapper: (ChartData data, _) => data.value,
                            dataLabelMapper: (ChartData data, _) => '${data.value}%',
                            dataLabelSettings: DataLabelSettings(
                              isVisible: true,
                              textStyle: TextStyle(color: textColor, fontSize: 10),
                            ),
                            pointColorMapper: (ChartData data, _) => data.color,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Dashboard Card Widget
  Widget _buildDashboardCard(BuildContext context, {
    required String title,
    required IconData icon,
    required Widget screen,
    required Color backgroundColor,
    required Color textColor,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => screen),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: textColor, size: 36),
            SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: textColor,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

// Chart Data Class
class ChartData {
  final String category;
  final double value;
  final Color color;

  ChartData(this.category, this.value, this.color);
}

// Dashboard Items (Updated to remove Permissions Monitor)
final List<Map<String, dynamic>> dashboardItems = [
  {'title': 'Anomaly Detection', 'icon': MdiIcons.chartLine, 'screen': AnomalyDetectionScreen()},
  {'title': 'Breach Notifier', 'icon': MdiIcons.alertCircleOutline, 'screen': BreachNotifierScreen()},
  {'title': 'Browsing Monitor', 'icon': MdiIcons.earth, 'screen': BrowsingMonitorScreen()},
  {'title': 'File Integrity', 'icon': MdiIcons.fileDocumentOutline, 'screen': FileIntegrityScreen()},
  {'title': 'Network Monitor', 'icon': MdiIcons.accessPointNetwork, 'screen': NetworkMonitorScreen()},
  {'title': 'Scanner', 'icon': FontAwesomeIcons.search, 'screen': ScannerScreen()},
  {'title': 'Signature Database', 'icon': FontAwesomeIcons.database, 'screen': SignatureDatabaseScreen()},
  {'title': 'Threat Intelligence', 'icon': MdiIcons.shieldAccount, 'screen': ThreatIntelligenceScreen()},
  {'title': 'Utility', 'icon': MdiIcons.tools, 'screen': UtilityScreen()},
  {'title': 'VPN Encryption', 'icon': MdiIcons.key, 'screen': VpnEncryptionScreen()},
  {'title': 'VPN', 'icon': FontAwesomeIcons.lock, 'screen': VpnScreen()},
];
