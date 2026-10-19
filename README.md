
# BiometricAuthKit

Small Swift SDK for Face ID / Touch ID authentication and Keychain token storage.
Protocol-based public API, typed errors, async/await, no third-party dependencies.

## Install

**Swift Package Manager**
```swift
.package(url: "https://github.com/irfantotti5199/BiometricAuthKit.git", from: "1.0.0")
```

**CocoaPods**
```ruby
pod 'BiometricAuthKit', '~> 1.0'
```

**XCFramework**: run `bash scripts/build_xcframework.sh` (macOS + Xcode), or download it from the CI artifacts.

## Usage
```swift
import BiometricAuthKit

let auth: BiometricAuthenticating = BiometricAuthenticator()
let store: TokenStoring = KeychainTokenStore()

switch auth.canAuthenticate() {
case .success:
    do {
        try await auth.authenticate(reason: "Unlock your account")
        let token = try store.load(for: "access_token")
    } catch let error as BiometricError {
        // .userCancelled, .lockedOut, .notEnrolled, ...
    }
case .failure(let reason):
    print("Biometrics unavailable: \(reason)")
}
```

## Design notes
- **Public API is protocols** (`BiometricAuthenticating`, `TokenStoring`), so apps can mock them in tests.
- **No platform errors leak**: `LAError` / `OSStatus` are mapped to `BiometricError` / `KeychainError`.
- **Versioning**: semantic versions, git tags, `CHANGELOG.md`, `BiometricAuthKitInfo.version`.
- **Requirements**: iOS 15+, Swift 5.9+.

## Release checklist
1. Update `SDKInfo.swift`, the podspec and `CHANGELOG.md`.
2. `git tag 1.0.0 && git push --tags`
3. `pod lib lint` (optional: `pod trunk push`).

