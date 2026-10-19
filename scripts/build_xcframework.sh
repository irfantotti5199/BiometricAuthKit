#!/bin/bash
# Builds BiometricAuthKit.xcframework (device + simulator). Run on macOS with Xcode.
set -euo pipefail

NAME="BiometricAuthKit"
OUT="build"
rm -rf "$OUT"

archive() {
  xcodebuild archive \
    -scheme "$NAME" \
    -destination "$1" \
    -archivePath "$OUT/$2.xcarchive" \
    SKIP_INSTALL=NO \
    BUILD_LIBRARY_FOR_DISTRIBUTION=YES
}

archive "generic/platform=iOS" ios
archive "generic/platform=iOS Simulator" sim

xcodebuild -create-xcframework \
  -framework "$OUT/ios.xcarchive/Products/Library/Frameworks/$NAME.framework" \
  -framework "$OUT/sim.xcarchive/Products/Library/Frameworks/$NAME.framework" \
  -output "$OUT/$NAME.xcframework"

(cd "$OUT" && zip -r "$NAME.xcframework.zip" "$NAME.xcframework")
swift package compute-checksum "$OUT/$NAME.xcframework.zip"
