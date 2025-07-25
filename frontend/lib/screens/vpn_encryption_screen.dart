import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../services/vpn_encryption_service.dart';

class VpnEncryptionScreen extends StatefulWidget {
  @override
  _VpnEncryptionScreenState createState() => _VpnEncryptionScreenState();
}

class _VpnEncryptionScreenState extends State<VpnEncryptionScreen> {
  final VpnEncryptionService _service = VpnEncryptionService();
  String _result = 'Press the button to initialize VPN encryption.';

  /// Initialize VPN Encryption
  void _initializeEncryption() async {
    try {
      final response = await _service.initializeEncryption();
      setState(() {
        _result = response.message;
      });
    } catch (e) {
      setState(() {
        _result = 'Error: $e';
      });
    }
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
              const Text('About VPN Encryption'),
            ],
          ),
          content: const Text(
            'VPN Encryption ensures that your network traffic is securely encrypted '
            'and protected from potential threats. Use this feature to initialize '
            'and safeguard your connection.',
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(MdiIcons.arrowLeft),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('VPN Encryption'),
        actions: [
          IconButton(
            icon: const Icon(MdiIcons.informationOutline),
            onPressed: _showInfoDialog,
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const FaIcon(
                FontAwesomeIcons.shieldAlt,
                size: 80,
                color: Colors.blueAccent,
              ),
              const SizedBox(height: 20),
              Text(
                'VPN Encryption Status',
                style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey, width: 1.5),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  _result,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyLarge?.copyWith(fontSize: 16),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: _initializeEncryption,
                icon: const Icon(MdiIcons.lockCheck),
                label: const Text('Initialize VPN Encryption'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: _showInfoDialog,
                icon: const Icon(MdiIcons.helpCircleOutline),
                label: const Text('Learn More'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orangeAccent,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
