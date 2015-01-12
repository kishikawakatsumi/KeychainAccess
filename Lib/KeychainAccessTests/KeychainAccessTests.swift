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
        
        Keychain(service: "Twitter", accessGroup: "12ABCD3E4F.shared").removeAll()
        Keychain(service: "Twitter").removeAll()
        
        Keychain(server: NSURL(string: "https://example.com")!, protocolType: .HTTPS).removeAll()
        
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
            let keychain = Keychain(service: "Twitter")
            
            keychain.set("kishikawa_katsumi", key: "username")
            keychain.set("password_1234", key: "password")
            
            let username = keychain.get("username")
            XCTAssertEqual(username!, "kishikawa_katsumi")
            
            let password = keychain.get("password")
            XCTAssertEqual(password!, "password_1234")
        }
        
        locally {
            // Update Keychain items
            let keychain = Keychain(service: "Twitter")
            
            keychain.set("katsumi_kishikawa", key: "username")
            keychain.set("1234_password", key: "password")
            
            let username = keychain.get("username")
            XCTAssertEqual(username!, "katsumi_kishikawa")
            
            let password = keychain.get("password")
            XCTAssertEqual(password!, "1234_password")
        }
        
        locally {
            // Remove Keychain items
            let keychain = Keychain(service: "Twitter")
            
            keychain.remove("username")
            keychain.remove("password")
            
            XCTAssertNil(keychain.get("username"))
            XCTAssertNil(keychain.get("password"))
        }
    }
    
    func testGenericPasswordSubscripting() {
        locally {
            // Add Keychain items
            let keychain = Keychain(service: "Twitter", accessGroup: "12ABCD3E4F.shared")
            
            keychain["username"] = "kishikawa_katsumi"
            keychain["password"] = "password_1234"
            
            let username = keychain["username"]
            XCTAssertEqual(username!, "kishikawa_katsumi")
            
            let password = keychain["password"]
            XCTAssertEqual(password!, "password_1234")
        }
        
        locally {
            // Update Keychain items
            let keychain = Keychain(service: "Twitter", accessGroup: "12ABCD3E4F.shared")
            
            keychain["username"] = "katsumi_kishikawa"
            keychain["password"] = "1234_password"
            
            let username = keychain["username"]
            XCTAssertEqual(username!, "katsumi_kishikawa")
            
            let password = keychain["password"]
            XCTAssertEqual(password!, "1234_password")
        }
        
        locally {
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
        locally {
            // Add Keychain items
            let keychain = Keychain(server: NSURL(string: "https://kishikawakatsumi.com")!, protocolType: .HTTPS)
            
            keychain.set("kishikawa_katsumi", key: "username")
            keychain.set("password_1234", key: "password")
            
            let username = keychain.get("username")
            XCTAssertEqual(username!, "kishikawa_katsumi")
            
            let password = keychain.get("password")
            XCTAssertEqual(password!, "password_1234")
        }
        
        locally {
            // Update Keychain items
            let keychain = Keychain(server: NSURL(string: "https://kishikawakatsumi.com")!, protocolType: .HTTPS)
            
            keychain.set("katsumi_kishikawa", key: "username")
            keychain.set("1234_password", key: "password")
            
            let username = keychain.get("username")
            XCTAssertEqual(username!, "katsumi_kishikawa")
            
            let password = keychain.get("password")
            XCTAssertEqual(password!, "1234_password")
        }
        
        locally {
            // Remove Keychain items
            let keychain = Keychain(server: NSURL(string: "https://kishikawakatsumi.com")!, protocolType: .HTTPS)
            
            keychain.remove("username")
            keychain.remove("password")
            
            XCTAssertNil(keychain.get("username"))
            XCTAssertNil(keychain.get("password"))
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
        
        XCTAssertFalse(keychain.contains("username"), "not stored username")
        XCTAssertFalse(keychain.contains("password"), "not stored password")
        
        keychain.set("kishikawakatsumi", key: "username")
        XCTAssertTrue(keychain.contains("username"), "stored username")
        XCTAssertFalse(keychain.contains("password"), "not stored password")
        
        keychain.set("password1234", key: "password")
        XCTAssertTrue(keychain.contains("username"), "stored username")
        XCTAssertTrue(keychain.contains("password"), "stored password")
    }
    
    // MARK:
    
    func testSetString() {
        let keychain = Keychain(service: "Twitter")
        
        XCTAssertNil(keychain.get("username"), "not stored username")
        XCTAssertNil(keychain.get("password"), "not stored password")
        
        keychain.set("kishikawakatsumi", key: "username")
        XCTAssertEqual(keychain.get("username")!, "kishikawakatsumi", "stored username")
        XCTAssertNil(keychain.get("password"), "not stored password")
        
        keychain.set("password1234", key: "password")
        XCTAssertEqual(keychain.get("username")!, "kishikawakatsumi", "stored username")
        XCTAssertEqual(keychain.get("password")!, "password1234", "stored password")
    }
    
    func testSetData() {
        let JSONObject = ["username": "kishikawakatsumi", "password": "password1234"]
        let JSONData = NSJSONSerialization.dataWithJSONObject(JSONObject, options: nil, error: nil)
        
        let keychain = Keychain(service: "Twitter")
        
        XCTAssertNil(keychain.getData("JSONData"), "not stored JSON data")
        
        keychain.set(JSONData!, key: "JSONData")
        XCTAssertEqual(keychain.getData("JSONData")!, JSONData!, "stored JSON data")
    }
    
    func testRemoveString() {
        let keychain = Keychain(service: "Twitter")
        
        XCTAssertNil(keychain.get("username"), "not stored username")
        XCTAssertNil(keychain.get("password"), "not stored password")
        
        keychain.set("kishikawakatsumi", key: "username")
        XCTAssertEqual(keychain.get("username")!, "kishikawakatsumi", "stored username")
        
        keychain.set("password1234", key: "password")
        XCTAssertEqual(keychain.get("password")!, "password1234", "stored password")
        
        keychain.remove("username")
        XCTAssertNil(keychain.get("username"), "removed username")
        XCTAssertEqual(keychain.get("password")!, "password1234", "left password")
        
        keychain.remove("password")
        XCTAssertNil(keychain.get("username"), "removed username")
        XCTAssertNil(keychain.get("password"), "removed password")
    }
    
    func testRemoveData() {
        let JSONObject = ["username": "kishikawakatsumi", "password": "password1234"]
        let JSONData = NSJSONSerialization.dataWithJSONObject(JSONObject, options: nil, error: nil)
        
        let keychain = Keychain(service: "Twitter")
        
        XCTAssertNil(keychain.getData("JSONData"), "not stored JSON data")
        
        keychain.set(JSONData!, key: "JSONData")
        XCTAssertEqual(keychain.getData("JSONData")!, JSONData!, "stored JSON data")
        
        keychain.remove("JSONData")
        XCTAssertNil(keychain.getData("JSONData"), "removed JSON data")
    }
    
    // MARK:
    
    func testSubscripting() {
        let keychain = Keychain(service: "Twitter")
        
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
        if let error = Keychain(service: "Twitter", accessGroup: "12ABCD3E4F.shared").removeAll() {
            XCTAssertNil(error, "no error occurred")
        }
        if let error = Keychain(service: "Twitter").removeAll() {
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
            let keychain = Keychain(service: "Twitter")
            
            if let error = keychain.set("kishikawa_katsumi", key: "username") {
                XCTAssertNil(error, "no error occurred")
            }
            if let error = keychain.set("password_1234", key: "password") {
                XCTAssertNil(error, "no error occurred")
            }
            
            let username = keychain.getStringOrError("username")
    
            switch username { // enum
            case .Success:
                XCTAssertEqual(username.value!, "kishikawa_katsumi")
            case .Failure:
                XCTFail("unknown error occurred")
            }
            
            if let error = username.error { // error object
                XCTFail("unknown error occurred")
            } else {
                XCTAssertEqual(username.value!, "kishikawa_katsumi")
            }
            
            if username.succeeded { // check succeeded property
                XCTAssertEqual(username.value!, "kishikawa_katsumi")
            } else {
                XCTFail("unknown error occurred")
            }
            
            if username.failed { // failed property
                XCTFail("unknown error occurred")
            } else {
                XCTAssertEqual(username.value!, "kishikawa_katsumi")
            }
    
            let password = keychain.getStringOrError("password")
            switch password { // enum
            case .Success:
                XCTAssertEqual(password.value!, "password_1234")
            case .Failure:
                XCTFail("unknown error occurred")
            }
            
            if let error = password.error { // error object
                XCTFail("unknown error occurred")
            } else {
                XCTAssertEqual(password.value!, "password_1234")
            }
            
            if password.succeeded { // check succeeded property
                XCTAssertEqual(password.value!, "password_1234")
            } else {
                XCTFail("unknown error occurred")
            }
            
            if password.failed { // failed property
                XCTFail("unknown error occurred")
            } else {
                XCTAssertEqual(password.value!, "password_1234")
            }
        }
        
        locally {
            // Update Keychain items
            let keychain = Keychain(service: "Twitter")
            
            if let error = keychain.set("katsumi_kishikawa", key: "username") {
                XCTAssertNil(error, "no error occurred")
            }
            if let error = keychain.set("1234_password", key: "password") {
                XCTAssertNil(error, "no error occurred")
            }
            
            let username = keychain.getStringOrError("username")
            switch username { // enum
            case .Success:
                XCTAssertEqual(username.value!, "katsumi_kishikawa")
            case .Failure:
                XCTFail("unknown error occurred")
            }
            
            if let error = username.error { // error object
                XCTFail("unknown error occurred")
            } else {
                XCTAssertEqual(username.value!, "katsumi_kishikawa")
            }
            
            if username.succeeded { // check succeeded property
                XCTAssertEqual(username.value!, "katsumi_kishikawa")
            } else {
                XCTFail("unknown error occurred")
            }
            
            if username.failed { // failed property
                XCTFail("unknown error occurred")
            } else {
                XCTAssertEqual(username.value!, "katsumi_kishikawa")
            }
            
            let password = keychain.getStringOrError("password")
            switch password { // enum
            case .Success:
                XCTAssertEqual(password.value!, "1234_password")
            case .Failure:
                XCTFail("unknown error occurred")
            }
            
            if let error = password.error { // check error object
                XCTFail("unknown error occurred")
            } else {
                XCTAssertEqual(password.value!, "1234_password")
            }
            
            if password.succeeded { // check succeeded property
                XCTAssertEqual(password.value!, "1234_password")
            } else {
                XCTFail("unknown error occurred")
            }
            
            if password.failed { // check failed property
                XCTFail("unknown error occurred")
            } else {
                XCTAssertEqual(password.value!, "1234_password")
            }
        }
        
        locally {
            // Remove Keychain items
            let keychain = Keychain(service: "Twitter")
            
            if let error = keychain.remove("username") {
                XCTAssertNil(error, "no error occurred")
            }
            if let error = keychain.remove("password") {
                XCTAssertNil(error, "no error occurred")
            }
            
            XCTAssertNil(keychain.get("username"))
            XCTAssertNil(keychain.get("password"))
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
        
        Keychain().removeAll()
        Keychain(service: service_1).removeAll()
        Keychain(service: service_2).removeAll()
        Keychain(service: service_3).removeAll()
        
        XCTAssertNil(Keychain().get("username"), "not stored username")
        XCTAssertNil(Keychain().get("password"), "not stored password")
        XCTAssertNil(Keychain(service: service_1).get("username"), "not stored username")
        XCTAssertNil(Keychain(service: service_1).get("password"), "not stored password")
        XCTAssertNil(Keychain(service: service_2).get("username"), "not stored username")
        XCTAssertNil(Keychain(service: service_2).get("password"), "not stored password")
        XCTAssertNil(Keychain(service: service_3).get("username"), "not stored username")
        XCTAssertNil(Keychain(service: service_3).get("password"), "not stored password")
        
        Keychain().set(username_1, key: "username")
        XCTAssertEqual(Keychain().get("username")!, username_1, "stored username")
        XCTAssertEqual(Keychain(service: service_1).get("username")!, username_1, "stored username")
        XCTAssertNil(Keychain(service: service_2).get("username"), "not stored username")
        XCTAssertNil(Keychain(service: service_3).get("username"), "not stored username")
        
        Keychain(service: service_1).set(username_1, key: "username")
        XCTAssertEqual(Keychain().get("username")!, username_1, "stored username")
        XCTAssertEqual(Keychain(service: service_1).get("username")!, username_1, "stored username")
        XCTAssertNil(Keychain(service: service_2).get("username"), "not stored username")
        XCTAssertNil(Keychain(service: service_3).get("username"), "not stored username")
        
        Keychain(service: service_2).set(username_2, key: "username")
        XCTAssertEqual(Keychain().get("username")!, username_1, "stored username")
        XCTAssertEqual(Keychain(service: service_1).get("username")!, username_1, "stored username")
        XCTAssertEqual(Keychain(service: service_2).get("username")!, username_2, "stored username")
        XCTAssertNil(Keychain(service: service_3).get("username"), "not stored username")
        
        Keychain(service: service_3).set(username_3, key: "username")
        XCTAssertEqual(Keychain().get("username")!, username_1, "stored username")
        XCTAssertEqual(Keychain(service: service_1).get("username")!, username_1, "stored username")
        XCTAssertEqual(Keychain(service: service_2).get("username")!, username_2, "stored username")
        XCTAssertEqual(Keychain(service: service_3).get("username")!, username_3, "stored username")
        
        Keychain().set(password_1, key: "password")
        XCTAssertEqual(Keychain().get("password")!, password_1, "stored password")
        XCTAssertEqual(Keychain(service: service_1).get("password")!, password_1, "stored password")
        XCTAssertNil(Keychain(service: service_2).get("password"), "not stored password")
        XCTAssertNil(Keychain(service: service_3).get("password"), "not stored password")
        
        Keychain(service: service_1).set(password_1, key: "password")
        XCTAssertEqual(Keychain().get("password")!, password_1, "stored password")
        XCTAssertEqual(Keychain(service: service_1).get("password")!, password_1, "stored password")
        XCTAssertNil(Keychain(service: service_2).get("password"), "not stored password")
        XCTAssertNil(Keychain(service: service_3).get("password"), "not stored password")
        
        Keychain(service: service_2).set(password_2, key: "password")
        XCTAssertEqual(Keychain().get("password")!, password_1, "stored password")
        XCTAssertEqual(Keychain(service: service_1).get("password")!, password_1, "stored password")
        XCTAssertEqual(Keychain(service: service_2).get("password")!, password_2, "stored password")
        XCTAssertNil(Keychain(service: service_3).get("password"), "not stored password")
        
        Keychain(service: service_3).set(password_3, key: "password")
        XCTAssertEqual(Keychain().get("password")!, password_1, "stored password")
        XCTAssertEqual(Keychain(service: service_1).get("password")!, password_1, "stored password")
        XCTAssertEqual(Keychain(service: service_2).get("password")!, password_2, "stored password")
        XCTAssertEqual(Keychain(service: service_3).get("password")!, password_3, "stored password")
        
        Keychain().remove("username")
        XCTAssertNil(Keychain().get("username"), "removed username")
        XCTAssertNil(Keychain(service: service_1).get("username"), "removed username")
        XCTAssertEqual(Keychain(service: service_2).get("username")!, username_2, "left username")
        XCTAssertEqual(Keychain(service: service_3).get("username")!, username_3, "left username")
        
        Keychain(service: service_1).remove("username")
        XCTAssertNil(Keychain().get("username"), "removed username")
        XCTAssertNil(Keychain(service: service_1).get("username"), "removed username")
        XCTAssertEqual(Keychain(service: service_2).get("username")!, username_2, "left username")
        XCTAssertEqual(Keychain(service: service_3).get("username")!, username_3, "left username")
        
        Keychain(service: service_2).remove("username")
        XCTAssertNil(Keychain().get("username"), "removed username")
        XCTAssertNil(Keychain(service: service_1).get("username"), "removed username")
        XCTAssertNil(Keychain(service: service_2).get("username"), "removed username")
        XCTAssertEqual(Keychain(service: service_3).get("username")!, username_3, "left username")
        
        Keychain(service: service_3).remove("username")
        XCTAssertNil(Keychain().get("username"), "removed username")
        XCTAssertNil(Keychain(service: service_1).get("username"), "removed username")
        XCTAssertNil(Keychain(service: service_2).get("username"), "removed username")
        XCTAssertNil(Keychain(service: service_3).get("username"), "removed username")
        
        Keychain().remove("password")
        XCTAssertNil(Keychain().get("password"), "removed password")
        XCTAssertNil(Keychain(service: service_1).get("password"), "removed password")
        XCTAssertEqual(Keychain(service: service_2).get("password")!, password_2, "left password")
        XCTAssertEqual(Keychain(service: service_3).get("password")!, password_3, "left password")
        
        Keychain(service: service_1).remove("password")
        XCTAssertNil(Keychain().get("password"), "removed password")
        XCTAssertNil(Keychain(service: service_1).get("password"), "removed password")
        XCTAssertEqual(Keychain(service: service_2).get("password")!, password_2, "left password")
        XCTAssertEqual(Keychain(service: service_3).get("password")!, password_3, "left password")
        
        Keychain(service: service_2).remove("password")
        XCTAssertNil(Keychain().get("password"), "removed password")
        XCTAssertNil(Keychain(service: service_1).get("password"), "removed password")
        XCTAssertNil(Keychain(service: service_2).get("password"), "removed password")
        XCTAssertEqual(Keychain(service: service_3).get("password")!, password_3, "left password")
        
        Keychain(service: service_3).remove("password")
        XCTAssertNil(Keychain().get("password"), "removed password")
        XCTAssertNil(Keychain(service: service_2).get("password"), "removed password")
        XCTAssertNil(Keychain(service: service_2).get("password"), "removed password")
        XCTAssertNil(Keychain(service: service_2).get("password"), "removed password")
    }
}
