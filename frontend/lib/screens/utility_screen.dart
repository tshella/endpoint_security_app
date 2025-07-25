import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // For Clipboard functionality
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../services/utility_service.dart';

class UtilityScreen extends StatefulWidget {
  @override
  _UtilityScreenState createState() => _UtilityScreenState();
}

class _UtilityScreenState extends State<UtilityScreen> {
  final UtilityService _service = UtilityService();
  String _generatedPassword = 'Press the button to generate a password.';
  int _passwordLength = 12; // Default password length
  bool _includeSpecialChars = true;

  /// Generate Password Function
  void _generatePassword() async {
    try {
      final response =
          await _service.generatePassword(_passwordLength, _includeSpecialChars);
      setState(() {
        _generatedPassword = response.generatedPassword.isNotEmpty
            ? response.generatedPassword
            : 'Failed to generate password.';
      });
    } catch (e) {
      setState(() {
        _generatedPassword = 'Error: $e';
      });
    }
  }

  /// Copy to Clipboard Function
  void _copyToClipboard() {
    if (_generatedPassword.isNotEmpty &&
        _generatedPassword != 'Press the button to generate a password.') {
      Clipboard.setData(ClipboardData(text: _generatedPassword));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Password copied to clipboard!'),
          duration: Duration(seconds: 2),
        ),
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
        title: const Text('Utility - Password Generator'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const FaIcon(
              FontAwesomeIcons.key,
              size: 80,
              color: Colors.blueAccent,
            ),
            const SizedBox(height: 20),
            Text(
              'Generated Password',
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
                _generatedPassword,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyLarge?.copyWith(fontSize: 16),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _generatePassword,
              icon: const Icon(MdiIcons.refresh),
              label: const Text('Generate Password'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: _copyToClipboard,
              icon: const Icon(MdiIcons.contentCopy),
              label: const Text('Copy to Clipboard'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(MdiIcons.numeric, color: Colors.blueAccent),
                const SizedBox(width: 10),
                const Text('Password Length:'),
                const SizedBox(width: 10),
                DropdownButton<int>(
                  value: _passwordLength,
                  items: [8, 12, 16, 20, 24].map((int value) {
                    return DropdownMenuItem<int>(
                      value: value,
                      child: Text(value.toString()),
                    );
                  }).toList(),
                  onChanged: (int? value) {
                    setState(() {
                      _passwordLength = value ?? 12;
                    });
                  },
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Checkbox(
                  value: _includeSpecialChars,
                  onChanged: (bool? value) {
                    setState(() {
                      _includeSpecialChars = value ?? true;
                    });
                  },
                ),
                const Text('Include Special Characters'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
