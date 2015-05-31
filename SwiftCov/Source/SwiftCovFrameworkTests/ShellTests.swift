//
//  ShellTests.swift
//  swiftcov
//
//  Created by Kishikawa Katsumi on 2015/05/31.
//  Copyright (c) 2015 Realm. All rights reserved.
//

import XCTest
import SwiftCovFramework

class ShellTests: XCTestCase {

    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }

    func testCommand() {
        let command = Shell(commandPath: "/bin/echo")
        switch command.output() {
        case let .Success(output):
            XCTAssertEqual(output.value, "\n")
        case let .Failure(error):
            XCTAssertNotEqual(error.value, EXIT_SUCCESS)
            XCTFail("Execution failure")
        }
    }

    func testCommandWithArgument() {
        let command = Shell(commandPath: "/bin/echo", arguments: ["foo"])
        switch command.output() {
        case let .Success(output):
            XCTAssertEqual(output.value, "foo\n")
        case let .Failure(error):
            XCTAssertNotEqual(error.value, EXIT_SUCCESS)
            XCTFail("Execution failure")
        }
    }

    func testCommandWithArguments() {
        let command = Shell(commandPath: "/bin/echo", arguments: ["foo", "bar"])
        switch command.output() {
        case let .Success(output):
            XCTAssertEqual(output.value, "foo bar\n")
        case let .Failure(error):
            XCTAssertNotEqual(error.value, EXIT_SUCCESS)
            XCTFail("Execution failure")
        }
    }

    func testCommandWithOption() {
        let command = Shell(commandPath: "/bin/echo", arguments: ["-n", "foo"])
        switch command.output() {
        case let .Success(output):
            XCTAssertEqual(output.value, "foo")
        case let .Failure(error):
            XCTAssertNotEqual(error.value, EXIT_SUCCESS)
            XCTFail("Execution failure")
        }
    }

    func testCommandWithWorkingDirectoryPath() {
        let command = Shell(commandPath: "/bin/ls", workingDirectoryPath: "./Carthage")
        switch command.output() {
        case let .Success(output):
            XCTAssertEqual(output.value, "Checkouts\n")
        case let .Failure(error):
            XCTAssertNotEqual(error.value, EXIT_SUCCESS)
            XCTFail("Execution failure")
        }
    }

    func testCommandWithIllegalOption() {
        let command = Shell(commandPath: "/bin/ls", arguments: ["-j"])
        switch command.output() {
        case let .Success(output):
            XCTFail("Must be fail")
        case let .Failure(error):
            XCTAssertNotEqual(error.value, EXIT_SUCCESS)
        }
    }

}
