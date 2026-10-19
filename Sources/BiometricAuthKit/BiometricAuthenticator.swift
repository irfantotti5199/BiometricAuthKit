#if canImport(LocalAuthentication)
import Foundation
import LocalAuthentication

/// The kind of biometric hardware available on the device.
public enum BiometricType: Equatable, Sendable {
    case none, touchID, faceID
}

/// Errors surfaced by the SDK. Public API never leaks raw `LAError`.
public enum BiometricError: Error, Equatable, Sendable {
    case notAvailable
    case notEnrolled
    case lockedOut
    case userCancelled
    case authenticationFailed
    case unknown
}

/// Public contract. Depend on this protocol in your app so it is easy to mock.
public protocol BiometricAuthenticating {
    var biometricType: BiometricType { get }
    func canAuthenticate() -> Result<Void, BiometricError>
    func authenticate(reason: String) async throws
}

/// Default implementation backed by `LocalAuthentication`.
public final class BiometricAuthenticator: BiometricAuthenticating {
    private let contextFactory: () -> LAContext

    public init() {
        self.contextFactory = { LAContext() }
    }

    /// Internal initializer used by tests.
    init(contextFactory: @escaping () -> LAContext) {
        self.contextFactory = contextFactory
    }

    public var biometricType: BiometricType {
        let context = contextFactory()
        var error: NSError?
        guard context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) else {
            return .none
        }
        switch context.biometryType {
        case .faceID: return .faceID
        case .touchID: return .touchID
        default: return .none
        }
    }

    public func canAuthenticate() -> Result<Void, BiometricError> {
        let context = contextFactory()
        var error: NSError?
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            return .success(())
        }
        return .failure(Self.map(error))
    }

    public func authenticate(reason: String) async throws {
        let context = contextFactory()
        do {
            _ = try await context.evaluatePolicy(
                .deviceOwnerAuthenticationWithBiometrics,
                localizedReason: reason
            )
        } catch {
            throw Self.map(error)
        }
    }

    static func map(_ error: Error?) -> BiometricError {
        guard let laError = error as? LAError else { return .unknown }
        switch laError.code {
        case .biometryNotAvailable: return .notAvailable
        case .biometryNotEnrolled: return .notEnrolled
        case .biometryLockout: return .lockedOut
        case .userCancel, .appCancel, .systemCancel: return .userCancelled
        case .authenticationFailed: return .authenticationFailed
        default: return .unknown
        }
    }
}
#endif
