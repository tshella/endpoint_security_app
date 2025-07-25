#include <boost/beast.hpp>
#include <boost/asio.hpp>
#include <iostream>
#include <string>
#include <ctime>
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
#include "anomaly_detector.h"
#include "threat_intelligence.h"
#include <openssl/rand.h>
#include <nlohmann/json.hpp>
#include <aes_encryption.h>
#include <breach_notifier.h>


using namespace boost;
namespace http = beast::http;
using tcp = asio::ip::tcp;
using json = nlohmann::json;

// Logging function with timestamp
void log(const std::string& message) {
    std::time_t now = std::time(nullptr);
    std::cout << "[" << std::ctime(&now) << "] " << message << std::endl;
}

// Helper function to create JSON responses
void createJsonResponse(http::response<http::string_body>& res, http::status status, const json& jsonBody) {
    res.result(status);
    res.set(http::field::content_type, "application/json");
    res.body() = jsonBody.dump();
    res.prepare_payload();
}


// Endpoint handler implementations
void handleAnomalyDetectionRequest(http::request<http::string_body>& req, http::response<http::string_body>& res) {
    try {
        if (req.method() == http::verb::post) {
            auto body = json::parse(req.body());
            std::string activityData = body.value("activity_data", "");

            AnomalyDetector anomalyDetector;
            bool anomaly = anomalyDetector.detectAnomaly(activityData);

            json responseBody = { {"status", "success"}, {"anomaly_detected", anomaly} };
            createJsonResponse(res, http::status::ok, responseBody);
            log("Anomaly detection POST request processed");
        }
        else if (req.method() == http::verb::get) {
            json responseBody = { {"status", "ready"}, {"message", "Anomaly detection endpoint ready"} };
            createJsonResponse(res, http::status::ok, responseBody);
            log("Anomaly detection GET request processed");
        }
        else {
            createJsonResponse(res, http::status::method_not_allowed, { {"error", "Only GET and POST methods allowed"} });
        }
    }
    catch (const std::exception& e) {
        createJsonResponse(res, http::status::internal_server_error, { {"error", e.what()} });
        log("Error in handleAnomalyDetectionRequest: " + std::string(e.what()));
    }
}

void handleBreachNotifierRequest(http::request<http::string_body>& req, http::response<http::string_body>& res) {
    try {
        if (req.method() == http::verb::post) {
            auto body = json::parse(req.body());
            std::string message = body.value("message", "Breach detected!");

            BreachNotifier notifier;
            notifier.notify(message);

            json responseBody = { {"status", "success"}, {"message", "Breach notification sent"} };
            createJsonResponse(res, http::status::ok, responseBody);
            log("Breach notifier POST request processed");
        }
        else if (req.method() == http::verb::get) {
            json responseBody = { {"status", "ready"}, {"message", "Breach notifier endpoint ready"} };
            createJsonResponse(res, http::status::ok, responseBody);
            log("Breach notifier GET request processed");
        }
        else {
            createJsonResponse(res, http::status::method_not_allowed, { {"error", "Only GET and POST methods allowed"} });
        }
    }
    catch (const std::exception& e) {
        createJsonResponse(res, http::status::internal_server_error, { {"error", e.what()} });
        log("Error in handleBreachNotifierRequest: " + std::string(e.what()));
    }
}

void handleBrowsingMonitorRequest(http::request<http::string_body>& req, http::response<http::string_body>& res) {
    try {
        if (req.method() == http::verb::post) {
            BrowsingMonitor browsingMonitor;
            browsingMonitor.monitorActivity();

            json responseBody = { {"status", "success"}, {"message", "Browsing activity monitored"} };
            createJsonResponse(res, http::status::ok, responseBody);
            log("Browsing monitor POST request processed");
        }
        else if (req.method() == http::verb::get) {
            json responseBody = { {"status", "ready"}, {"message", "Browsing monitor endpoint ready"} };
            createJsonResponse(res, http::status::ok, responseBody);
            log("Browsing monitor GET request processed");
        }
        else {
            createJsonResponse(res, http::status::method_not_allowed, { {"error", "Only GET and POST methods allowed"} });
        }
    }
    catch (const std::exception& e) {
        createJsonResponse(res, http::status::internal_server_error, { {"error", e.what()} });
        log("Error in handleBrowsingMonitorRequest: " + std::string(e.what()));
    }
}

