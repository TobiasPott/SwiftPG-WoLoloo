// swift-tools-version: 5.9

// WARNING:
// This file is automatically generated.
// Do not edit it by hand because the contents will be replaced.

import PackageDescription
import AppleProductTypes

let package = Package(
    name: "WoLoloo",
    platforms: [
        .iOS("17.0")
    ],
    products: [
        .iOSApplication(
            name: "WoLoloo",
            targets: ["AppModule"],
            bundleIdentifier: "de.tobiaspott.playground.wololoo",
            teamIdentifier: "LR2W97LX43",
            displayVersion: "0.5",
            bundleVersion: "34",
            appIcon: .asset("AppIcon"),
            accentColor: .presetColor(.blue),
            supportedDeviceFamilies: [
                .pad,
                .phone
            ],
            supportedInterfaceOrientations: [
                .portrait,
                .landscapeRight,
                .landscapeLeft,
                .portraitUpsideDown(.when(deviceFamilies: [.pad]))
            ],
            capabilities: [
                .localNetwork(purposeString: "Send Wake-On-Lan to specific devices on your network", bonjourServiceTypes: [])
            ],
            appCategory: .developerTools
        )
    ],
    targets: [
        .executableTarget(
            name: "AppModule",
            path: ".",
            resources: [
                .process("Resources")
            ],
            swiftSettings: [
                .enableUpcomingFeature("BareSlashRegexLiterals")
            ]
        )
    ]
)
