#include "encryption.h"
#include <stdexcept>
#include <openssl/rand.h>
#include <openssl/err.h>
#include <iostream>
#include <vector>

Encryption::Encryption() {}

Encryption::~Encryption() {}

// Placeholder encryption and decryption for demonstration
std::string Encryption::encrypt(const std::string& data) {
    return "Encrypted: " + data;
}

std::string Encryption::decrypt(const std::string& data) {
    return data.substr(11); // Assuming "Encrypted: " prefix
}

// Helper function to handle OpenSSL errors
void Encryption::handleErrors() {
    ERR_print_errors_fp(stderr);
    abort();
}

// AES Encryption using AES-256-CBC
std::string Encryption::encryptAES(const std::string& data, const unsigned char* key, const unsigned char* iv) {
    EVP_CIPHER_CTX* ctx = EVP_CIPHER_CTX_new();
    if (!ctx) handleErrors();

    if (EVP_EncryptInit_ex(ctx, EVP_aes_256_cbc(), NULL, key, iv) != 1)
        handleErrors();

    std::vector<unsigned char> ciphertext(data.size() + EVP_CIPHER_block_size(EVP_aes_256_cbc()));
    int len = 0, ciphertext_len = 0;

    if (EVP_EncryptUpdate(ctx, ciphertext.data(), &len, reinterpret_cast<const unsigned char*>(data.c_str()), data.size()) != 1)
        handleErrors();
    ciphertext_len = len;

    if (EVP_EncryptFinal_ex(ctx, ciphertext.data() + len, &len) != 1)
        handleErrors();
    ciphertext_len += len;

    EVP_CIPHER_CTX_free(ctx);

    return std::string(ciphertext.begin(), ciphertext.begin() + ciphertext_len);
}

// AES Decryption using AES-256-CBC
std::string Encryption::decryptAES(const std::string& encryptedData, const unsigned char* key, const unsigned char* iv) {
    EVP_CIPHER_CTX* ctx = EVP_CIPHER_CTX_new();
    if (!ctx) handleErrors();

    if (EVP_DecryptInit_ex(ctx, EVP_aes_256_cbc(), NULL, key, iv) != 1)
        handleErrors();

    std::vector<unsigned char> plaintext(encryptedData.size());
    int len = 0, plaintext_len = 0;

    if (EVP_DecryptUpdate(ctx, plaintext.data(), &len, reinterpret_cast<const unsigned char*>(encryptedData.c_str()), encryptedData.size()) != 1)
        handleErrors();
    plaintext_len = len;

    if (EVP_DecryptFinal_ex(ctx, plaintext.data() + len, &len) != 1)
        handleErrors();
    plaintext_len += len;

    EVP_CIPHER_CTX_free(ctx);

    return std::string(plaintext.begin(), plaintext.begin() + plaintext_len);
}

// RSA Key Pair Generation
EVP_PKEY* Encryption::generateRSAKeyPair() {
    EVP_PKEY* pkey = EVP_PKEY_new();
    EVP_PKEY_CTX* ctx = EVP_PKEY_CTX_new_id(EVP_PKEY_RSA, NULL);

    if (!ctx || EVP_PKEY_keygen_init(ctx) <= 0 || EVP_PKEY_CTX_set_rsa_keygen_bits(ctx, 2048) <= 0 || EVP_PKEY_keygen(ctx, &pkey) <= 0) {
        EVP_PKEY_CTX_free(ctx);
        throw std::runtime_error("Failed to generate RSA key pair");
    }

    EVP_PKEY_CTX_free(ctx);
    return pkey;
}

// RSA Encryption
std::string Encryption::encryptRSA(const std::string& data, EVP_PKEY* key) {
    EVP_PKEY_CTX* ctx = EVP_PKEY_CTX_new(key, NULL);
    if (!ctx) throw std::runtime_error("Failed to create context for encryption");

    if (EVP_PKEY_encrypt_init(ctx) <= 0)
        throw std::runtime_error("Encryption initialization failed");

    size_t outlen;
    if (EVP_PKEY_encrypt(ctx, NULL, &outlen, reinterpret_cast<const unsigned char*>(data.c_str()), data.size()) <= 0)
        throw std::runtime_error("Failed to determine buffer length for encryption");

    std::vector<unsigned char> encrypted(outlen);
    if (EVP_PKEY_encrypt(ctx, encrypted.data(), &outlen, reinterpret_cast<const unsigned char*>(data.c_str()), data.size()) <= 0)
        throw std::runtime_error("RSA encryption failed");

    EVP_PKEY_CTX_free(ctx);
    return std::string(encrypted.begin(), encrypted.end());
}

// RSA Decryption
std::string Encryption::decryptRSA(const std::string& data, EVP_PKEY* key) {
    EVP_PKEY_CTX* ctx = EVP_PKEY_CTX_new(key, NULL);
    if (!ctx) throw std::runtime_error("Failed to create context for decryption");

    if (EVP_PKEY_decrypt_init(ctx) <= 0)
        throw std::runtime_error("Decryption initialization failed");

    size_t outlen;
    if (EVP_PKEY_decrypt(ctx, NULL, &outlen, reinterpret_cast<const unsigned char*>(data.c_str()), data.size()) <= 0)
        throw std::runtime_error("Failed to determine buffer length for decryption");

    std::vector<unsigned char> decrypted(outlen);
    if (EVP_PKEY_decrypt(ctx, decrypted.data(), &outlen, reinterpret_cast<const unsigned char*>(data.c_str()), data.size()) <= 0)
        throw std::runtime_error("RSA decryption failed");

    EVP_PKEY_CTX_free(ctx);
    return std::string(decrypted.begin(), decrypted.begin() + outlen);
}

// Free RSA Key
void Encryption::freeRSAKey(EVP_PKEY* key) {
    EVP_PKEY_free(key);
}
