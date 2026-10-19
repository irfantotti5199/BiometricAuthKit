import XCTest
@testable import BiometricAuthKit

#if canImport(LocalAuthentication)
import LocalAuthentication

final class BiometricErrorMappingTests: XCTestCase {
    func testLockoutMapsToLockedOut() {
        XCTAssertEqual(BiometricAuthenticator.map(LAError(.biometryLockout)), .lockedOut)
    }

    func testNotEnrolledMapsToNotEnrolled() {
        XCTAssertEqual(BiometricAuthenticator.map(LAError(.biometryNotEnrolled)), .notEnrolled)
    }

    func testNotAvailableMapsToNotAvailable() {
        XCTAssertEqual(BiometricAuthenticator.map(LAError(.biometryNotAvailable)), .notAvailable)
    }

    func testCancelVariantsMapToUserCancelled() {
        XCTAssertEqual(BiometricAuthenticator.map(LAError(.userCancel)), .userCancelled)
        XCTAssertEqual(BiometricAuthenticator.map(LAError(.systemCancel)), .userCancelled)
    }

    func testFailedMapsToAuthenticationFailed() {
        XCTAssertEqual(BiometricAuthenticator.map(LAError(.authenticationFailed)), .authenticationFailed)
    }

    func testUnknownErrorMapsToUnknown() {
        XCTAssertEqual(BiometricAuthenticator.map(NSError(domain: "x", code: 1)), .unknown)
        XCTAssertEqual(BiometricAuthenticator.map(nil), .unknown)
    }
}
#endif

final class SDKInfoTests: XCTestCase {
    func testVersionIsSemver() {
        let parts = BiometricAuthKitInfo.version.split(separator: ".")
        XCTAssertEqual(parts.count, 3)
        XCTAssertTrue(parts.allSatisfy { Int($0) != nil })
    }
}