void handleSignatureDatabaseRequest(http::request<http::string_body>& req, http::response<http::string_body>& res) {
    try {
        if (req.method() == http::verb::post) {
            SignatureDatabase signatureDb;
            signatureDb.loadSignatures("path_to_signature_file");

            json responseBody = { {"status", "success"}, {"message", "Signatures loaded successfully"} };
            createJsonResponse(res, http::status::ok, responseBody);
            log("Signature database POST request processed");
        }
        else if (req.method() == http::verb::get) {
            json responseBody = { {"status", "ready"}, {"message", "Signature database endpoint ready"} };
            createJsonResponse(res, http::status::ok, responseBody);
            log("Signature database GET request processed");
        }
        else {
            createJsonResponse(res, http::status::method_not_allowed, { {"error", "Only GET and POST methods allowed"} });
        }
    }
    catch (const std::exception& e) {
        createJsonResponse(res, http::status::internal_server_error, { {"error", e.what()} });
        log("Error in handleSignatureDatabaseRequest: " + std::string(e.what()));
    }
}

void handleUtilityRequest(http::request<http::string_body>& req, http::response<http::string_body>& res) {
    try {
        if (req.method() == http::verb::post) {
            // Extract length and special character inclusion from the request body
            auto body = json::parse(req.body());
            int length = body.value("length", 12);
            bool includeSpecialChars = body.value("include_special_chars", true);

            std::string password = generateRandomPassword(length, includeSpecialChars);
            json responseBody = { {"status", "success"}, {"generated_password", password} };
            createJsonResponse(res, http::status::ok, responseBody);
            log("Utility POST request processed");
        }
        else if (req.method() == http::verb::get) {
            // Default parameters for GET requests
            int length = 12;
            bool includeSpecialChars = true;

            std::string password = generateRandomPassword(length, includeSpecialChars);
            json responseBody = { {"status", "success"}, {"generated_password", password} };
            createJsonResponse(res, http::status::ok, responseBody);
            log("Utility GET request processed");
        }
        else {
            createJsonResponse(res, http::status::method_not_allowed, { {"error", "Only GET and POST methods allowed"} });
        }
    }
    catch (const std::exception& e) {
        createJsonResponse(res, http::status::internal_server_error, { {"error", e.what()} });
        log("Error in handleUtilityRequest: " + std::string(e.what()));
    }
}


// VPN Encryption endpoint handler
void handleVPNEncryptionRequest(http::request<http::string_body>& req, http::response<http::string_body>& res) {
    try {
        if (req.method() == http::verb::post) {
            VpnEncryption vpnEncryptor;
            unsigned char key[32], iv[16];
            RAND_bytes(key, sizeof(key));
            RAND_bytes(iv, sizeof(iv));
            vpnEncryptor.initialize(key, iv);

            json responseBody = {
                {"status", "success"},
                {"message", "VPN encryption initialized successfully"}
            };
            createJsonResponse(res, http::status::ok, responseBody);
            log("VPN encryption POST request processed");
        }
        else if (req.method() == http::verb::get) {
            json responseBody = {
                {"status", "ready"},
                {"message", "VPN encryption endpoint ready"}
            };
            createJsonResponse(res, http::status::ok, responseBody);
            log("VPN encryption GET request processed");
        }
        else {
            createJsonResponse(res, http::status::method_not_allowed, {
                {"error", "Only GET and POST methods allowed"}
                });
        }
    }
    catch (const std::exception& e) {
        createJsonResponse(res, http::status::internal_server_error, {
            {"error", e.what()}
            });
        log("Error in handleVPNEncryptionRequest: " + std::string(e.what()));
    }
}


