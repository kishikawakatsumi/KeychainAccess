//
//  KeychainAccessTests.swift
//  KeychainAccessTests
//
//  Created by kishikawa katsumi on 2014/12/24.
//  Copyright (c) 2014 kishikawa katsumi. All rights reserved.
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

import Foundation
import XCTest
import KeychainAccess

class KeychainAccessTests: XCTestCase {
    override func setUp() {
        super.setUp()

        do { try Keychain(service: "Twitter", accessGroup: "27AEDK3C9F.shared").removeAll() } catch {}
        do { try Keychain(service: "Twitter").removeAll() } catch {}

        do { try Keychain(server: URL(string: "https://example.com")!, protocolType: .https).removeAll() } catch {}
        do { try Keychain(server: URL(string: "https://example.com:443")!, protocolType: .https).removeAll() } catch {}

        do { try Keychain().removeAll() } catch {}
    }

    override func tearDown() {
        super.tearDown()
    }

    // MARK:

    func testGenericPassword() {
        do {
            // Add Keychain items
            let keychain = Keychain(service: "Twitter")

            do { try keychain.set("kishikawa_katsumi", key: "username") } catch {}
            do { try keychain.set("password_1234", key: "password") } catch {}

            let username = try! keychain.get("username")
            XCTAssertEqual(username, "kishikawa_katsumi")

            let password = try! keychain.get("password")
            XCTAssertEqual(password, "password_1234")
        }

        do {
            // Update Keychain items
            let keychain = Keychain(service: "Twitter")

            do { try keychain.set("katsumi_kishikawa", key: "username") } catch {}
            do { try keychain.set("1234_password", key: "password") } catch {}

            let username = try! keychain.get("username")
            XCTAssertEqual(username, "katsumi_kishikawa")

            let password = try! keychain.get("password")
            XCTAssertEqual(password, "1234_password")
        }

        do {
            // Remove Keychain items
            let keychain = Keychain(service: "Twitter")

            do { try keychain.remove("username") } catch {}
            do { try keychain.remove("password") } catch {}

            XCTAssertNil(try! keychain.get("username"))
            XCTAssertNil(try! keychain.get("password"))
        }
    }

    func testGenericPasswordSubscripting() {
        do {
            // Add Keychain items
            let keychain = Keychain(service: "Twitter", accessGroup: "27AEDK3C9F.shared")

            keychain["username"] = "kishikawa_katsumi"
            keychain["password"] = "password_1234"

            let username = keychain["username"]
            XCTAssertEqual(username, "kishikawa_katsumi")

            let password = keychain["password"]
            XCTAssertEqual(password, "password_1234")
        }

        do {
            // Update Keychain items
            let keychain = Keychain(service: "Twitter", accessGroup: "27AEDK3C9F.shared")

            keychain["username"] = "katsumi_kishikawa"
            keychain["password"] = "1234_password"

            let username = keychain["username"]
            XCTAssertEqual(username, "katsumi_kishikawa")

            let password = keychain["password"]
            XCTAssertEqual(password, "1234_password")
        }

        do {
            // Remove Keychain items
            let keychain = Keychain(service: "Twitter", accessGroup: "27AEDK3C9F.shared")

            keychain["username"] = nil
            keychain["password"] = nil

            XCTAssertNil(keychain["username"])
            XCTAssertNil(keychain["password"])
        }
    }

    func testGenericPasswordWithAccessGroup1() {
        do {
            // Add Keychain items
            // This attribute (kSecAttrAccessGroup) applies to macOS keychain items only if you also set a value of true for the
            // kSecUseDataProtectionKeychain key, the kSecAttrSynchronizable key, or both.
            // https://developer.apple.com/documentation/security/ksecattraccessgroup
            let keychain = Keychain(service: "Twitter").synchronizable(true)
            let keychainWithAccessGroup = Keychain(service: "Twitter", accessGroup: "27AEDK3C9F.shared").synchronizable(true)

            do { try keychain.set("kishikawa_katsumi", key: "username") } catch {}
            do { try keychain.set("password_1234", key: "password") } catch {}
            do { try keychainWithAccessGroup.set("kishikawa_katsumi_access_group", key: "username") } catch {}
            do { try keychainWithAccessGroup.set("password_1234_access_group", key: "password") } catch {}

            XCTAssertEqual(try! keychain.get("username"), "kishikawa_katsumi")
            XCTAssertEqual(try! keychain.get("password"), "password_1234")

            XCTAssertEqual(try! keychainWithAccessGroup.get("username"), "kishikawa_katsumi_access_group")
            XCTAssertEqual(try! keychainWithAccessGroup.get("password"), "password_1234_access_group")
        }

        do {
            // Update Keychain items
            let keychain = Keychain(service: "Twitter").synchronizable(true)
            let keychainWithAccessGroup = Keychain(service: "Twitter", accessGroup: "27AEDK3C9F.shared").synchronizable(true)

            do { try keychain.set("katsumi_kishikawa", key: "username") } catch {}
            do { try keychain.set("1234_password", key: "password") } catch {}
            do { try keychainWithAccessGroup.set("katsumi_kishikawa_access_group", key: "username") } catch {}
            do { try keychainWithAccessGroup.set("1234_password_access_group", key: "password") } catch {}

            XCTAssertEqual(try! keychain.get("username"), "katsumi_kishikawa")
            XCTAssertEqual(try! keychain.get("password"), "1234_password")

            XCTAssertEqual(try! keychainWithAccessGroup.get("username"), "katsumi_kishikawa_access_group")
            XCTAssertEqual(try! keychainWithAccessGroup.get("password"), "1234_password_access_group")
        }

        do {
            // Remove Keychain items
            let keychain = Keychain(service: "Twitter").synchronizable(true)
            let keychainWithAccessGroup = Keychain(service: "Twitter", accessGroup: "27AEDK3C9F.shared").synchronizable(true)

            XCTAssertNotNil(try! keychainWithAccessGroup.get("username"))
            XCTAssertNotNil(try! keychainWithAccessGroup.get("password"))

            do { try keychainWithAccessGroup.remove("username") } catch {}
            do { try keychainWithAccessGroup.remove("password") } catch {}


            XCTAssertNil(try! keychainWithAccessGroup.get("username"))
            XCTAssertNil(try! keychainWithAccessGroup.get("password"))

            XCTAssertNotNil(try! keychain.get("username"))
            XCTAssertNotNil(try! keychain.get("password"))

            do { try keychain.remove("username") } catch {}
            do { try keychain.remove("password") } catch {}

            XCTAssertNil(try! keychain.get("username"))
            XCTAssertNil(try! keychain.get("password"))
        }
    }

    func testGenericPasswordWithAccessGroup2() {
        do {
            // Add Keychain items
            let keychain = Keychain(service: "Twitter").synchronizable(true)
            let keychainWithAccessGroup = Keychain(service: "Twitter", accessGroup: "27AEDK3C9F.shared").synchronizable(true)

            do { try keychain.set("kishikawa_katsumi", key: "username") } catch {}
            do { try keychain.set("password_1234", key: "password") } catch {}
            do { try keychainWithAccessGroup.set("kishikawa_katsumi_access_group", key: "username") } catch {}
            do { try keychainWithAccessGroup.set("password_1234_access_group", key: "password") } catch {}

            XCTAssertEqual(try! keychain.get("username"), "kishikawa_katsumi")
            XCTAssertEqual(try! keychain.get("password"), "password_1234")

            XCTAssertEqual(try! keychainWithAccessGroup.get("username"), "kishikawa_katsumi_access_group")
            XCTAssertEqual(try! keychainWithAccessGroup.get("password"), "password_1234_access_group")
        }

        do {
            // Update Keychain items
            let keychain = Keychain(service: "Twitter").synchronizable(true)
            let keychainWithAccessGroup = Keychain(service: "Twitter", accessGroup: "27AEDK3C9F.shared").synchronizable(true)

            do { try keychain.set("katsumi_kishikawa", key: "username") } catch {}
            do { try keychain.set("1234_password", key: "password") } catch {}
            do { try keychainWithAccessGroup.set("katsumi_kishikawa_access_group", key: "username") } catch {}
            do { try keychainWithAccessGroup.set("1234_password_access_group", key: "password") } catch {}

            XCTAssertEqual(try! keychain.get("username"), "katsumi_kishikawa")
            XCTAssertEqual(try! keychain.get("password"), "1234_password")

            XCTAssertEqual(try! keychainWithAccessGroup.get("username"), "katsumi_kishikawa_access_group")
            XCTAssertEqual(try! keychainWithAccessGroup.get("password"), "1234_password_access_group")
        }

        do {
            // Remove Keychain items
            let keychain = Keychain(service: "Twitter").synchronizable(true)
            let keychainWithAccessGroup = Keychain(service: "Twitter", accessGroup: "27AEDK3C9F.shared").synchronizable(true)

            XCTAssertNotNil(try! keychainWithAccessGroup.get("username"))
            XCTAssertNotNil(try! keychainWithAccessGroup.get("password"))

            do { try keychain.remove("username") } catch {}
            do { try keychain.remove("password") } catch {}

            // If the access group is empty, the query will match all access group. So delete all values in other access groups.
            XCTAssertNil(try! keychain.get("username"))
            XCTAssertNil(try! keychain.get("password"))

            XCTAssertNil(try! keychainWithAccessGroup.get("username"))
            XCTAssertNil(try! keychainWithAccessGroup.get("password"))
        }
    }

    // MARK:

    func testInternetPassword() {
        do {
            // Add Keychain items
            let keychain = Keychain(server: URL(string: "https://kishikawakatsumi.com")!, protocolType: .https)

            do { try keychain.set("kishikawa_katsumi", key: "username") } catch {}
            do { try keychain.set("password_1234", key: "password") } catch {}

            let username = try! keychain.get("username")
            XCTAssertEqual(username, "kishikawa_katsumi")

            let password = try! keychain.get("password")
            XCTAssertEqual(password, "password_1234")
        }

        do {
            // Update Keychain items
            let keychain = Keychain(server: URL(string: "https://kishikawakatsumi.com")!, protocolType: .https)

            do { try keychain.set("katsumi_kishikawa", key: "username") } catch {}
            do { try keychain.set("1234_password", key: "password") } catch {}

            let username = try! keychain.get("username")
            XCTAssertEqual(username, "katsumi_kishikawa")

            let password = try! keychain.get("password")
            XCTAssertEqual(password, "1234_password")
        }

        do {
            // Remove Keychain items
            let keychain = Keychain(server: URL(string: "https://kishikawakatsumi.com")!, protocolType: .https)

            do { try keychain.remove("username") } catch {}
            do { try keychain.remove("password") } catch {}

            XCTAssertNil(try! keychain.get("username"))
            XCTAssertNil(try! keychain.get("password"))
        }
    }

