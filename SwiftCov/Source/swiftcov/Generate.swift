//
//  GenerateCommand.swift
//  SwiftCov
//
//  Created by JP Simard on 2015-05-20.
//  Copyright (c) 2015 Realm. All rights reserved.
//

import Commandant
import Result
import SwiftCovFramework

struct GenerateCommand: CommandType {
    typealias ClientError = SwiftCovError
    let verb = "generate"
    let function = "Generate test code coverage files for your Swift tests"

    func run(mode: CommandMode) -> Result<(), CommandantError<SwiftCovError>> {
        return GenerateOptions.evaluate(mode).flatMap { options in
            let arguments = Process.arguments
            if arguments.count < 4 {
                return .failure(.UsageError(description: "Usage: swiftcov generate [swiftcov options] xcodebuild [xcodebuild options]"))
            }
            let requiredArguments = [
                "xcodebuild",
                "test",
                "-configuration",
                "-sdk"
            ]
            for argument in requiredArguments {
                if find(arguments, argument) == nil {
                    return .failure(.UsageError(description: "'\(argument)' argument required"))
                }
            }

            println("Generate test code coverage files")
            println("Loading build settings...")

            var xcodebuild = Xcodebuild(arguments: arguments, verbose: options.debug)
            let result = xcodebuild.showBuildSettings()
                .map { BuildSettings(output: $0) }
                .flatMap { buildSettings -> Result<BuildSettings, TerminationStatus> in
                    println("Building target...")
                    return xcodebuild.buildExecutable().flatMap { _ in
                        return .success(buildSettings)
                    }
                }
                .flatMap { buildSettings -> Result<String, TerminationStatus> in
                    println("Generating code coverage...")
                    let coverageReporter = CoverageReporter(outputDirectory: options.output, threshold: options.threshold, verbose: options.debug)
                    return coverageReporter.runCoverageReport(buildSettings: buildSettings)
            }

            switch result {
            case .Success:
                return .success()
            case let .Failure(error):
                return .failure(toCommandantError(.GenerateFailed))
            }
        }
    }
}

struct GenerateOptions: OptionsType {
    let output: String
    let threshold: Int
    let debug: Bool

    static func create(output: String)(threshold: Int)(debug: Bool) -> GenerateOptions {
        return self(output: output, threshold: threshold, debug: debug)
    }

    static func evaluate(m: CommandMode) -> Result<GenerateOptions, CommandantError<SwiftCovError>> {
        return create
            <*> m <| Option(key: "output", defaultValue: "", usage: "Folder to output the coverage files to")
            <*> m <| Option(key: "threshold", defaultValue: 0, usage: "Threshold value of max hit count (for performance)")
            <*> m <| Option(key: "debug", defaultValue: false, usage: "Output very verbose progress messages")
    }
}
