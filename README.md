# 🛡️ CyberSec Flutter Suite

A full-stack, modular cybersecurity platform built with **Flutter (Dart)** for the frontend and **C++ (Visual Studio)** for the backend. This suite provides real-time threat detection, VPN and encryption tools, network monitoring, and more — all in a beautiful, cross-platform interface.

> 🎯 Ideal for: security researchers, analysts, and educational institutions building cyber-awareness tools.

---

👥 Author
Manaka Anthony Raphasha
Senior Software Engineer | Cybersecurity Developer

---

## 🧩 Architecture Overview

📁 /lib/ (Flutter Frontend)
├── models/ # Data models for each cybersecurity module
├── screens/ # UI screens mapped 1:1 with each module
├── services/ # Integration points (C++ backend bridges)

📁 /backend/ (C++ Backend)
├── src/
│ ├── core_modules/ # AES, VPN, Threat Engine, etc.
│ ├── interfaces/ # Exposed C++ <-> Dart FFI interfaces
│ └── main.cpp # Entry point for CLI or service

yaml
Copy
Edit

> 🔄 Communication between frontend and backend is done via **FFI (Dart ↔ C++)**, making it performant and native.

---

## 🔐 Key Features

| Module                   | Description                                               |
|--------------------------|-----------------------------------------------------------|
| 🔒 AES Encryption        | Fast symmetric key encryption/decryption (C++ backend)     |
| 🧠 Anomaly Detection     | Statistical and heuristic-based system behavior analysis   |
| 🚨 Breach Notifier       | Leak detection from logs or known breach lists             |
| 🌐 Browsing Monitor      | Real-time browser/network tracking                         |
| 📁 File Integrity        | Watch file changes and hash validation                     |
| 📡 Network Monitor       | Deep packet inspection and live stats                      |
| 🛡️ VPN + Encryption     | VPN routing and AES tunnel control                         |
| 🧬 Signature Database    | C++-driven pattern matching engine                         |
| 🕵️ Threat Intelligence  | Threat feeds & enrichment (YARA, IOC)                      |
| 🧰 Utility Toolkit       | Hashing tools, port scanner, IP geolocation, etc.          |
| 🌐 Web Filter            | URL blocking and DNS watchlist                            |

---

## 💻 Tech Stack

| Layer         | Technology                      |
|---------------|----------------------------------|
| Frontend      | Flutter (Dart)                   |
| Backend       | C++ (Visual Studio)              |
| UI/UX         | Material + Custom Secure Themes  |
| Integration   | Dart FFI                         |
| Build Target  | Desktop, Android (Linux-first)   |

---

## 🚀 Getting Started

### 🔧 Backend (C++)

1. Open `/backend/` in **Visual Studio 2022+**
2. Build `Release` or `Debug` target
3. Output will be a native DLL or executable exposing FFI methods

### 💻 Frontend (Flutter)


# Clone the repo
    git clone https://github.com/tshella/endpoint_security_app
    cd endpoint_security_app

# Install dependencies
flutter pub get

# Run app
    flutter run -d windows  # or linux/android
    Ensure your backend binary is accessible to the frontend (via .so / .dll / .dylib in platform-specific paths).

🔗 Integration (Dart ↔ C++)
FFI bindings are located in lib/services/ffi_bindings.dart

Each module (e.g., aes_encryption.dart) calls native methods from the compiled C++ backend

C++ header functions follow:

    extern "C" __declspec(dllexport) const char* encryptAES(const char* plaintext);
🧪 Status & To-Dos
✅ Frontend modules complete and modularized

✅ Backend core functionality in C++

🔄 C++ ↔ Dart integration in progress (via FFI)

⏳ Unit tests (Dart & C++) to be expanded

📊 Analytics & usage logging planned

🧰 Dev Tips
Use flutter_riverpod or provider for clean state management

Enable FFI logs for debug builds

On Linux/macOS, ensure .so or .dylib files are in the build/ path

On Windows, .dll must be placed in the same directory as the exe

🧠 Knowledge Tags
#Flutter #C++ #Cybersecurity #Encryption #FFI #ThreatDetection #VPN #ModularArchitecture #CrossPlatform

