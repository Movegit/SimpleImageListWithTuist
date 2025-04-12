import ProjectDescription

let targets: [Target] = [
    .target(name: "JHPresentation",
            destinations: .iOS,
            product: .framework,
            bundleId: "io.tuist.SimpleImageListPresentationTuist",
            deploymentTargets: .iOS("15.0"),
            infoPlist: .default,
            sources: ["Sources/**"],
            resources: ["Resources/**"],
            dependencies: [
                .project(target: "JHUtil", path: "../Util"),
                .project(target: "JHDomain", path: "../Domain"),
                .package(product: "SwiftLintBuildToolPlugin", type: .plugin),
                .package(product: "SnapKit", type: .runtime),
                .package(product: "Kingfisher", type: .runtime),
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
    .target(name: "SimpleImageListPresentationTuistTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "io.tuist.SimpleImageListPresentationTuistTests",
            deploymentTargets: .iOS("15.0"),
            infoPlist: .default,
            sources: ["Tests/**"],
            resources: [],
            dependencies: [
                .target(name: "JHPresentation"),
                .package(product: "Quick", type: .runtime),
                .package(product: "Nimble", type: .runtime),
            ]),
]

let mainProject = Project(
    name: "JHPresentation",
    packages: [
        .remote(url: "https://github.com/SnapKit/SnapKit.git", requirement: .upToNextMajor(from: "5.0.0")),
        .remote(url: "https://github.com/onevcat/Kingfisher.git", requirement: .upToNextMajor(from: "7.0.0")),
        .remote(url: "https://github.com/Quick/Quick.git", requirement: .upToNextMajor(from: "6.0.0")),
        .remote(url: "https://github.com/Quick/Nimble.git", requirement: .upToNextMajor(from: "12.0.0")),
        .remote(url: "https://github.com/SimplyDanny/SwiftLintPlugins", requirement: .upToNextMajor(from: "0.56.1")),
    ],
    targets: targets
)
