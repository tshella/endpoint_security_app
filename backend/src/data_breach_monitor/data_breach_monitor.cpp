#include "data_breach_monitor.h"
#include <iostream>
#include <fstream>
#include <vector>
#include <openssl/sha.h>   // For SHA-256 hashing
#include <openssl/rand.h>  // For random data generation
#include <openssl/evp.h>   // For encryption algorithms
#include <sstream>
#include <iomanip>
#include <cmath>
#include <numeric>
#include <cstdint>

#ifdef _WIN32
#include <winsock2.h>
#include <pcap.h>
typedef unsigned char u_char;
typedef unsigned int u_int;
#else
#include <sys/time.h>
#include <pcap.h>
#endif

void DataBreachMonitor::checkForBreaches() {
    std::cout << "Checking for data breaches..." << std::endl;

    // Anomaly Detection
    if (detectAnomaliesInData()) {
        alertAdmin("Anomaly detected in data access patterns.");
    }

    // Integrity Verification
    std::vector<std::string> sensitiveFiles = { "file1.txt", "file2.txt" };
    for (const auto& file : sensitiveFiles) {
        if (!verifyFileIntegrity(file)) {
            alertAdmin("Integrity breach detected in " + file);
        }
    }

    // Signature-Based Threat Detection
    if (checkAgainstThreatSignatures()) {
        alertAdmin("Known threat signature detected in system logs.");
    }

    // Network Packet Inspection
    if (inspectNetworkPackets()) {
        alertAdmin("Suspicious network activity detected.");
    }

    // Unauthorized Access Detection
    if (detectUnauthorizedAccess()) {
        alertAdmin("Unauthorized access attempt detected.");
    }
}

// Robust Anomaly Detection with Statistical Analysis
bool DataBreachMonitor::detectAnomaliesInData() {
    std::vector<int> dataAccessPatterns = { 1, 2, 3, 3, 4, 5, 3, 100 }; // Sample access frequency data

    double mean = std::accumulate(dataAccessPatterns.begin(), dataAccessPatterns.end(), 0.0) / dataAccessPatterns.size();
    double variance = 0.0;
    for (int accessFrequency : dataAccessPatterns) {
        variance += std::pow(accessFrequency - mean, 2);
    }
    variance /= dataAccessPatterns.size();
    double stdDeviation = std::sqrt(variance);

    const double zScoreThreshold = 3.0;
    for (int accessFrequency : dataAccessPatterns) {
        double zScore = (accessFrequency - mean) / stdDeviation;
        if (std::abs(zScore) > zScoreThreshold) {
            std::cout << "Anomalous access frequency detected: " << accessFrequency << " (Z-score: " << zScore << ")" << std::endl;
            return true;
        }
    }
    return false;
}

// Integrity Check using SHA-256 hashing
bool DataBreachMonitor::verifyFileIntegrity(const std::string& filePath) {
    std::ifstream file(filePath, std::ios::binary);
    if (!file) {
        std::cerr << "Could not open file: " << filePath << std::endl;
        return false;
    }

    std::string content((std::istreambuf_iterator<char>(file)), std::istreambuf_iterator<char>());
    std::string currentHash = calculateHash(content);

    return compareWithStoredHash(filePath, currentHash);
}

std::string DataBreachMonitor::calculateHash(const std::string& data) {
    unsigned char hash[SHA256_DIGEST_LENGTH];
    SHA256(reinterpret_cast<const unsigned char*>(data.c_str()), data.size(), hash);

    std::stringstream ss;
    for (unsigned char byte : hash) {
        ss << std::hex << std::setw(2) << std::setfill('0') << (int)byte;
    }
    return ss.str();
}

bool DataBreachMonitor::compareWithStoredHash(const std::string& filePath, const std::string& currentHash) {
    std::string storedHash = "expected_hash"; // Retrieve from secure storage in production
    return currentHash == storedHash;
}

// Signature-Based Threat Detection with log scanning
bool DataBreachMonitor::checkAgainstThreatSignatures() {
    std::vector<std::string> threatSignatures = getThreatSignatures();
    std::string systemLog = "Example system log content"; // Replace with actual log file content
    for (const auto& signature : threatSignatures) {
        if (systemLog.find(signature) != std::string::npos) {
            return true;
        }
    }
    return false;
}

std::vector<std::string> DataBreachMonitor::getThreatSignatures() {
    return { "malicious_code_signature1", "malicious_code_signature2" };
}

// Real-Time Network Inspection with Packet Analysis
bool DataBreachMonitor::inspectNetworkPackets() {
    char errbuf[PCAP_ERRBUF_SIZE];
    pcap_t* handle = pcap_open_live("eth0", BUFSIZ, 1, 1000, errbuf); // Open device for live capture
    if (!handle) {
        std::cerr << "Error opening device for packet capture: " << errbuf << std::endl;
        return false;
    }

    struct pcap_pkthdr header;
    const unsigned char* packet;
    while ((packet = pcap_next(handle, &header)) != nullptr) {
        if (header.len > 54 && packet[54] == 'G' && packet[55] == 'E' && packet[56] == 'T') {
            pcap_close(handle);
            return true;
        }
    }
    pcap_close(handle);
    return false;
}

// Unauthorized Access Detection with Brute-Force Detection Logic
bool DataBreachMonitor::detectUnauthorizedAccess() {
    int failedAttempts = 0;
    std::string logLine;
    std::ifstream logFile("auth.log");
    while (std::getline(logFile, logLine)) {
        if (logLine.find("Failed login") != std::string::npos) {
            failedAttempts++;
            if (failedAttempts > 3) {
                return true;
            }
        }
    }
    return false;
}

// Alerting System - Sends alerts to administrator
void DataBreachMonitor::alertAdmin(const std::string& message) {
    std::cout << "ALERT: " << message << std::endl;
}
