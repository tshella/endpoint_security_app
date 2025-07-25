#ifndef BROWSING_MONITOR_H
#define BROWSING_MONITOR_H

#include <string>
#include <set>

class BrowsingMonitor {
public:
    // Constructor
    BrowsingMonitor();

    // Public Methods
    void monitorActivity();
    bool checkURLReputation(const std::string& url);
    void analyzeBrowsingPacket(const unsigned char* packet, int length);

private:
    // Private Methods
    bool detectMaliciousURL(const std::string& packetData);
    bool detectMaliciousContent(const std::string& packetData);
    void alertAdmin(const std::string& message);
    std::string sanitizeLogString(const std::string& input);

    // Malicious patterns for content detection
    static const std::set<std::string> MALICIOUS_PATTERNS;
};

#endif // BROWSING_MONITOR_H
