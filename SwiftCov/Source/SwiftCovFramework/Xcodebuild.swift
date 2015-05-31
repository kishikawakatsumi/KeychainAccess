//
//  Xcodebuild.swift
//  swiftcov
//
//  Created by Kishikawa Katsumi on 2015-05-26.
//  Copyright (c) 2015 Realm. All rights reserved.
//

import Foundation
import Result

public struct Xcodebuild {
    private var arguments: [String]
    private let verbose: Bool

    public init(arguments: [String], verbose: Bool = false) {
        self.arguments = Array(split(arguments, allowEmptySlices: true) { $0 == "xcodebuild" }[1])
        self.verbose = verbose
    }

    public mutating func exchangeArgumentAtIndex(index: Int, argument: String) {
        arguments[index] = argument
    }

    public mutating func addArgument(argument: String) {
        arguments.append(argument)
    }

    public func showBuildSettings() -> Result<String, TerminationStatus> {
        let command = Shell(commandPath: "/usr/bin/xcrun", arguments: ["xcodebuild", "-showBuildSettings"] + arguments, verbose: verbose)
        return command.output()
    }

    public func buildExecutable() -> Result<String, TerminationStatus> {
        let command = Shell(commandPath: "/usr/bin/xcrun", arguments: ["xcodebuild", "SWIFT_OPTIMIZATION_LEVEL=-Onone", "ONLY_ACTIVE_ARCH=NO"] + arguments, verbose: verbose)
        return command.output()
    }
}
