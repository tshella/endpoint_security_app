#ifndef FILE_INTEGRITY_H
#define FILE_INTEGRITY_H

#include <string>
#include <atomic>

class FileIntegrity {
public:
    // Performs both signature verification and tampering detection
    bool checkIntegrity(const std::string& filePath);

    // Pause, resume, and stop handlers
    void pause();
    void resume();
    void stop();

    // Get current progress
    int getProgress() const;

private:
    // Verifies file integrity by checking cryptographic signatures
    bool verifySignature(const std::string& filePath);

    // Detects tampering by comparing hash values with stored values
    bool detectTampering(const std::string& filePath);

    // Computes the SHA-256 hash of a file
    std::string computeHash(const std::string& filePath);

    // Helper function to simulate or retrieve stored hash for comparison
    std::string getStoredHash(const std::string& filePath);

    // Logs or alerts any detected tampering
    void alertTamperingDetected(const std::string& filePath);

    // Helper functions for progress control
    void resetState();
    void log(const std::string& message);
};

#endif // FILE_INTEGRITY_H
