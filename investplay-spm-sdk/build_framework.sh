# A shell script for creating an XCFramework for iOS.

# Starting from a clean slate
# Removing the build and output folders
rm -rf ./build &&\
rm -rf ./output &&\

# Cleaning the workspace cache
xcodebuild \
    clean \
    -workspace InvestplaySDK.xcworkspace \
    -scheme InvestplaySDK

# Create an archive for iOS devices
xcodebuild \
    archive \
        SKIP_INSTALL=NO \
        BUILD_LIBRARY_FOR_DISTRIBUTION=YES \
        -workspace InvestplaySDK.xcworkspace \
        -scheme InvestplaySDK \
        -configuration Release \
        -destination "generic/platform=iOS" \
        -archivePath build/InvestplaySDK-iOS.xcarchive

# Create an archive for iOS simulators
xcodebuild \
    archive \
        SKIP_INSTALL=NO \
        BUILD_LIBRARY_FOR_DISTRIBUTION=YES \
        -workspace InvestplaySDK.xcworkspace \
        -scheme InvestplaySDK \
        -configuration Release \
        -destination "generic/platform=iOS Simulator" \
        -archivePath build/InvestplaySDK-iOS_Simulator.xcarchive

# Convert the archives to .framework
# and package them both into one xcframework
xcodebuild \
    -create-xcframework \
    -archive build/InvestplaySDK-iOS.xcarchive -framework InvestplaySDK.framework \
    -archive build/InvestplaySDK-iOS_Simulator.xcarchive -framework InvestplaySDK.framework \
    -output output/InvestplaySDK.xcframework &&\
    rm -rf build
