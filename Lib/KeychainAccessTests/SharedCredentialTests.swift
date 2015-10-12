//
//  SharedCredentialTests.swift
//  KeychainAccessTests
//
//  Created by kishikawa katsumi on 10/12/15.
//  Copyright © 2015 kishikawa katsumi. All rights reserved.
//

import XCTest
import KeychainAccess

class SharedCredentialTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testGeneratePassword() {
        do {
            var passwords = Set<String>()
            for _ in 0...100_000 {
                let password = Keychain.generatePassword()
                
                XCTAssertEqual(password.characters.count, "xxx-xxx-xxx-xxx".characters.count)
                XCTAssertFalse(passwords.contains(password))

                passwords.insert(password)
            }
        }

    }
}
