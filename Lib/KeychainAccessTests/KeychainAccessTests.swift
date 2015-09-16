//
//  KeychainAccessTests.swift
//  KeychainAccessTests
//
//  Created by kishikawa katsumi on 2014/12/24.
//  Copyright (c) 2014 kishikawa katsumi. All rights reserved.
//

import Foundation
import XCTest

import KeychainAccess

class KeychainAccessTests: XCTestCase {
    
    override func setUp() {
        super.setUp()

        do { try Keychain(service: "Twitter", accessGroup: "12ABCD3E4F.shared").removeAll() } catch {}
        do { try Keychain(service: "Twitter").removeAll() } catch {}
        
        do { try Keychain(server: NSURL(string: "https://example.com")!, protocolType: .HTTPS).removeAll() } catch {}
        
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
            XCTAssertEqual(username!, "kishikawa_katsumi")
            
            let password = try! keychain.get("password")
            XCTAssertEqual(password!, "password_1234")
        }
        
        do {
            // Update Keychain items
            let keychain = Keychain(service: "Twitter")
            
            do { try keychain.set("katsumi_kishikawa", key: "username") } catch {}
            do { try keychain.set("1234_password", key: "password") } catch {}
            
            let username = try! keychain.get("username")
            XCTAssertEqual(username!, "katsumi_kishikawa")
            
            let password = try! keychain.get("password")
            XCTAssertEqual(password!, "1234_password")
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
            let keychain = Keychain(service: "Twitter", accessGroup: "12ABCD3E4F.shared")
            
            keychain["username"] = "kishikawa_katsumi"
            keychain["password"] = "password_1234"
            
            let username = keychain["username"]
            XCTAssertEqual(username!, "kishikawa_katsumi")
            
            let password = keychain["password"]
            XCTAssertEqual(password!, "password_1234")
        }
        
        do {
            // Update Keychain items
            let keychain = Keychain(service: "Twitter", accessGroup: "12ABCD3E4F.shared")
            
            keychain["username"] = "katsumi_kishikawa"
            keychain["password"] = "1234_password"
            
            let username = keychain["username"]
            XCTAssertEqual(username!, "katsumi_kishikawa")
            
            let password = keychain["password"]
            XCTAssertEqual(password!, "1234_password")
        }
        
        do {
            // Remove Keychain items
            let keychain = Keychain(service: "Twitter", accessGroup: "12ABCD3E4F.shared")
            
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
            XCTAssertEqual(username!, "kishikawa_katsumi")
            
            let password = try! keychain.get("password")
            XCTAssertEqual(password!, "password_1234")
        }
        
        do {
            // Update Keychain items
            let keychain = Keychain(server: NSURL(string: "https://kishikawakatsumi.com")!, protocolType: .HTTPS)
            
            do { try keychain.set("katsumi_kishikawa", key: "username") } catch {}
            do { try keychain.set("1234_password", key: "password") } catch {}
            
            let username = try! keychain.get("username")
            XCTAssertEqual(username!, "katsumi_kishikawa")
            
            let password = try! keychain.get("password")
            XCTAssertEqual(password!, "1234_password")
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
            XCTAssertEqual(username!, "kishikawa_katsumi")
            
            let password = keychain["password"]
            XCTAssertEqual(password!, "password_1234")
        }
        
        do {
            // Update Keychain items
            let keychain = Keychain(server: NSURL(string: "https://kishikawakatsumi.com")!, protocolType: .HTTPS)
            
            keychain["username"] = "katsumi_kishikawa"
            keychain["password"] = "1234_password"
            
            let username = keychain["username"]
            XCTAssertEqual(username!, "katsumi_kishikawa")
            
            let password = keychain["password"]
            XCTAssertEqual(password!, "1234_password")
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
        XCTAssertEqual(keychain.service, "")
        XCTAssertNil(keychain.accessGroup)
    }
    
    func testInitializerWithService() {
        let keychain = Keychain(service: "com.example.github-token")
        XCTAssertEqual(keychain.service, "com.example.github-token")
        XCTAssertNil(keychain.accessGroup)
    }
    
