#include "file_integrity.h"
#include <iostream>
#include <fstream>
#include <openssl/evp.h>
#include <sstream>
#include <iomanip>
#include <stdexcept>
#include <thread>
#include <atomic>

// Global variables for progress tracking
std::atomic<int> progress(0);
std::atomic<bool> isPaused(false);
std::atomic<bool> isStopped(false);

// Checks the overall integrity of a file by verifying signature and detecting tampering
bool FileIntegrity::checkIntegrity(const std::string& filePath) {
    resetState();
    try {
        // Simulate steps for progress tracking
        for (int i = 0; i <= 100; i++) {
            if (isStopped) {
                log("Integrity check stopped.");
                return false;
            }
            while (isPaused) {
                std::this_thread::sleep_for(std::chrono::milliseconds(100));
            }
            std::this_thread::sleep_for(std::chrono::milliseconds(50)); // Simulate processing time
            progress = i;
        }

        bool signatureValid = verifySignature(filePath);
        bool tamperingDetected = detectTampering(filePath);

        return signatureValid && !tamperingDetected;
    }
    catch (const std::exception& e) {
        log("Error during file integrity check: " + std::string(e.what()));
        return false;
    }
}

// Verifies file integrity by comparing computed and stored hash signatures
bool FileIntegrity::verifySignature(const std::string& filePath) {
    log("Verifying signature of " + filePath + "...");
    std::string computedHash = computeHash(filePath);
    std::string storedHash = getStoredHash(filePath);

    if (computedHash == storedHash) {
        log("File signature verified successfully.");
        return true;
    }
    else {
        log("File signature verification failed!");
        alertTamperingDetected(filePath);
        return false;
    }
}

// Detects tampering by comparing current hash with expected hash value
bool FileIntegrity::detectTampering(const std::string& filePath) {
    log("Detecting tampering for " + filePath + "...");
    if (!verifySignature(filePath)) {
        log("Tampering detected in file: " + filePath);
        alertTamperingDetected(filePath);
        return true;
    }
    log("No tampering detected.");
    return false;
}

// Computes the SHA-256 hash of the specified file using the OpenSSL EVP API
std::string FileIntegrity::computeHash(const std::string& filePath) {
    std::ifstream file(filePath, std::ios::binary);
    if (!file) {
        throw std::runtime_error("Failed to open file: " + filePath);
    }

    EVP_MD_CTX* mdctx = EVP_MD_CTX_new();
    if (!mdctx) {
        throw std::runtime_error("Failed to create EVP_MD_CTX");
    }

    if (EVP_DigestInit_ex(mdctx, EVP_sha256(), NULL) != 1) {
        EVP_MD_CTX_free(mdctx);
        throw std::runtime_error("Failed to initialize digest");
    }

    char buffer[4096];
    while (file.read(buffer, sizeof(buffer))) {
        if (EVP_DigestUpdate(mdctx, buffer, file.gcount()) != 1) {
            EVP_MD_CTX_free(mdctx);
            throw std::runtime_error("Failed to update digest");
        }
    }
    if (file.gcount() > 0) { // Handle any remaining data in the buffer
        EVP_DigestUpdate(mdctx, buffer, file.gcount());
    }

    unsigned char hash[EVP_MAX_MD_SIZE];
    unsigned int hash_len;
    if (EVP_DigestFinal_ex(mdctx, hash, &hash_len) != 1) {
        EVP_MD_CTX_free(mdctx);
        throw std::runtime_error("Failed to finalize digest");
    }

    EVP_MD_CTX_free(mdctx);

    std::stringstream ss;
    for (unsigned int i = 0; i < hash_len; i++) {
        ss << std::hex << std::setw(2) << std::setfill('0') << static_cast<int>(hash[i]);
    }
    return ss.str();
}

// Placeholder function to retrieve stored hash (in a real application, retrieve from secure storage)
std::string FileIntegrity::getStoredHash(const std::string& filePath) {
    return "expected_hash_value_for_demo_purposes";
}

// Logs or alerts tampering detection
void FileIntegrity::alertTamperingDetected(const std::string& filePath) {
    log("ALERT: Tampering detected in file: " + filePath + "! Please investigate.");
}

// Helper function to reset global state
void FileIntegrity::resetState() {
    isPaused = false;
    isStopped = false;
    progress = 0;
}

// Logs messages
void FileIntegrity::log(const std::string& message) {
    std::cout << "[FileIntegrity] " << message << std::endl;
}

// Pause, resume, and stop handlers
void FileIntegrity::pause() {
    isPaused = true;
    log("Integrity check paused.");
}

void FileIntegrity::resume() {
    isPaused = false;
    log("Integrity check resumed.");
}

void FileIntegrity::stop() {
    isStopped = true;
    log("Integrity check stopped.");
}

int FileIntegrity::getProgress() const {
    return progress.load();
}