    func testInternetPasswordSubscripting() {
        do {
            // Add Keychain items
            let keychain = Keychain(server: URL(string: "https://kishikawakatsumi.com")!, protocolType: .https)

            keychain["username"] = "kishikawa_katsumi"
            keychain["password"] = "password_1234"

            let username = keychain["username"]
            XCTAssertEqual(username, "kishikawa_katsumi")

            let password = keychain["password"]
            XCTAssertEqual(password, "password_1234")
        }

        do {
            // Update Keychain items
            let keychain = Keychain(server: URL(string: "https://kishikawakatsumi.com")!, protocolType: .https)

            keychain["username"] = "katsumi_kishikawa"
            keychain["password"] = "1234_password"

            let username = keychain["username"]
            XCTAssertEqual(username, "katsumi_kishikawa")

            let password = keychain["password"]
            XCTAssertEqual(password, "1234_password")
        }

        do {
            // Remove Keychain items
            let keychain = Keychain(server: URL(string: "https://kishikawakatsumi.com")!, protocolType: .https)

            keychain["username"] = nil
            keychain["password"] = nil

            XCTAssertNil(keychain["username"])
            XCTAssertNil(keychain["password"])
        }
    }

    func testInternetPasswordWithAccessGroup1() {
        do {
            // Add Keychain items
            // This attribute (kSecAttrAccessGroup) applies to macOS keychain items only if you also set a value of true for the
            // kSecUseDataProtectionKeychain key, the kSecAttrSynchronizable key, or both.
            // https://developer.apple.com/documentation/security/ksecattraccessgroup
            let keychain = Keychain(server: "https://kishikawakatsumi.com", protocolType: .https).synchronizable(true)
            let keychainWithAccessGroup = Keychain(server: "https://kishikawakatsumi.com", protocolType: .https, accessGroup: "27AEDK3C9F.shared").synchronizable(true)

            do { try keychain.set("kishikawa_katsumi", key: "username") } catch {}
            do { try keychain.set("password_1234", key: "password") } catch {}
            do { try keychainWithAccessGroup.set("kishikawa_katsumi_access_group", key: "username") } catch {}
            do { try keychainWithAccessGroup.set("password_1234_access_group", key: "password") } catch {}

            XCTAssertEqual(try! keychain.get("username"), "kishikawa_katsumi")
            XCTAssertEqual(try! keychain.get("password"), "password_1234")

            XCTAssertEqual(try! keychainWithAccessGroup.get("username"), "kishikawa_katsumi_access_group")
            XCTAssertEqual(try! keychainWithAccessGroup.get("password"), "password_1234_access_group")
        }

        do {
            // Update Keychain items
            let keychain = Keychain(server: "https://kishikawakatsumi.com", protocolType: .https).synchronizable(true)
            let keychainWithAccessGroup = Keychain(server: "https://kishikawakatsumi.com", protocolType: .https, accessGroup: "27AEDK3C9F.shared").synchronizable(true)

            do { try keychain.set("katsumi_kishikawa", key: "username") } catch {}
            do { try keychain.set("1234_password", key: "password") } catch {}
            do { try keychainWithAccessGroup.set("katsumi_kishikawa_access_group", key: "username") } catch {}
            do { try keychainWithAccessGroup.set("1234_password_access_group", key: "password") } catch {}

            XCTAssertEqual(try! keychain.get("username"), "katsumi_kishikawa")
            XCTAssertEqual(try! keychain.get("password"), "1234_password")

            XCTAssertEqual(try! keychainWithAccessGroup.get("username"), "katsumi_kishikawa_access_group")
            XCTAssertEqual(try! keychainWithAccessGroup.get("password"), "1234_password_access_group")
        }

        do {
            // Remove Keychain items
            let keychain = Keychain(server: "https://kishikawakatsumi.com", protocolType: .https).synchronizable(true)
            let keychainWithAccessGroup = Keychain(server: "https://kishikawakatsumi.com", protocolType: .https, accessGroup: "27AEDK3C9F.shared").synchronizable(true)

            XCTAssertNotNil(try! keychainWithAccessGroup.get("username"))
            XCTAssertNotNil(try! keychainWithAccessGroup.get("password"))

            do { try keychainWithAccessGroup.remove("username") } catch {}
            do { try keychainWithAccessGroup.remove("password") } catch {}


            XCTAssertNil(try! keychainWithAccessGroup.get("username"))
            XCTAssertNil(try! keychainWithAccessGroup.get("password"))

            XCTAssertNotNil(try! keychain.get("username"))
            XCTAssertNotNil(try! keychain.get("password"))

            do { try keychain.remove("username") } catch {}
            do { try keychain.remove("password") } catch {}

            XCTAssertNil(try! keychain.get("username"))
            XCTAssertNil(try! keychain.get("password"))
        }
    }

    func testInternetPasswordWithAccessGroup2() {
        do {
            // Add Keychain items
            let keychain = Keychain(server: "https://kishikawakatsumi.com", protocolType: .https).synchronizable(true)
            let keychainWithAccessGroup = Keychain(server: "https://kishikawakatsumi.com", protocolType: .https, accessGroup: "27AEDK3C9F.shared").synchronizable(true)

            do { try keychain.set("kishikawa_katsumi", key: "username") } catch {}
            do { try keychain.set("password_1234", key: "password") } catch {}
            do { try keychainWithAccessGroup.set("kishikawa_katsumi_access_group", key: "username") } catch {}
            do { try keychainWithAccessGroup.set("password_1234_access_group", key: "password") } catch {}

            XCTAssertEqual(try! keychain.get("username"), "kishikawa_katsumi")
            XCTAssertEqual(try! keychain.get("password"), "password_1234")

            XCTAssertEqual(try! keychainWithAccessGroup.get("username"), "kishikawa_katsumi_access_group")
            XCTAssertEqual(try! keychainWithAccessGroup.get("password"), "password_1234_access_group")
        }

        do {
            // Update Keychain items
            let keychain = Keychain(server: "https://kishikawakatsumi.com", protocolType: .https).synchronizable(true)
            let keychainWithAccessGroup = Keychain(server: "https://kishikawakatsumi.com", protocolType: .https, accessGroup: "27AEDK3C9F.shared").synchronizable(true)

            do { try keychain.set("katsumi_kishikawa", key: "username") } catch {}
            do { try keychain.set("1234_password", key: "password") } catch {}
            do { try keychainWithAccessGroup.set("katsumi_kishikawa_access_group", key: "username") } catch {}
            do { try keychainWithAccessGroup.set("1234_password_access_group", key: "password") } catch {}

            XCTAssertEqual(try! keychain.get("username"), "katsumi_kishikawa")
            XCTAssertEqual(try! keychain.get("password"), "1234_password")

            XCTAssertEqual(try! keychainWithAccessGroup.get("username"), "katsumi_kishikawa_access_group")
            XCTAssertEqual(try! keychainWithAccessGroup.get("password"), "1234_password_access_group")
        }

        do {
            // Remove Keychain items
            let keychain = Keychain(server: "https://kishikawakatsumi.com", protocolType: .https).synchronizable(true)
            let keychainWithAccessGroup = Keychain(server: "https://kishikawakatsumi.com", protocolType: .https, accessGroup: "27AEDK3C9F.shared").synchronizable(true)

            XCTAssertNotNil(try! keychainWithAccessGroup.get("username"))
            XCTAssertNotNil(try! keychainWithAccessGroup.get("password"))

            do { try keychain.remove("username") } catch {}
            do { try keychain.remove("password") } catch {}

            // If the access group is empty, the query will match all access group. So delete all values in other access groups.
            XCTAssertNil(try! keychain.get("username"))
            XCTAssertNil(try! keychain.get("password"))

            XCTAssertNil(try! keychainWithAccessGroup.get("username"))
            XCTAssertNil(try! keychainWithAccessGroup.get("password"))
        }
    }


    // MARK:

    func testDefaultInitializer() {
        let keychain = Keychain()
        XCTAssertEqual(keychain.service, Bundle.main.bundleIdentifier)
        let service: String
        #if targetEnvironment(macCatalyst)
        service = "maccatalyst.com.kishikawakatsumi.KeychainAccess.TestHost-MacCatalyst"
        #else
        service = "com.kishikawakatsumi.KeychainAccess.TestHost"
        #endif
        XCTAssertEqual(keychain.service, service)
        XCTAssertNil(keychain.accessGroup)
    }

    func testInitializerWithService() {
        let keychain = Keychain(service: "com.example.github-token")
        XCTAssertEqual(keychain.service, "com.example.github-token")
        XCTAssertNil(keychain.accessGroup)
    }

    func testInitializerWithAccessGroup() {
        let keychain = Keychain(accessGroup: "27AEDK3C9F.shared")
        let service: String
        #if targetEnvironment(macCatalyst)
        service = "maccatalyst.com.kishikawakatsumi.KeychainAccess.TestHost-MacCatalyst"
        #else
        service = "com.kishikawakatsumi.KeychainAccess.TestHost"
        #endif
        XCTAssertEqual(keychain.service, service)
        XCTAssertEqual(keychain.accessGroup, "27AEDK3C9F.shared")
    }

    func testInitializerWithServiceAndAccessGroup() {
        let keychain = Keychain(service: "com.example.github-token", accessGroup: "27AEDK3C9F.shared")
        XCTAssertEqual(keychain.service, "com.example.github-token")
        XCTAssertEqual(keychain.accessGroup, "27AEDK3C9F.shared")
    }

    func testInitializerWithServer() {
        let server = "https://kishikawakatsumi.com"
        let url = URL(string: server)!

        do {
            let keychain = Keychain(server: server, protocolType: .https)
            XCTAssertEqual(keychain.server, url)
            XCTAssertEqual(keychain.protocolType, ProtocolType.https)
            XCTAssertEqual(keychain.authenticationType, AuthenticationType.default)
        }
        do {
            let keychain = Keychain(server: url, protocolType: .https)
            XCTAssertEqual(keychain.server, url)
            XCTAssertEqual(keychain.protocolType, ProtocolType.https)
            XCTAssertEqual(keychain.authenticationType, AuthenticationType.default)
        }
    }

    func testInitializerWithServerAndAuthenticationType() {
        let server = "https://kishikawakatsumi.com"
        let url = URL(string: server)!

        do {
            let keychain = Keychain(server: server, protocolType: .https, authenticationType: .htmlForm)
            XCTAssertEqual(keychain.server, url)
            XCTAssertEqual(keychain.protocolType, ProtocolType.https)
            XCTAssertEqual(keychain.authenticationType, AuthenticationType.htmlForm)
        }
        do {
            let keychain = Keychain(server: url, protocolType: .https, authenticationType: .htmlForm)
            XCTAssertEqual(keychain.server, url)
            XCTAssertEqual(keychain.protocolType, ProtocolType.https)
            XCTAssertEqual(keychain.authenticationType, AuthenticationType.htmlForm)
        }
    }

    // MARK:

