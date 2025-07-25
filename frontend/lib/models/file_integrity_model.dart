class FileIntegrityModel {
  final bool isIntegrityVerified; // Add this field
  final String message;

  FileIntegrityModel({
    required this.isIntegrityVerified, // Initialize it here
    required this.message,
  });

  factory FileIntegrityModel.fromJson(Map<String, dynamic> json) {
    return FileIntegrityModel(
      isIntegrityVerified: json['isIntegrityVerified'] ?? false, // Parse from JSON
      message: json['message'] ?? 'Unknown status',
    );
  }
}
