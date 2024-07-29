import ProjectDescription

let project = Project(
    name: "InvestPlayApp",
    organizationName: "InvestPlay",
    targets: [
        .target(
            name: "InvestPlaySDK",
            destinations: .iOS,
            product: .staticLibrary,
            bundleId: "br.com.investplaysdk",
            sources: ["InvestPlaySDK/Sources/**"],
            resources: ["InvestPlaySDK/Resources/**"]
        ),
        .target(
            name: "InvestPlayApp",
            destinations: .iOS,
            product: .app,
            bundleId: "br.com.investplayapp",
            infoPlist: .extendingDefault(
                with: ["UIApplicationSceneManifest": .dictionary(
                    ["UISceneConfigurations": .dictionary(
                        ["UIWindowSceneSessionRoleApplication": .array(
                            [.dictionary(
                                ["UISceneConfigurationName": .string(
                                    "Default Configuration"
                                ),
                                 "UISceneDelegateClassName": .string(
                                    "$(PRODUCT_MODULE_NAME).SceneDelegate"
                                 )]
                            )]
                        )]
                    ),
                     "UIApplicationSupportsMultipleScenes": .string(
                        "NO"
                     )]
                ), "UILaunchStoryboardName": .string("")]
            ),
//            infoPlist: .extendingDefault(
//                with: ["UIApplicationSceneManifest": .dictionary(
//                    ["UISceneConfigurations": .dictionary(
//                        ["UISceneConfigurationName": .string(
//                            "Default Configuration"
//                        ),
//                         "UISceneDelegateClassName": .string(
//                            "$(PRODUCT_MODULE_NAME).SceneDelegate"
//                         )]
//                    ),
//                     "UIApplicationSupportsMultipleScenes": .string(
//                        "NO"
//                     )]
//                )]
//            ),
            sources: ["InvestPlayApp/Sources/**"],
            resources: ["InvestPlayApp/Resources/**"],
            scripts: [.pre(
                script: """
if [[ "$(uname -m)" == arm64 ]]; then
    export PATH="/opt/homebrew/bin:$PATH"
fi

if which swiftlint > /dev/null; then
  swiftlint
else
  echo "warning: SwiftLint not installed, download from https://github.com/realm/SwiftLint"
fi
""",
                name: "SwiftLint"
            )],
            dependencies: [.target(name: "InvestPlaySDK")]
        ),
        .target(
            name: "InvestPlayAppTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "io.tuist.InvestPlayAppTests",
            infoPlist: .default,
            sources: ["InvestPlayApp/Tests/**"],
            resources: [],
            dependencies: [.target(name: "InvestPlayApp")]
        ),
    ]
)
