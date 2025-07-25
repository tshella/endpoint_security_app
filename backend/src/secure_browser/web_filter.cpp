#include "web_filter.h"
#include <iostream>
#include <regex>
#include <unordered_set>

// Sample set of known malicious domains for reputation check
const std::unordered_set<std::string> knownMaliciousDomains = {
    "malicious.com",
    "phishing-site.org",
    "dangerous.net"
};

// Checks if the URL contains suspicious patterns
bool WebFilter::containsSuspiciousPatterns(const std::string& url) {
    // Example patterns: URLs with IP addresses, suspicious keywords, or uncommon characters
    std::regex ipPattern(R"(\b\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}\b)");
    std::regex phishingPattern(R"(.*(login|update|verify|secure|bank|account).*)", std::regex::icase);

    // Check for patterns that might indicate phishing or malicious intent
    if (std::regex_search(url, ipPattern) || std::regex_search(url, phishingPattern)) {
        std::cout << "Suspicious pattern detected in URL: " << url << std::endl;
        return true;
    }
    return false;
}

// Checks if the URL's domain is in the list of known malicious domains
bool WebFilter::isMaliciousDomain(const std::string& url) {
    // Extract domain from URL (simple extraction; could be improved with a URL parser)
    std::string::size_type pos = url.find("://");
    std::string domain = (pos == std::string::npos) ? url : url.substr(pos + 3);
    pos = domain.find('/');
    if (pos != std::string::npos) domain = domain.substr(0, pos);

    // Check against the known malicious domains list
    if (knownMaliciousDomains.find(domain) != knownMaliciousDomains.end()) {
        std::cout << "Malicious domain detected: " << domain << std::endl;
        return true;
    }
    return false;
}

// Main function to filter the URL and detect potential threats
void WebFilter::filterURL(const std::string& url) {
    std::cout << "Filtering URL: " << url << std::endl;

    if (containsSuspiciousPatterns(url) || isMaliciousDomain(url)) {
        alertAdmin("Potentially harmful URL detected: " + url);
    }
    else {
        std::cout << "URL passed the web filter." << std::endl;
    }
}

// Alerting system to notify administrators if a harmful URL is detected
void WebFilter::alertAdmin(const std::string& message) {
    std::cout << "ALERT: " << message << std::endl;
}
