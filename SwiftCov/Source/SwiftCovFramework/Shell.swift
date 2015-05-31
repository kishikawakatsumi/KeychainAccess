//
//  Shell.swift
//  swiftcov
//
//  Created by Kishikawa Katsumi on 2015-05-24.
//  Copyright (c) 2015 Realm. All rights reserved.
//

import Foundation
import Commandant
import Result

public typealias TerminationStatus = Int32

public class Shell {
    private let commandPath: String
    private let arguments: [String]
    private let workingDirectoryPath: String?
    private let environment: [String: String]?
    private let verbose: Bool

    private var outputString = ""

    public init(commandPath: String, arguments: [String] = [], workingDirectoryPath: String? = nil, environment: [String: String]? = nil, verbose: Bool = false) {
        self.commandPath = commandPath
        self.arguments = arguments
        self.workingDirectoryPath = workingDirectoryPath
        self.environment = environment
        self.verbose = verbose
    }

    public func run() -> Result<String, TerminationStatus> {
        return launchTask(createTask())
    }

    public func output() -> Result<String, TerminationStatus> {
        let task = createTask()
        task.standardOutput = NSPipe()
        return launchTask(task)
    }

    public func combinedOutput() -> Result<String, TerminationStatus> {
        let task = createTask()
        let pipe = NSPipe()
        task.standardOutput = pipe
        task.standardError = pipe
        return launchTask(task)
    }

    private func createTask() -> NSTask {
        let task = NSTask()
        task.setValue(false, forKey: "startsNewProcessGroup")
        task.launchPath = commandPath
        task.arguments = arguments
        if let workingDirectoryPath = workingDirectoryPath {
            task.currentDirectoryPath = workingDirectoryPath
        }
        if let environment = environment {
            task.environment = environment
        }
        return task
    }

    private func launchTask(task: NSTask) -> Result<String, TerminationStatus> {
        if let fileHandle = task.standardOutput.fileHandleForReading {
            fileHandle.readabilityHandler = { fileHandle in
                if let string = NSString(data: fileHandle.availableData, encoding: NSUTF8StringEncoding) {
                    if self.verbose {
                        fputs("\(string)", stdout)
                    }
                    self.outputString += string as String
                }
            }
        }
        if let fileHandle = task.standardError.fileHandleForReading {
            fileHandle.readabilityHandler = { fileHandle in
                if let string = NSString(data: fileHandle.availableData, encoding: NSUTF8StringEncoding) {
                    if self.verbose {
                        fputs("\(string)", stderr)
                    }
                    self.outputString += string as String
                }
            }
        }

        task.launch()
        task.waitUntilExit()

        task.terminationHandler = { task in
            if let fileHandle = task.standardOutput.fileHandleForReading {
                fileHandle.readabilityHandler = nil
            }
            if let fileHandle = task.standardError.fileHandleForReading {
                fileHandle.readabilityHandler = nil
            }
        }

        if task.terminationStatus == EXIT_SUCCESS {
            return .success(outputString)
        } else {
            return .failure(task.terminationStatus)
        }
    }
}
