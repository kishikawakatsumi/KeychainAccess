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
        
        Keychain(service: "example.com", accessGroup: "12ABCD3E4F.shared").removeAll()
        Keychain(service: "example.com").removeAll()
        
        Keychain(server: NSURL(string: "https://kishikawakatsumi.com")!, protocolType: .HTTPS).removeAll()
        
        Keychain().removeAll()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func locally(x: () -> ()) {
        x()
    }
    
    // MARK:
    
    func testGenericPassword() {
        locally {
            // Add Keychain items
            let keychain = Keychain(service: "example.com")
            
            keychain.set("kishikawa_katsumi", key: "username")
            keychain.set("password_1234", key: "password")
            
            let username = keychain.get("username").asString
            XCTAssertEqual(username!, "kishikawa_katsumi")
            
            let password = keychain.get("password").asString
            XCTAssertEqual(password!, "password_1234")
        }
        
        locally {
            // Update Keychain items
            let keychain = Keychain(service: "example.com")
            
            keychain.set("katsumi_kishikawa", key: "username")
            keychain.set("1234_password", key: "password")
            
            let username = keychain.get("username").asString
            XCTAssertEqual(username!, "katsumi_kishikawa")
            
            let password = keychain.get("password").asString
            XCTAssertEqual(password!, "1234_password")
        }
        
        locally {
            // Remove Keychain items
            let keychain = Keychain(service: "example.com")
            
            keychain.remove("username")
            keychain.remove("password")
            
            XCTAssertNil(keychain.get("username").asString)
            XCTAssertNil(keychain.get("password").asString)
        }
    }
    
    func testGenericPasswordSubscripting() {
        locally {
            // Add Keychain items
            let keychain = Keychain(service: "example.com", accessGroup: "12ABCD3E4F.shared")
            
            keychain["username"] = "kishikawa_katsumi"
            keychain["password"] = "password_1234"
            
            let username = keychain["username"]
            XCTAssertEqual(username!, "kishikawa_katsumi")
            
            let password = keychain["password"]
            XCTAssertEqual(password!, "password_1234")
        }
        
        locally {
            // Update Keychain items
            let keychain = Keychain(service: "example.com", accessGroup: "12ABCD3E4F.shared")
            
            keychain["username"] = "katsumi_kishikawa"
            keychain["password"] = "1234_password"
            
            let username = keychain["username"]
            XCTAssertEqual(username!, "katsumi_kishikawa")
            
            let password = keychain["password"]
            XCTAssertEqual(password!, "1234_password")
        }
        
        locally {
            // Remove Keychain items
            let keychain = Keychain(service: "example.com", accessGroup: "12ABCD3E4F.shared")
            
            keychain["username"] = nil
            keychain["password"] = nil
            
            XCTAssertNil(keychain["username"])
            XCTAssertNil(keychain["password"])
        }
    }
    
    // MARK:
    
    func testInternetPassword() {
        locally {
            // Add Keychain items
            let keychain = Keychain(server: NSURL(string: "https://kishikawakatsumi.com")!, protocolType: .HTTPS)
            
            keychain.set("kishikawa_katsumi", key: "username")
            keychain.set("password_1234", key: "password")
            
            let username = keychain.get("username").asString
            XCTAssertEqual(username!, "kishikawa_katsumi")
            
            let password = keychain.get("password").asString
            XCTAssertEqual(password!, "password_1234")
        }
        
        locally {
            // Update Keychain items
            let keychain = Keychain(server: NSURL(string: "https://kishikawakatsumi.com")!, protocolType: .HTTPS)
            
            keychain.set("katsumi_kishikawa", key: "username")
            keychain.set("1234_password", key: "password")
            
            let username = keychain.get("username").asString
            XCTAssertEqual(username!, "katsumi_kishikawa")
            
            let password = keychain.get("password").asString
            XCTAssertEqual(password!, "1234_password")
        }
        
        locally {
            // Remove Keychain items
            let keychain = Keychain(server: NSURL(string: "https://kishikawakatsumi.com")!, protocolType: .HTTPS)
            
            keychain.remove("username")
            keychain.remove("password")
            
            XCTAssertNil(keychain.get("username").asString)
            XCTAssertNil(keychain.get("password").asString)
        }
    }
    
    func testInternetPasswordSubscripting() {
        locally {
            // Add Keychain items
            let keychain = Keychain(server: NSURL(string: "https://kishikawakatsumi.com")!, protocolType: .HTTPS)
            
            keychain["username"] = "kishikawa_katsumi"
            keychain["password"] = "password_1234"
            
            let username = keychain["username"]
            XCTAssertEqual(username!, "kishikawa_katsumi")
            
            let password = keychain["password"]
            XCTAssertEqual(password!, "password_1234")
        }
        
        locally {
            // Update Keychain items
            let keychain = Keychain(server: NSURL(string: "https://kishikawakatsumi.com")!, protocolType: .HTTPS)
            
            keychain["username"] = "katsumi_kishikawa"
            keychain["password"] = "1234_password"
            
            let username = keychain["username"]
            XCTAssertEqual(username!, "katsumi_kishikawa")
            
            let password = keychain["password"]
            XCTAssertEqual(password!, "1234_password")
        }
        
        locally {
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
        let keychain = Keychain(service: "example.com")
        XCTAssertEqual(keychain.service, "example.com")
        XCTAssertNil(keychain.accessGroup)
    }
    
    func testInitializerWithAccessGroup() {
        let keychain = Keychain(accessGroup: "12ABCD3E4F.shared")
        XCTAssertEqual(keychain.service, "")
        XCTAssertEqual(keychain.accessGroup!, "12ABCD3E4F.shared")
    }
    
    func testInitializerWithServiceAndAccessGroup() {
        let keychain = Keychain(service: "example.com", accessGroup: "12ABCD3E4F.shared")
        XCTAssertEqual(keychain.service, "example.com")
        XCTAssertEqual(keychain.accessGroup!, "12ABCD3E4F.shared")
    }
    
    // MARK:
    
    func testSetString() {
        let keychain = Keychain(service: "example.com")
        
        XCTAssertNil(keychain.get("username").asString, "not stored username")
        XCTAssertNil(keychain.get("password").asString, "not stored password")
        
        keychain.set("kishikawakatsumi", key: "username")
        XCTAssertEqual(keychain.get("username").asString!, "kishikawakatsumi", "stored username")
        XCTAssertNil(keychain.get("password").asString, "not stored password")
        
        keychain.set("password1234", key: "password")
        XCTAssertEqual(keychain.get("username").asString!, "kishikawakatsumi", "stored username")
        XCTAssertEqual(keychain.get("password").asString!, "password1234", "stored password")
    }
    
    func testSetData() {
        let JSONObject = ["username": "kishikawakatsumi", "password": "password1234"]
        let JSONData = NSJSONSerialization.dataWithJSONObject(JSONObject, options: nil, error: nil)
        
        let keychain = Keychain(service: "example.com")
        
        XCTAssertNil(keychain.get("JSONData").asData, "not stored JSON data")
        
        keychain.set(JSONData!, key: "JSONData")
        XCTAssertEqual(keychain.get("JSONData").asData!, JSONData!, "stored JSONData")
    }
    
    func testRemoveString() {
        let keychain = Keychain(service: "example.com")
        
        XCTAssertNil(keychain.get("username").asString, "not stored username")
        XCTAssertNil(keychain.get("password").asString, "not stored password")
        
        keychain.set("kishikawakatsumi", key: "username")
        XCTAssertEqual(keychain.get("username").asString!, "kishikawakatsumi", "stored username")
        
        keychain.set("password1234", key: "password")
        XCTAssertEqual(keychain.get("password").asString!, "password1234", "stored password")
        
        keychain.remove("username")
        XCTAssertNil(keychain.get("username").asString, "removed username")
        XCTAssertEqual(keychain.get("password").asString!, "password1234", "left password")
        
        keychain.remove("password")
        XCTAssertNil(keychain.get("username").asString, "removed username")
        XCTAssertNil(keychain.get("password").asString, "removed password")
    }
    
    func testRemoveData() {
        let JSONObject = ["username": "kishikawakatsumi", "password": "password1234"]
        let JSONData = NSJSONSerialization.dataWithJSONObject(JSONObject, options: nil, error: nil)
        
        let keychain = Keychain(service: "example.com")
        
        XCTAssertNil(keychain.get("JSONData").asData, "not stored JSON data")
        
        keychain.set(JSONData!, key: "JSONData")
        XCTAssertEqual(keychain.get("JSONData").asData!, JSONData!, "stored JSONData")
        
        keychain.remove("JSONData")
        XCTAssertNil(keychain.get("JSONData").asData, "removed JSONData")
    }
    
    // MARK:
    
    func testSubscripting() {
        let keychain = Keychain(service: "example.com")
        
        XCTAssertNil(keychain["username"], "not stored username")
        XCTAssertNil(keychain["password"], "not stored password")
        
        keychain["username"] = "kishikawakatsumi"
        XCTAssertEqual(keychain["username"]!, "kishikawakatsumi", "stored username")
        
        keychain["password"] = "password1234"
        XCTAssertEqual(keychain["password"]!, "password1234", "stored password")
        
        keychain["username"] = nil
        XCTAssertNil(keychain["username"], "removed username")
        XCTAssertEqual(keychain["password"]!, "password1234", "left password")
        
        keychain["password"] = nil
        XCTAssertNil(keychain["username"], "removed username")
        XCTAssertNil(keychain["password"], "removed password")
    }
    
    // MARK:
    
    #if os(iOS)
    func testErrorHandling() {
        if let error = Keychain(service: "example.com", accessGroup: "12ABCD3E4F.shared").removeAll() {
            XCTAssertNil(error, "no error occurred")
        }
        if let error = Keychain(service: "example.com").removeAll() {
            XCTAssertNil(error, "no error occurred")
        }
        if let error = Keychain(server: NSURL(string: "https://kishikawakatsumi.com")!, protocolType: .HTTPS).removeAll() {
            XCTAssertNil(error, "no error occurred")
        }
        if let error = Keychain().removeAll() {
            XCTAssertNil(error, "no error occurred")
        }
        
        locally {
            // Add Keychain items
            let keychain = Keychain(service: "example.com")
            
            if let error = keychain.set("kishikawa_katsumi", key: "username") {
                XCTAssertNil(error, "no error occurred")
            }
            if let error = keychain.set("password_1234", key: "password") {
                XCTAssertNil(error, "no error occurred")
            }
            
            let username = keychain.get("username")
            XCTAssertEqual(username.asString!, "kishikawa_katsumi")
            XCTAssertNil(username.error, "no error occurred")
            
            let password = keychain.get("password")
            XCTAssertEqual(password.asString!, "password_1234")
            XCTAssertNil(password.error, "no error occurred")
        }
        
        locally {
            // Update Keychain items
            let keychain = Keychain(service: "example.com")
            
            if let error = keychain.set("katsumi_kishikawa", key: "username") {
                XCTAssertNil(error, "no error occurred")
            }
            if let error = keychain.set("1234_password", key: "password") {
                XCTAssertNil(error, "no error occurred")
            }
            
            let username = keychain.get("username")
            XCTAssertEqual(username.asString!, "katsumi_kishikawa")
            XCTAssertNil(username.error, "no error occurred")
            
            let password = keychain.get("password")
            XCTAssertEqual(password.asString!, "1234_password")
            XCTAssertNil(password.error, "no error occurred")
        }
        
        locally {
            // Remove Keychain items
            let keychain = Keychain(service: "example.com")
            
            if let error = keychain.remove("username") {
                XCTAssertNil(error, "no error occurred")
            }
            if let error = keychain.remove("password") {
                XCTAssertNil(error, "no error occurred")
            }
            
            XCTAssertNil(keychain.get("username").asString)
            XCTAssertNil(keychain.get("password").asString)
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
        
        Keychain(service: service_1).removeAll()
        Keychain(service: service_2).removeAll()
        Keychain(service: service_3).removeAll()
        
        XCTAssertNil(Keychain().get("username").asString, "not stored username")
        XCTAssertNil(Keychain().get("password").asString, "not stored password")
        XCTAssertNil(Keychain(service: service_1).get("username").asString, "not stored username")
        XCTAssertNil(Keychain(service: service_1).get("password").asString, "not stored password")
        XCTAssertNil(Keychain(service: service_2).get("username").asString, "not stored username")
        XCTAssertNil(Keychain(service: service_2).get("password").asString, "not stored password")
        XCTAssertNil(Keychain(service: service_3).get("username").asString, "not stored username")
        XCTAssertNil(Keychain(service: service_3).get("password").asString, "not stored password")
        
        Keychain().set(username_1, key: "username")
        XCTAssertEqual(Keychain().get("username").asString!, username_1, "stored username")
        XCTAssertEqual(Keychain(service: service_1).get("username").asString!, username_1, "stored username")
        XCTAssertNil(Keychain(service: service_2).get("username").asString, "not stored username")
        XCTAssertNil(Keychain(service: service_3).get("username").asString, "not stored username")
        
        Keychain(service: service_1).set(username_1, key: "username")
        XCTAssertEqual(Keychain(service: service_1).get("username").asString!, username_1, "stored username")
        XCTAssertEqual(Keychain(service: service_1).get("username").asString!, username_1, "stored username")
        XCTAssertNil(Keychain(service: service_2).get("username").asString, "not stored username")
        XCTAssertNil(Keychain(service: service_3).get("username").asString, "not stored username")
        
        Keychain(service: service_2).set(username_2, key: "username")
        XCTAssertEqual(Keychain().get("username").asString!, username_1, "stored username")
        XCTAssertEqual(Keychain(service: service_1).get("username").asString!, username_1, "stored username")
        XCTAssertEqual(Keychain(service: service_2).get("username").asString!, username_2, "stored username")
        XCTAssertNil(Keychain(service: service_3).get("username").asString, "not stored username")
        
        Keychain(service: service_3).set(username_3, key: "username")
        XCTAssertEqual(Keychain().get("username").asString!, username_1, "stored username")
        XCTAssertEqual(Keychain(service: service_1).get("username").asString!, username_1, "stored username")
        XCTAssertEqual(Keychain(service: service_2).get("username").asString!, username_2, "stored username")
        XCTAssertEqual(Keychain(service: service_3).get("username").asString!, username_3, "stored username")
        
        Keychain().set(password_1, key: "password")
        XCTAssertEqual(Keychain().get("password").asString!, password_1, "stored password")
        XCTAssertEqual(Keychain(service: service_1).get("password").asString!, password_1, "stored password")
        XCTAssertNil(Keychain(service: service_2).get("password").asString, "not stored password")
        XCTAssertNil(Keychain(service: service_3).get("password").asString, "not stored password")
        
        Keychain(service: service_1).set(password_1, key: "password")
        XCTAssertEqual(Keychain().get("password").asString!, password_1, "stored password")
        XCTAssertEqual(Keychain(service: service_1).get("password").asString!, password_1, "stored password")
        XCTAssertNil(Keychain(service: service_2).get("password").asString, "not stored password")
        XCTAssertNil(Keychain(service: service_3).get("password").asString, "not stored password")
        
        Keychain(service: service_2).set(password_2, key: "password")
        XCTAssertEqual(Keychain().get("password").asString!, password_1, "stored password")
        XCTAssertEqual(Keychain(service: service_1).get("password").asString!, password_1, "stored password")
        XCTAssertEqual(Keychain(service: service_2).get("password").asString!, password_2, "stored password")
        XCTAssertNil(Keychain(service: service_3).get("password").asString, "not stored password")
        
        Keychain(service: service_3).set(password_3, key: "password")
        XCTAssertEqual(Keychain().get("password").asString!, password_1, "stored password")
        XCTAssertEqual(Keychain(service: service_1).get("password").asString!, password_1, "stored password")
        XCTAssertEqual(Keychain(service: service_2).get("password").asString!, password_2, "stored password")
        XCTAssertEqual(Keychain(service: service_3).get("password").asString!, password_3, "stored password")
        
        Keychain().remove("username")
        XCTAssertNil(Keychain().get("username").asString, "removed username")
        XCTAssertNil(Keychain(service: service_1).get("username").asString, "removed username")
        XCTAssertEqual(Keychain(service: service_2).get("username").asString!, username_2, "left username")
        XCTAssertEqual(Keychain(service: service_3).get("username").asString!, username_3, "left username")
        
        Keychain(service: service_1).remove("username")
        XCTAssertNil(Keychain().get("username").asString, "removed username")
        XCTAssertNil(Keychain(service: service_1).get("username").asString, "removed username")
        XCTAssertEqual(Keychain(service: service_2).get("username").asString!, username_2, "left username")
        XCTAssertEqual(Keychain(service: service_3).get("username").asString!, username_3, "left username")
        
        Keychain(service: service_2).remove("username")
        XCTAssertNil(Keychain().get("username").asString, "removed username")
        XCTAssertNil(Keychain(service: service_1).get("username").asString, "removed username")
        XCTAssertNil(Keychain(service: service_2).get("username").asString, "removed username")
        XCTAssertEqual(Keychain(service: service_3).get("username").asString!, username_3, "left username")
        
        Keychain(service: service_3).remove("username")
        XCTAssertNil(Keychain().get("username").asString, "removed username")
        XCTAssertNil(Keychain(service: service_1).get("username").asString, "removed username")
        XCTAssertNil(Keychain(service: service_2).get("username").asString, "removed username")
        XCTAssertNil(Keychain(service: service_3).get("username").asString, "removed username")
        
        Keychain().remove("password")
        XCTAssertNil(Keychain().get("password").asString, "removed password")
        XCTAssertNil(Keychain(service: service_1).get("password").asString, "removed password")
        XCTAssertEqual(Keychain(service: service_2).get("password").asString!, password_2, "left password")
        XCTAssertEqual(Keychain(service: service_3).get("password").asString!, password_3, "left password")
        
        Keychain(service: service_1).remove("password")
        XCTAssertNil(Keychain().get("password").asString, "removed password")
        XCTAssertNil(Keychain(service: service_1).get("password").asString, "removed password")
        XCTAssertEqual(Keychain(service: service_2).get("password").asString!, password_2, "left password")
        XCTAssertEqual(Keychain(service: service_3).get("password").asString!, password_3, "left password")
        
        Keychain(service: service_2).remove("password")
        XCTAssertNil(Keychain().get("password").asString, "removed password")
        XCTAssertNil(Keychain(service: service_1).get("password").asString, "removed password")
        XCTAssertNil(Keychain(service: service_2).get("password").asString, "removed password")
        XCTAssertEqual(Keychain(service: service_3).get("password").asString!, password_3, "left password")
        
        Keychain(service: service_3).remove("password")
        XCTAssertNil(Keychain().get("password").asString, "removed password")
        XCTAssertNil(Keychain(service: service_2).get("password").asString, "removed password")
        XCTAssertNil(Keychain(service: service_2).get("password").asString, "removed password")
        XCTAssertNil(Keychain(service: service_2).get("password").asString, "removed password")
    }
}