    func testContains() {
        let keychain = Keychain(service: "Twitter")

        XCTAssertFalse(try! keychain.contains("username"), "not stored username")
        XCTAssertFalse(try! keychain.contains("password"), "not stored password")

        do { try keychain.set("kishikawakatsumi", key: "username") } catch {}
        XCTAssertTrue(try! keychain.contains("username"), "stored username")
        XCTAssertFalse(try! keychain.contains("password"), "not stored password")

        do { try keychain.set("password1234", key: "password") } catch {}
        XCTAssertTrue(try! keychain.contains("username"), "stored username")
        XCTAssertTrue(try! keychain.contains("password"), "stored password")
    }

    // MARK:

    func testSetString() {
        let keychain = Keychain(service: "Twitter")

        XCTAssertNil(try! keychain.get("username"), "not stored username")
        XCTAssertNil(try! keychain.get("password"), "not stored password")

        do { try keychain.set("kishikawakatsumi", key: "username") } catch {}
        XCTAssertEqual(try! keychain.get("username"), "kishikawakatsumi", "stored username")
        XCTAssertNil(try! keychain.get("password"), "not stored password")

        do { try keychain.set("password1234", key: "password") } catch {}
        XCTAssertEqual(try! keychain.get("username"), "kishikawakatsumi", "stored username")
        XCTAssertEqual(try! keychain.get("password"), "password1234", "stored password")
    }

    func testSetStringWithLabel() {
        let keychain = Keychain(service: "Twitter")
            .label("Twitter Account")

        XCTAssertNil(keychain["kishikawakatsumi"], "not stored password")

        do {
            let label = try keychain.get("kishikawakatsumi") { (attributes) -> String? in
                return attributes?.label
            }
            XCTAssertNil(label)
        } catch {
            XCTFail("error occurred")
        }

        keychain["kishikawakatsumi"] = "password1234"
        XCTAssertEqual(keychain["kishikawakatsumi"], "password1234", "stored password")

        do {
            let label = try keychain.get("kishikawakatsumi") { (attributes) -> String? in
                return attributes?.label
            }
            XCTAssertEqual(label, "Twitter Account")
        } catch {
            XCTFail("error occurred")
        }
    }

    func testSetStringWithComment() {
        let keychain = Keychain(service: "Twitter")
            .comment("Kishikawa Katsumi")

        XCTAssertNil(keychain["kishikawakatsumi"], "not stored password")

        do {
            let comment = try keychain.get("kishikawakatsumi") { (attributes) -> String? in
                return attributes?.comment
            }
            XCTAssertNil(comment)
        } catch {
            XCTFail("error occurred")
        }

        keychain["kishikawakatsumi"] = "password1234"
        XCTAssertEqual(keychain["kishikawakatsumi"], "password1234", "stored password")

        do {
            let comment = try keychain.get("kishikawakatsumi") { (attributes) -> String? in
                return attributes?.comment
            }
            XCTAssertEqual(comment, "Kishikawa Katsumi")
        } catch {
            XCTFail("error occurred")
        }
    }

    func testSetStringWithLabelAndComment() {
        let keychain = Keychain(service: "Twitter")
            .label("Twitter Account")
            .comment("Kishikawa Katsumi")

        XCTAssertNil(keychain["kishikawakatsumi"], "not stored password")

        do {
            let label = try keychain.get("kishikawakatsumi") { (attributes) -> String? in
                return attributes?.label
            }
            XCTAssertNil(label)

            let comment = try keychain.get("kishikawakatsumi") { (attributes) -> String? in
                return attributes?.comment
            }
            XCTAssertNil(comment)
        } catch {
            XCTFail("error occurred")
        }

        keychain["kishikawakatsumi"] = "password1234"
        XCTAssertEqual(keychain["kishikawakatsumi"], "password1234", "stored password")

        do {
            let label = try keychain.get("kishikawakatsumi") { (attributes) -> String? in
                return attributes?.label
            }
            XCTAssertEqual(label, "Twitter Account")

            let comment = try keychain.get("kishikawakatsumi") { (attributes) -> String? in
                return attributes?.comment
            }
            XCTAssertEqual(comment, "Kishikawa Katsumi")
        } catch {
            XCTFail("error occurred")
        }
    }

    func testSetData() {
        let JSONObject = ["username": "kishikawakatsumi", "password": "password1234"]
        let JSONData = try! JSONSerialization.data(withJSONObject: JSONObject, options: [])

        let keychain = Keychain(service: "Twitter")

        XCTAssertNil(try! keychain.getData("JSONData"), "not stored JSON data")

        do { try keychain.set(JSONData, key: "JSONData") } catch {}
        XCTAssertEqual(try! keychain.getData("JSONData"), JSONData, "stored JSON data")
    }

    func testStringConversionError() {
        let keychain = Keychain(service: "Twitter")

        let length = 256
        let data = NSMutableData(length: length)!
        let bytes = data.mutableBytes.bindMemory(to: UInt8.self, capacity: length)
        _ = SecRandomCopyBytes(kSecRandomDefault, length, bytes)

        do {
            try keychain.set(data as Data, key: "RandomData")
            let _ = try keychain.getString("RandomData")
            XCTFail("no error occurred")
        } catch let error as NSError {
            XCTAssertEqual(error.domain, KeychainAccessErrorDomain)
            XCTAssertEqual(error.code, Int(Status.conversionError.rawValue))
            XCTAssertEqual(error.userInfo[NSLocalizedDescriptionKey] as! String, Status.conversionError.localizedDescription)
        } catch {
            XCTFail("unexpected error occurred")
        }

        do {
            try keychain.set(data as Data, key: "RandomData")
            let _ = try keychain.getString("RandomData")
            XCTFail("no error occurred")
        } catch Status.conversionError {
            XCTAssertTrue(true)
        } catch {
            XCTFail("unexpected error occurred")
        }
    }

    func testGetPersistentRef() {
        let keychain = Keychain(service: "Twitter")

        XCTAssertNil(keychain["kishikawakatsumi"], "not stored password")

        do {
            let persistentRef = try keychain.get("kishikawakatsumi") { $0?.persistentRef }
            XCTAssertNil(persistentRef)
        } catch {
            XCTFail("error occurred")
        }

        keychain["kishikawakatsumi"] = "password1234"
        XCTAssertEqual(keychain["kishikawakatsumi"], "password1234", "stored password")

        do {
            let persistentRef = try keychain.get("kishikawakatsumi") { $0?.persistentRef }
            XCTAssertNotNil(persistentRef)
        } catch {
            XCTFail("error occurred")
        }
    }

