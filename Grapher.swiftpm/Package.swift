// swift-tools-version: 5.7

import PackageDescription
import AppleProductTypes

let package = Package(
    name: "Grapher",
    platforms: [
        .iOS("16.0"),
        .macOS("13.0")
    ],
    products: [
        .iOSApplication(
            name: "Grapher",
            targets: ["AppModule"],
            bundleIdentifier: "com.example.Grapher",
            teamIdentifier: "",
            displayVersion: "1.0",
            bundleVersion: "1",
            appIcon: .placeholder(icon: .chart),
            accentColor: .presetColor(.blue),
            supportedDeviceFamilies: [
                .pad,
                .phone,
                .mac
            ],
            supportedInterfaceOrientations: [
                .portrait,
                .landscapeRight,
                .landscapeLeft,
                .portraitUpsideDown(.when(deviceFamilies: [.pad]))
            ]
        )
    ],
    targets: [
        .executableTarget(
            name: "AppModule",
            path: "."
        )
    ]
)