// Web Filter endpoint handler
void handleWebFilterRequest(http::request<http::string_body>& req, http::response<http::string_body>& res) {
    try {
        if (req.method() == http::verb::post) {
            auto body = json::parse(req.body());
            std::string url = body.value("url", "");

            WebFilter webFilter;
            webFilter.filterURL(url);

            json responseBody = { {"status", "success"}, {"message", "Web filtering applied"} };
            createJsonResponse(res, http::status::ok, responseBody);
            log("Web filter POST request processed");
        }
        else if (req.method() == http::verb::get) {
            json responseBody = { {"status", "ready"}, {"message", "Web filter endpoint ready"} };
            createJsonResponse(res, http::status::ok, responseBody);
            log("Web filter GET request processed");
        }
        else {
            createJsonResponse(res, http::status::method_not_allowed, { {"error", "Only GET and POST methods allowed"} });
        }
    }
    catch (const std::exception& e) {
        createJsonResponse(res, http::status::internal_server_error, { {"error", e.what()} });
        log("Error in handleWebFilterRequest: " + std::string(e.what()));
    }
}

// Threat Intelligence endpoint handler
void handleThreatIntelligenceRequest(http::request<http::string_body>& req, http::response<http::string_body>& res) {
    try {
        if (req.method() == http::verb::post) {
            ThreatIntelligence threatIntel;
            bool success = threatIntel.fetchLatestThreats();

            json responseBody = { {"status", "success"}, {"message", "Threat intelligence updated"}, {"updated", success} };
            createJsonResponse(res, http::status::ok, responseBody);
            log("Threat intelligence POST request processed");
        }
        else if (req.method() == http::verb::get) {
            json responseBody = { {"status", "ready"}, {"message", "Threat intelligence endpoint ready"} };
            createJsonResponse(res, http::status::ok, responseBody);
            log("Threat intelligence GET request processed");
        }
        else {
            createJsonResponse(res, http::status::method_not_allowed, { {"error", "Only GET and POST methods allowed"} });
        }
    }
    catch (const std::exception& e) {
        createJsonResponse(res, http::status::internal_server_error, { {"error", e.what()} });
        log("Error in handleThreatIntelligenceRequest: " + std::string(e.what()));
    }
}

// AES Encryption endpoint handler
void handleAESEncryptionRequest(http::request<http::string_body>& req, http::response<http::string_body>& res) {
    try {
        Encryption encryption;
        if (req.method() == http::verb::post) {
            auto body = json::parse(req.body());
            std::string data = body.value("data", "");
            unsigned char key[32], iv[16];
            RAND_bytes(key, sizeof(key));
            RAND_bytes(iv, sizeof(iv));

            std::string encryptedData = encryption.encryptAES(data, key, iv);
            json responseBody = { {"status", "success"}, {"encrypted_data", encryptedData} };
            createJsonResponse(res, http::status::ok, responseBody);
            log("AES encryption POST request processed");
        }
        else if (req.method() == http::verb::get) {
            json responseBody = { {"status", "ready"}, {"message", "AES encryption endpoint ready"} };
            createJsonResponse(res, http::status::ok, responseBody);
            log("AES encryption GET request processed");
        }
        else {
            createJsonResponse(res, http::status::method_not_allowed, { {"error", "Only GET and POST methods allowed"} });
        }
    }
    catch (const std::exception& e) {
        createJsonResponse(res, http::status::internal_server_error, { {"error", e.what()} });
        log("Error in handleAESEncryptionRequest: " + std::string(e.what()));
    }
}

// Data Breach Monitor endpoint handler
void handleDataBreachMonitorRequest(http::request<http::string_body>& req, http::response<http::string_body>& res) {
    try {
        if (req.method() == http::verb::post) {
            DataBreachMonitor breachMonitor;
            breachMonitor.checkForBreaches();

            json responseBody = { {"status", "success"}, {"message", "Data breach check complete"} };
            createJsonResponse(res, http::status::ok, responseBody);
            log("Data breach monitor POST request processed");
        }
        else if (req.method() == http::verb::get) {
            json responseBody = { {"status", "ready"}, {"message", "Data breach monitor endpoint ready"} };
            createJsonResponse(res, http::status::ok, responseBody);
            log("Data breach monitor GET request processed");
        }
        else {
            createJsonResponse(res, http::status::method_not_allowed, { {"error", "Only GET and POST methods allowed"} });
        }
    }
    catch (const std::exception& e) {
        createJsonResponse(res, http::status::internal_server_error, { {"error", e.what()} });
        log("Error in handleDataBreachMonitorRequest: " + std::string(e.what()));
    }
}

