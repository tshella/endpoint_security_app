#include "permission_checker.h"
#include <iostream>
#include <fstream>
#include <sstream>
#include <iomanip>
#include <chrono>

// Constructor
PermissionChecker::PermissionChecker() {}

// Load roles and permissions from configuration
void PermissionChecker::loadRolesFromConfig(const std::string& configPath) {
    // Example: Populate roles and permissions with sample data for testing
    roles["admin"].permissions = { "read", "write", "delete" };
    roles["user"].permissions = { "read" };

    Permission readPerm = { "read", std::chrono::system_clock::now() + std::chrono::hours(1), false };
    Permission writePerm = { "write", std::chrono::system_clock::now() + std::chrono::hours(2), true };

    permissions["read"] = readPerm;
    permissions["write"] = writePerm;
}

// Assign a role to a user
void PermissionChecker::assignRole(const std::string& user, const std::string& role) {
    userRoles[user].insert(role);
}

// Check if a user has a specific permission, considering expiration and 2FA requirements
bool PermissionChecker::hasPermission(const std::string& user, const std::string& permission) {
    for (const auto& role : userRoles[user]) {
        const auto& rolePermissions = roles[role].permissions;
        if (rolePermissions.count(permission) && isPermissionActive(permissions[permission])) {
            if (permissions[permission].requires2FA) {
                return verify2FA(user);
            }
            return true;
        }
    }
    logAccessAttempt(user, permission, false);
    return false;
}

// Check if a permission is active based on its expiration
bool PermissionChecker::isPermissionActive(const Permission& permission) const {
    return std::chrono::system_clock::now() < permission.expiration;
}

// Log user access attempt
void PermissionChecker::logAccessAttempt(const std::string& user, const std::string& permission, bool success) const {
    std::ofstream logFile("access_log.txt", std::ios::app);
    auto now = std::chrono::system_clock::now();
    auto zonedTime = std::chrono::zoned_time{ std::chrono::current_zone(), now };

    if (logFile.is_open()) {
        logFile << "["
            << std::format("{:%Y-%m-%d %H:%M:%S}", zonedTime)
            << "] User: " << user
            << " attempted to access permission: " << permission
            << " Result: " << (success ? "Granted" : "Denied") << "\n";
        logFile.close();
    }
    else {
        std::cerr << "[PermissionChecker] Failed to open log file for writing.\n";
    }
}

// Simulate Two-Factor Authentication (2FA) verification
bool PermissionChecker::verify2FA(const std::string& user) {
    std::cout << "[2FA] Please enter the verification code sent to " << user << ":\n";
    std::string code;
    std::cin >> code;
    return code == "1234";  // Replace with actual 2FA verification
}

// Check if the permission is time-based and active
bool PermissionChecker::checkTimeBasedPermission(const Permission& permission) const {
    return std::chrono::system_clock::now() < permission.expiration;
}

// Placeholder for geographic location check
bool PermissionChecker::checkGeoLocation(const std::string& user) const {
    // Example: Only allow access from specific IP ranges or locations
    return true;  // Assume allowed
}

bool PermissionChecker::checkPermissions(const std::string& user, const std::string& permission) {
    if (!hasPermission(user, permission)) {
        logAccessAttempt(user, permission, false);
        return false;
    }

    const auto& perm = permissions[permission];
    if (!isPermissionActive(perm)) {
        logAccessAttempt(user, permission, false);
        return false;
    }

    if (perm.requires2FA && !verify2FA(user)) {
        logAccessAttempt(user, permission, false);
        return false;
    }

    if (!checkGeoLocation(user)) {
        logAccessAttempt(user, permission, false);
        return false;
    }

    logAccessAttempt(user, permission, true);
    return true;
}

// Load permissions from a configuration file
bool PermissionChecker::loadPermissions(const std::string& configPath) {
    // Load permissions from a config file
    // This is a stub and should be implemented to read actual configurations
    std::ifstream file(configPath);
    if (!file.is_open()) {
        logActivity("Failed to open permissions config file.");
        return false;
    }

    // Sample loading logic
    permissions["read_data"] = { "read_data", std::chrono::system_clock::now() + std::chrono::hours(24), false };
    permissions["write_data"] = { "write_data", std::chrono::system_clock::now() + std::chrono::hours(12), true };

    file.close();
    return true;
}

// Logging activity to console (can be expanded to write to a file or external logging system)
void PermissionChecker::logActivity(const std::string& logMessage) const {
    std::cout << logMessage << std::endl;
}
