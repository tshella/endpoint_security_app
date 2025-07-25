#include "browsing_monitor.h"
#include <iostream>
#include <regex>
#include <set>

// Initialize static member
const std::set<std::string> BrowsingMonitor::MALICIOUS_PATTERNS = {
    "eval(", "<script>", "iframe", "base64"
};

BrowsingMonitor::BrowsingMonitor() {
    // Constructor logic if needed
}

void BrowsingMonitor::monitorActivity() {
    std::cout << "[BrowsingMonitor] Monitoring browsing activity..." << std::endl;
}

bool BrowsingMonitor::checkURLReputation(const std::string& url) {
    std::cout << "[BrowsingMonitor] Checking URL reputation for: " << url << std::endl;
    return url.find("malicious") != std::string::npos;
}

void BrowsingMonitor::analyzeBrowsingPacket(const unsigned char* packet, int length) {
    if (packet == nullptr || length <= 0) {
        std::cerr << "[BrowsingMonitor] Invalid packet data or length" << std::endl;
        return;
    }

    std::cout << "[BrowsingMonitor] Analyzing browsing packet..." << std::endl;
    std::string packetData(reinterpret_cast<const char*>(packet), length);

    if (detectMaliciousContent(packetData)) {
        alertAdmin("Malicious content detected in browsing packet.");
    }

    if (detectMaliciousURL(packetData)) {
        alertAdmin("Malicious URL detected in browsing packet.");
    }
}

bool BrowsingMonitor::detectMaliciousURL(const std::string& packetData) {
    static const std::regex urlRegex(R"((https?|ftp)://[^\s/$.?#].[^\s]*)", std::regex::icase);
    auto matches_begin = std::sregex_iterator(packetData.begin(), packetData.end(), urlRegex);
    auto matches_end = std::sregex_iterator();

    for (auto it = matches_begin; it != matches_end; ++it) {
        std::string foundURL = it->str();
        std::cout << "[BrowsingMonitor] Found URL: " << foundURL << std::endl;

        if (checkURLReputation(foundURL)) {
            return true;
        }
    }
    return false;
}

bool BrowsingMonitor::detectMaliciousContent(const std::string& packetData) {
    for (const auto& pattern : MALICIOUS_PATTERNS) {
        if (packetData.find(pattern) != std::string::npos) {
            std::cout << "[BrowsingMonitor] Detected malicious pattern: " << pattern << std::endl;
            return true;
        }
    }
    return false;
}

void BrowsingMonitor::alertAdmin(const std::string& message) {
    std::cout << "[BrowsingMonitor] ALERT: " << sanitizeLogString(message) << std::endl;
}

std::string BrowsingMonitor::sanitizeLogString(const std::string& input) {
    std::string sanitized;
    for (const char c : input) {
        if (c != '\n' && c != '\r') {
            sanitized += c;
        }
        else {
            sanitized += ' ';
        }
    }
    return sanitized;
}