// File Integrity endpoint handler
void handleFileIntegrityRequest(http::request<http::string_body>& req, http::response<http::string_body>& res) {
    try {
        FileIntegrity fileIntegrity;
        if (req.method() == http::verb::post) {
            auto body = json::parse(req.body());
            std::string filePath = body.value("file_path", "");
            bool integrityOk = fileIntegrity.checkIntegrity(filePath);

            json responseBody = { {"status", "success"}, {"integrity_ok", integrityOk} };
            createJsonResponse(res, http::status::ok, responseBody.dump());
            log("File integrity POST request processed");
        }
        else {
            json responseBody = { {"status", "ready"}, {"message", "File integrity endpoint ready"} };
            createJsonResponse(res, http::status::ok, responseBody.dump());
            log("File integrity GET request processed");
        }
    }
    catch (const std::exception& e) {
        createJsonResponse(res, http::status::internal_server_error, { {"error", e.what()} });
    }
}

// Network Monitor endpoint handler
void handleNetworkMonitorRequest(http::request<http::string_body>& req, http::response<http::string_body>& res) {
    try {
        if (req.method() == http::verb::post) {
            NetworkMonitor networkMonitor;
            networkMonitor.monitorTraffic();

            json responseBody = { {"status", "success"}, {"message", "Network traffic monitored"} };
            createJsonResponse(res, http::status::ok, responseBody);
            log("Network monitor POST request processed");
        }
        else if (req.method() == http::verb::get) {
            json responseBody = { {"status", "ready"}, {"message", "Network monitor endpoint ready"} };
            createJsonResponse(res, http::status::ok, responseBody);
            log("Network monitor GET request processed");
        }
        else {
            createJsonResponse(res, http::status::method_not_allowed, { {"error", "Only GET and POST methods allowed"} });
        }
    }
    catch (const std::exception& e) {
        createJsonResponse(res, http::status::internal_server_error, { {"error", e.what()} });
        log("Error in handleNetworkMonitorRequest: " + std::string(e.what()));
    }
}


// Permission Checker endpoint handler
void handlePermissionCheckerRequest(http::request<http::string_body>& req, http::response<http::string_body>& res) {
    try {
        if (req.method() == http::verb::post) {
            PermissionChecker permissionChecker;
            std::string user = "sampleUser";         // Replace with actual user data
            std::string permission = "samplePerm";   // Replace with actual permission data

            if (permissionChecker.checkPermissions(user, permission)) {
                json responseBody = { {"status", "success"}, {"message", "Permissions checked"} };
                createJsonResponse(res, http::status::ok, responseBody);
            }
            else {
                json responseBody = { {"status", "failure"}, {"message", "Permission denied"} };
                createJsonResponse(res, http::status::forbidden, responseBody);
            }
            log("Permission checker POST request processed");
        }
        else if (req.method() == http::verb::get) {
            json responseBody = { {"status", "ready"}, {"message", "Permission checker endpoint ready"} };
            createJsonResponse(res, http::status::ok, responseBody);
            log("Permission checker GET request processed");
        }
        else {
            createJsonResponse(res, http::status::method_not_allowed, { {"error", "Only GET and POST methods allowed"} });
        }
    }
    catch (const std::exception& e) {
        createJsonResponse(res, http::status::internal_server_error, { {"error", e.what()} });
        log("Error in handlePermissionCheckerRequest: " + std::string(e.what()));
    }
}

static Scanner scanner;

// Handler for `/api/scanner` - Start and Stop System-Wide Scan
void handleScannerRequest(http::request<http::string_body>& req, http::response<http::string_body>& res) {
    try {
        if (req.method() == http::verb::post) {
            Scanner scanner;
            scanner.startScan();

            json responseBody = {
                {"status", "success"},
                {"message", "System-wide scan started"},
                {"threats", json::array()} // Always return an empty array if no threats
            };
            createJsonResponse(res, http::status::ok, responseBody);
            log("Started system-wide scan.");
        }
        else {
            createJsonResponse(res, http::status::method_not_allowed, json{ {"error", "Only POST method allowed"} });
        }
    }
    catch (const std::exception& e) {
        createJsonResponse(res, http::status::internal_server_error, json{ {"error", e.what()} });
        log("Error in handleScannerRequest: " + std::string(e.what()));
    }
}



