# Changelog

This project follows [Semantic Versioning](https://semver.org).

## 1.0.0
- `BiometricAuthenticating` protocol and `BiometricAuthenticator` (Face ID / Touch ID, async/await).
- `BiometricError`: typed errors, no raw `LAError` in the public API.
- `TokenStoring` protocol and `KeychainTokenStore` (this-device-only, when unlocked).
