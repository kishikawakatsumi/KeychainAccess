//
//  IntegrationTests.swift
//  swiftcov
//
//  Created by Kishikawa Katsumi on 2015/05/31.
//  Copyright (c) 2015 Realm. All rights reserved.
//

import XCTest
import SwiftCovFramework

class CoverageReporterTests: XCTestCase {
    let reportFilename = "Calculator.swift.gcov"
    var fixtureFilePath: String {
        return "./Examples/ExampleFramework/results/" + reportFilename
    }

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testGenerateCoverageReportIOS() {
        let temporaryDirectory = NSTemporaryDirectory().stringByAppendingPathComponent(NSProcessInfo().globallyUniqueString)
        NSFileManager().createDirectoryAtPath(temporaryDirectory, withIntermediateDirectories: true, attributes: nil, error: nil)

        let reporter = CoverageReporter(outputDirectory: temporaryDirectory)

        let xcodebuild = Xcodebuild(arguments: ["xcodebuild",
                                                "test",
                                                "-project", "./Examples/ExampleFramework/ExampleFramework.xcodeproj",
                                                "-scheme", "ExampleFramework-iOS",
                                                "-configuration", "Release",
                                                "-sdk", "iphonesimulator",
                                                "-destination", "name=iPhone 6,OS=8.3",
                                                "-derivedDataPath", temporaryDirectory])
        switch xcodebuild.showBuildSettings() {
        case let .Success(output):
            let buildSettings = BuildSettings(output: output.value)

            switch xcodebuild.buildExecutable() {
            case .Success:
                switch reporter.runCoverageReport(buildSettings: buildSettings) {
                case .Success:
                    let reportFilePath = temporaryDirectory.stringByAppendingPathComponent(reportFilename)

                    XCTAssertEqual(
                        NSString(contentsOfFile: reportFilePath, encoding: NSUTF8StringEncoding, error: nil)!,
                        NSString(contentsOfFile: fixtureFilePath, encoding: NSUTF8StringEncoding, error: nil)!)
                case let .Failure(error):
                    XCTAssertNotEqual(error.value, EXIT_SUCCESS)
                    XCTFail("Execution failure")
                }
            case let .Failure(error):
                XCTAssertNotEqual(error.value, EXIT_SUCCESS)
                XCTFail("Execution failure")
            }
        case let .Failure(error):
            XCTAssertNotEqual(error.value, EXIT_SUCCESS)
            XCTFail("Execution failure")
        }
    }

    func testGenerateCoverageReportOSX() {
        let temporaryDirectory = NSTemporaryDirectory().stringByAppendingPathComponent(NSProcessInfo().globallyUniqueString)
        NSFileManager().createDirectoryAtPath(temporaryDirectory, withIntermediateDirectories: true, attributes: nil, error: nil)

        let reporter = CoverageReporter(outputDirectory: temporaryDirectory)

        let xcodebuild = Xcodebuild(arguments: ["xcodebuild",
                                                "test",
                                                "-project", "./Examples/ExampleFramework/ExampleFramework.xcodeproj",
                                                "-scheme", "ExampleFramework-Mac",
                                                "-configuration", "Release",
                                                "-sdk", "macosx",
                                                "-derivedDataPath", temporaryDirectory])
        switch xcodebuild.showBuildSettings() {
        case let .Success(output):
            let buildSettings = BuildSettings(output: output.value)
            
            switch xcodebuild.buildExecutable() {
            case .Success:
                switch reporter.runCoverageReport(buildSettings: buildSettings) {
                case .Success:
                    let reportFilePath = temporaryDirectory.stringByAppendingPathComponent(reportFilename)
                    
                    XCTAssertEqual(
                        NSString(contentsOfFile: reportFilePath, encoding: NSUTF8StringEncoding, error: nil)!,
                        NSString(contentsOfFile: fixtureFilePath, encoding: NSUTF8StringEncoding, error: nil)!)
                case let .Failure(error):
                    XCTAssertNotEqual(error.value, EXIT_SUCCESS)
                    XCTFail("Execution failure")
                }
            case let .Failure(error):
                XCTAssertNotEqual(error.value, EXIT_SUCCESS)
                XCTFail("Execution failure")
            }
        case let .Failure(error):
            XCTAssertNotEqual(error.value, EXIT_SUCCESS)
            XCTFail("Execution failure")
        }
    }

}