// Handler for `/api/scanner/file` - Scan a specific file
void handleFileScanRequest(http::request<http::string_body>& req, http::response<http::string_body>& res) {
    try {
        if (req.method() == http::verb::post) {
            auto body = json::parse(req.body());
            std::string filePath = body.value("filePath", "");

            if (filePath.empty()) {
                createJsonResponse(res, http::status::bad_request, { {"error", "File path is required"} });
                return;
            }

            bool threatDetected = scanner.scanFile(filePath);
            json responseBody = {
                {"status", "success"},
                {"message", "File scan completed"},
                {"filePath", filePath},
                {"threatDetected", threatDetected}
            };
            createJsonResponse(res, http::status::ok, responseBody);

            log("Scanned file: " + filePath + " | Threat Detected: " + (threatDetected ? "Yes" : "No"));
        }
        else {
            createJsonResponse(res, http::status::method_not_allowed, { {"error", "Only POST method is allowed"} });
        }
    }
    catch (const std::exception& e) {
        createJsonResponse(res, http::status::internal_server_error, { {"error", e.what()} });
        log("Error in handleFileScanRequest: " + std::string(e.what()));
    }
}

//handlePermissionMonitorRequest
void handlePermissionMonitorRequest(http::request<http::string_body>& req, http::response<http::string_body>& res) {
    try {
        if (req.method() == http::verb::post) {
            PermissionMonitor permissionMonitor;
            permissionMonitor.checkPermissions();

            json responseBody = { {"status", "success"}, {"message", "Permissions monitored"} };
            createJsonResponse(res, http::status::ok, responseBody);
            log("Permission monitor POST request processed");
        }
        else if (req.method() == http::verb::get) {
            json responseBody = { {"status", "ready"}, {"message", "Permission monitor endpoint ready"} };
            createJsonResponse(res, http::status::ok, responseBody);
            log("Permission monitor GET request processed");
        }
        else {
            createJsonResponse(res, http::status::method_not_allowed, json{ {"error", "Only GET and POST methods allowed"} });
        }
    }
    catch (const std::exception& e) {
        createJsonResponse(res, http::status::internal_server_error, json{ {"error", e.what()} });
        log("Error in handlePermissionMonitorRequest: " + std::string(e.what()));
    }
}

//handleThreatDetectionRequest
void handleThreatDetectionRequest(http::request<http::string_body>& req, http::response<http::string_body>& res) {
    try {
        if (req.method() == http::verb::post) {
            auto body = json::parse(req.body());
            std::string suspiciousData = body.value("data", "");

            ThreatDetection threatDetection;
            bool threatDetected = threatDetection.detectThreat(suspiciousData);

            json responseBody = { {"status", "success"}, {"threat_detected", threatDetected} };
            createJsonResponse(res, http::status::ok, responseBody);
            log("Threat detection POST request processed");
        }
        else if (req.method() == http::verb::get) {
            json responseBody = { {"status", "ready"}, {"message", "Threat detection endpoint ready"} };
            createJsonResponse(res, http::status::ok, responseBody);
            log("Threat detection GET request processed");
        }
        else {
            createJsonResponse(res, http::status::method_not_allowed, json{ {"error", "Only GET and POST methods allowed"} });
        }
    }
    catch (const std::exception& e) {
        createJsonResponse(res, http::status::internal_server_error, json{ {"error", e.what()} });
        log("Error in handleThreatDetectionRequest: " + std::string(e.what()));
    }
}
 //handleVPNRequest
void handleVPNRequest(http::request<http::string_body>& req, http::response<http::string_body>& res) {
    try {
        if (req.method() == http::verb::post) {
            VpnManager vpnManager;
            vpnManager.connect(); // Assume this connects to the VPN

            json responseBody = { {"status", "success"}, {"message", "VPN connection established"} };
            createJsonResponse(res, http::status::ok, responseBody);
            log("VPN POST request processed");
        }
        else if (req.method() == http::verb::get) {
            json responseBody = { {"status", "ready"}, {"message", "VPN endpoint ready"} };
            createJsonResponse(res, http::status::ok, responseBody);
            log("VPN GET request processed");
        }
        else {
            createJsonResponse(res, http::status::method_not_allowed, json{ {"error", "Only GET and POST methods allowed"} });
        }
    }
    catch (const std::exception& e) {
        createJsonResponse(res, http::status::internal_server_error, json{ {"error", e.what()} });
        log("Error in handleVPNRequest: " + std::string(e.what()));
    }
}

