#ifndef PERMISSION_CHECKER_H
#define PERMISSION_CHECKER_H

#include <string>
#include <unordered_map>
#include <unordered_set>
#include <vector>
#include <chrono>
#include <optional>

class PermissionChecker {
public:
    struct Permission {
        std::string name;
        std::chrono::system_clock::time_point expiration;
        bool requires2FA;
    };

    struct Role {
        std::string name;
        std::unordered_set<std::string> permissions;
    };

    PermissionChecker();

    bool checkPermissions(const std::string& user, const std::string& permission);

    // Public access methods
    bool loadPermissions(const std::string& configPath);
    void loadRolesFromConfig(const std::string& configPath);
    std::unordered_map<std::string, Permission>& getPermissions();

    void assignRole(const std::string& user, const std::string& role);
    bool hasPermission(const std::string& user, const std::string& permission);
    bool isPermissionActive(const Permission& permission) const;
    bool verify2FA(const std::string& user);
    void logAccessAttempt(const std::string& user, const std::string& permission, bool success) const;

private:
    std::unordered_map<std::string, std::unordered_set<std::string>> userRoles;
    std::unordered_map<std::string, Role> roles;
    std::unordered_map<std::string, Permission> permissions;

    bool checkTimeBasedPermission(const Permission& permission) const;
    bool checkGeoLocation(const std::string& user) const;
    void logActivity(const std::string& logMessage) const;
};

// Inline getter for permissions
inline std::unordered_map<std::string, PermissionChecker::Permission>& PermissionChecker::getPermissions() {
    return permissions;
}

#endif // PERMISSION_CHECKER_H
