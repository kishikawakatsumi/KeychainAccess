// swift-tools-version:5.6

//  Package.swift
//  KeychainAccess
//
//  Created by kishikawa katsumi on 2015/12/4.
//  Copyright (c) 2015 kishikawa katsumi. All rights reserved.
//

import PackageDescription

let package = Package(
    name: "KeychainAccess",
    platforms: [
        .macOS(.v10_10), .iOS(.v8), .tvOS(.v9), .watchOS(.v2)
    ],
    products: [
        .library(
            name: "KeychainAccess", targets: ["KeychainAccess"],
            dependencies: [], swiftSettings: [
                .unsafeFlags([
                    "-Xfrontend",
                    "-define-availability",
                    "-Xfrontend",
                    "SwiftStdlib 5.9",
                ])
            ]
        )
    ],
    targets: [
        .target(
            name: "KeychainAccess", path: "Lib/KeychainAccess",
            dependencies: [], swiftSettings: [
                .unsafeFlags([
                    "-Xfrontend",
                    "-define-availability",
                    "-Xfrontend",
                    "SwiftStdlib 5.9",
                ])
            ]
        )
    ]
)
