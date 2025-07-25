#ifndef WEB_FILTER_H
#define WEB_FILTER_H

#include <string>

class WebFilter {
public:
    // Main function to filter the URL and detect potential threats
    void filterURL(const std::string& url);

private:
    // Checks if the URL contains suspicious patterns (e.g., phishing keywords, IP addresses)
    bool containsSuspiciousPatterns(const std::string& url);

    // Checks if the URL's domain is in the list of known malicious domains
    bool isMaliciousDomain(const std::string& url);

    // Alerting system to notify administrators if a harmful URL is detected
    void alertAdmin(const std::string& message);
};

#endif // WEB_FILTER_H
