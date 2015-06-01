//
//  Errors.swift
//  SwiftCov
//
//  Created by JP Simard on 2015-05-20.
//  Copyright (c) 2015 Realm. All rights reserved.
//

import Commandant
import Box

/// Possible errors within SwiftCov.
enum SwiftCovError: Printable {
    /// One or more argument was invalid.
    case InvalidArgument(description: String)

    case MissingBuildSetting(String)

    /// Failed to read a file at the given path.
    case ReadFailed(path: String)

    /// Failed to generate test code coverage files.
    case GenerateFailed

    /// An error occurred while shelling out.
    case TaskError(terminationStatus: Int32)

    /// An error message corresponding to this error.
    var description: String {
        switch self {
        case let .InvalidArgument(description):
            return description
        case let .MissingBuildSetting(description):
            return "`xcodebuild` did not return a build setting that we needed."
        case let .ReadFailed(path):
            return "Failed to read file at '\(path)'."
        case let .GenerateFailed:
            return "Failed to generate test code coverage files."
        case let .TaskError:
            return "A shell task exited unsuccessfully."
        }
    }
}

func toCommandantError(swiftCovError: SwiftCovError) -> CommandantError<SwiftCovError> {
    return .CommandError(Box(swiftCovError))
}
