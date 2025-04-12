import ProjectDescription

let mainInfoPlist: [String: Plist.Value] = [
    "CFBundleShortVersionString": "1.0",
    "CFBundleVersion": "1",
    "UIApplicationSceneManifest": .dictionary([
        "UIApplicationSupportsMultipleScenes": .boolean(true),
        "UISceneConfigurations": .dictionary([
            "UIWindowSceneSessionRoleApplication": .array([
                .dictionary([
                    "UISceneConfigurationName": .string("Default Configuration"),
                    "UISceneDelegateClassName": .string("$(PRODUCT_MODULE_NAME).SceneDelegate")
                ])
            ])
        ])
    ]),
    "UILaunchStoryboardName": .string("LaunchScreen")
]

let targets: [Target] = [
    .target(name: "SimpleImageListMainTuist",
            destinations: .iOS,
            product: .app,
            bundleId: "io.tuist.SimpleImageListMainTuist",
            deploymentTargets: .iOS("15.0"),
            infoPlist: .extendingDefault(with: mainInfoPlist),
            sources: ["Sources/**"],
            resources: ["Resources/**"],
            dependencies: [
                .project(target: "JHPresentation", path: "../Presentation"),
                .package(product: "SwiftLintBuildToolPlugin", type: .plugin)
            ],
            settings: .settings(
                base: [
                    "SWIFT_VERSION": "5.7",
                    "TARGETED_DEVICE_FAMILY": "1,2"
                ],
                configurations: [
                    .debug(name: .debug, settings: [
                        "SWIFT_ACTIVE_COMPILATION_CONDITIONS": "DEBUG $(inherited)"
                    ]),
                    .release(name: .release, settings: [:])
                ]
            )),
    .target(name: "SimpleImageListMainTuistUITests",
            destinations: .iOS,
            product: .uiTests,
            bundleId: "io.tuist.SimpleImageListMainTuistUITests",
            deploymentTargets: .iOS("15.0"),
            infoPlist: .default,
            sources: ["UITests/**"],
            resources: [],
            dependencies: [
                .target(name: "SimpleImageListMainTuist")
            ])
]

let mainProject = Project(
    name: "Main",
    packages: [
        .remote(url: "https://github.com/SimplyDanny/SwiftLintPlugins", requirement: .upToNextMajor(from: "0.56.1")),
    ],
    targets: targets
)
