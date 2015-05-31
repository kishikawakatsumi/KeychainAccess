//
//  VersionCommand.swift
//  SwiftCov
//
//  Created by JP Simard on 2015-05-20.
//  Copyright (c) 2015 Realm. All rights reserved.
//

import Commandant
import Result

private let version = "0.1.0"

struct VersionCommand: CommandType {
    typealias ClientError = SwiftCovError
    let verb = "version"
    let function = "Display the current version of SwiftCov"

    func run(mode: CommandMode) -> Result<(), CommandantError<SwiftCovError>> {
        switch mode {
        case let .Arguments:
            println(version)

        default:
            break
        }
        return .success(())
    }
}
