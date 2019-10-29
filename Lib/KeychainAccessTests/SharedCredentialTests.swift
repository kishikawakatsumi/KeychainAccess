//
//  SharedCredentialTests.swift
//  KeychainAccessTests
//
//  Created by kishikawa katsumi on 10/12/15.
//  Copyright © 2015 kishikawa katsumi. All rights reserved.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import XCTest
import KeychainAccess

class SharedCredentialTests: XCTestCase {
    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testGetSharedPassword() {
        do {
            let expectation = self.expectation(description: "getSharedPassword")

            let keychain = Keychain(server: "https://kishikawakatsumi.com", protocolType: .https)

            keychain.getSharedPassword("kishikawakatsumi") { (password, error) -> () in
                XCTAssertNil(password)
                XCTAssertNotNil(error)
                expectation.fulfill()
            }

            waitForExpectations(timeout: 10.0, handler: nil)
        }
        do {
            let expectation = self.expectation(description: "getSharedPassword")

            let keychain = Keychain(server: "https://kishikawakatsumi.com", protocolType: .https)

            keychain.getSharedPassword { (account, password, error) -> () in
                XCTAssertNil(account)
                XCTAssertNil(password)
                XCTAssertNotNil(error)
                expectation.fulfill()
            }

            waitForExpectations(timeout: 10.0, handler: nil)
        }

    }

    func testGeneratePassword() {
        do {
            var passwords = Set<String>()
            for _ in 0...100_000 {
                let password = Keychain.generatePassword()

                #if swift(>=4.2)
                XCTAssertEqual(password.count, "xxx-xxx-xxx-xxx".count)
                #else
                XCTAssertEqual(password.characters.count, "xxx-xxx-xxx-xxx".characters.count)
                #endif
                XCTAssertFalse(passwords.contains(password))

                passwords.insert(password)
            }
        }
    }

}
