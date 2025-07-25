#include "aes_encryption.h"
#include <openssl/aes.h>
#include <openssl/evp.h>
#include <openssl/err.h>
#include <iostream>
#include <stdexcept>
#include <vector>
#include <cstring>

AesEncryption::AesEncryption() {}

AesEncryption::~AesEncryption() {}

void AesEncryption::handleErrors() {
    ERR_print_errors_fp(stderr);
    abort();
}

// Encrypt data using AES-256-CBC
std::string AesEncryption::encryptAES(const std::string& data, const unsigned char* key, const unsigned char* iv) {
    EVP_CIPHER_CTX* ctx = EVP_CIPHER_CTX_new();
    if (!ctx) handleErrors();

    if (EVP_EncryptInit_ex(ctx, EVP_aes_256_cbc(), NULL, key, iv) != 1)
        handleErrors();

    std::vector<unsigned char> ciphertext(data.size() + AES_BLOCK_SIZE);
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

// Decrypt data using AES-256-CBC
std::string AesEncryption::decryptAES(const std::string& encryptedData, const unsigned char* key, const unsigned char* iv) {
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
