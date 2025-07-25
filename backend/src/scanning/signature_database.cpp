#include "signature_database.h"
#include <fstream>
#include <iostream>
#include <sstream>
#include <iomanip>
#include <openssl/sha.h> // For SHA-256 hashing

SignatureDatabase::SignatureDatabase() {
    // Load signatures on initialization
    loadSignatures("signatures.txt"); // Assume a default file path
}

// Load signatures from a file
void SignatureDatabase::loadSignatures(const std::string& filePath) {
    std::ifstream file(filePath);
    if (!file.is_open()) {
        std::cerr << "Could not open signature file." << std::endl;
        return;
    }

    std::string line;
    while (std::getline(file, line)) {
        std::string hash = hashSignature(line);
        signatures.insert(hash);
    }
    file.close();
    std::cout << "Loaded " << signatures.size() << " signatures." << std::endl;
}

// Hash each signature for fast comparison
std::string SignatureDatabase::hashSignature(const std::string& signature) const {
    unsigned char hash[SHA256_DIGEST_LENGTH];
    SHA256(reinterpret_cast<const unsigned char*>(signature.c_str()), signature.size(), hash);

    std::stringstream ss;
    for (unsigned char byte : hash) {
        ss << std::hex << std::setw(2) << std::setfill('0') << static_cast<int>(byte);
    }
    return ss.str();
}

// Check if a signature is in the database
bool SignatureDatabase::containsSignature(const std::string& signature) const {
    std::string hashedSig = hashSignature(signature);
    return signatures.find(hashedSig) != signatures.end();
}

// Add a new signature to the database
void SignatureDatabase::addSignature(const std::string& signature) {
    std::string hash = hashSignature(signature);
    signatures.insert(hash);
}

// Alert if tampering is detected
void SignatureDatabase::alertAdmin(const std::string& message) const {
    std::cout << "ALERT: " << message << std::endl;
}

// Fuzzy matching based on similarity (simplified)
bool SignatureDatabase::fuzzyMatch(const std::string& data) const {
    // Simplified example using exact matches; replace with Levenshtein or Jaccard as needed
    for (const auto& signature : signatures) {
        if (data.find(signature) != std::string::npos) {
            return true;
        }
    }
    return false;
}

// Calculate similarity (stub for actual fuzzy matching)
double SignatureDatabase::calculateSimilarity(const std::string& data, const std::string& signature) const {
    // Implement real fuzzy-matching algorithm if needed
    return 0.0; // Placeholder
}
