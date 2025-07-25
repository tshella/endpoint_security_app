#include "vpn_encryption.h"
#include <stdexcept>
#include <vector>

VpnEncryption::VpnEncryption() : encryptCtx(EVP_CIPHER_CTX_new()), decryptCtx(EVP_CIPHER_CTX_new()) {}

VpnEncryption::~VpnEncryption() {
    if (encryptCtx) EVP_CIPHER_CTX_free(encryptCtx);
    if (decryptCtx) EVP_CIPHER_CTX_free(decryptCtx);
}

void VpnEncryption::initialize(unsigned char* key, unsigned char* iv) {
    if (!EVP_EncryptInit_ex(encryptCtx, EVP_aes_256_cbc(), NULL, key, iv))
        throw std::runtime_error("Encryption context initialization failed");

    if (!EVP_DecryptInit_ex(decryptCtx, EVP_aes_256_cbc(), NULL, key, iv))
        throw std::runtime_error("Decryption context initialization failed");
}

std::string VpnEncryption::encrypt(const std::string& data) {
    std::vector<unsigned char> ciphertext(data.size() + EVP_MAX_BLOCK_LENGTH);
    int len, ciphertext_len;

    if (!EVP_EncryptUpdate(encryptCtx, ciphertext.data(), &len, reinterpret_cast<const unsigned char*>(data.c_str()), data.size()))
        throw std::runtime_error("Encryption failed");
    ciphertext_len = len;

    if (!EVP_EncryptFinal_ex(encryptCtx, ciphertext.data() + len, &len))
        throw std::runtime_error("Encryption finalization failed");
    ciphertext_len += len;

    return std::string(ciphertext.begin(), ciphertext.begin() + ciphertext_len);
}

std::string VpnEncryption::decrypt(const std::string& data) {
    std::vector<unsigned char> plaintext(data.size());
    int len, plaintext_len;

    if (!EVP_DecryptUpdate(decryptCtx, plaintext.data(), &len, reinterpret_cast<const unsigned char*>(data.c_str()), data.size()))
        throw std::runtime_error("Decryption failed");
    plaintext_len = len;

    if (!EVP_DecryptFinal_ex(decryptCtx, plaintext.data() + len, &len))
        throw std::runtime_error("Decryption finalization failed");
    plaintext_len += len;

    return std::string(plaintext.begin(), plaintext.begin() + plaintext_len);
}
