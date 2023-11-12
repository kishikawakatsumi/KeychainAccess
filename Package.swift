// swift-tools-version:5.0

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
        .library(name: "KeychainAccess", targets: ["KeychainAccess"]),
        .library(name: "KeychainAccessDynamic", type: .dynamic, targets: ["KeychainAccess"]),
        .library(name: "KeychainAccessStatic", type: .static, targets: ["KeychainAccess"])
    ],
    targets: [
        .target(
          name: "KeychainAccess",
          path: "Lib/KeychainAccess",
          linkerSettings: [.unsafeFlags(["-Xlinker", "-no_application_extension"])])
    ]
)
