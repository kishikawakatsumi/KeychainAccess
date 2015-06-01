//
//  CoverageReporter.swift
//  swiftcov
//
//  Created by Kishikawa Katsumi on 2015/05/31.
//  Copyright (c) 2015 Realm. All rights reserved.
//

import Foundation
import Result

public class CoverageReporter {
    private let outputDirectory: String
    private let threshold: Int
    private let verbose: Bool

    public init(outputDirectory: String = "", threshold: Int = 0, verbose: Bool = false) {
        self.outputDirectory = outputDirectory
        self.threshold = threshold
        self.verbose = verbose
    }
    
    public func runCoverageReport(buildSettings settings: BuildSettings) -> Result<String, TerminationStatus> {
        func buildSetting(key: String) -> String? {
            return settings.executable.buildSettings[key]
        }

        func testBundleBuildSetting(key: String) -> String? {
            return settings.testingBundles.first?.buildSettings[key]
        }

        if let sdkName = buildSetting("SDK_NAME"),
            let sdkroot = buildSetting("SDKROOT"),
            let builtProductsDir = testBundleBuildSetting("BUILT_PRODUCTS_DIR"),
            let fullProductName = testBundleBuildSetting("FULL_PRODUCT_NAME"),
            let srcroot = buildSetting("SRCROOT"),
            let objectFileDirNormal = buildSetting("OBJECT_FILE_DIR_normal"),
            let currentArch = buildSetting("CURRENT_ARCH"),
            let scriptPath = NSBundle(forClass: Shell.self).pathForResource("coverage", ofType: "py") {
                let targetPath = builtProductsDir.stringByAppendingPathComponent(fullProductName)
                let outputDir: String
                if outputDirectory.isEmpty {
                    outputDir = objectFileDirNormal.stringByAppendingPathComponent(currentArch)
                } else {
                    let fileManager = NSFileManager.defaultManager()
                    var isDirectory: ObjCBool = false
                    if !fileManager.fileExistsAtPath(outputDirectory, isDirectory: &isDirectory) || !isDirectory {
                        fileManager.createDirectoryAtPath(outputDirectory, withIntermediateDirectories: true, attributes: nil, error: nil)
                    }
                    outputDir = outputDirectory
                }

                return Shell(commandPath: "/usr/bin/xcode-select", arguments: ["--print-path"], verbose: verbose).output()
                    .map { $0.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()) }
                    .flatMap { xcodePath -> Result<String, TerminationStatus> in
                        let dyldFallbackFrameworkPath = "/Library/Frameworks:/Network/Library/Frameworks:/System/Library/Frameworks:\(xcodePath)/Platforms/iPhoneSimulator.platform/Developer/Library/PrivateFrameworks:\(xcodePath)/Library/PrivateFrameworks:\(xcodePath)/../OtherFrameworks:\(xcodePath)/../SharedFrameworks:\(xcodePath)/Library/Frameworks:\(xcodePath)/Platforms/iPhoneSimulator.platform/Developer/Library/Frameworks"
                        let dyldFallbackLibraryPath = "\(xcodePath)/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator.sdk/usr/lib"

                        let env = [
                            "SWIFTCOV_SDK_NAME": sdkName,
                            "SWIFTCOV_DYLD_FRAMEWORK_PATH": builtProductsDir,
                            "SWIFTCOV_DYLD_LIBRARY_PATH": builtProductsDir,
                            "SWIFTCOV_DYLD_FALLBACK_FRAMEWORK_PATH": dyldFallbackFrameworkPath,
                            "SWIFTCOV_DYLD_FALLBACK_LIBRARY_PATH": dyldFallbackLibraryPath,
                            "SWIFTCOV_DYLD_ROOT_PATH": sdkroot,
                            "SWIFTCOV_HIT_COUNT": "\(threshold)"
                        ]
                        
                        return Shell(commandPath: "/usr/bin/python", arguments: [scriptPath, targetPath, srcroot, outputDir], environment: env, verbose: verbose).run()
                }
        }
        
        return Result(error: EXIT_FAILURE)
    }
}
