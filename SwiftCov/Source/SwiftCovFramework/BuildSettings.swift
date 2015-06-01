//
//  BuildSettings.swift
//  swiftcov
//
//  Created by Kishikawa Katsumi on 2015-05-26.
//  Copyright (c) 2015 Realm. All rights reserved.
//

import Foundation

public typealias TargetName = String
public typealias BuildSettingsDictionary = [String: String]

public struct Executable {
    public let name: TargetName
    public let buildSettings: BuildSettingsDictionary
}

public struct TestingBundle {
    public let name: TargetName
    public let buildSettings: BuildSettingsDictionary
}

public struct BuildSettings {
    public let executable: Executable
    public let testingBundles: [TestingBundle]

    public init(output: String) {
        var executable = Executable(name: "", buildSettings: BuildSettingsDictionary())
        var bundles = [TestingBundle]()

        for (target, settings) in BuildSettings.parseOutput(output) {
            if let productType = settings["PRODUCT_TYPE"] {
                if productType == "com.apple.product-type.bundle.unit-test" {
                    bundles.append(TestingBundle(name: target, buildSettings: settings))
                } else {
                    executable = Executable(name: target, buildSettings: settings)
                }
            }
        }
        self.executable = executable
        self.testingBundles = bundles
    }

    private static func parseOutput(output: String) -> [TargetName: BuildSettingsDictionary] {
        let whitespaceAndNewlineCharacterSet = NSCharacterSet.whitespaceAndNewlineCharacterSet()
        let lines: [String] = {
            var lines = [String]()
            output.enumerateLines { line, _ in
                lines.append(line.stringByTrimmingCharactersInSet(whitespaceAndNewlineCharacterSet))
            }
            return lines.filter { !$0.isEmpty }
        }()

        var target: String?
        var settings = [TargetName: BuildSettingsDictionary]()
        for line in lines {
            let regex = NSRegularExpression(pattern: "^Build settings for action .+ and target (.+):$", options: nil, error: nil)!
            let matches = regex.matchesInString(line, options: nil, range: NSRange(location: 0, length: (line as NSString).length))
            if matches.count == 1 {
                for match in matches {
                    if let match = match as? NSTextCheckingResult {
                        target = (line as NSString).substringWithRange(match.rangeAtIndex(1))
                        if let target = target {
                            settings[target] = BuildSettingsDictionary()
                        }
                    }
                }
            } else if let target = target {
                let kv = split(line, allowEmptySlices: true) { $0 == "=" }
                let key = kv[0].stringByTrimmingCharactersInSet(whitespaceAndNewlineCharacterSet)
                let value = kv[1].stringByTrimmingCharactersInSet(whitespaceAndNewlineCharacterSet)
                if var s = settings[target] {
                    s[key] = value
                    settings[target] = s
                }
            }
        }

        return settings
    }
}
