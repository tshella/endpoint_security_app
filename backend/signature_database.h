#ifndef SIGNATURE_DATABASE_H
#define SIGNATURE_DATABASE_H

#include <string>
#include <unordered_set>
#include <vector>

class SignatureDatabase {
public:
    // Constructor and Destructor
    SignatureDatabase();
    ~SignatureDatabase() = default;

    // Load signatures from a file
    void loadSignatures(const std::string& filePath);

    // Check if a specific signature exists in the database
    bool containsSignature(const std::string& signature) const;

    // Add a new signature to the database
    void addSignature(const std::string& signature);

    // Perform fuzzy match with a given threshold (e.g., for polymorphic malware)
    bool fuzzyMatch(const std::string& data) const;

private:
    // Data structure to store hashed signatures for fast lookup
    std::unordered_set<std::string> signatures;

    // Helper method to hash a signature for quick comparison
    std::string hashSignature(const std::string& signature) const;

    // Alert system to notify the admin about threats
    void alertAdmin(const std::string& message) const;

    // Calculate similarity between data and a signature (for fuzzy matching)
    double calculateSimilarity(const std::string& data, const std::string& signature) const;
};

#endif // SIGNATURE_DATABASE_H