    #if os(iOS) || os(tvOS)
    func testSetAttributes() {
        do {
            var attributes = [String: Any]()
            attributes[String(kSecAttrDescription)] = "Description Test"
            attributes[String(kSecAttrComment)] = "Comment Test"
            attributes[String(kSecAttrCreator)] = "Creator Test"
            attributes[String(kSecAttrType)] = "Type Test"
            attributes[String(kSecAttrLabel)] = "Label Test"
            attributes[String(kSecAttrIsInvisible)] = true
            attributes[String(kSecAttrIsNegative)] = true

            let keychain = Keychain(service: "Twitter")
                .attributes(attributes)

            XCTAssertNil(keychain["kishikawakatsumi"], "not stored password")

            do {
                let attributes = try keychain.get("kishikawakatsumi") { $0 }
                XCTAssertNil(attributes)
            } catch {
                XCTFail("error occurred")
            }

            keychain["kishikawakatsumi"] = "password1234"
            XCTAssertEqual(keychain["kishikawakatsumi"], "password1234", "stored password")

            do {
                let attributes = try keychain.get("kishikawakatsumi") { $0 }
                XCTAssertEqual(attributes?.`class`, ItemClass.genericPassword.rawValue)
                XCTAssertEqual(attributes?.data, "password1234".data(using: .utf8))
                XCTAssertNil(attributes?.ref)
                XCTAssertNotNil(attributes?.persistentRef)
                XCTAssertEqual(attributes?.accessible, Accessibility.afterFirstUnlock.rawValue)
                #if targetEnvironment(macCatalyst)
                XCTAssertNotNil(attributes?.accessControl)
                #else
                if ProcessInfo().isOperatingSystemAtLeast(OperatingSystemVersion(majorVersion: 11, minorVersion: 3, patchVersion: 0)) {
                    XCTAssertNotNil(attributes?.accessControl)
                } else {
                    XCTAssertNil(attributes?.accessControl)
                }
                #endif
                let accessGroup: String
                #if targetEnvironment(macCatalyst)
                accessGroup = "27AEDK3C9F.com.kishikawakatsumi.KeychainAccess.TestHost-MacCatalyst"
                #else
                accessGroup = "27AEDK3C9F.com.kishikawakatsumi.KeychainAccess.TestHost"
                #endif
                XCTAssertEqual(attributes?.accessGroup, accessGroup)
                XCTAssertNotNil(attributes?.synchronizable)
                XCTAssertNotNil(attributes?.creationDate)
                XCTAssertNotNil(attributes?.modificationDate)
                XCTAssertEqual(attributes?.attributeDescription, "Description Test")
                XCTAssertEqual(attributes?.comment, "Comment Test")
                XCTAssertEqual(attributes?.creator, "Creator Test")
                XCTAssertEqual(attributes?.type, "Type Test")
                XCTAssertEqual(attributes?.label, "Label Test")
                XCTAssertEqual(attributes?.isInvisible, true)
                XCTAssertEqual(attributes?.isNegative, true)
                XCTAssertEqual(attributes?.account, "kishikawakatsumi")
                XCTAssertEqual(attributes?.service, "Twitter")
                XCTAssertNil(attributes?.generic)
                XCTAssertNil(attributes?.securityDomain)
                XCTAssertNil(attributes?.server)
                XCTAssertNil(attributes?.`protocol`)
                XCTAssertNil(attributes?.authenticationType)
                XCTAssertNil(attributes?.port)
                XCTAssertNil(attributes?.path)

                XCTAssertEqual(attributes?[String(kSecClass)] as? String, ItemClass.genericPassword.rawValue)
                XCTAssertEqual(attributes?[String(kSecValueData)] as? Data, "password1234".data(using: .utf8))
            } catch {
                XCTFail("error occurred")
            }
        }

        do {
            var attributes = [String: Any]()
            attributes[String(kSecAttrDescription)] = "Description Test"
            attributes[String(kSecAttrComment)] = "Comment Test"
            attributes[String(kSecAttrCreator)] = "Creator Test"
            attributes[String(kSecAttrType)] = "Type Test"
            attributes[String(kSecAttrLabel)] = "Label Test"
            attributes[String(kSecAttrIsInvisible)] = true
            attributes[String(kSecAttrIsNegative)] = true
            attributes[String(kSecAttrSecurityDomain)] = "securitydomain"

            let keychain = Keychain(server: URL(string: "https://example.com:443/api/login/")!, protocolType: .https)
                .attributes(attributes)

            XCTAssertNil(keychain["kishikawakatsumi"], "not stored password")

            do {
                let attributes = try keychain.get("kishikawakatsumi") { $0 }
                XCTAssertNil(attributes)
            } catch {
                XCTFail("error occurred")
            }

            do {
                keychain["kishikawakatsumi"] = "password1234"
                XCTAssertEqual(keychain["kishikawakatsumi"], "password1234", "stored password")

                let attributes = try keychain.get("kishikawakatsumi") { $0 }
                XCTAssertEqual(attributes?.`class`, ItemClass.internetPassword.rawValue)
                XCTAssertEqual(attributes?.data, "password1234".data(using: .utf8))
                XCTAssertNil(attributes?.ref)
                XCTAssertNotNil(attributes?.persistentRef)
                XCTAssertEqual(attributes?.accessible, Accessibility.afterFirstUnlock.rawValue)
                #if os(iOS)
                if #available(iOS 11.3, *) {
                    XCTAssertNotNil(attributes?.accessControl)
                } else if #available(iOS 9.0, *) {
                    XCTAssertNil(attributes?.accessControl)
                } else {
                    XCTAssertNotNil(attributes?.accessControl)
                }
                #else
                if #available(tvOS 11.3, *) {
                    XCTAssertNotNil(attributes?.accessControl)
                } else {
                    XCTAssertNil(attributes?.accessControl)
                }
                #endif
                let accessGroup: String
                #if targetEnvironment(macCatalyst)
                accessGroup = "27AEDK3C9F.com.kishikawakatsumi.KeychainAccess.TestHost-MacCatalyst"
                #else
                accessGroup = "27AEDK3C9F.com.kishikawakatsumi.KeychainAccess.TestHost"
                #endif
                XCTAssertEqual(attributes?.accessGroup, accessGroup)
                XCTAssertNotNil(attributes?.synchronizable)
                XCTAssertNotNil(attributes?.creationDate)
                XCTAssertNotNil(attributes?.modificationDate)
                XCTAssertEqual(attributes?.attributeDescription, "Description Test")
                XCTAssertEqual(attributes?.comment, "Comment Test")
                XCTAssertEqual(attributes?.creator, "Creator Test")
                XCTAssertEqual(attributes?.type, "Type Test")
                XCTAssertEqual(attributes?.label, "Label Test")
                XCTAssertEqual(attributes?.isInvisible, true)
                XCTAssertEqual(attributes?.isNegative, true)
                XCTAssertEqual(attributes?.account, "kishikawakatsumi")
                XCTAssertNil(attributes?.service)
                XCTAssertNil(attributes?.generic)
                XCTAssertEqual(attributes?.securityDomain, "securitydomain")
                XCTAssertEqual(attributes?.server, "example.com")
                XCTAssertEqual(attributes?.`protocol`, ProtocolType.https.rawValue)
                XCTAssertEqual(attributes?.authenticationType, AuthenticationType.default.rawValue)
                XCTAssertEqual(attributes?.port, 443)
                XCTAssertEqual(attributes?.path, "")
            } catch {
                XCTFail("error occurred")
            }
            do {
                let keychain = Keychain(server: URL(string: "https://example.com:443/api/login/")!, protocolType: .https)

                XCTAssertEqual(keychain["kishikawakatsumi"], "password1234", "stored password")

                keychain["kishikawakatsumi"] = "1234password"
                XCTAssertEqual(keychain["kishikawakatsumi"], "1234password", "updated password")

                let attributes = try keychain.get("kishikawakatsumi") { $0 }
                XCTAssertEqual(attributes?.`class`, ItemClass.internetPassword.rawValue)
                XCTAssertEqual(attributes?.data, "1234password".data(using: .utf8))
                XCTAssertNil(attributes?.ref)
                XCTAssertNotNil(attributes?.persistentRef)
                XCTAssertEqual(attributes?.accessible, Accessibility.afterFirstUnlock.rawValue)
                #if os(iOS)
                if #available(iOS 11.3, *) {
                    XCTAssertNotNil(attributes?.accessControl)
                } else if #available(iOS 9.0, *) {
                    XCTAssertNil(attributes?.accessControl)
                } else {
                    XCTAssertNotNil(attributes?.accessControl)
                }
                #else
                if #available(tvOS 11.3, *) {
                    XCTAssertNotNil(attributes?.accessControl)
                } else {
                    XCTAssertNil(attributes?.accessControl)
                }
                #endif
                let accessGroup: String
                #if targetEnvironment(macCatalyst)
                accessGroup = "27AEDK3C9F.com.kishikawakatsumi.KeychainAccess.TestHost-MacCatalyst"
                #else
                accessGroup = "27AEDK3C9F.com.kishikawakatsumi.KeychainAccess.TestHost"
                #endif
                XCTAssertEqual(attributes?.accessGroup, accessGroup)
                XCTAssertNotNil(attributes?.synchronizable)
                XCTAssertNotNil(attributes?.creationDate)
                XCTAssertNotNil(attributes?.modificationDate)
                XCTAssertEqual(attributes?.attributeDescription, "Description Test")
                XCTAssertEqual(attributes?.comment, "Comment Test")
                XCTAssertEqual(attributes?.creator, "Creator Test")
                XCTAssertEqual(attributes?.type, "Type Test")
                XCTAssertEqual(attributes?.label, "Label Test")
                XCTAssertEqual(attributes?.isInvisible, true)
                XCTAssertEqual(attributes?.isNegative, true)
                XCTAssertEqual(attributes?.account, "kishikawakatsumi")
                XCTAssertNil(attributes?.service)
                XCTAssertNil(attributes?.generic)
                XCTAssertEqual(attributes?.securityDomain, "securitydomain")
                XCTAssertEqual(attributes?.server, "example.com")
                XCTAssertEqual(attributes?.`protocol`, ProtocolType.https.rawValue)
                XCTAssertEqual(attributes?.authenticationType, AuthenticationType.default.rawValue)
                XCTAssertEqual(attributes?.port, 443)
                XCTAssertEqual(attributes?.path, "")
            } catch {
                XCTFail("error occurred")
            }
            do {
                let keychain = Keychain(server: URL(string: "https://example.com:443/api/login/")!, protocolType: .https)
                    .attributes([String(kSecAttrDescription): "Updated Description"])

                XCTAssertEqual(keychain["kishikawakatsumi"], "1234password", "stored password")

                keychain["kishikawakatsumi"] = "password1234"
                XCTAssertEqual(keychain["kishikawakatsumi"], "password1234", "updated password")

                let attributes = keychain[attributes: "kishikawakatsumi"]
                XCTAssertEqual(attributes?.`class`, ItemClass.internetPassword.rawValue)
                XCTAssertEqual(attributes?.data, "password1234".data(using: .utf8))
                XCTAssertNil(attributes?.ref)
                XCTAssertNotNil(attributes?.persistentRef)
                XCTAssertEqual(attributes?.accessible, Accessibility.afterFirstUnlock.rawValue)
                #if os(iOS)
                if #available(iOS 11.3, *) {
                    XCTAssertNotNil(attributes?.accessControl)
                } else if #available(iOS 9.0, *) {
                    XCTAssertNil(attributes?.accessControl)
                } else {
                    XCTAssertNotNil(attributes?.accessControl)
                }
                #else
                if #available(tvOS 11.3, *) {
                    XCTAssertNotNil(attributes?.accessControl)
                } else {
                    XCTAssertNil(attributes?.accessControl)
                }
                #endif
                let accessGroup: String
                #if targetEnvironment(macCatalyst)
                accessGroup = "27AEDK3C9F.com.kishikawakatsumi.KeychainAccess.TestHost-MacCatalyst"
                #else
                accessGroup = "27AEDK3C9F.com.kishikawakatsumi.KeychainAccess.TestHost"
                #endif
                XCTAssertEqual(attributes?.accessGroup, accessGroup)
                XCTAssertNotNil(attributes?.synchronizable)
                XCTAssertNotNil(attributes?.creationDate)
                XCTAssertNotNil(attributes?.modificationDate)
                XCTAssertEqual(attributes?.attributeDescription, "Updated Description")
                XCTAssertEqual(attributes?.comment, "Comment Test")
                XCTAssertEqual(attributes?.creator, "Creator Test")
                XCTAssertEqual(attributes?.type, "Type Test")
                XCTAssertEqual(attributes?.label, "Label Test")
                XCTAssertEqual(attributes?.isInvisible, true)
                XCTAssertEqual(attributes?.isNegative, true)
                XCTAssertEqual(attributes?.account, "kishikawakatsumi")
                XCTAssertNil(attributes?.service)
                XCTAssertNil(attributes?.generic)
                XCTAssertEqual(attributes?.securityDomain, "securitydomain")
                XCTAssertEqual(attributes?.server, "example.com")
                XCTAssertEqual(attributes?.`protocol`, ProtocolType.https.rawValue)
                XCTAssertEqual(attributes?.authenticationType, AuthenticationType.default.rawValue)
                XCTAssertEqual(attributes?.port, 443)
                XCTAssertEqual(attributes?.path, "")
            }
        }
    }
    #endif

    func testRemoveString() {
        let keychain = Keychain(service: "Twitter")

        XCTAssertNil(try! keychain.get("username"), "not stored username")
        XCTAssertNil(try! keychain.get("password"), "not stored password")

        do { try keychain.set("kishikawakatsumi", key: "username") } catch {}
        XCTAssertEqual(try! keychain.get("username"), "kishikawakatsumi", "stored username")

        do { try keychain.set("password1234", key: "password") } catch {}
        XCTAssertEqual(try! keychain.get("password"), "password1234", "stored password")

        do { try keychain.remove("username") } catch {}
        XCTAssertNil(try! keychain.get("username"), "removed username")
        XCTAssertEqual(try! keychain.get("password"), "password1234", "left password")

        do { try keychain.remove("password") } catch {}
        XCTAssertNil(try! keychain.get("username"), "removed username")
        XCTAssertNil(try! keychain.get("password"), "removed password")
    }

    func testRemoveData() {
        let JSONObject = ["username": "kishikawakatsumi", "password": "password1234"]
        let JSONData = try! JSONSerialization.data(withJSONObject: JSONObject, options: [])

        let keychain = Keychain(service: "Twitter")

        XCTAssertNil(try! keychain.getData("JSONData"), "not stored JSON data")

        do { try keychain.set(JSONData, key: "JSONData") } catch {}
        XCTAssertEqual(try! keychain.getData("JSONData"), JSONData, "stored JSON data")

        do { try keychain.remove("JSONData") } catch {}
        XCTAssertNil(try! keychain.getData("JSONData"), "removed JSON data")
    }

    // MARK:

    func testSubscripting() {
        let keychain = Keychain(service: "Twitter")

        XCTAssertNil(keychain["username"], "not stored username")
        XCTAssertNil(keychain["password"], "not stored password")
        XCTAssertNil(keychain[string: "username"], "not stored username")
        XCTAssertNil(keychain[string: "password"], "not stored password")

        keychain["username"] = "kishikawakatsumi"
        XCTAssertEqual(keychain["username"], "kishikawakatsumi", "stored username")
        XCTAssertEqual(keychain[string: "username"], "kishikawakatsumi", "stored username")

        keychain["password"] = "password1234"
        XCTAssertEqual(keychain["password"], "password1234", "stored password")
        XCTAssertEqual(keychain[string: "password"], "password1234", "stored password")

        keychain[string: "username"] = nil
        XCTAssertNil(keychain["username"], "removed username")
        XCTAssertEqual(keychain["password"], "password1234", "left password")
        XCTAssertNil(keychain[string: "username"], "removed username")
        XCTAssertEqual(keychain[string: "password"], "password1234", "left password")

        keychain[string: "password"] = nil
        XCTAssertNil(keychain["username"], "removed username")
        XCTAssertNil(keychain["password"], "removed password")
        XCTAssertNil(keychain[string: "username"], "removed username")
        XCTAssertNil(keychain[string: "password"], "removed password")

        let JSONObject = ["username": "kishikawakatsumi", "password": "password1234"]
        let JSONData = try! JSONSerialization.data(withJSONObject: JSONObject, options: [])

        XCTAssertNil(keychain[data:"JSONData"], "not stored JSON data")

        keychain[data: "JSONData"] = JSONData
        XCTAssertEqual(keychain[data: "JSONData"], JSONData, "stored JSON data")

        keychain[data: "JSONData"] = nil
        XCTAssertNil(keychain[data:"JSONData"], "removed JSON data")
    }

    // MARK:

    func testErrorHandling() {
        do {
            let keychain = Keychain(service: "Twitter", accessGroup: "27AEDK3C9F.shared")
            try keychain.removeAll()
            XCTAssertTrue(true, "no error occurred")
        } catch {
            XCTFail("error occurred")
        }

        do {
            let keychain = Keychain(service: "Twitter")
            try keychain.removeAll()
            XCTAssertTrue(true, "no error occurred")
        } catch {
            XCTFail("error occurred")
        }

        do {
            let keychain = Keychain(server: URL(string: "https://kishikawakatsumi.com")!, protocolType: .https)
            try keychain.removeAll()
            XCTAssertTrue(true, "no error occurred")
        } catch {
            XCTFail("error occurred")
        }

        do {
            let keychain = Keychain()
            try keychain.removeAll()
            XCTAssertTrue(true, "no error occurred")
        } catch {
            XCTFail("error occurred")
        }

        do {
            // Add Keychain items
            let keychain = Keychain(service: "Twitter")

            do {
                try keychain.set("kishikawa_katsumi", key: "username")
                XCTAssertTrue(true, "no error occurred")
            } catch {
                XCTFail("error occurred")
            }
            do {
                try keychain.set("password_1234", key: "password")
                XCTAssertTrue(true, "no error occurred")
            } catch {
                XCTFail("error occurred")
            }

            do {
                let username = try keychain.get("username")
                XCTAssertEqual(username, "kishikawa_katsumi")
            } catch {
                XCTFail("error occurred")
            }
            do {
                let password = try keychain.get("password")
                XCTAssertEqual(password, "password_1234")
            } catch {
                XCTFail("error occurred")
            }
        }

        do {
            // Update Keychain items
            let keychain = Keychain(service: "Twitter")

            do {
                try keychain.set("katsumi_kishikawa", key: "username")
                XCTAssertTrue(true, "no error occurred")
            } catch {
                XCTFail("error occurred")
            }
            do {
                try keychain.set("1234_password", key: "password")
                XCTAssertTrue(true, "no error occurred")
            } catch {
                XCTFail("error occurred")
            }

            do {
                let username = try keychain.get("username")
                XCTAssertEqual(username, "katsumi_kishikawa")
            } catch {
                XCTFail("error occurred")
            }
            do {
                let password = try keychain.get("password")
                XCTAssertEqual(password, "1234_password")
            } catch {
                XCTFail("error occurred")
            }
        }
        
        do {
            // Remove Keychain items
            let keychain = Keychain(service: "Twitter")

            do {
                try keychain.remove("username")
                XCTAssertNil(try! keychain.get("username"))
            } catch {
                XCTFail("error occurred")
            }
            do {
                try keychain.remove("password")
                XCTAssertNil(try! keychain.get("username"))
            } catch {
                XCTFail("error occurred")
            }
        }
    }

    // MARK:

    func testSetStringWithCustomService() {
        let username_1 = "kishikawakatsumi"
        let password_1 = "password1234"
        let username_2 = "kishikawa_katsumi"
        let password_2 = "password_1234"
        let username_3 = "k_katsumi"
        let password_3 = "12341234"

        let service_1 = ""
        let service_2 = "com.kishikawakatsumi.KeychainAccess"
        let service_3 = "example.com"

        do { try Keychain().removeAll() } catch {}
        do { try Keychain(service: service_1).removeAll() } catch {}
        do { try Keychain(service: service_2).removeAll() } catch {}
        do { try Keychain(service: service_3).removeAll() } catch {}

        XCTAssertNil(try! Keychain().get("username"), "not stored username")
        XCTAssertNil(try! Keychain().get("password"), "not stored password")
        XCTAssertNil(try! Keychain(service: service_1).get("username"), "not stored username")
        XCTAssertNil(try! Keychain(service: service_1).get("password"), "not stored password")
        XCTAssertNil(try! Keychain(service: service_2).get("username"), "not stored username")
        XCTAssertNil(try! Keychain(service: service_2).get("password"), "not stored password")
        XCTAssertNil(try! Keychain(service: service_3).get("username"), "not stored username")
        XCTAssertNil(try! Keychain(service: service_3).get("password"), "not stored password")

        do { try Keychain().set(username_1, key: "username") } catch {}
        XCTAssertEqual(try! Keychain().get("username"), username_1, "stored username")
        XCTAssertNil(try! Keychain(service: service_1).get("password"), "not stored password")
        XCTAssertNil(try! Keychain(service: service_2).get("username"), "not stored username")
        XCTAssertNil(try! Keychain(service: service_3).get("username"), "not stored username")

        do { try Keychain(service: service_1).set(username_1, key: "username") } catch {}
        XCTAssertEqual(try! Keychain().get("username"), username_1, "stored username")
        XCTAssertEqual(try! Keychain(service: service_1).get("username"), username_1, "stored username")
        XCTAssertNil(try! Keychain(service: service_2).get("username"), "not stored username")
        XCTAssertNil(try! Keychain(service: service_3).get("username"), "not stored username")

        do { try Keychain(service: service_2).set(username_2, key: "username") } catch {}
        XCTAssertEqual(try! Keychain().get("username"), username_1, "stored username")
        XCTAssertEqual(try! Keychain(service: service_1).get("username"), username_1, "stored username")
        XCTAssertEqual(try! Keychain(service: service_2).get("username"), username_2, "stored username")
        XCTAssertNil(try! Keychain(service: service_3).get("username"), "not stored username")

        do { try Keychain(service: service_3).set(username_3, key: "username") } catch {}
        XCTAssertEqual(try! Keychain().get("username"), username_1, "stored username")
        XCTAssertEqual(try! Keychain(service: service_1).get("username"), username_1, "stored username")
        XCTAssertEqual(try! Keychain(service: service_2).get("username"), username_2, "stored username")
        XCTAssertEqual(try! Keychain(service: service_3).get("username"), username_3, "stored username")

        do { try Keychain().set(password_1, key: "password") } catch {}
        XCTAssertEqual(try! Keychain().get("password"), password_1, "stored password")
        XCTAssertNil(try! Keychain(service: service_1).get("password"), "not stored password")
        XCTAssertNil(try! Keychain(service: service_2).get("password"), "not stored password")
        XCTAssertNil(try! Keychain(service: service_3).get("password"), "not stored password")

        do { try Keychain(service: service_1).set(password_1, key: "password") } catch {}
        XCTAssertEqual(try! Keychain().get("password"), password_1, "stored password")
        XCTAssertEqual(try! Keychain(service: service_1).get("password"), password_1, "stored password")
        XCTAssertNil(try! Keychain(service: service_2).get("password"), "not stored password")
        XCTAssertNil(try! Keychain(service: service_3).get("password"), "not stored password")

        do { try Keychain(service: service_2).set(password_2, key: "password") } catch {}
        XCTAssertEqual(try! Keychain().get("password"), password_1, "stored password")
        XCTAssertEqual(try! Keychain(service: service_1).get("password"), password_1, "stored password")
        XCTAssertEqual(try! Keychain(service: service_2).get("password"), password_2, "stored password")
        XCTAssertNil(try! Keychain(service: service_3).get("password"), "not stored password")

        do { try Keychain(service: service_3).set(password_3, key: "password") } catch {}
        XCTAssertEqual(try! Keychain().get("password"), password_1, "stored password")
        XCTAssertEqual(try! Keychain(service: service_1).get("password"), password_1, "stored password")
        XCTAssertEqual(try! Keychain(service: service_2).get("password"), password_2, "stored password")
        XCTAssertEqual(try! Keychain(service: service_3).get("password"), password_3, "stored password")

        do { try Keychain().remove("username") } catch {}
        XCTAssertNil(try! Keychain().get("username"), "removed username")
        XCTAssertEqual(try! Keychain(service: service_1).get("username"), username_1, "left username")
        XCTAssertEqual(try! Keychain(service: service_2).get("username"), username_2, "left username")
        XCTAssertEqual(try! Keychain(service: service_3).get("username"), username_3, "left username")

        do { try Keychain(service: service_1).remove("username") } catch {}
        XCTAssertNil(try! Keychain().get("username"), "removed username")
        XCTAssertNil(try! Keychain(service: service_1).get("username"), "removed username")
        XCTAssertEqual(try! Keychain(service: service_2).get("username"), username_2, "left username")
        XCTAssertEqual(try! Keychain(service: service_3).get("username"), username_3, "left username")

        do { try Keychain(service: service_2).remove("username") } catch {}
        XCTAssertNil(try! Keychain().get("username"), "removed username")
        XCTAssertNil(try! Keychain(service: service_1).get("username"), "removed username")
        XCTAssertNil(try! Keychain(service: service_2).get("username"), "removed username")
        XCTAssertEqual(try! Keychain(service: service_3).get("username"), username_3, "left username")

        do { try Keychain(service: service_3).remove("username") } catch {}
        XCTAssertNil(try! Keychain().get("username"), "removed username")
        XCTAssertNil(try! Keychain(service: service_1).get("username"), "removed username")
        XCTAssertNil(try! Keychain(service: service_2).get("username"), "removed username")
        XCTAssertNil(try! Keychain(service: service_3).get("username"), "removed username")

        do { try Keychain().remove("password") } catch {}
        XCTAssertNil(try! Keychain().get("password"), "removed password")
        XCTAssertEqual(try! Keychain(service: service_1).get("password"), password_1, "left password")
        XCTAssertEqual(try! Keychain(service: service_2).get("password"), password_2, "left password")
        XCTAssertEqual(try! Keychain(service: service_3).get("password"), password_3, "left password")

        do { try Keychain(service: service_1).remove("password") } catch {}
        XCTAssertNil(try! Keychain().get("password"), "removed password")
        XCTAssertNil(try! Keychain(service: service_1).get("password"), "removed password")
        XCTAssertEqual(try! Keychain(service: service_2).get("password"), password_2, "left password")
        XCTAssertEqual(try! Keychain(service: service_3).get("password"), password_3, "left password")

        do { try Keychain(service: service_2).remove("password") } catch {}
        XCTAssertNil(try! Keychain().get("password"), "removed password")
        XCTAssertNil(try! Keychain(service: service_1).get("password"), "removed password")
        XCTAssertNil(try! Keychain(service: service_2).get("password"), "removed password")
        XCTAssertEqual(try! Keychain(service: service_3).get("password"), password_3, "left password")

        do { try Keychain(service: service_3).remove("password") } catch {}
        XCTAssertNil(try! Keychain().get("password"), "removed password")
        XCTAssertNil(try! Keychain(service: service_2).get("password"), "removed password")
        XCTAssertNil(try! Keychain(service: service_2).get("password"), "removed password")
        XCTAssertNil(try! Keychain(service: service_2).get("password"), "removed password")
    }

    // MARK:

    func testProperties() {
        guard #available(OSX 10.10, *) else {
            return
        }

        let keychain = Keychain()

        XCTAssertEqual(keychain.synchronizable, false)
        XCTAssertEqual(keychain.synchronizable(true).synchronizable, true)
        XCTAssertEqual(keychain.synchronizable(false).synchronizable, false)
        XCTAssertEqual(keychain.accessibility(.afterFirstUnlock).accessibility, Accessibility.afterFirstUnlock)
        XCTAssertEqual(keychain.accessibility(.whenPasscodeSetThisDeviceOnly, authenticationPolicy: .userPresence).accessibility, Accessibility.whenPasscodeSetThisDeviceOnly)
        XCTAssertEqual(keychain.accessibility(.whenPasscodeSetThisDeviceOnly, authenticationPolicy: .userPresence).authenticationPolicy, AuthenticationPolicy.userPresence)
        XCTAssertNil(keychain.label)
        XCTAssertEqual(keychain.label("Label").label, "Label")
        XCTAssertNil(keychain.comment)
        XCTAssertEqual(keychain.comment("Comment").comment, "Comment")
        XCTAssertEqual(keychain.authenticationPrompt("Prompt").authenticationPrompt, "Prompt")
    }

    // MARK:

    func testAllKeys() {
        do {
            let keychain = Keychain()
            keychain["key1"] = "value1"
            keychain["key2"] = "value2"
            keychain["key3"] = "value3"

            let allKeys = keychain.allKeys()
            XCTAssertEqual(allKeys.count, 3)
            XCTAssertEqual(allKeys.sorted(), ["key1", "key2", "key3"])

            let allItems = keychain.allItems()
            XCTAssertEqual(allItems.count, 3)

            let sortedItems = allItems.sorted { (item1, item2) -> Bool in
                let key1 = item1["key"] as! String
                let key2 = item2["key"] as! String
                return key1.compare(key2) == .orderedAscending || key1.compare(key2) == .orderedSame
            }

            #if !os(OSX)

            let service: String
            let accessGroup: String
            #if targetEnvironment(macCatalyst)
            service = "maccatalyst.com.kishikawakatsumi.KeychainAccess.TestHost-MacCatalyst"
            accessGroup = "27AEDK3C9F.com.kishikawakatsumi.KeychainAccess.TestHost-MacCatalyst"
            #else
            service = "com.kishikawakatsumi.KeychainAccess.TestHost"
            accessGroup = "27AEDK3C9F.com.kishikawakatsumi.KeychainAccess.TestHost"
            #endif

            XCTAssertEqual(sortedItems[0]["accessGroup"] as? String, accessGroup)
            XCTAssertEqual(sortedItems[0]["synchronizable"] as? String, "false")
            XCTAssertEqual(sortedItems[0]["service"] as? String, service)
            XCTAssertEqual(sortedItems[0]["value"] as? String, "value1")
            XCTAssertEqual(sortedItems[0]["key"] as? String, "key1")
            XCTAssertEqual(sortedItems[0]["class"] as? String, "GenericPassword")
            XCTAssertEqual(sortedItems[0]["accessibility"] as? String, "AfterFirstUnlock")

            XCTAssertEqual(sortedItems[1]["accessGroup"] as? String, accessGroup)
            XCTAssertEqual(sortedItems[1]["synchronizable"] as? String, "false")
            XCTAssertEqual(sortedItems[1]["service"] as? String, service)
            XCTAssertEqual(sortedItems[1]["value"] as? String, "value2")
            XCTAssertEqual(sortedItems[1]["key"] as? String, "key2")
            XCTAssertEqual(sortedItems[1]["class"] as? String, "GenericPassword")
            XCTAssertEqual(sortedItems[1]["accessibility"] as? String, "AfterFirstUnlock")

            XCTAssertEqual(sortedItems[2]["accessGroup"] as? String, accessGroup)
            XCTAssertEqual(sortedItems[2]["synchronizable"] as? String, "false")
            XCTAssertEqual(sortedItems[2]["service"] as? String, service)
            XCTAssertEqual(sortedItems[2]["value"] as? String, "value3")
            XCTAssertEqual(sortedItems[2]["key"] as? String, "key3")
            XCTAssertEqual(sortedItems[2]["class"] as? String, "GenericPassword")
            XCTAssertEqual(sortedItems[2]["accessibility"] as? String, "AfterFirstUnlock")
            #else
            XCTAssertEqual(sortedItems[0]["service"] as? String, "com.kishikawakatsumi.KeychainAccess.TestHost")
            XCTAssertEqual(sortedItems[0]["key"] as? String, "key1")
            XCTAssertEqual(sortedItems[0]["class"] as? String, "GenericPassword")

            XCTAssertEqual(sortedItems[1]["service"] as? String, "com.kishikawakatsumi.KeychainAccess.TestHost")
            XCTAssertEqual(sortedItems[1]["key"] as? String, "key2")
            XCTAssertEqual(sortedItems[1]["class"] as? String, "GenericPassword")

            XCTAssertEqual(sortedItems[2]["service"] as? String, "com.kishikawakatsumi.KeychainAccess.TestHost")
            XCTAssertEqual(sortedItems[2]["key"] as? String, "key3")
            XCTAssertEqual(sortedItems[2]["class"] as? String, "GenericPassword")
            #endif
        }
        do {
            let keychain = Keychain(service: "service1")
            try! keychain
                .synchronizable(true)
                .accessibility(.whenUnlockedThisDeviceOnly)
                .set("service1_value1", key: "service1_key1")

            try! keychain
                .synchronizable(false)
                .accessibility(.afterFirstUnlockThisDeviceOnly)
                .set("service1_value2", key: "service1_key2")

            let allKeys = keychain.allKeys()
            XCTAssertEqual(allKeys.count, 2)
            XCTAssertEqual(allKeys.sorted(), ["service1_key1", "service1_key2"])

            let allItems = keychain.allItems()
            XCTAssertEqual(allItems.count, 2)

            let sortedItems = allItems.sorted { (item1, item2) -> Bool in
                let key1 = item1["key"] as! String
                let key2 = item2["key"] as! String
                return key1.compare(key2) == .orderedAscending || key1.compare(key2) == .orderedSame
            }

            #if !os(OSX)

            let accessGroup: String
            #if targetEnvironment(macCatalyst)
            accessGroup = "27AEDK3C9F.com.kishikawakatsumi.KeychainAccess.TestHost-MacCatalyst"
            #else
            accessGroup = "27AEDK3C9F.com.kishikawakatsumi.KeychainAccess.TestHost"
            #endif

            XCTAssertEqual(sortedItems[0]["accessGroup"] as? String, accessGroup)
            XCTAssertEqual(sortedItems[0]["synchronizable"] as? String, "true")
            XCTAssertEqual(sortedItems[0]["service"] as? String, "service1")
            XCTAssertEqual(sortedItems[0]["value"] as? String, "service1_value1")
            XCTAssertEqual(sortedItems[0]["key"] as? String, "service1_key1")
            XCTAssertEqual(sortedItems[0]["class"] as? String, "GenericPassword")
            XCTAssertEqual(sortedItems[0]["accessibility"] as? String, "WhenUnlockedThisDeviceOnly")

            XCTAssertEqual(sortedItems[1]["accessGroup"] as? String, accessGroup)
            XCTAssertEqual(sortedItems[1]["synchronizable"] as? String, "false")
            XCTAssertEqual(sortedItems[1]["service"] as? String, "service1")
            XCTAssertEqual(sortedItems[1]["value"] as? String, "service1_value2")
            XCTAssertEqual(sortedItems[1]["key"] as? String, "service1_key2")
            XCTAssertEqual(sortedItems[1]["class"] as? String, "GenericPassword")
            XCTAssertEqual(sortedItems[1]["accessibility"] as? String, "AfterFirstUnlockThisDeviceOnly")
            #else
            XCTAssertEqual(sortedItems[0]["service"] as? String, "service1")
            XCTAssertEqual(sortedItems[0]["key"] as? String, "service1_key1")
            XCTAssertEqual(sortedItems[0]["class"] as? String, "GenericPassword")

            XCTAssertEqual(sortedItems[1]["service"] as? String, "service1")
            XCTAssertEqual(sortedItems[1]["key"] as? String, "service1_key2")
            XCTAssertEqual(sortedItems[1]["class"] as? String, "GenericPassword")
            #endif
        }
        do {
            let keychain = Keychain(server: "https://google.com", protocolType: .https)
            #if !targetEnvironment(macCatalyst)
            try! keychain
                .synchronizable(false)
                .accessibility(.alwaysThisDeviceOnly)
                .set("google.com_value1", key: "google.com_key1")
            #else
            try! keychain
                .synchronizable(false)
                .accessibility(.afterFirstUnlockThisDeviceOnly)
                .set("google.com_value1", key: "google.com_key1")
            #endif

            #if !targetEnvironment(macCatalyst)
            try! keychain
                .synchronizable(true)
                .accessibility(.always)
                .set("google.com_value2", key: "google.com_key2")
            #else
            try! keychain
                .synchronizable(true)
                .accessibility(.afterFirstUnlock)
                .set("google.com_value2", key: "google.com_key2")
            #endif

            let allKeys = keychain.allKeys()
            XCTAssertEqual(allKeys.count, 2)
            XCTAssertEqual(allKeys.sorted(), ["google.com_key1", "google.com_key2"])

            let allItems = keychain.allItems()
            XCTAssertEqual(allItems.count, 2)

            let sortedItems = allItems.sorted { (item1, item2) -> Bool in
                let key1 = item1["key"] as! String
                let key2 = item2["key"] as! String
                return key1.compare(key2) == .orderedAscending || key1.compare(key2) == .orderedSame
            }

            #if !os(OSX)
            XCTAssertEqual(sortedItems[0]["synchronizable"] as? String, "false")
            XCTAssertEqual(sortedItems[0]["value"] as? String, "google.com_value1")
            XCTAssertEqual(sortedItems[0]["key"] as? String, "google.com_key1")
            XCTAssertEqual(sortedItems[0]["server"] as? String, "google.com")
            XCTAssertEqual(sortedItems[0]["class"] as? String, "InternetPassword")
            XCTAssertEqual(sortedItems[0]["authenticationType"] as? String, "Default")
            XCTAssertEqual(sortedItems[0]["protocol"] as? String, "HTTPS")
            #if targetEnvironment(macCatalyst)
            XCTAssertEqual(sortedItems[0]["accessibility"] as? String, "AfterFirstUnlockThisDeviceOnly")
            #else
            XCTAssertEqual(sortedItems[0]["accessibility"] as? String, "AlwaysThisDeviceOnly")
            #endif
            XCTAssertEqual(sortedItems[1]["synchronizable"] as? String, "true")
            XCTAssertEqual(sortedItems[1]["value"] as? String, "google.com_value2")
            XCTAssertEqual(sortedItems[1]["key"] as? String, "google.com_key2")
            XCTAssertEqual(sortedItems[1]["server"] as? String, "google.com")
            XCTAssertEqual(sortedItems[1]["class"] as? String, "InternetPassword")
            XCTAssertEqual(sortedItems[1]["authenticationType"] as? String, "Default")
            XCTAssertEqual(sortedItems[1]["protocol"] as? String, "HTTPS")
            #if targetEnvironment(macCatalyst)
            XCTAssertEqual(sortedItems[1]["accessibility"] as? String, "AfterFirstUnlock")
            #else
            XCTAssertEqual(sortedItems[1]["accessibility"] as? String, "Always")
            #endif
            #else
            XCTAssertEqual(sortedItems[0]["key"] as? String, "google.com_key1")
            XCTAssertEqual(sortedItems[0]["server"] as? String, "google.com")
            XCTAssertEqual(sortedItems[0]["class"] as? String, "InternetPassword")
            XCTAssertEqual(sortedItems[0]["authenticationType"] as? String, "Default")
            XCTAssertEqual(sortedItems[0]["protocol"] as? String, "HTTPS")

            XCTAssertEqual(sortedItems[1]["key"] as? String, "google.com_key2")
            XCTAssertEqual(sortedItems[1]["server"] as? String, "google.com")
            XCTAssertEqual(sortedItems[1]["class"] as? String, "InternetPassword")
            XCTAssertEqual(sortedItems[1]["authenticationType"] as? String, "Default")
            XCTAssertEqual(sortedItems[1]["protocol"] as? String, "HTTPS")
            #endif
        }

        #if !os(OSX)
        do {
            let allKeys = Keychain.allKeys(.genericPassword)
            XCTAssertEqual(allKeys.count, 5)

            let sortedKeys = allKeys.sorted { (key1, key2) -> Bool in
                return key1.1.compare(key2.1) == .orderedAscending || key1.1.compare(key2.1) == .orderedSame
            }

            let service: String
            #if targetEnvironment(macCatalyst)
            service = "maccatalyst.com.kishikawakatsumi.KeychainAccess.TestHost-MacCatalyst"
            #else
            service = "com.kishikawakatsumi.KeychainAccess.TestHost"
            #endif

            XCTAssertEqual(sortedKeys[0].0, service)
            XCTAssertEqual(sortedKeys[0].1, "key1")
            XCTAssertEqual(sortedKeys[1].0, service)
            XCTAssertEqual(sortedKeys[1].1, "key2")
            XCTAssertEqual(sortedKeys[2].0, service)
            XCTAssertEqual(sortedKeys[2].1, "key3")
            XCTAssertEqual(sortedKeys[3].0, "service1")
            XCTAssertEqual(sortedKeys[3].1, "service1_key1")
            XCTAssertEqual(sortedKeys[4].0, "service1")
            XCTAssertEqual(sortedKeys[4].1, "service1_key2")
        }
        do {
            let allKeys = Keychain.allKeys(.internetPassword)
            XCTAssertEqual(allKeys.count, 2)

            let sortedKeys = allKeys.sorted { (key1, key2) -> Bool in
                return key1.1.compare(key2.1) == .orderedAscending || key1.1.compare(key2.1) == .orderedSame
            }
            XCTAssertEqual(sortedKeys[0].0, "google.com")
            XCTAssertEqual(sortedKeys[0].1, "google.com_key1")
            XCTAssertEqual(sortedKeys[1].0, "google.com")
            XCTAssertEqual(sortedKeys[1].1, "google.com_key2")
        }
        #endif
    }

    func testDescription() {
        do {
            let keychain = Keychain()

            XCTAssertEqual(keychain.description, "[]")
            XCTAssertEqual(keychain.debugDescription, "[]")
        }
    }

    // MARK:

    func testAuthenticationPolicy() {
        guard #available(iOS 9.0, OSX 10.11, *) else {
            return
        }

        do {
            let accessibility: Accessibility = .whenPasscodeSetThisDeviceOnly

            let policy: AuthenticationPolicy = [.userPresence]
            let flags = SecAccessControlCreateFlags(rawValue: policy.rawValue)

            var error: Unmanaged<CFError>?
            let accessControl = SecAccessControlCreateWithFlags(kCFAllocatorDefault, accessibility.rawValue as CFTypeRef, flags, &error)

            XCTAssertNil(error)
            XCTAssertNotNil(accessControl)
        }
        #if os(iOS)
        do {
            let accessibility: Accessibility = .whenPasscodeSetThisDeviceOnly

            let policy: AuthenticationPolicy = [.userPresence, .applicationPassword]
            let flags = SecAccessControlCreateFlags(rawValue: policy.rawValue)

            var error: Unmanaged<CFError>?
            let accessControl = SecAccessControlCreateWithFlags(kCFAllocatorDefault, accessibility.rawValue as CFTypeRef, flags, &error)

            XCTAssertNil(error)
            XCTAssertNotNil(accessControl)
        }
        do {
            let accessibility: Accessibility = .whenPasscodeSetThisDeviceOnly

            let policy: AuthenticationPolicy = [.userPresence, .applicationPassword, .privateKeyUsage]
            let flags = SecAccessControlCreateFlags(rawValue: policy.rawValue)

            var error: Unmanaged<CFError>?
            let accessControl = SecAccessControlCreateWithFlags(kCFAllocatorDefault, accessibility.rawValue as CFTypeRef, flags, &error)

            XCTAssertNil(error)
            XCTAssertNotNil(accessControl)
        }
        do {
            let accessibility: Accessibility = .whenPasscodeSetThisDeviceOnly

            let policy: AuthenticationPolicy = [.applicationPassword]
            let flags = SecAccessControlCreateFlags(rawValue: policy.rawValue)

            var error: Unmanaged<CFError>?
            let accessControl = SecAccessControlCreateWithFlags(kCFAllocatorDefault, accessibility.rawValue as CFTypeRef, flags, &error)

            XCTAssertNil(error)
            XCTAssertNotNil(accessControl)
        }
        do {
            let accessibility: Accessibility = .whenPasscodeSetThisDeviceOnly

            let policy: AuthenticationPolicy = [.applicationPassword, .privateKeyUsage]
            let flags = SecAccessControlCreateFlags(rawValue: policy.rawValue)

            var error: Unmanaged<CFError>?
            let accessControl = SecAccessControlCreateWithFlags(kCFAllocatorDefault, accessibility.rawValue as CFTypeRef, flags, &error)

            XCTAssertNil(error)
            XCTAssertNotNil(accessControl)
        }
        do {
            let accessibility: Accessibility = .whenPasscodeSetThisDeviceOnly

            let policy: AuthenticationPolicy = [.privateKeyUsage]
            let flags = SecAccessControlCreateFlags(rawValue: policy.rawValue)

            var error: Unmanaged<CFError>?
            let accessControl = SecAccessControlCreateWithFlags(kCFAllocatorDefault, accessibility.rawValue as CFTypeRef, flags, &error)

            XCTAssertNil(error)
            XCTAssertNotNil(accessControl)
        }
        do {
            let accessibility: Accessibility = .whenPasscodeSetThisDeviceOnly

            let policy: AuthenticationPolicy = [.touchIDAny]
            let flags = SecAccessControlCreateFlags(rawValue: policy.rawValue)

            var error: Unmanaged<CFError>?
            let accessControl = SecAccessControlCreateWithFlags(kCFAllocatorDefault, accessibility.rawValue as CFTypeRef, flags, &error)

            XCTAssertNil(error)
            XCTAssertNotNil(accessControl)
        }
        do {
            let accessibility: Accessibility = .whenPasscodeSetThisDeviceOnly

            let policy: AuthenticationPolicy = [.touchIDAny, .devicePasscode]
            let flags = SecAccessControlCreateFlags(rawValue: policy.rawValue)

            var error: Unmanaged<CFError>?
            let accessControl = SecAccessControlCreateWithFlags(kCFAllocatorDefault, accessibility.rawValue as CFTypeRef, flags, &error)

            XCTAssertNil(error)
            XCTAssertTrue(accessControl != nil)
        }
        do {
            let accessibility: Accessibility = .whenPasscodeSetThisDeviceOnly

            let policy: AuthenticationPolicy = [.touchIDAny, .applicationPassword]
            let flags = SecAccessControlCreateFlags(rawValue: policy.rawValue)

            var error: Unmanaged<CFError>?
            let accessControl = SecAccessControlCreateWithFlags(kCFAllocatorDefault, accessibility.rawValue as CFTypeRef, flags, &error)

            XCTAssertNil(error)
            XCTAssertNotNil(accessControl)
        }
        do {
            let accessibility: Accessibility = .whenPasscodeSetThisDeviceOnly

            let policy: AuthenticationPolicy = [.touchIDAny, .applicationPassword, .privateKeyUsage]
            let flags = SecAccessControlCreateFlags(rawValue: policy.rawValue)

            var error: Unmanaged<CFError>?
            let accessControl = SecAccessControlCreateWithFlags(kCFAllocatorDefault, accessibility.rawValue as CFTypeRef, flags, &error)

            XCTAssertNil(error)
            XCTAssertNotNil(accessControl)
        }
        do {
            let accessibility: Accessibility = .whenPasscodeSetThisDeviceOnly

            let policy: AuthenticationPolicy = [.touchIDCurrentSet]
            let flags = SecAccessControlCreateFlags(rawValue: policy.rawValue)

            var error: Unmanaged<CFError>?
            let accessControl = SecAccessControlCreateWithFlags(kCFAllocatorDefault, accessibility.rawValue as CFTypeRef, flags, &error)

            XCTAssertNil(error)
            XCTAssertNotNil(accessControl)
        }
        do {
            let accessibility: Accessibility = .whenPasscodeSetThisDeviceOnly

            let policy: AuthenticationPolicy = [.touchIDCurrentSet, .devicePasscode]
            let flags = SecAccessControlCreateFlags(rawValue: policy.rawValue)

            var error: Unmanaged<CFError>?
            let accessControl = SecAccessControlCreateWithFlags(kCFAllocatorDefault, accessibility.rawValue as CFTypeRef, flags, &error)

            XCTAssertNil(error)
            XCTAssertTrue(accessControl != nil)
        }
        do {
            let accessibility: Accessibility = .whenPasscodeSetThisDeviceOnly

            let policy: AuthenticationPolicy = [.touchIDCurrentSet, .applicationPassword]
            let flags = SecAccessControlCreateFlags(rawValue: policy.rawValue)

            var error: Unmanaged<CFError>?
            let accessControl = SecAccessControlCreateWithFlags(kCFAllocatorDefault, accessibility.rawValue as CFTypeRef, flags, &error)

            XCTAssertNil(error)
            XCTAssertNotNil(accessControl)
        }
        do {
            let accessibility: Accessibility = .whenPasscodeSetThisDeviceOnly

            let policy: AuthenticationPolicy = [.touchIDCurrentSet, .applicationPassword, .privateKeyUsage]
            let flags = SecAccessControlCreateFlags(rawValue: policy.rawValue)

            var error: Unmanaged<CFError>?
            let accessControl = SecAccessControlCreateWithFlags(kCFAllocatorDefault, accessibility.rawValue as CFTypeRef, flags, &error)

            XCTAssertNil(error)
            XCTAssertNotNil(accessControl)
        }
        do {
            let accessibility: Accessibility = .whenPasscodeSetThisDeviceOnly

            let policy: AuthenticationPolicy = [.touchIDAny, .or, .devicePasscode]
            let flags = SecAccessControlCreateFlags(rawValue: policy.rawValue)

            var error: Unmanaged<CFError>?
            let accessControl = SecAccessControlCreateWithFlags(kCFAllocatorDefault, accessibility.rawValue as CFTypeRef, flags, &error)

            XCTAssertNil(error)
            XCTAssertTrue(accessControl != nil)
        }
        do {
            let accessibility: Accessibility = .whenPasscodeSetThisDeviceOnly

            let policy: AuthenticationPolicy = [.touchIDAny, .and, .devicePasscode]
            let flags = SecAccessControlCreateFlags(rawValue: policy.rawValue)

            var error: Unmanaged<CFError>?
            let accessControl = SecAccessControlCreateWithFlags(kCFAllocatorDefault, accessibility.rawValue as CFTypeRef, flags, &error)

            XCTAssertNil(error)
            XCTAssertTrue(accessControl != nil)
        }
        #endif
        #if os(OSX)
        do {
            let accessibility: Accessibility = .whenPasscodeSetThisDeviceOnly

            let policy: AuthenticationPolicy = [.userPresence]
            let flags = SecAccessControlCreateFlags(rawValue: policy.rawValue)

            var error: Unmanaged<CFError>?
            let accessControl = SecAccessControlCreateWithFlags(kCFAllocatorDefault, accessibility.rawValue as CFTypeRef, flags, &error)

            XCTAssertNil(error)
            XCTAssertNotNil(accessControl)
        }
        do {
            let accessibility: Accessibility = .whenPasscodeSetThisDeviceOnly

            let policy: AuthenticationPolicy = [.devicePasscode]
            let flags = SecAccessControlCreateFlags(rawValue: policy.rawValue)

            var error: Unmanaged<CFError>?
            let accessControl = SecAccessControlCreateWithFlags(kCFAllocatorDefault, accessibility.rawValue as CFTypeRef, flags, &error)

            XCTAssertNil(error)
            XCTAssertNotNil(accessControl)
        }
        #endif
    }

    func testIgnoringAttributeSynchronizable() {
        let keychain = Keychain(service: "Twitter").synchronizable(false)
        let keychainSynchronizable = Keychain(service: "Twitter").synchronizable(true)

        XCTAssertNil(try! keychain.get("username", ignoringAttributeSynchronizable: false), "not stored username")
        XCTAssertNil(try! keychain.get("password", ignoringAttributeSynchronizable: false), "not stored password")
        XCTAssertNil(try! keychainSynchronizable.get("username", ignoringAttributeSynchronizable: false), "not stored username")
        XCTAssertNil(try! keychainSynchronizable.get("password", ignoringAttributeSynchronizable: false), "not stored password")

        do { try keychain.set("kishikawakatsumi", key: "username", ignoringAttributeSynchronizable: false) } catch {}
        do { try keychainSynchronizable.set("kishikawakatsumi_synchronizable", key: "username", ignoringAttributeSynchronizable: false) } catch {}
        XCTAssertEqual(try! keychain.get("username", ignoringAttributeSynchronizable: false), "kishikawakatsumi", "stored username")
        XCTAssertEqual(try! keychainSynchronizable.get("username", ignoringAttributeSynchronizable: false), "kishikawakatsumi_synchronizable", "stored username")
        XCTAssertNil(try! keychain.get("password", ignoringAttributeSynchronizable: false), "not stored password")
        XCTAssertNil(try! keychainSynchronizable.get("password", ignoringAttributeSynchronizable: false), "not stored password")

        do { try keychain.set("password1234", key: "password", ignoringAttributeSynchronizable: false) } catch {}
        do { try keychainSynchronizable.set("password1234_synchronizable", key: "password", ignoringAttributeSynchronizable: false) } catch {}
        XCTAssertEqual(try! keychain.get("username", ignoringAttributeSynchronizable: false), "kishikawakatsumi", "stored username")
        XCTAssertEqual(try! keychainSynchronizable.get("username", ignoringAttributeSynchronizable: false), "kishikawakatsumi_synchronizable", "stored username")
        XCTAssertEqual(try! keychain.get("password", ignoringAttributeSynchronizable: false), "password1234", "stored password")
        XCTAssertEqual(try! keychainSynchronizable.get("password", ignoringAttributeSynchronizable: false), "password1234_synchronizable", "stored password")

        do { try keychain.remove("username", ignoringAttributeSynchronizable: false) } catch {}
        XCTAssertNil(try! keychain.get("username", ignoringAttributeSynchronizable: false), "not stored username")
        XCTAssertEqual(try! keychainSynchronizable.get("username", ignoringAttributeSynchronizable: false), "kishikawakatsumi_synchronizable", "stored username")

        do { try keychainSynchronizable.remove("username", ignoringAttributeSynchronizable: false) } catch {}
        XCTAssertNil(try! keychain.get("username", ignoringAttributeSynchronizable: false), "not stored username")
        XCTAssertNil(try! keychainSynchronizable.get("username", ignoringAttributeSynchronizable: false), "not stored username")
        
        XCTAssertEqual(try! keychain.get("password", ignoringAttributeSynchronizable: false), "password1234", "stored password")
        XCTAssertEqual(try! keychainSynchronizable.get("password", ignoringAttributeSynchronizable: false), "password1234_synchronizable", "stored password")

        do { try keychain.removeAll() } catch {}
        XCTAssertNil(try! keychain.get("username", ignoringAttributeSynchronizable: false), "not stored username")
        XCTAssertNil(try! keychainSynchronizable.get("username", ignoringAttributeSynchronizable: false), "not stored username")
        XCTAssertNil(try! keychain.get("password", ignoringAttributeSynchronizable: false), "not stored password")
        XCTAssertNil(try! keychainSynchronizable.get("password", ignoringAttributeSynchronizable: false), "not stored password")
    }

    func testIgnoringAttributeSynchronizableBackwardCompatibility() {
        let keychain = Keychain(service: "Twitter").synchronizable(false)
        let keychainSynchronizable = Keychain(service: "Twitter").synchronizable(true)

        XCTAssertNil(try! keychain.get("username"), "not stored username")
        XCTAssertNil(try! keychain.get("password"), "not stored password")
        XCTAssertNil(try! keychainSynchronizable.get("username"), "not stored username")
        XCTAssertNil(try! keychainSynchronizable.get("password"), "not stored password")

        do { try keychain.set("kishikawakatsumi", key: "username") } catch {}
        XCTAssertEqual(try! keychain.get("username"), "kishikawakatsumi", "stored username")
        XCTAssertEqual(try! keychainSynchronizable.get("username"), "kishikawakatsumi", "stored username")

        do { try keychainSynchronizable.set("kishikawakatsumi_synchronizable", key: "username") } catch {}
        XCTAssertEqual(try! keychain.get("username"), "kishikawakatsumi_synchronizable", "stored username")
        XCTAssertEqual(try! keychainSynchronizable.get("username"), "kishikawakatsumi_synchronizable", "stored username")
        XCTAssertNil(try! keychain.get("password"), "not stored password")
        XCTAssertNil(try! keychainSynchronizable.get("password"), "not stored password")

        do { try keychain.set("password1234", key: "password") } catch {}
        XCTAssertEqual(try! keychain.get("password"), "password1234", "stored password")
        XCTAssertEqual(try! keychainSynchronizable.get("password"), "password1234", "stored password")

        do { try keychainSynchronizable.set("password1234_synchronizable", key: "password") } catch {}
        XCTAssertEqual(try! keychain.get("username"), "kishikawakatsumi_synchronizable", "stored username")
        XCTAssertEqual(try! keychainSynchronizable.get("username"), "kishikawakatsumi_synchronizable", "stored username")
        XCTAssertEqual(try! keychain.get("password"), "password1234_synchronizable", "stored password")
        XCTAssertEqual(try! keychainSynchronizable.get("password"), "password1234_synchronizable", "stored password")

        do { try keychain.remove("username") } catch {}
        XCTAssertNil(try! keychain.get("username"), "not stored username")
        XCTAssertNil(try! keychainSynchronizable.get("username"), "not stored username")
        XCTAssertEqual(try! keychain.get("password"), "password1234_synchronizable", "stored password")
        XCTAssertEqual(try! keychainSynchronizable.get("password"), "password1234_synchronizable", "stored password")

        do { try keychain.removeAll() } catch {}
        XCTAssertNil(try! keychain.get("username"), "not stored username")
        XCTAssertNil(try! keychainSynchronizable.get("username"), "not stored username")
        XCTAssertNil(try! keychain.get("password"), "not stored password")
        XCTAssertNil(try! keychainSynchronizable.get("password"), "not stored password")
    }
}
