#ifndef ENCRYPTION_H
#define ENCRYPTION_H

#include <string>
#include <vector>
#include <openssl/evp.h>
#include <openssl/rsa.h>
#include <openssl/pem.h>

class Encryption {
public:
    // Constructor and Destructor
    Encryption();
    ~Encryption();

    // Placeholder encryption and decryption for demonstration
    std::string encrypt(const std::string& data);
    std::string decrypt(const std::string& data);

    // AES Encryption and Decryption (AES-256-CBC)
    std::string encryptAES(const std::string& data, const unsigned char* key, const unsigned char* iv);
    std::string decryptAES(const std::string& data, const unsigned char* key, const unsigned char* iv);

    // RSA Key Pair Generation
    EVP_PKEY* generateRSAKeyPair();

    // RSA Encryption and Decryption
    std::string encryptRSA(const std::string& data, EVP_PKEY* key);
    std::string decryptRSA(const std::string& data, EVP_PKEY* key);

    // Free RSA Key
    void freeRSAKey(EVP_PKEY* key);

private:
    // Helper function for OpenSSL error handling
    void handleErrors();
};

#endif // ENCRYPTION_H
