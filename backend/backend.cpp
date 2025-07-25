#include "scanner.h"
#include "vpn_manager.h"
#include "encryption.h"
#include "data_breach_monitor.h"
#include "permission_monitor.h"
#include "web_filter.h"
#include "vpn_encryption.h"
#include "threat_detection.h"
#include "network_monitor.h"
#include "file_integrity.h"
#include "browsing_monitor.h"
#include "signature_database.h"
#include "permission_checker.h"
#include "breach_notifier.h"
#include "utility.h"
#include <iostream>
#include <openssl/rand.h>

void initializeComponents() {
    try {
        // Generate a random password with special characters, 12 characters long
        std::string randomPassword = generateRandomPassword(12, true);
        std::cout << "Generated Random Password: " << randomPassword << std::endl;

        // Initialize and test Threat Detection
        ThreatDetection threatDetection;
        std::string suspiciousData = "<script>alert('malicious code')</script>";
        if (threatDetection.detectThreat(suspiciousData)) {
            std::cout << "Threat detected in data: " << suspiciousData << std::endl;
        }
        else {
            std::cout << "No threat detected in data: " << suspiciousData << std::endl;
        }

        // Initialize and test Permission Checker
        PermissionChecker permissionChecker;
        permissionChecker.loadRolesFromConfig("config_path");
        permissionChecker.assignRole("user123", "admin");

        bool hasWritePermission = permissionChecker.hasPermission("user123", "write");
        std::cout << "Permission check for 'write': " << (hasWritePermission ? "Granted" : "Denied") << std::endl;

        // Test additional functionalities of PermissionChecker
        auto permissions = permissionChecker.getPermissions();
        if (permissions.find("read") != permissions.end()) {
            bool isReadPermissionActive = permissionChecker.isPermissionActive(permissions["read"]);
            std::cout << "Is 'read' permission active for 'user123': " << (isReadPermissionActive ? "Yes" : "No") << std::endl;
        }
        else {
            std::cout << "'read' permission not found." << std::endl;
        }

        // Initialize and test Scanner
        Scanner scanner;
        scanner.startScan();
        scanner.stopScan();

        // Initialize and test VPN Manager
        VpnManager vpnManager;
        vpnManager.connect();
        vpnManager.disconnect();

        // Test AES Encryption
        Encryption encryption;
        unsigned char aesKey[32];
        unsigned char aesIV[16];
        RAND_bytes(aesKey, sizeof(aesKey));
        RAND_bytes(aesIV, sizeof(aesIV));

        std::string aesData = "Confidential AES Data";
        std::string aesEncrypted = encryption.encryptAES(aesData, aesKey, aesIV);
        std::cout << "AES Encrypted Data: " << aesEncrypted << std::endl;
        std::string aesDecrypted = encryption.decryptAES(aesEncrypted, aesKey, aesIV);
        std::cout << "AES Decrypted Data: " << aesDecrypted << std::endl;

        // Test RSA Encryption
        EVP_PKEY* rsaKeyPair = encryption.generateRSAKeyPair();
        std::string rsaData = "Confidential RSA Data";

        std::string rsaEncrypted = encryption.encryptRSA(rsaData, rsaKeyPair);
        std::cout << "RSA Encrypted Data: " << rsaEncrypted << std::endl;
        std::string rsaDecrypted = encryption.decryptRSA(rsaEncrypted, rsaKeyPair);
        std::cout << "RSA Decrypted Data: " << rsaDecrypted << std::endl;

        // Clean up RSA keys
        encryption.freeRSAKey(rsaKeyPair);

        // Test the Data Breach Monitor
        DataBreachMonitor breachMonitor;
        breachMonitor.checkForBreaches();

        // Test the Permission Monitor
        PermissionMonitor permissionMonitor;
        permissionMonitor.checkPermissions();

        // Test Web Filtering
        WebFilter webFilter;
        webFilter.filterURL("http://example.com");

        // Test VPN Encryption
        VpnEncryption vpnEncryption;
        vpnEncryption.initialize(aesKey, aesIV);
        std::string vpnEncrypted = vpnEncryption.encrypt("VPN data");
        std::cout << "VPN Encrypted Data: " << vpnEncrypted << std::endl;
        std::string vpnDecrypted = vpnEncryption.decrypt(vpnEncrypted);
        std::cout << "VPN Decrypted Data: " << vpnDecrypted << std::endl;
    }
    catch (const std::exception& e) {
        std::cerr << "An error occurred: " << e.what() << std::endl;
    }
}
