# 🚀 SwiftX Full Showcase Example

This example demonstrates the complete power of the **SwiftX Framework**. It covers everything from basic routing to complex lifecycle plugins and request interceptors.

## 🏗️ Structure
The `main.swift` file is heavily commented-out and structured into sections:
1.  **Plugin Definition**: Creating a custom `AuthPlugin`.
2.  **Server Init**: Loading `.env` and registering official plugins.
3.  **Middleware**: Local request interception and context state management.
4.  **Routing & Groups**: API organization with path parameters.
5.  **Catch-all**: Custom 404 branding.
6.  **Startup**: High-performance runtime configuration.

## 🚀 How to Run

### 1. Requirements
-   **SwiftX 1.0.1+**
-   **Swift 6.2+** 

### 2. Configuration
Create a `.env` file in this directory:
```text
PORT=5200
API_KEY=my_secure_key
DEBUG=true
```

### 3. Execution
Run following command from the project root:
```powershell
swift run FullShowcase
```

Wait, ensure the package is updated to include the new target!
(Note: You might need to add `FullShowcase` to YOUR `Package.swift` targets).

## 💡 Key Concepts
-   **`Req`**: The request wrapper (headers, path, params).
-   **`Context`**: The request state (logs, sleep, key-value storage).
-   **`Res`**: The response wrapper (text, json, html, headers).
-   **`SwiftXApp`**: The main coordination unit.

---
Built by SwiftX Team.
