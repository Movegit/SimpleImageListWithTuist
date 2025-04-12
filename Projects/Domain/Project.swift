import ProjectDescription

let targets: [Target] = [
    .target(name: "JHDomain",
            destinations: .iOS,
            product: .framework,
            bundleId: "io.tuist.SimpleImageListDomainTuist",
            deploymentTargets: .iOS("15.0"),
            infoPlist: .default,
            sources: ["Sources/**"],
            resources: ["Resources/**"],
            dependencies: [
                .project(target: "JHAPIService", path: "../API"),
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
            )),
    .target(name: "SimpleImageListDomainTuistTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "io.tuist.SimpleImageListDomainTuistTests",
            deploymentTargets: .iOS("15.0"),
            infoPlist: .default,
            sources: ["Tests/**"],
            resources: [],
            dependencies: [
                .target(name: "JHDomain"),
                .package(product: "Quick", type: .runtime),
                .package(product: "Nimble", type: .runtime),
            ])
]

let project = Project(
    name: "JHDomain",
    packages: [
        .remote(url: "https://github.com/Quick/Quick.git", requirement: .upToNextMajor(from: "6.0.0")),
        .remote(url: "https://github.com/Quick/Nimble.git", requirement: .upToNextMajor(from: "12.0.0")),
        .remote(url: "https://github.com/SimplyDanny/SwiftLintPlugins", requirement: .upToNextMajor(from: "0.56.1")),
    ],
    targets: targets
)
