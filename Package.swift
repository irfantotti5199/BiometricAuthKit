// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "BiometricAuthKit",
    platforms: [.iOS(.v15), .macOS(.v12)],
    products: [
        // Dynamic so `xcodebuild archive` can produce a framework for the XCFramework.
        // SPM consumers can still depend on it normally.
        .library(name: "BiometricAuthKit", type: .dynamic, targets: ["BiometricAuthKit"])
    ],
    targets: [
        .target(name: "BiometricAuthKit"),
        .testTarget(name: "BiometricAuthKitTests", dependencies: ["BiometricAuthKit"])
    ]
)