    func testInitializerWithAccessGroup() {
        let keychain = Keychain(accessGroup: "12ABCD3E4F.shared")
        XCTAssertEqual(keychain.service, "")
        XCTAssertEqual(keychain.accessGroup!, "12ABCD3E4F.shared")
    }
    
    func testInitializerWithServiceAndAccessGroup() {
        let keychain = Keychain(service: "com.example.github-token", accessGroup: "12ABCD3E4F.shared")
        XCTAssertEqual(keychain.service, "com.example.github-token")
        XCTAssertEqual(keychain.accessGroup!, "12ABCD3E4F.shared")
    }
    
    func testInitializerWithServer() {
        let URL = NSURL(string: "https://kishikawakatsumi.com")!
        
        let keychain = Keychain(server: URL, protocolType: .HTTPS)
        XCTAssertEqual(keychain.server, URL)
        XCTAssertEqual(keychain.protocolType, ProtocolType.HTTPS)
        XCTAssertEqual(keychain.authenticationType, AuthenticationType.Default)
    }
    
    func testInitializerWithServerAndAuthenticationType() {
        let URL = NSURL(string: "https://kishikawakatsumi.com")!
        
        let keychain = Keychain(server: URL, protocolType: .HTTPS, authenticationType: .HTMLForm)
        XCTAssertEqual(keychain.server, URL)
        XCTAssertEqual(keychain.protocolType, ProtocolType.HTTPS)
        XCTAssertEqual(keychain.authenticationType, AuthenticationType.HTMLForm)
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
        XCTAssertEqual(try! keychain.get("username")!, "kishikawakatsumi", "stored username")
        XCTAssertNil(try! keychain.get("password"), "not stored password")
        
        do { try keychain.set("password1234", key: "password") } catch {}
        XCTAssertEqual(try! keychain.get("username")!, "kishikawakatsumi", "stored username")
        XCTAssertEqual(try! keychain.get("password")!, "password1234", "stored password")
    }
    
    func testSetData() {
        let JSONObject = ["username": "kishikawakatsumi", "password": "password1234"]
        let JSONData = try! NSJSONSerialization.dataWithJSONObject(JSONObject, options: [])
        
        let keychain = Keychain(service: "Twitter")
        
        XCTAssertNil(try! keychain.getData("JSONData"), "not stored JSON data")
        
        do { try keychain.set(JSONData, key: "JSONData") } catch {}
        XCTAssertEqual(try! keychain.getData("JSONData")!, JSONData, "stored JSON data")
    }
    
    func testRemoveString() {
        let keychain = Keychain(service: "Twitter")
        
        XCTAssertNil(try! keychain.get("username"), "not stored username")
        XCTAssertNil(try! keychain.get("password"), "not stored password")
        
        do { try keychain.set("kishikawakatsumi", key: "username") } catch {}
        XCTAssertEqual(try! keychain.get("username")!, "kishikawakatsumi", "stored username")
        
        do { try keychain.set("password1234", key: "password") } catch {}
        XCTAssertEqual(try! keychain.get("password")!, "password1234", "stored password")
        
        do { try keychain.remove("username") } catch {}
        XCTAssertNil(try! keychain.get("username"), "removed username")
        XCTAssertEqual(try! keychain.get("password")!, "password1234", "left password")
        
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
        XCTAssertEqual(try! keychain.getData("JSONData")!, JSONData, "stored JSON data")
        
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
        XCTAssertEqual(keychain["username"]!, "kishikawakatsumi", "stored username")
        XCTAssertEqual(keychain[string: "username"]!, "kishikawakatsumi", "stored username")
        
        keychain["password"] = "password1234"
        XCTAssertEqual(keychain["password"]!, "password1234", "stored password")
        XCTAssertEqual(keychain[string: "password"]!, "password1234", "stored password")
        
        keychain["username"] = nil
        XCTAssertNil(keychain["username"], "removed username")
        XCTAssertEqual(keychain["password"]!, "password1234", "left password")
        XCTAssertNil(keychain[string: "username"], "removed username")
        XCTAssertEqual(keychain[string: "password"]!, "password1234", "left password")
        
        keychain["password"] = nil
        XCTAssertNil(keychain["username"], "removed username")
        XCTAssertNil(keychain["password"], "removed password")
        XCTAssertNil(keychain[string: "username"], "removed username")
        XCTAssertNil(keychain[string: "password"], "removed password")

        let JSONObject = ["username": "kishikawakatsumi", "password": "password1234"]
        let JSONData = try! NSJSONSerialization.dataWithJSONObject(JSONObject, options: [])

        XCTAssertNil(keychain[data:"JSONData"], "not stored JSON data")

        keychain[data: "JSONData"] = JSONData
        XCTAssertEqual(keychain[data:"JSONData"]!, JSONData, "stored JSON data")
    }
    
