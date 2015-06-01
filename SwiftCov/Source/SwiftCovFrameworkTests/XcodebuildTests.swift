//
//  XcodebuildTests.swift
//  swiftcov
//
//  Created by Kishikawa Katsumi on 2015/05/31.
//  Copyright (c) 2015 Realm. All rights reserved.
//

import XCTest
import SwiftCovFramework

class XcodebuildTests: XCTestCase {

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testBuildSettings() {
        let xcodebuild = Xcodebuild(arguments: ["xcodebuild",
                                                "test",
                                                "-scheme", "SwiftCovFramework",
                                                "-configuration", "Debug",
                                                "-sdk", "macosx"])

        switch xcodebuild.showBuildSettings() {
        case let .Success(output):
            let buildSettings = BuildSettings(output: output.value)

            let executable = buildSettings.executable
            XCTAssertEqual(executable.name, "SwiftCovFramework")
            if let action = executable.buildSettings["ACTION"] {
                XCTAssertEqual(action, "test")
            } else {
                XCTFail("Failed to load build settings: ACTION")
            }
            if let confiuration = executable.buildSettings["CONFIGURATION"] {
                XCTAssertEqual(confiuration, "Debug")
            } else {
                XCTFail("Failed to load build settings: CONFIGURATION")
            }
            if let sdk = executable.buildSettings["SDK_NAME"] {
                XCTAssertTrue(sdk.hasPrefix("macosx"))
            } else {
                XCTFail("Failed to load build settings: SDK_NAME")
            }
            if let srcroot = executable.buildSettings["SRCROOT"] {
                XCTAssertEqual(srcroot, NSFileManager().currentDirectoryPath)
            } else {
                XCTFail("Failed to load build settings: SRCROOT")
            }

            let testingBundles = buildSettings.testingBundles
            XCTAssertEqual(testingBundles.count, 1)

            if let testingBundle = testingBundles.first {
                XCTAssertEqual(testingBundle.name, "SwiftCovFrameworkTests")
                if let action = testingBundle.buildSettings["ACTION"] {
                    XCTAssertEqual(action, "test")
                } else {
                    XCTFail("Failed to load build settings: ACTION")
                }
                if let confiuration = testingBundle.buildSettings["CONFIGURATION"] {
                    XCTAssertEqual(confiuration, "Debug")
                } else {
                    XCTFail("Failed to load build settings: CONFIGURATION")
                }
                if let sdk = testingBundle.buildSettings["SDK_NAME"] {
                    XCTAssertTrue(sdk.hasPrefix("macosx"))
                } else {
                    XCTFail("Failed to load build settings: SDK_NAME")
                }
                if let srcroot = testingBundle.buildSettings["SRCROOT"] {
                    XCTAssertEqual(srcroot, NSFileManager().currentDirectoryPath)
                } else {
                    XCTFail("Failed to load build settings: SRCROOT")
                }
            }
        case let .Failure(error):
            XCTAssertNotEqual(error.value, EXIT_SUCCESS)
            XCTFail("Execution failure")
        }
    }

    func testExchangeArgument() {
        var xcodebuild = Xcodebuild(arguments: ["xcodebuild", "test",
                                                "-scheme", "SwiftCovFramework",
                                                "-configuration", "Debug",
                                                "-sdk", "macosx"])
        xcodebuild.exchangeArgumentAtIndex(0, argument: "build")
        xcodebuild.exchangeArgumentAtIndex(4, argument: "Release")

        switch xcodebuild.showBuildSettings() {
        case let .Success(output):
            let buildSettings = BuildSettings(output: output.value)

            let executable = buildSettings.executable
            XCTAssertEqual(executable.name, "SwiftCovFramework")
            if let action = executable.buildSettings["ACTION"] {
                XCTAssertEqual(action, "build")
            } else {
                XCTFail("Failed to load build settings: ACTION")
            }
            if let confiuration = executable.buildSettings["CONFIGURATION"] {
                XCTAssertEqual(confiuration, "Release")
            } else {
                XCTFail("Failed to load build settings: CONFIGURATION")
            }
            if let sdk = executable.buildSettings["SDK_NAME"] {
                XCTAssertTrue(sdk.hasPrefix("macosx"))
            } else {
                XCTFail("Failed to load build settings: SDK_NAME")
            }
            if let srcroot = executable.buildSettings["SRCROOT"] {
                XCTAssertEqual(srcroot, NSFileManager().currentDirectoryPath)
            } else {
                XCTFail("Failed to load build settings: SRCROOT")
            }
        case let .Failure(error):
            XCTAssertNotEqual(error.value, EXIT_SUCCESS)
            XCTFail("Execution failure")
        }
    }

    func testAddArgument() {
        var xcodebuild = Xcodebuild(arguments: ["xcodebuild",
                                                "test",
                                                "-scheme", "SwiftCovFramework",
                                                "-configuration", "Debug",
                                                "-sdk", "macosx"])
        xcodebuild.addArgument("-derivedDataPath")
        xcodebuild.addArgument("build")

        switch xcodebuild.showBuildSettings() {
        case let .Success(output):
            let buildSettings = BuildSettings(output: output.value)

            let executable = buildSettings.executable
            XCTAssertEqual(executable.name, "SwiftCovFramework")
            if let action = executable.buildSettings["ACTION"] {
                XCTAssertEqual(action, "test")
            } else {
                XCTFail("Failed to load build settings: ACTION")
            }
            if let confiuration = executable.buildSettings["CONFIGURATION"] {
                XCTAssertEqual(confiuration, "Debug")
            } else {
                XCTFail("Failed to load build settings: CONFIGURATION")
            }
            if let sdk = executable.buildSettings["SDK_NAME"] {
                XCTAssertTrue(sdk.hasPrefix("macosx"))
            } else {
                XCTFail("Failed to load build settings: SDK_NAME")
            }
            if let srcroot = executable.buildSettings["SRCROOT"] {
                XCTAssertEqual(srcroot, NSFileManager().currentDirectoryPath)
            } else {
                XCTFail("Failed to load build settings: SRCROOT")
            }
            if let objroot = executable.buildSettings["OBJROOT"] {
                XCTAssertEqual(objroot,
                    NSFileManager().currentDirectoryPath
                    .stringByAppendingPathComponent("build")
                    .stringByAppendingPathComponent("Build/Intermediates"))
            } else {
                XCTFail("Failed to load build settings: BUILD_DIR")
            }
        case let .Failure(error):
            XCTAssertNotEqual(error.value, EXIT_SUCCESS)
            XCTFail("Execution failure")
        }
    }

}
