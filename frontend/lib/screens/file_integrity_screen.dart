import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../services/file_integrity_service.dart';

class FileIntegrityScreen extends StatefulWidget {
  @override
  _FileIntegrityScreenState createState() => _FileIntegrityScreenState();
}

class _FileIntegrityScreenState extends State<FileIntegrityScreen> {
  final FileIntegrityService _service = FileIntegrityService();
  String _statusMessage = 'Select a file to check its integrity.';
  String? _selectedFilePath;
  double _progress = 0.0;
  bool _isChecking = false;

  void _pickFile() async {
    try {
      final result = await FilePicker.platform.pickFiles();
      if (result != null && result.files.single.path != null) {
        setState(() {
          _selectedFilePath = result.files.single.path!;
          _statusMessage = 'File selected: ${result.files.single.name}';
        });
      } else {
        setState(() {
          _statusMessage = 'No file selected.';
        });
      }
    } catch (e) {
      setState(() {
        _statusMessage = 'Error selecting file: $e';
      });
    }
  }

  void _startIntegrityCheck() async {
    if (_selectedFilePath == null) {
      setState(() {
        _statusMessage = 'Please select a file before starting the check.';
      });
      return;
    }

    setState(() {
      _isChecking = true;
      _progress = 0.0;
      _statusMessage = 'Starting file integrity check...';
    });

    try {
      await _service.startIntegrityCheck(_selectedFilePath!);
      _statusMessage = 'Integrity check started.';
      _updateProgress();
    } catch (e) {
      setState(() {
        _statusMessage = 'Failed to start file integrity check: $e';
      });
    }
  }

  void _pauseIntegrityCheck() async {
    try {
      await _service.pauseIntegrityCheck();
      setState(() {
        _statusMessage = 'Integrity check paused.';
      });
    } catch (e) {
      setState(() {
        _statusMessage = 'Failed to pause file integrity check: $e';
      });
    }
  }

  void _resumeIntegrityCheck() async {
    try {
      await _service.resumeIntegrityCheck();
      setState(() {
        _statusMessage = 'Resumed integrity check.';
        _updateProgress();
      });
    } catch (e) {
      setState(() {
        _statusMessage = 'Failed to resume file integrity check: $e';
      });
    }
  }

  void _stopIntegrityCheck() async {
    try {
      await _service.stopIntegrityCheck();
      setState(() {
        _isChecking = false;
        _progress = 0.0;
        _statusMessage = 'File integrity check stopped.';
      });
    } catch (e) {
      setState(() {
        _statusMessage = 'Failed to stop file integrity check: $e';
      });
    }
  }

  void _updateProgress() async {
    while (_isChecking) {
      try {
        final progress = await _service.getProgress();
        setState(() {
          _progress = progress / 100.0;
        });

        if (progress == 100) {
          setState(() {
            _isChecking = false;
            _statusMessage = 'File integrity check complete.';
          });

          _showFeedbackDialog(
            icon: MdiIcons.checkCircleOutline,
            color: Colors.green,
            title: 'Integrity Check Complete',
            message: 'The file integrity check has finished successfully.',
          );
          break;
        }

        await Future.delayed(Duration(seconds: 1));
      } catch (e) {
        setState(() {
          _statusMessage = 'Error fetching progress: $e';
        });
        break;
      }
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
              Text('About File Integrity Checker'),
            ],
          ),
          content: Text(
            'The File Integrity Checker verifies the integrity of a selected file by '
            'comparing its computed hash with a stored hash value. It can detect tampering '
            'and ensure the file’s authenticity. You can start, pause, resume, or stop the check, and track its progress.',
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
        title: Text('File Integrity Checker'),
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
                FontAwesomeIcons.fingerprint,
                size: 80,
                color: theme.primaryColor,
              ),
              SizedBox(height: 20),
              Text(
                'File Integrity Checker',
                style: theme.textTheme.headlineSmall!.copyWith(color: Colors.blueGrey),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: _pickFile,
                icon: Icon(MdiIcons.folderOpen),
                label: Text('Select File'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
              ),
              SizedBox(height: 20),
              if (_selectedFilePath != null)
                Text(
                  'Selected file: $_selectedFilePath',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium,
                ),
              SizedBox(height: 20),
              LinearProgressIndicator(
                value: _isChecking ? _progress : null,
                backgroundColor: Colors.grey[300],
                color: theme.primaryColor,
              ),
              SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: _isChecking ? null : _startIntegrityCheck,
                icon: Icon(MdiIcons.play),
                label: Text('Start Check'),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton.icon(
                    onPressed: !_isChecking ? null : _pauseIntegrityCheck,
                    icon: Icon(MdiIcons.pause),
                    label: Text('Pause'),
                  ),
                  ElevatedButton.icon(
                    onPressed: !_isChecking ? null : _resumeIntegrityCheck,
                    icon: Icon(MdiIcons.play),
                    label: Text('Resume'),
                  ),
                  ElevatedButton.icon(
                    onPressed: !_isChecking ? null : _stopIntegrityCheck,
                    icon: Icon(MdiIcons.stop),
                    label: Text('Stop'),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Text(
                _statusMessage,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
