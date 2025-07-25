import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../services/web_filter_service.dart';

class WebFilterScreen extends StatefulWidget {
  @override
  _WebFilterScreenState createState() => _WebFilterScreenState();
}

class _WebFilterScreenState extends State<WebFilterScreen> {
  final WebFilterService _service = WebFilterService();
  final TextEditingController _urlController = TextEditingController();
  String _result = 'Enter a URL and press the button to check its safety.';

  /// Apply Web Filter
  void _applyWebFilter() async {
    final url = _urlController.text.trim();
    if (url.isEmpty) {
      setState(() {
        _result = 'Please enter a URL.';
      });
      return;
    }

    try {
      final response = await _service.applyWebFilter(url);
      setState(() {
        _result = response.message.isNotEmpty
            ? response.message
            : 'The URL check returned no results.';
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
              const Text('About Web Filter'),
            ],
          ),
          content: const Text(
            'The Web Filter checks URLs for known malicious domains and suspicious patterns. '
            'Use it to ensure your browsing safety by detecting potentially harmful URLs.',
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
        title: const Text('Web Filter'),
        actions: [
          IconButton(
            icon: const Icon(MdiIcons.informationOutline),
            onPressed: _showInfoDialog,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Center(
              child: FaIcon(
                FontAwesomeIcons.shieldVirus,
                size: 80,
                color: Colors.blueAccent,
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: Text(
                'Web Filter',
                style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 10),
            Center(
              child: Text(
                'Check if a URL is safe to visit.',
                style: theme.textTheme.bodyMedium,
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _urlController,
              decoration: InputDecoration(
                labelText: 'Enter URL',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                prefixIcon: const Icon(MdiIcons.web),
              ),
              textInputAction: TextInputAction.done,
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _applyWebFilter,
              icon: const Icon(MdiIcons.shieldCheck),
              label: const Text('Check URL'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
            const SizedBox(height: 20),
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
          ],
        ),
      ),
    );
  }
}