// Function to handle the check URL reputation request
void handleBrowsingMonitorCheckUrlRequest(http::request<http::string_body>& req, http::response<http::string_body>& res) {
    try {
        // Parse the request body
        const std::string& body = req.body();
        json requestData = json::parse(body);
        std::string urlToCheck = requestData["url"];

        // Check the URL reputation
        BrowsingMonitor monitor;
        bool isMalicious = monitor.checkURLReputation(urlToCheck);

        // Create the response JSON
        json responseBody = {
            {"isMalicious", isMalicious}
        };

        // Send the response
        res.result(http::status::ok);
        res.set(http::field::content_type, "application/json");
        res.body() = responseBody.dump();
        res.prepare_payload();

        log("BrowsingMonitor checked URL: " + urlToCheck + " | Malicious: " + (isMalicious ? "Yes" : "No"));
    }
    catch (const std::exception& e) {
        createJsonResponse(res, http::status::internal_server_error, e.what());
        log("Error in handleBrowsingMonitorCheckUrlRequest: " + std::string(e.what()));
    }
}

// File Integrity - Static instance for persistence
static FileIntegrity fileIntegrity;

// Start Integrity Check
void handleStartIntegrityCheck(http::request<http::string_body>& req, http::response<http::string_body>& res) {
    try {
        auto bodyJson = json::parse(req.body());
        std::string filePath = bodyJson.at("filePath");

        std::thread([filePath]() {
            try {
                bool result = fileIntegrity.checkIntegrity(filePath);
                log("File integrity result for " + filePath + ": " + (result ? "Verified" : "Tampered"));
            }
            catch (const std::exception& e) {
                log("Error during file integrity check: " + std::string(e.what()));
            }
            }).detach();

        createJsonResponse(res, http::status::ok, { {"message", "Integrity check started"} });
    }
    catch (const std::exception& e) {
        createJsonResponse(res, http::status::bad_request, { {"error", e.what()} });
    }
}

// Pause Integrity Check
void handlePauseIntegrityCheck(http::request<http::string_body>& req, http::response<http::string_body>& res) {
    try {
        fileIntegrity.pause();
        createJsonResponse(res, http::status::ok, { {"message", "Integrity check paused"} });
    }
    catch (const std::exception& e) {
        createJsonResponse(res, http::status::internal_server_error, { {"error", e.what()} });
    }
}

// Resume Integrity Check
void handleResumeIntegrityCheck(http::request<http::string_body>& req, http::response<http::string_body>& res) {
    try {
        fileIntegrity.resume();
        createJsonResponse(res, http::status::ok, { {"message", "Integrity check resumed"} });
    }
    catch (const std::exception& e) {
        createJsonResponse(res, http::status::internal_server_error, { {"error", e.what()} });
    }
}

// Stop Integrity Check
void handleStopIntegrityCheck(http::request<http::string_body>& req, http::response<http::string_body>& res) {
    try {
        fileIntegrity.stop();
        createJsonResponse(res, http::status::ok, { {"message", "Integrity check stopped"} });
    }
    catch (const std::exception& e) {
        createJsonResponse(res, http::status::internal_server_error, { {"error", e.what()} });
    }
}

// Get Progress
void handleGetProgress(http::request<http::string_body>& req, http::response<http::string_body>& res) {
    try {
        int progress = fileIntegrity.getProgress();
        createJsonResponse(res, http::status::ok, { {"progress", progress} });
    }
    catch (const std::exception& e) {
        createJsonResponse(res, http::status::internal_server_error, { {"error", e.what()} });
    }
}



