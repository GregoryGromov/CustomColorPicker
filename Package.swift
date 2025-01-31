// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "CustomColorPicker",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "CustomColorPicker",
            targets: ["CustomColorPicker"]),
    ],
    targets: [

        .target(
            name: "CustomColorPicker")
    ]
)
