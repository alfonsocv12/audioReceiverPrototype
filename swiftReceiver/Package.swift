// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "audioReceiver",
    products: [
        .executable(name: "audioReceiver", targets: ["audioReceiver"])
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser.git", from: "1.1.2")
    ],
    targets: [
        .executableTarget(
            name: "audioReceiver",
            dependencies: [
                .product(name: "ArgumentParser",
                         package: "swift-argument-parser")
            ]
        )
    ]
)