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

        do { try Keychain(server: NSURL(string: "https://example.com")!, protocolType: .HTTPS).removeAll() } catch {}
        do { try Keychain(server: NSURL(string: "https://example.com:443")!, protocolType: .HTTPS).removeAll() } catch {}

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

    // MARK:

    func testInternetPassword() {
        do {
            // Add Keychain items
            let keychain = Keychain(server: NSURL(string: "https://kishikawakatsumi.com")!, protocolType: .HTTPS)

            do { try keychain.set("kishikawa_katsumi", key: "username") } catch {}
            do { try keychain.set("password_1234", key: "password") } catch {}

            let username = try! keychain.get("username")
            XCTAssertEqual(username, "kishikawa_katsumi")

            let password = try! keychain.get("password")
            XCTAssertEqual(password, "password_1234")
        }

        do {
            // Update Keychain items
            let keychain = Keychain(server: NSURL(string: "https://kishikawakatsumi.com")!, protocolType: .HTTPS)

            do { try keychain.set("katsumi_kishikawa", key: "username") } catch {}
            do { try keychain.set("1234_password", key: "password") } catch {}

            let username = try! keychain.get("username")
            XCTAssertEqual(username, "katsumi_kishikawa")

            let password = try! keychain.get("password")
            XCTAssertEqual(password, "1234_password")
        }

        do {
            // Remove Keychain items
            let keychain = Keychain(server: NSURL(string: "https://kishikawakatsumi.com")!, protocolType: .HTTPS)

            do { try keychain.remove("username") } catch {}
            do { try keychain.remove("password") } catch {}

            XCTAssertNil(try! keychain.get("username"))
            XCTAssertNil(try! keychain.get("password"))
        }
    }

    func testInternetPasswordSubscripting() {
        do {
            // Add Keychain items
            let keychain = Keychain(server: NSURL(string: "https://kishikawakatsumi.com")!, protocolType: .HTTPS)

            keychain["username"] = "kishikawa_katsumi"
            keychain["password"] = "password_1234"

            let username = keychain["username"]
            XCTAssertEqual(username, "kishikawa_katsumi")

            let password = keychain["password"]
            XCTAssertEqual(password, "password_1234")
        }

        do {
            // Update Keychain items
            let keychain = Keychain(server: NSURL(string: "https://kishikawakatsumi.com")!, protocolType: .HTTPS)

            keychain["username"] = "katsumi_kishikawa"
            keychain["password"] = "1234_password"

            let username = keychain["username"]
            XCTAssertEqual(username, "katsumi_kishikawa")

            let password = keychain["password"]
            XCTAssertEqual(password, "1234_password")
        }

        do {
            // Remove Keychain items
            let keychain = Keychain(server: NSURL(string: "https://kishikawakatsumi.com")!, protocolType: .HTTPS)

            keychain["username"] = nil
            keychain["password"] = nil

            XCTAssertNil(keychain["username"])
            XCTAssertNil(keychain["password"])
        }
    }

    // MARK:

    func testDefaultInitializer() {
        let keychain = Keychain()
        XCTAssertEqual(keychain.service, NSBundle.mainBundle().bundleIdentifier)
        XCTAssertEqual(keychain.service, "com.kishikawakatsumi.KeychainAccess.TestHost")
        XCTAssertNil(keychain.accessGroup)
    }

    func testInitializerWithService() {
        let keychain = Keychain(service: "com.example.github-token")
        XCTAssertEqual(keychain.service, "com.example.github-token")
        XCTAssertNil(keychain.accessGroup)
    }

    func testInitializerWithAccessGroup() {
        let keychain = Keychain(accessGroup: "27AEDK3C9F.shared")
        XCTAssertEqual(keychain.service, "com.kishikawakatsumi.KeychainAccess.TestHost")
        XCTAssertEqual(keychain.accessGroup, "27AEDK3C9F.shared")
    }

    func testInitializerWithServiceAndAccessGroup() {
        let keychain = Keychain(service: "com.example.github-token", accessGroup: "27AEDK3C9F.shared")
        XCTAssertEqual(keychain.service, "com.example.github-token")
        XCTAssertEqual(keychain.accessGroup, "27AEDK3C9F.shared")
    }

    func testInitializerWithServer() {
        let server = "https://kishikawakatsumi.com"
        let URL = NSURL(string: server)!

        do {
            let keychain = Keychain(server: server, protocolType: .HTTPS)
            XCTAssertEqual(keychain.server, URL)
            XCTAssertEqual(keychain.protocolType, ProtocolType.HTTPS)
            XCTAssertEqual(keychain.authenticationType, AuthenticationType.Default)
        }
        do {
            let keychain = Keychain(server: URL, protocolType: .HTTPS)
            XCTAssertEqual(keychain.server, URL)
            XCTAssertEqual(keychain.protocolType, ProtocolType.HTTPS)
            XCTAssertEqual(keychain.authenticationType, AuthenticationType.Default)
        }
    }

    func testInitializerWithServerAndAuthenticationType() {
        let server = "https://kishikawakatsumi.com"
        let URL = NSURL(string: server)!

        do {
            let keychain = Keychain(server: server, protocolType: .HTTPS, authenticationType: .HTMLForm)
            XCTAssertEqual(keychain.server, URL)
            XCTAssertEqual(keychain.protocolType, ProtocolType.HTTPS)
            XCTAssertEqual(keychain.authenticationType, AuthenticationType.HTMLForm)
        }
        do {
            let keychain = Keychain(server: URL, protocolType: .HTTPS, authenticationType: .HTMLForm)
            XCTAssertEqual(keychain.server, URL)
            XCTAssertEqual(keychain.protocolType, ProtocolType.HTTPS)
            XCTAssertEqual(keychain.authenticationType, AuthenticationType.HTMLForm)
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
        let JSONData = try! NSJSONSerialization.dataWithJSONObject(JSONObject, options: [])

        let keychain = Keychain(service: "Twitter")

        XCTAssertNil(try! keychain.getData("JSONData"), "not stored JSON data")

        do { try keychain.set(JSONData, key: "JSONData") } catch {}
        XCTAssertEqual(try! keychain.getData("JSONData"), JSONData, "stored JSON data")
    }

    func testStringConversionError() {
        let keychain = Keychain(service: "Twitter")

        let length = 256
        let data = NSMutableData(length: length)!
        _ = SecRandomCopyBytes(kSecRandomDefault, length, UnsafeMutablePointer<UInt8>(data.mutableBytes))

        do {
            try keychain.set(data, key: "RandomData")
            let _ = try keychain.getString("RandomData")
        } catch let error as NSError {
            XCTAssertEqual(error.domain, KeychainAccessErrorDomain)
            XCTAssertEqual(error.code, Int(Status.ConversionError.rawValue))
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
        let expectation = expectationWithDescription("Touch ID authentication")

        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            do {
                var attributes = [String: AnyObject]()
                attributes[String(kSecAttrDescription)] = "Description Test"
                attributes[String(kSecAttrComment)] = "Comment Test"
                attributes[String(kSecAttrCreator)] = "Creator Test"
                attributes[String(kSecAttrType)] = "Type Test"
                attributes[String(kSecAttrLabel)] = "Label Test"
                attributes[String(kSecAttrIsInvisible)] = true
                attributes[String(kSecAttrIsNegative)] = true

                let keychain = Keychain(service: "Twitter")
                    .attributes(attributes)
                    .accessibility(.WhenPasscodeSetThisDeviceOnly, authenticationPolicy: .UserPresence)

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
                    XCTAssertEqual(attributes?.`class`, ItemClass.GenericPassword.rawValue)
                    XCTAssertEqual(attributes?.data, "password1234".dataUsingEncoding(NSUTF8StringEncoding))
                    XCTAssertNil(attributes?.ref)
                    XCTAssertNotNil(attributes?.persistentRef)
                    XCTAssertEqual(attributes?.accessible, Accessibility.WhenPasscodeSetThisDeviceOnly.rawValue)
                    XCTAssertNotNil(attributes?.accessControl)
                    XCTAssertEqual(attributes?.accessGroup, "27AEDK3C9F.com.kishikawakatsumi.KeychainAccess.TestHost")
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

                    XCTAssertEqual(attributes![String(kSecClass)] as? String, ItemClass.GenericPassword.rawValue)
                    XCTAssertEqual(attributes![String(kSecValueData)] as? NSData, "password1234".dataUsingEncoding(NSUTF8StringEncoding))

                    expectation.fulfill()
                } catch {
                    XCTFail("error occurred")
                }
            }
        }
        waitForExpectationsWithTimeout(10.0, handler: nil)

        do {
            var attributes = [String: AnyObject]()
            attributes[String(kSecAttrDescription)] = "Description Test"
            attributes[String(kSecAttrComment)] = "Comment Test"
            attributes[String(kSecAttrCreator)] = "Creator Test"
            attributes[String(kSecAttrType)] = "Type Test"
            attributes[String(kSecAttrLabel)] = "Label Test"
            attributes[String(kSecAttrIsInvisible)] = true
            attributes[String(kSecAttrIsNegative)] = true
            attributes[String(kSecAttrSecurityDomain)] = "securitydomain"

            let keychain = Keychain(server: NSURL(string: "https://example.com:443/api/login/")!, protocolType: .HTTPS)
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
                XCTAssertEqual(attributes?.`class`, ItemClass.InternetPassword.rawValue)
                XCTAssertEqual(attributes?.data, "password1234".dataUsingEncoding(NSUTF8StringEncoding))
                XCTAssertNil(attributes?.ref)
                XCTAssertNotNil(attributes?.persistentRef)
                XCTAssertEqual(attributes?.accessible, Accessibility.AfterFirstUnlock.rawValue)
                if #available(iOS 9.0, *) {
                    XCTAssertNil(attributes?.accessControl)
                } else {
                    XCTAssertNotNil(attributes?.accessControl)
                }
                XCTAssertEqual(attributes?.accessGroup, "27AEDK3C9F.com.kishikawakatsumi.KeychainAccess.TestHost")
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
                XCTAssertEqual(attributes?.`protocol`, ProtocolType.HTTPS.rawValue)
                XCTAssertEqual(attributes?.authenticationType, AuthenticationType.Default.rawValue)
                XCTAssertEqual(attributes?.port, 443)
                XCTAssertEqual(attributes?.path, "")
            } catch {
                XCTFail("error occurred")
            }
            do {
                let keychain = Keychain(server: NSURL(string: "https://example.com:443/api/login/")!, protocolType: .HTTPS)

                XCTAssertEqual(keychain["kishikawakatsumi"], "password1234", "stored password")

                keychain["kishikawakatsumi"] = "1234password"
                XCTAssertEqual(keychain["kishikawakatsumi"], "1234password", "updated password")

                let attributes = try keychain.get("kishikawakatsumi") { $0 }
                XCTAssertEqual(attributes?.`class`, ItemClass.InternetPassword.rawValue)
                XCTAssertEqual(attributes?.data, "1234password".dataUsingEncoding(NSUTF8StringEncoding))
                XCTAssertNil(attributes?.ref)
                XCTAssertNotNil(attributes?.persistentRef)
                XCTAssertEqual(attributes?.accessible, Accessibility.AfterFirstUnlock.rawValue)
                if #available(iOS 9.0, *) {
                    XCTAssertNil(attributes?.accessControl)
                } else {
                    XCTAssertNotNil(attributes?.accessControl)
                }
                XCTAssertEqual(attributes?.accessGroup, "27AEDK3C9F.com.kishikawakatsumi.KeychainAccess.TestHost")
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
                XCTAssertEqual(attributes?.`protocol`, ProtocolType.HTTPS.rawValue)
                XCTAssertEqual(attributes?.authenticationType, AuthenticationType.Default.rawValue)
                XCTAssertEqual(attributes?.port, 443)
                XCTAssertEqual(attributes?.path, "")
            } catch {
                XCTFail("error occurred")
            }
            do {
                let keychain = Keychain(server: NSURL(string: "https://example.com:443/api/login/")!, protocolType: .HTTPS)
                    .attributes([String(kSecAttrDescription): "Updated Description"])

                XCTAssertEqual(keychain["kishikawakatsumi"], "1234password", "stored password")

                keychain["kishikawakatsumi"] = "password1234"
                XCTAssertEqual(keychain["kishikawakatsumi"], "password1234", "updated password")

                let attributes = keychain[attributes: "kishikawakatsumi"]
                XCTAssertEqual(attributes?.`class`, ItemClass.InternetPassword.rawValue)
                XCTAssertEqual(attributes?.data, "password1234".dataUsingEncoding(NSUTF8StringEncoding))
                XCTAssertNil(attributes?.ref)
                XCTAssertNotNil(attributes?.persistentRef)
                XCTAssertEqual(attributes?.accessible, Accessibility.AfterFirstUnlock.rawValue)
                if #available(iOS 9.0, *) {
                    XCTAssertNil(attributes?.accessControl)
                } else {
                    XCTAssertNotNil(attributes?.accessControl)
                }
                XCTAssertEqual(attributes?.accessGroup, "27AEDK3C9F.com.kishikawakatsumi.KeychainAccess.TestHost")
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
                XCTAssertEqual(attributes?.`protocol`, ProtocolType.HTTPS.rawValue)
                XCTAssertEqual(attributes?.authenticationType, AuthenticationType.Default.rawValue)
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
        let JSONData = try! NSJSONSerialization.dataWithJSONObject(JSONObject, options: [])

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
        let JSONData = try! NSJSONSerialization.dataWithJSONObject(JSONObject, options: [])

        XCTAssertNil(keychain[data:"JSONData"], "not stored JSON data")

        keychain[data: "JSONData"] = JSONData
        XCTAssertEqual(keychain[data: "JSONData"], JSONData, "stored JSON data")

        keychain[data: "JSONData"] = nil
        XCTAssertNil(keychain[data:"JSONData"], "removed JSON data")
    }

    // MARK:

    #if !os(OSX) // Disable on CI
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
            let keychain = Keychain(server: NSURL(string: "https://kishikawakatsumi.com")!, protocolType: .HTTPS)
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
    #endif

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
        XCTAssertEqual(keychain.accessibility(.AfterFirstUnlock).accessibility, Accessibility.AfterFirstUnlock)
        XCTAssertEqual(keychain.accessibility(.WhenPasscodeSetThisDeviceOnly, authenticationPolicy: .UserPresence).accessibility, Accessibility.WhenPasscodeSetThisDeviceOnly)
        XCTAssertEqual(keychain.accessibility(.WhenPasscodeSetThisDeviceOnly, authenticationPolicy: .UserPresence).authenticationPolicy, AuthenticationPolicy.UserPresence)
        XCTAssertNil(keychain.label)
        XCTAssertEqual(keychain.label("Label").label, "Label")
        XCTAssertNil(keychain.comment)
        XCTAssertEqual(keychain.comment("Comment").comment, "Comment")
        XCTAssertEqual(keychain.authenticationPrompt("Prompt").authenticationPrompt, "Prompt")
    }

    // MARK:

    #if !os(OSX) // Disable on CI
    func testAllKeys() {
        do {
            let keychain = Keychain()
            keychain["key1"] = "value1"
            keychain["key2"] = "value2"
            keychain["key3"] = "value3"

            let allKeys = keychain.allKeys()
            XCTAssertEqual(allKeys.count, 3)
            XCTAssertEqual(allKeys.sort(), ["key1", "key2", "key3"])

            let allItems = keychain.allItems()
            XCTAssertEqual(allItems.count, 3)

            let sortedItems = allItems.sort { (item1, item2) -> Bool in
                let key1 = item1["key"] as! String
                let key2 = item2["key"] as! String
                return key1.compare(key2) == .OrderedAscending || key1.compare(key2) == .OrderedSame
            }

            #if !os(OSX)
            XCTAssertEqual(sortedItems[0]["accessGroup"] as? String, "27AEDK3C9F.com.kishikawakatsumi.KeychainAccess.TestHost")
            XCTAssertEqual(sortedItems[0]["synchronizable"] as? String, "false")
            XCTAssertEqual(sortedItems[0]["service"] as? String, "com.kishikawakatsumi.KeychainAccess.TestHost")
            XCTAssertEqual(sortedItems[0]["value"] as? String, "value1")
            XCTAssertEqual(sortedItems[0]["key"] as? String, "key1")
            XCTAssertEqual(sortedItems[0]["class"] as? String, "GenericPassword")
            XCTAssertEqual(sortedItems[0]["accessibility"] as? String, "AfterFirstUnlock")

            XCTAssertEqual(sortedItems[1]["accessGroup"] as? String, "27AEDK3C9F.com.kishikawakatsumi.KeychainAccess.TestHost")
            XCTAssertEqual(sortedItems[1]["synchronizable"] as? String, "false")
            XCTAssertEqual(sortedItems[1]["service"] as? String, "com.kishikawakatsumi.KeychainAccess.TestHost")
            XCTAssertEqual(sortedItems[1]["value"] as? String, "value2")
            XCTAssertEqual(sortedItems[1]["key"] as? String, "key2")
            XCTAssertEqual(sortedItems[1]["class"] as? String, "GenericPassword")
            XCTAssertEqual(sortedItems[1]["accessibility"] as? String, "AfterFirstUnlock")

            XCTAssertEqual(sortedItems[2]["accessGroup"] as? String, "27AEDK3C9F.com.kishikawakatsumi.KeychainAccess.TestHost")
            XCTAssertEqual(sortedItems[2]["synchronizable"] as? String, "false")
            XCTAssertEqual(sortedItems[2]["service"] as? String, "com.kishikawakatsumi.KeychainAccess.TestHost")
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
                .accessibility(.WhenUnlockedThisDeviceOnly)
                .set("service1_value1", key: "service1_key1")

            try! keychain
                .synchronizable(false)
                .accessibility(.AfterFirstUnlockThisDeviceOnly)
                .set("service1_value2", key: "service1_key2")

            let allKeys = keychain.allKeys()
            XCTAssertEqual(allKeys.count, 2)
            XCTAssertEqual(allKeys.sort(), ["service1_key1", "service1_key2"])

            let allItems = keychain.allItems()
            XCTAssertEqual(allItems.count, 2)

            let sortedItems = allItems.sort { (item1, item2) -> Bool in
                let key1 = item1["key"] as! String
                let key2 = item2["key"] as! String
                return key1.compare(key2) == .OrderedAscending || key1.compare(key2) == .OrderedSame
            }

            #if !os(OSX)
            XCTAssertEqual(sortedItems[0]["accessGroup"] as? String, "27AEDK3C9F.com.kishikawakatsumi.KeychainAccess.TestHost")
            XCTAssertEqual(sortedItems[0]["synchronizable"] as? String, "true")
            XCTAssertEqual(sortedItems[0]["service"] as? String, "service1")
            XCTAssertEqual(sortedItems[0]["value"] as? String, "service1_value1")
            XCTAssertEqual(sortedItems[0]["key"] as? String, "service1_key1")
            XCTAssertEqual(sortedItems[0]["class"] as? String, "GenericPassword")
            XCTAssertEqual(sortedItems[0]["accessibility"] as? String, "WhenUnlockedThisDeviceOnly")

            XCTAssertEqual(sortedItems[1]["accessGroup"] as? String, "27AEDK3C9F.com.kishikawakatsumi.KeychainAccess.TestHost")
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
            let keychain = Keychain(server: "https://google.com", protocolType: .HTTPS)
            try! keychain
                .synchronizable(false)
                .accessibility(.AlwaysThisDeviceOnly)
                .set("google.com_value1", key: "google.com_key1")

            try! keychain
                .synchronizable(true)
                .accessibility(.Always)
                .set("google.com_value2", key: "google.com_key2")

            let allKeys = keychain.allKeys()
            XCTAssertEqual(allKeys.count, 2)
            XCTAssertEqual(allKeys.sort(), ["google.com_key1", "google.com_key2"])

            let allItems = keychain.allItems()
            XCTAssertEqual(allItems.count, 2)

            let sortedItems = allItems.sort { (item1, item2) -> Bool in
                let key1 = item1["key"] as! String
                let key2 = item2["key"] as! String
                return key1.compare(key2) == .OrderedAscending || key1.compare(key2) == .OrderedSame
            }

            #if !os(OSX)
            XCTAssertEqual(sortedItems[0]["synchronizable"] as? String, "false")
            XCTAssertEqual(sortedItems[0]["value"] as? String, "google.com_value1")
            XCTAssertEqual(sortedItems[0]["key"] as? String, "google.com_key1")
            XCTAssertEqual(sortedItems[0]["server"] as? String, "google.com")
            XCTAssertEqual(sortedItems[0]["class"] as? String, "InternetPassword")
            XCTAssertEqual(sortedItems[0]["authenticationType"] as? String, "Default")
            XCTAssertEqual(sortedItems[0]["protocol"] as? String, "HTTPS")
            XCTAssertEqual(sortedItems[0]["accessibility"] as? String, "AlwaysThisDeviceOnly")

            XCTAssertEqual(sortedItems[1]["synchronizable"] as? String, "true")
            XCTAssertEqual(sortedItems[1]["value"] as? String, "google.com_value2")
            XCTAssertEqual(sortedItems[1]["key"] as? String, "google.com_key2")
            XCTAssertEqual(sortedItems[1]["server"] as? String, "google.com")
            XCTAssertEqual(sortedItems[1]["class"] as? String, "InternetPassword")
            XCTAssertEqual(sortedItems[1]["authenticationType"] as? String, "Default")
            XCTAssertEqual(sortedItems[1]["protocol"] as? String, "HTTPS")
            XCTAssertEqual(sortedItems[1]["accessibility"] as? String, "Always")
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
            let allKeys = Keychain.allKeys(.GenericPassword)
            XCTAssertEqual(allKeys.count, 5)

            let sortedKeys = allKeys.sort { (key1, key2) -> Bool in
                return key1.1.compare(key2.1) == .OrderedAscending || key1.1.compare(key2.1) == .OrderedSame
            }
            XCTAssertEqual(sortedKeys[0].0, "com.kishikawakatsumi.KeychainAccess.TestHost")
            XCTAssertEqual(sortedKeys[0].1, "key1")
            XCTAssertEqual(sortedKeys[1].0, "com.kishikawakatsumi.KeychainAccess.TestHost")
            XCTAssertEqual(sortedKeys[1].1, "key2")
            XCTAssertEqual(sortedKeys[2].0, "com.kishikawakatsumi.KeychainAccess.TestHost")
            XCTAssertEqual(sortedKeys[2].1, "key3")
            XCTAssertEqual(sortedKeys[3].0, "service1")
            XCTAssertEqual(sortedKeys[3].1, "service1_key1")
            XCTAssertEqual(sortedKeys[4].0, "service1")
            XCTAssertEqual(sortedKeys[4].1, "service1_key2")
        }
        do {
            let allKeys = Keychain.allKeys(.InternetPassword)
            XCTAssertEqual(allKeys.count, 2)

            let sortedKeys = allKeys.sort { (key1, key2) -> Bool in
                return key1.1.compare(key2.1) == .OrderedAscending || key1.1.compare(key2.1) == .OrderedSame
            }
            XCTAssertEqual(sortedKeys[0].0, "google.com")
            XCTAssertEqual(sortedKeys[0].1, "google.com_key1")
            XCTAssertEqual(sortedKeys[1].0, "google.com")
            XCTAssertEqual(sortedKeys[1].1, "google.com_key2")
        }
        #endif
    }
    #endif

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
            let accessibility: Accessibility = .WhenPasscodeSetThisDeviceOnly

            let policy: AuthenticationPolicy = [.UserPresence]
            let flags = SecAccessControlCreateFlags(rawValue: policy.rawValue)

            var error: Unmanaged<CFError>?
            let accessControl = SecAccessControlCreateWithFlags(kCFAllocatorDefault, accessibility.rawValue, flags, &error)

            XCTAssertNil(error)
            XCTAssertNotNil(accessControl)
        }
        #if os(iOS)
        do {
            let accessibility: Accessibility = .WhenPasscodeSetThisDeviceOnly

            let policy: AuthenticationPolicy = [.UserPresence, .ApplicationPassword]
            let flags = SecAccessControlCreateFlags(rawValue: policy.rawValue)

            var error: Unmanaged<CFError>?
            let accessControl = SecAccessControlCreateWithFlags(kCFAllocatorDefault, accessibility.rawValue, flags, &error)

            XCTAssertNil(error)
            XCTAssertNotNil(accessControl)
        }
        do {
            let accessibility: Accessibility = .WhenPasscodeSetThisDeviceOnly

            let policy: AuthenticationPolicy = [.UserPresence, .ApplicationPassword, .PrivateKeyUsage]
            let flags = SecAccessControlCreateFlags(rawValue: policy.rawValue)

            var error: Unmanaged<CFError>?
            let accessControl = SecAccessControlCreateWithFlags(kCFAllocatorDefault, accessibility.rawValue, flags, &error)

            XCTAssertNil(error)
            XCTAssertNotNil(accessControl)
        }
        do {
            let accessibility: Accessibility = .WhenPasscodeSetThisDeviceOnly

            let policy: AuthenticationPolicy = [.ApplicationPassword]
            let flags = SecAccessControlCreateFlags(rawValue: policy.rawValue)

            var error: Unmanaged<CFError>?
            let accessControl = SecAccessControlCreateWithFlags(kCFAllocatorDefault, accessibility.rawValue, flags, &error)

            XCTAssertNil(error)
            XCTAssertNotNil(accessControl)
        }
        do {
            let accessibility: Accessibility = .WhenPasscodeSetThisDeviceOnly

            let policy: AuthenticationPolicy = [.ApplicationPassword, .PrivateKeyUsage]
            let flags = SecAccessControlCreateFlags(rawValue: policy.rawValue)

            var error: Unmanaged<CFError>?
            let accessControl = SecAccessControlCreateWithFlags(kCFAllocatorDefault, accessibility.rawValue, flags, &error)

            XCTAssertNil(error)
            XCTAssertNotNil(accessControl)
        }
        do {
            let accessibility: Accessibility = .WhenPasscodeSetThisDeviceOnly

            let policy: AuthenticationPolicy = [.PrivateKeyUsage]
            let flags = SecAccessControlCreateFlags(rawValue: policy.rawValue)

            var error: Unmanaged<CFError>?
            let accessControl = SecAccessControlCreateWithFlags(kCFAllocatorDefault, accessibility.rawValue, flags, &error)

            XCTAssertNil(error)
            XCTAssertNotNil(accessControl)
        }
        do {
            let accessibility: Accessibility = .WhenPasscodeSetThisDeviceOnly

            let policy: AuthenticationPolicy = [.TouchIDAny]
            let flags = SecAccessControlCreateFlags(rawValue: policy.rawValue)

            var error: Unmanaged<CFError>?
            let accessControl = SecAccessControlCreateWithFlags(kCFAllocatorDefault, accessibility.rawValue, flags, &error)

            XCTAssertNil(error)
            XCTAssertNotNil(accessControl)
        }
        do {
            let accessibility: Accessibility = .WhenPasscodeSetThisDeviceOnly

            let policy: AuthenticationPolicy = [.TouchIDAny, .DevicePasscode]
            let flags = SecAccessControlCreateFlags(rawValue: policy.rawValue)

            var error: Unmanaged<CFError>?
            let accessControl = SecAccessControlCreateWithFlags(kCFAllocatorDefault, accessibility.rawValue, flags, &error)

            XCTAssertNil(error)
            XCTAssertNotNil(accessControl)
        }
        do {
            let accessibility: Accessibility = .WhenPasscodeSetThisDeviceOnly

            let policy: AuthenticationPolicy = [.TouchIDAny, .ApplicationPassword]
            let flags = SecAccessControlCreateFlags(rawValue: policy.rawValue)

            var error: Unmanaged<CFError>?
            let accessControl = SecAccessControlCreateWithFlags(kCFAllocatorDefault, accessibility.rawValue, flags, &error)

            XCTAssertNil(error)
            XCTAssertNotNil(accessControl)
        }
        do {
            let accessibility: Accessibility = .WhenPasscodeSetThisDeviceOnly

            let policy: AuthenticationPolicy = [.TouchIDAny, .ApplicationPassword, .PrivateKeyUsage]
            let flags = SecAccessControlCreateFlags(rawValue: policy.rawValue)

            var error: Unmanaged<CFError>?
            let accessControl = SecAccessControlCreateWithFlags(kCFAllocatorDefault, accessibility.rawValue, flags, &error)

            XCTAssertNil(error)
            XCTAssertNotNil(accessControl)
        }
        do {
            let accessibility: Accessibility = .WhenPasscodeSetThisDeviceOnly

            let policy: AuthenticationPolicy = [.TouchIDCurrentSet]
            let flags = SecAccessControlCreateFlags(rawValue: policy.rawValue)

            var error: Unmanaged<CFError>?
            let accessControl = SecAccessControlCreateWithFlags(kCFAllocatorDefault, accessibility.rawValue, flags, &error)

            XCTAssertNil(error)
            XCTAssertNotNil(accessControl)
        }
        do {
            let accessibility: Accessibility = .WhenPasscodeSetThisDeviceOnly

            let policy: AuthenticationPolicy = [.TouchIDCurrentSet, .DevicePasscode]
            let flags = SecAccessControlCreateFlags(rawValue: policy.rawValue)

            var error: Unmanaged<CFError>?
            let accessControl = SecAccessControlCreateWithFlags(kCFAllocatorDefault, accessibility.rawValue, flags, &error)

            XCTAssertNil(error)
            XCTAssertNotNil(accessControl)
        }
        do {
            let accessibility: Accessibility = .WhenPasscodeSetThisDeviceOnly

            let policy: AuthenticationPolicy = [.TouchIDCurrentSet, .ApplicationPassword]
            let flags = SecAccessControlCreateFlags(rawValue: policy.rawValue)

            var error: Unmanaged<CFError>?
            let accessControl = SecAccessControlCreateWithFlags(kCFAllocatorDefault, accessibility.rawValue, flags, &error)

            XCTAssertNil(error)
            XCTAssertNotNil(accessControl)
        }
        do {
            let accessibility: Accessibility = .WhenPasscodeSetThisDeviceOnly

            let policy: AuthenticationPolicy = [.TouchIDCurrentSet, .ApplicationPassword, .PrivateKeyUsage]
            let flags = SecAccessControlCreateFlags(rawValue: policy.rawValue)

            var error: Unmanaged<CFError>?
            let accessControl = SecAccessControlCreateWithFlags(kCFAllocatorDefault, accessibility.rawValue, flags, &error)

            XCTAssertNil(error)
            XCTAssertNotNil(accessControl)
        }
        do {
            let accessibility: Accessibility = .WhenPasscodeSetThisDeviceOnly

            let policy: AuthenticationPolicy = [.TouchIDAny, .Or, .DevicePasscode]
            let flags = SecAccessControlCreateFlags(rawValue: policy.rawValue)

            var error: Unmanaged<CFError>?
            let accessControl = SecAccessControlCreateWithFlags(kCFAllocatorDefault, accessibility.rawValue, flags, &error)

            XCTAssertNil(error)
            XCTAssertNotNil(accessControl)
        }
        do {
            let accessibility: Accessibility = .WhenPasscodeSetThisDeviceOnly

            let policy: AuthenticationPolicy = [.TouchIDAny, .And, .DevicePasscode]
            let flags = SecAccessControlCreateFlags(rawValue: policy.rawValue)

            var error: Unmanaged<CFError>?
            let accessControl = SecAccessControlCreateWithFlags(kCFAllocatorDefault, accessibility.rawValue, flags, &error)

            XCTAssertNil(error)
            XCTAssertNotNil(accessControl)
        }
        #endif
        #if os(OSX)
        do {
            let accessibility: Accessibility = .WhenPasscodeSetThisDeviceOnly

            let policy: AuthenticationPolicy = [.UserPresence]
            let flags = SecAccessControlCreateFlags(rawValue: policy.rawValue)

            var error: Unmanaged<CFError>?
            let accessControl = SecAccessControlCreateWithFlags(kCFAllocatorDefault, accessibility.rawValue, flags, &error)

            XCTAssertNil(error)
            XCTAssertNotNil(accessControl)
        }
        do {
            let accessibility: Accessibility = .WhenPasscodeSetThisDeviceOnly

            let policy: AuthenticationPolicy = [.DevicePasscode]
            let flags = SecAccessControlCreateFlags(rawValue: policy.rawValue)

            var error: Unmanaged<CFError>?
            let accessControl = SecAccessControlCreateWithFlags(kCFAllocatorDefault, accessibility.rawValue, flags, &error)

            XCTAssertNil(error)
            XCTAssertNotNil(accessControl)
        }
        #endif
    }
}
