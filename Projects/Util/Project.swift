import ProjectDescription

let targets: [Target] = [
    .target(name: "JHUtil",
            destinations: .iOS,
            product: .framework,
            bundleId: "io.tuist.SimpleImageListUtilTuist",
            deploymentTargets: .iOS("15.0"),
            infoPlist: .default,
            sources: ["Sources/**"],
            resources: ["Resources/**"],
            dependencies: [
                .package(product: "SwiftLintBuildToolPlugin", type: .plugin),
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
            ))
]

let project = Project(
    name: "JHUtil",
    packages: [
        .remote(url: "https://github.com/SimplyDanny/SwiftLintPlugins", requirement: .upToNextMajor(from: "0.56.1")),
    ],
    targets: targets
)
