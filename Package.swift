// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "InvestplaySDK",
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "InvestplaySDK",
            targets: ["InvestplaySDK"]
        ),
    ],
    dependencies: [
        .package(
            url: "git@ssh.dev.azure.com:v3/unicredbr/TI/unicred-uds-ios",
            from: "1.22.0"
        )
    ],
    targets: [
        .target(
            name: "InvestplaySDK",
            dependencies: [
                "NetworkSDK",
                .product(
                    name: "DesignSystem",
                    package: "unicred-uds-ios"
                )
            ],
            path: "investplay-spm-sdk/InvestPlaySDK/InvestplaySDK"
        ),
        .binaryTarget(
            name: "NetworkSDK",
            path: "investplay-spm-sdk/NetworkSDK/NetworkSdk.xcframework"
        ),
        .testTarget(
            name: "InvestplaySDKTests",
            dependencies: ["InvestplaySDK"],
            path: "investplay-spm-sdk/InvestPlaySDK/InvestplaySDKTests"
        ),
    ]
)
