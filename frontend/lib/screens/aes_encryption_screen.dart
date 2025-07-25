import 'package:flutter/material.dart';
import '../services/aes_encryption_service.dart';
import '../models/aes_encryption_model.dart';

class AesEncryptionScreen extends StatefulWidget {
  @override
  _AesEncryptionScreenState createState() => _AesEncryptionScreenState();
}

class _AesEncryptionScreenState extends State<AesEncryptionScreen> {
  final AesEncryptionService _service = AesEncryptionService();
  String _result = 'Press the button to initialize AES encryption.';

  void _initializeEncryption() async {
    try {
      AesEncryptionModel response = await _service.initializeEncryption();
      setState(() {
        _result = response.message;
      });
    } catch (e) {
      setState(() {
        _result = 'Error: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('AES Encryption')),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(_result),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _initializeEncryption,
                child: Text('Initialize AES Encryption'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