void startServer() {
    log("Starting server...");
    try {
        asio::io_context ioc;
        tcp::acceptor acceptor(ioc, { asio::ip::make_address("127.0.0.1"), 8080 });
        log("Listening on http://localhost:8080/api...");

        for (;;) {
            tcp::socket socket(ioc);
            acceptor.accept(socket);

            beast::flat_buffer buffer;
            http::request<http::string_body> req;
            http::read(socket, buffer, req);

            http::response<http::string_body> res;

            // Routing requests to specific endpoint handlers
            if (req.target() == "/api/anomaly-detector") {
                handleAnomalyDetectionRequest(req, res);
            }
            else if (req.target() == "/api/breach-notifier") {
                handleBreachNotifierRequest(req, res);
            }
            else if (req.target() == "/api/browsing-monitor") {
                handleBrowsingMonitorRequest(req, res);
            }
            else if (req.target() == "/api/browsing-monitor/check-url") { // New handler
                if (req.method() == http::verb::post) {
                    handleBrowsingMonitorCheckUrlRequest(req, res);
                }
                else {
                    log("Invalid HTTP method for /api/browsing-monitor/check-url");
                    createJsonResponse(res, http::status::method_not_allowed,
                        json{ {"error", "Invalid HTTP method"} });
                }
            }
            else if (req.target() == "/api/signature-database") {
                handleSignatureDatabaseRequest(req, res);
            }
            else if (req.target() == "/api/threat-intelligence") {
                handleThreatIntelligenceRequest(req, res);
            }
            else if (req.target() == "/api/utility") {
                handleUtilityRequest(req, res);
            }
            else if (req.target() == "/api/vpn-encryption") {
                handleVPNEncryptionRequest(req, res);
            }
            else if (req.target() == "/api/web-filter") {
                handleWebFilterRequest(req, res);
            }
            else if (req.target() == "/api/aes-encryption") {
                handleAESEncryptionRequest(req, res);
            }
            else if (req.target() == "/api/data-breach-monitor") {
                handleDataBreachMonitorRequest(req, res);
            }
            else if (req.target() == "/api/file-integrity") {
                handleFileIntegrityRequest(req, res);
            }
            else if (req.target() == "/api/network-monitor") {
                handleNetworkMonitorRequest(req, res);
            }
            else if (req.target() == "/api/permission-checker") {
                handlePermissionCheckerRequest(req, res);
            }
            else if (req.target() == "/api/permission-monitor") {
                handlePermissionMonitorRequest(req, res);
            }
            else if (req.target() == "/api/scanner") {
                handleScannerRequest(req, res);
            }
            else if (req.target() == "/api/threat-detection") {
                handleThreatDetectionRequest(req, res);
            }
            else if (req.target() == "/api/vpn") {
                handleVPNRequest(req, res);
            }
            else if (req.target() == "/api/file-integrity/start") {
                handleStartIntegrityCheck(req, res);
            }
            else if (req.target() == "/api/file-integrity/pause") {
                handlePauseIntegrityCheck(req, res);
            }
            else if (req.target() == "/api/file-integrity/resume") {
                handleResumeIntegrityCheck(req, res);
            }
            else if (req.target() == "/api/file-integrity/stop") {
                handleStopIntegrityCheck(req, res);
            }
            else if (req.target() == "/api/file-integrity/progress") {
                handleGetProgress(req, res);
            }
            else if (req.target() == "/api/scanner") {
                handleScannerRequest(req, res); // Handles Start/Stop Scan
            }
            else if (req.target() == "/api/scanner/file") {
                handleFileScanRequest(req, res); // Handles File Scan
            }
            else if (req.target() == "/api/signature-database") {
                handleSignatureDatabaseRequest(req, res);
            }
            else if (req.target() == "/api/scanner") {
                handleScannerRequest(req, res); // Handles system-wide scans
            }
            else if (req.target() == "/api/scanner/file") {
                handleFileScanRequest(req, res); // Handles individual file scans
            }
            
            else {
                log("Received request for unknown endpoint: " + std::string(req.target()));
                createJsonResponse(res, http::status::not_found, json{ {"error", "Endpoint not found"} });
            }

            // Write the response back to the client
            http::write(socket, res);
        }
    }
    catch (const std::exception& e) {
        log("Server error: " + std::string(e.what()));
    }
}

int main() {
    startServer();
    return 0;
}
