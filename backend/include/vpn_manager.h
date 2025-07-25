#ifndef VPN_MANAGER_H
#define VPN_MANAGER_H

#include <string>

class VpnManager {
public:
    void connect();
    void disconnect();
    bool isConnected() const;                  // Check if VPN is connected
    bool validateSecureConnection();           // Validate if the connection is secure
    void monitorConnection();                  // Monitor VPN connection for suspicious activity

private:
    bool connectionStatus = false;             // Track VPN connection status
    void alertAdmin(const std::string& message); // Alert system for VPN issues
};

#endif // VPN_MANAGER_H