    // MARK:
    
    #if os(iOS)
    func testErrorHandling() {
        do {
            let keychain = Keychain(service: "Twitter", accessGroup: "12ABCD3E4F.shared")
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
        XCTAssertEqual(try! Keychain().get("username")!, username_1, "stored username")
        XCTAssertEqual(try! Keychain(service: service_1).get("username")!, username_1, "stored username")
        XCTAssertNil(try! Keychain(service: service_2).get("username"), "not stored username")
        XCTAssertNil(try! Keychain(service: service_3).get("username"), "not stored username")
        
        do { try Keychain(service: service_1).set(username_1, key: "username") } catch {}
        XCTAssertEqual(try! Keychain().get("username")!, username_1, "stored username")
        XCTAssertEqual(try! Keychain(service: service_1).get("username")!, username_1, "stored username")
        XCTAssertNil(try! Keychain(service: service_2).get("username"), "not stored username")
        XCTAssertNil(try! Keychain(service: service_3).get("username"), "not stored username")
        
        do { try Keychain(service: service_2).set(username_2, key: "username") } catch {}
        XCTAssertEqual(try! Keychain().get("username")!, username_1, "stored username")
        XCTAssertEqual(try! Keychain(service: service_1).get("username")!, username_1, "stored username")
        XCTAssertEqual(try! Keychain(service: service_2).get("username")!, username_2, "stored username")
        XCTAssertNil(try! Keychain(service: service_3).get("username"), "not stored username")
        
        do { try Keychain(service: service_3).set(username_3, key: "username") } catch {}
        XCTAssertEqual(try! Keychain().get("username")!, username_1, "stored username")
        XCTAssertEqual(try! Keychain(service: service_1).get("username")!, username_1, "stored username")
        XCTAssertEqual(try! Keychain(service: service_2).get("username")!, username_2, "stored username")
        XCTAssertEqual(try! Keychain(service: service_3).get("username")!, username_3, "stored username")

        do { try Keychain().set(password_1, key: "password") } catch {}
        XCTAssertEqual(try! Keychain().get("password")!, password_1, "stored password")
        XCTAssertEqual(try! Keychain(service: service_1).get("password")!, password_1, "stored password")
        XCTAssertNil(try! Keychain(service: service_2).get("password"), "not stored password")
        XCTAssertNil(try! Keychain(service: service_3).get("password"), "not stored password")
        
        do { try Keychain(service: service_1).set(password_1, key: "password") } catch {}
        XCTAssertEqual(try! Keychain().get("password")!, password_1, "stored password")
        XCTAssertEqual(try! Keychain(service: service_1).get("password")!, password_1, "stored password")
        XCTAssertNil(try! Keychain(service: service_2).get("password"), "not stored password")
        XCTAssertNil(try! Keychain(service: service_3).get("password"), "not stored password")
        
        do { try Keychain(service: service_2).set(password_2, key: "password") } catch {}
        XCTAssertEqual(try! Keychain().get("password")!, password_1, "stored password")
        XCTAssertEqual(try! Keychain(service: service_1).get("password")!, password_1, "stored password")
        XCTAssertEqual(try! Keychain(service: service_2).get("password")!, password_2, "stored password")
        XCTAssertNil(try! Keychain(service: service_3).get("password"), "not stored password")
        
        do { try Keychain(service: service_3).set(password_3, key: "password") } catch {}
        XCTAssertEqual(try! Keychain().get("password")!, password_1, "stored password")
        XCTAssertEqual(try! Keychain(service: service_1).get("password")!, password_1, "stored password")
        XCTAssertEqual(try! Keychain(service: service_2).get("password")!, password_2, "stored password")
        XCTAssertEqual(try! Keychain(service: service_3).get("password")!, password_3, "stored password")
        
        do { try Keychain().remove("username") } catch {}
        XCTAssertNil(try! Keychain().get("username"), "removed username")
        XCTAssertNil(try! Keychain(service: service_1).get("username"), "removed username")
        XCTAssertEqual(try! Keychain(service: service_2).get("username")!, username_2, "left username")
        XCTAssertEqual(try! Keychain(service: service_3).get("username")!, username_3, "left username")
        
        do { try Keychain(service: service_1).remove("username") } catch {}
        XCTAssertNil(try! Keychain().get("username"), "removed username")
        XCTAssertNil(try! Keychain(service: service_1).get("username"), "removed username")
        XCTAssertEqual(try! Keychain(service: service_2).get("username")!, username_2, "left username")
        XCTAssertEqual(try! Keychain(service: service_3).get("username")!, username_3, "left username")
        
        do { try Keychain(service: service_2).remove("username") } catch {}
        XCTAssertNil(try! Keychain().get("username"), "removed username")
        XCTAssertNil(try! Keychain(service: service_1).get("username"), "removed username")
        XCTAssertNil(try! Keychain(service: service_2).get("username"), "removed username")
        XCTAssertEqual(try! Keychain(service: service_3).get("username")!, username_3, "left username")
        
        do { try Keychain(service: service_3).remove("username") } catch {}
        XCTAssertNil(try! Keychain().get("username"), "removed username")
        XCTAssertNil(try! Keychain(service: service_1).get("username"), "removed username")
        XCTAssertNil(try! Keychain(service: service_2).get("username"), "removed username")
        XCTAssertNil(try! Keychain(service: service_3).get("username"), "removed username")
        
        do { try Keychain().remove("password") } catch {}
        XCTAssertNil(try! Keychain().get("password"), "removed password")
        XCTAssertNil(try! Keychain(service: service_1).get("password"), "removed password")
        XCTAssertEqual(try! Keychain(service: service_2).get("password")!, password_2, "left password")
        XCTAssertEqual(try! Keychain(service: service_3).get("password")!, password_3, "left password")
        
        do { try Keychain(service: service_1).remove("password") } catch {}
        XCTAssertNil(try! Keychain().get("password"), "removed password")
        XCTAssertNil(try! Keychain(service: service_1).get("password"), "removed password")
        XCTAssertEqual(try! Keychain(service: service_2).get("password")!, password_2, "left password")
        XCTAssertEqual(try! Keychain(service: service_3).get("password")!, password_3, "left password")
        
        do { try Keychain(service: service_2).remove("password") } catch {}
        XCTAssertNil(try! Keychain().get("password"), "removed password")
        XCTAssertNil(try! Keychain(service: service_1).get("password"), "removed password")
        XCTAssertNil(try! Keychain(service: service_2).get("password"), "removed password")
        XCTAssertEqual(try! Keychain(service: service_3).get("password")!, password_3, "left password")
        
        do { try Keychain(service: service_3).remove("password") } catch {}
        XCTAssertNil(try! Keychain().get("password"), "removed password")
        XCTAssertNil(try! Keychain(service: service_2).get("password"), "removed password")
        XCTAssertNil(try! Keychain(service: service_2).get("password"), "removed password")
        XCTAssertNil(try! Keychain(service: service_2).get("password"), "removed password")
    }
}
