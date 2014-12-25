//
//  KeychainAccessTests.swift
//  KeychainAccessTests
//
//  Created by kishikawa katsumi on 2014/12/24.
//  Copyright (c) 2014 kishikawa katsumi. All rights reserved.
//

import UIKit
import XCTest

import KeychainAccess

class KeychainAccessTests: XCTestCase {
    
    let service = "com.kishikawakatsumi.KeychainAccess"
    let accessGroup = "com.kishikawakatsumi"
    
    let usernameKey = "username"
    let passwordKey = "password"
    
    let username = "kishikawakatsumi"
    let password = "password1234"
    
    override func setUp() {
        super.setUp()
        
        Keychain.removeAll()
        Keychain.removeAll(service: service)
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    // MARK:
    
    func testBasicUsage1() {
        Keychain.set("kishikawakatsumi", key: "username")
        Keychain.set("password1234", key: "password")
        
        let username = Keychain.get("username")
        XCTAssertEqual(username!, "kishikawakatsumi")
        
        let password = Keychain.get("password")
        XCTAssertEqual(password!, "password1234")
        
        Keychain.remove("username")
        Keychain.remove("password")
        
        XCTAssertNil(Keychain.get("username"))
        XCTAssertNil(Keychain.get("password"))
    }
    
    func testBasicUsage2() {
        let keychain = Keychain(service: "com.kishikawakatsumi.KeychainAccess", accessGroup: "com.kishikawakatsumi")
        
        keychain["username"] = "kishikawakatsumi"
        keychain["password"] = "password1234"
        
        let username = keychain["username"]
        
        XCTAssertEqual(username!, "kishikawakatsumi")
        XCTAssertNil(Keychain.get("username"))
        XCTAssertEqual(Keychain.get("username", service: "com.kishikawakatsumi.KeychainAccess", accessGroup: "com.kishikawakatsumi")!, "kishikawakatsumi")
        
        let password = keychain["password"]
        
        XCTAssertEqual(password!, "password1234")
        XCTAssertNil(Keychain.get("password"))
        XCTAssertEqual(Keychain.get("password", service: "com.kishikawakatsumi.KeychainAccess", accessGroup: "com.kishikawakatsumi")!, "password1234")
        
        keychain["username"] = nil
        keychain["password"] = nil
        
        XCTAssertNil(keychain["username"])
        XCTAssertNil(keychain["password"])
        XCTAssertNil(Keychain.get("username", service: "com.kishikawakatsumi.KeychainAccess", accessGroup: "com.kishikawakatsumi"))
        XCTAssertNil(Keychain.get("password", service: "com.kishikawakatsumi.KeychainAccess", accessGroup: "com.kishikawakatsumi"))
    }
    
    func testBasicUsage3() {
        let keychain = Keychain(service: "com.kishikawakatsumi.KeychainAccess")
        
        keychain.set("kishikawakatsumi", key: "username")
        keychain.set("password1234", key: "password")
        
        let username = keychain.get("username")
        
        XCTAssertEqual(username!, "kishikawakatsumi")
        XCTAssertNil(Keychain.get("username"))
        XCTAssertEqual(Keychain.get("username", service: "com.kishikawakatsumi.KeychainAccess")!, "kishikawakatsumi")
        
        let password = keychain.get("password")
        
        XCTAssertEqual(password!, "password1234")
        XCTAssertNil(Keychain.get("password"))
        XCTAssertEqual(Keychain.get("password", service: "com.kishikawakatsumi.KeychainAccess")!, "password1234")
        
        keychain.remove("username")
        keychain.remove("password")
        
        XCTAssertNil(keychain.get("username"))
        XCTAssertNil(keychain.get("password"))
        XCTAssertNil(Keychain.get("username", service: "com.kishikawakatsumi.KeychainAccess"))
        XCTAssertNil(Keychain.get("password", service: "com.kishikawakatsumi.KeychainAccess"))
    }
    
    // MARK:
    
    func testDefaultInitializer() {
        let keychain = Keychain()
        XCTAssertEqual(keychain.service, "")
        XCTAssertNil(keychain.accessGroup)
    }
    
    func testInitializerWithService() {
        let keychain = Keychain(service: service)
        XCTAssertEqual(keychain.service, service)
        XCTAssertNil(keychain.accessGroup)
    }
    
    func testInitializerWithServiceAndAccessGroup() {
        let keychain = Keychain(service: service, accessGroup: accessGroup)
        XCTAssertEqual(keychain.service, service)
        XCTAssertEqual(keychain.accessGroup!, accessGroup)
    }
    
    // MARK:
    
    func testClassMethodSetString() {
        XCTAssertNil(Keychain.get(usernameKey), "not stored username")
        XCTAssertNil(Keychain.get(passwordKey), "not stored password")
        
        Keychain.set(username, key: usernameKey)
        XCTAssertEqual(Keychain.get(usernameKey)!, username, "stored username")
        XCTAssertNil(Keychain.get(passwordKey), "not stored password")
        
        Keychain.set(password, key: passwordKey)
        XCTAssertEqual(Keychain.get(usernameKey)!, username, "stored username")
        XCTAssertEqual(Keychain.get(passwordKey)!, password, "stored password")
    }
    
    func testClassMethodSetData() {
        let usernameData = username.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!
        let passwordData = password.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!
        
        XCTAssertNil(Keychain.getAsData(usernameKey), "not stored username")
        XCTAssertNil(Keychain.getAsData(passwordKey), "not stored password")
        
        Keychain.set(usernameData, key: usernameKey)
        XCTAssertEqual(Keychain.getAsData(usernameKey)!, usernameData, "stored username")
        XCTAssertNil(Keychain.getAsData(passwordKey), "not stored password")
        
        Keychain.set(passwordData, key: passwordKey)
        XCTAssertEqual(Keychain.getAsData(usernameKey)!, usernameData, "stored username")
        XCTAssertEqual(Keychain.getAsData(passwordKey)!, passwordData, "stored password")
    }
    
    func testClassMethodRemoveString() {
        XCTAssertNil(Keychain.get(usernameKey), "not stored username")
        XCTAssertNil(Keychain.get(passwordKey), "not stored password")
        
        Keychain.set(username, key: usernameKey)
        XCTAssertEqual(Keychain.get(usernameKey)!, username, "stored username")
        
        Keychain.set(password, key: passwordKey)
        XCTAssertEqual(Keychain.get(passwordKey)!, password, "stored password")
        
        Keychain.remove(usernameKey)
        XCTAssertNil(Keychain.getAsData(usernameKey), "removed username")
        XCTAssertEqual(Keychain.get(passwordKey)!, password, "left password")
        
        Keychain.remove(passwordKey)
        XCTAssertNil(Keychain.get(usernameKey), "removed username")
        XCTAssertNil(Keychain.get(passwordKey), "removed password")
    }
    
    func testClassMethodRemoveData() {
        let usernameData = username.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!
        let passwordData = password.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!
        
        XCTAssertNil(Keychain.getAsData(usernameKey), "not stored username")
        XCTAssertNil(Keychain.getAsData(passwordKey), "not stored password")
        
        Keychain.set(usernameData, key: usernameKey)
        XCTAssertEqual(Keychain.getAsData(usernameKey)!, usernameData, "stored username")
        
        Keychain.set(passwordData, key: passwordKey)
        XCTAssertEqual(Keychain.getAsData(passwordKey)!, passwordData, "stored password")
        
        Keychain.remove(usernameKey)
        XCTAssertNil(Keychain.getAsData(usernameKey), "removed username")
        XCTAssertEqual(Keychain.getAsData(passwordKey)!, passwordData, "left password")
        
        Keychain.remove(passwordKey)
        XCTAssertNil(Keychain.getAsData(usernameKey), "removed username")
        XCTAssertNil(Keychain.getAsData(passwordKey), "removed password")
    }
    
    func testClassMethodRemoveStringBySettingNilValue() {
        XCTAssertNil(Keychain.get(usernameKey), "not stored username")
        XCTAssertNil(Keychain.get(passwordKey), "not stored password")
        
        Keychain.set(username, key: usernameKey)
        XCTAssertEqual(Keychain.get(usernameKey)!, username, "stored username")
        
        Keychain.set(password, key: passwordKey)
        XCTAssertEqual(Keychain.get(passwordKey)!, password, "stored password")
        
        Keychain.set(nil as String?, key: usernameKey)
        XCTAssertNil(Keychain.get(usernameKey), "removed username")
        XCTAssertEqual(Keychain.get(passwordKey)!, password, "left password")
        
        Keychain.set(nil as String?, key: passwordKey)
        XCTAssertNil(Keychain.get(usernameKey), "removed username")
        XCTAssertNil(Keychain.get(passwordKey), "removed password")
    }
    
    func testClassMethodRemoveDataBySettingNilValue() {
        let usernameData = username.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!
        let passwordData = password.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!
        
        XCTAssertNil(Keychain.getAsData(usernameKey), "not stored username")
        XCTAssertNil(Keychain.getAsData(passwordKey), "not stored password")
        
        Keychain.set(usernameData, key: usernameKey)
        XCTAssertEqual(Keychain.getAsData(usernameKey)!, usernameData, "stored username")
        
        Keychain.set(passwordData, key: passwordKey)
        XCTAssertEqual(Keychain.getAsData(passwordKey)!, passwordData, "stored password")
        
        Keychain.set(nil as NSData?, key: usernameKey)
        XCTAssertNil(Keychain.getAsData(usernameKey), "removed username")
        XCTAssertEqual(Keychain.getAsData(passwordKey)!, passwordData, "left password")
        
        Keychain.set(nil as NSData?, key: passwordKey)
        XCTAssertNil(Keychain.getAsData(usernameKey), "removed username")
        XCTAssertNil(Keychain.getAsData(passwordKey), "removed password")
    }
    
    // MARK:
    
    func testNoErrorOccurred() {
        Keychain.removeAll() { error in XCTAssertNil(error, "no error occurred") }
        Keychain.removeAll(service: service) { error in XCTAssertNil(error, "no error occurred") }
        
        XCTAssertNil(Keychain.get(usernameKey) { error in XCTAssertNil(error, "no error occurred") }, "not stored username")
        XCTAssertNil(Keychain.get(passwordKey) { error in XCTAssertNil(error, "no error occurred") }, "not stored password")
        
        Keychain.set(username, key: usernameKey) { error in XCTAssertNil(error, "no error occurred") }
        XCTAssertEqual(Keychain.get(usernameKey) { error in XCTAssertNil(error, "no error occurred") }!, username, "stored username")
        XCTAssertNil(Keychain.get(passwordKey) { error in XCTAssertNil(error, "no error occurred") }, "not stored password")
        
        Keychain.set(password, key: passwordKey) { error in XCTAssertNil(error, "no error occurred") }
        XCTAssertEqual(Keychain.get(usernameKey) { error in XCTAssertNil(error, "no error occurred") }!, username, "stored username")
        XCTAssertEqual(Keychain.get(passwordKey) { error in XCTAssertNil(error, "no error occurred") }!, password, "stored password")
    }
    
    // MARK:
    
    func testClassMethodSetStringWithCustomService() {
        let username_1 = "kishikawakatsumi"
        let password_1 = "password1234"
        let username_2 = "kishikawa_katsumi"
        let password_2 = "password_1234"
        let username_3 = "k_katsumi"
        let password_3 = "12341234"
        
        let service_1 = ""
        let service_2 = "com.kishikawakatsumi.KeychainAccess"
        let service_3 = "example.com"
        
        Keychain.removeAll(service: service_1)
        Keychain.removeAll(service: service_2)
        Keychain.removeAll(service: service_3)
        
        XCTAssertNil(Keychain.get(usernameKey), "not stored username")
        XCTAssertNil(Keychain.get(passwordKey), "not stored password")
        XCTAssertNil(Keychain.get(usernameKey, service: service_1), "not stored username")
        XCTAssertNil(Keychain.get(passwordKey, service: service_1), "not stored password")
        XCTAssertNil(Keychain.get(usernameKey, service: service_2), "not stored username")
        XCTAssertNil(Keychain.get(passwordKey, service: service_2), "not stored password")
        XCTAssertNil(Keychain.get(usernameKey, service: service_3), "not stored username")
        XCTAssertNil(Keychain.get(passwordKey, service: service_3), "not stored password")
        
        Keychain.set(username_1, key: usernameKey)
        XCTAssertEqual(Keychain.get(usernameKey)!, username_1, "stored username")
        XCTAssertEqual(Keychain.get(usernameKey, service: service_1)!, username_1, "stored username")
        XCTAssertNil(Keychain.get(usernameKey, service: service_2), "not stored username")
        XCTAssertNil(Keychain.get(usernameKey, service: service_3), "not stored username")
        
        Keychain.set(username_1, key: usernameKey, service: service_1)
        XCTAssertEqual(Keychain.get(usernameKey)!, username_1, "stored username")
        XCTAssertEqual(Keychain.get(usernameKey, service: service_1)!, username_1, "stored username")
        XCTAssertNil(Keychain.get(usernameKey, service: service_2), "not stored username")
        XCTAssertNil(Keychain.get(usernameKey, service: service_3), "not stored username")
        
        Keychain.set(username_2, key: usernameKey, service: service_2)
        XCTAssertEqual(Keychain.get(usernameKey)!, username_1, "stored username")
        XCTAssertEqual(Keychain.get(usernameKey, service: service_1)!, username_1, "stored username")
        XCTAssertEqual(Keychain.get(usernameKey, service: service_2)!, username_2, "stored username")
        XCTAssertNil(Keychain.get(usernameKey, service: service_3), "not stored username")
        
        Keychain.set(username_3, key: usernameKey, service: service_3)
        XCTAssertEqual(Keychain.get(usernameKey)!, username_1, "stored username")
        XCTAssertEqual(Keychain.get(usernameKey, service: service_1)!, username_1, "stored username")
        XCTAssertEqual(Keychain.get(usernameKey, service: service_2)!, username_2, "stored username")
        XCTAssertEqual(Keychain.get(usernameKey, service: service_3)!, username_3, "stored username")
        
        Keychain.set(password_1, key: passwordKey)
        XCTAssertEqual(Keychain.get(passwordKey)!, password_1, "stored password")
        XCTAssertEqual(Keychain.get(passwordKey, service: service_1)!, password_1, "stored password")
        XCTAssertNil(Keychain.get(passwordKey, service: service_2), "not stored password")
        XCTAssertNil(Keychain.get(passwordKey, service: service_3), "not stored password")
        
        Keychain.set(password_1, key: passwordKey, service: service_1)
        XCTAssertEqual(Keychain.get(passwordKey)!, password_1, "stored password")
        XCTAssertEqual(Keychain.get(passwordKey, service: service_1)!, password_1, "stored password")
        XCTAssertNil(Keychain.get(passwordKey, service: service_2), "not stored password")
        XCTAssertNil(Keychain.get(passwordKey, service: service_3), "not stored password")
        
        Keychain.set(password_2, key: passwordKey, service: service_2)
        XCTAssertEqual(Keychain.get(passwordKey)!, password_1, "stored password")
        XCTAssertEqual(Keychain.get(passwordKey, service: service_1)!, password_1, "stored password")
        XCTAssertEqual(Keychain.get(passwordKey, service: service_2)!, password_2, "stored password")
        XCTAssertNil(Keychain.get(passwordKey, service: service_3), "not stored password")
        
        Keychain.set(password_3, key: passwordKey, service: service_3)
        XCTAssertEqual(Keychain.get(passwordKey)!, password_1, "stored password")
        XCTAssertEqual(Keychain.get(passwordKey, service: service_1)!, password_1, "stored password")
        XCTAssertEqual(Keychain.get(passwordKey, service: service_2)!, password_2, "stored password")
        XCTAssertEqual(Keychain.get(passwordKey, service: service_3)!, password_3, "stored password")
        
        Keychain.remove(usernameKey)
        XCTAssertNil(Keychain.get(usernameKey), "removed username")
        XCTAssertNil(Keychain.get(usernameKey, service: service_1), "removed username")
        XCTAssertEqual(Keychain.get(usernameKey, service: service_2)!, username_2, "left username")
        XCTAssertEqual(Keychain.get(usernameKey, service: service_3)!, username_3, "left username")
        
        Keychain.remove(usernameKey, service: service_1)
        XCTAssertNil(Keychain.get(usernameKey), "removed username")
        XCTAssertNil(Keychain.get(usernameKey, service: service_1), "removed username")
        XCTAssertEqual(Keychain.get(usernameKey, service: service_2)!, username_2, "left username")
        XCTAssertEqual(Keychain.get(usernameKey, service: service_3)!, username_3, "left username")
        
        Keychain.remove(usernameKey, service: service_2)
        XCTAssertNil(Keychain.get(usernameKey), "removed username")
        XCTAssertNil(Keychain.get(usernameKey, service: service_1), "removed username")
        XCTAssertNil(Keychain.get(usernameKey, service: service_2), "removed username")
        XCTAssertEqual(Keychain.get(usernameKey, service: service_3)!, username_3, "left username")
        
        Keychain.remove(usernameKey, service: service_3)
        XCTAssertNil(Keychain.get(usernameKey), "removed username")
        XCTAssertNil(Keychain.get(usernameKey, service: service_1), "removed username")
        XCTAssertNil(Keychain.get(usernameKey, service: service_2), "removed username")
        XCTAssertNil(Keychain.get(usernameKey, service: service_3), "removed username")
        
        Keychain.remove(passwordKey)
        XCTAssertNil(Keychain.get(passwordKey), "removed password")
        XCTAssertNil(Keychain.get(passwordKey, service: service_1), "removed password")
        XCTAssertEqual(Keychain.get(passwordKey, service: service_2)!, password_2, "left password")
        XCTAssertEqual(Keychain.get(passwordKey, service: service_3)!, password_3, "left password")
        
        Keychain.remove(passwordKey, service: service_1)
        XCTAssertNil(Keychain.get(passwordKey), "removed password")
        XCTAssertNil(Keychain.get(passwordKey, service: service_1), "removed password")
        XCTAssertEqual(Keychain.get(passwordKey, service: service_2)!, password_2, "left password")
        XCTAssertEqual(Keychain.get(passwordKey, service: service_3)!, password_3, "left password")
        
        Keychain.remove(passwordKey, service: service_2)
        XCTAssertNil(Keychain.get(passwordKey), "removed password")
        XCTAssertNil(Keychain.get(passwordKey, service: service_1), "removed password")
        XCTAssertNil(Keychain.get(passwordKey, service: service_2), "removed password")
        XCTAssertEqual(Keychain.get(passwordKey, service: service_3)!, password_3, "left password")
        
        Keychain.remove(passwordKey, service: service_3)
        XCTAssertNil(Keychain.get(passwordKey), "removed password")
        XCTAssertNil(Keychain.get(passwordKey, service: service_1), "removed password")
        XCTAssertNil(Keychain.get(passwordKey, service: service_2), "removed password")
        XCTAssertNil(Keychain.get(passwordKey, service: service_3), "removed password")
    }
    
    // MARK:
    
    func testInstanceMethodSetString() {
        let keychain = Keychain()
        
        XCTAssertNil(keychain.get(usernameKey), "not stored username")
        XCTAssertNil(keychain.get(passwordKey), "not stored password")
        
        keychain.set(username, key: usernameKey)
        XCTAssertEqual(keychain.get(usernameKey)!, username, "stored username")
        XCTAssertNil(keychain.get(passwordKey), "not stored password")
        
        keychain.set(password, key: passwordKey)
        XCTAssertEqual(keychain.get(usernameKey)!, username, "stored username")
        XCTAssertEqual(keychain.get(passwordKey)!, password, "stored password")
    }
    
    func testInstanceMethodSetData() {
        let usernameData = username.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!
        let passwordData = password.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!
        
        let keychain = Keychain()
        
        XCTAssertNil(keychain.getAsData(usernameKey), "not stored username")
        XCTAssertNil(keychain.getAsData(passwordKey), "not stored password")
        
        keychain.set(usernameData, key: usernameKey)
        XCTAssertEqual(keychain.getAsData(usernameKey)!, usernameData, "stored username")
        XCTAssertNil(keychain.getAsData(passwordKey), "not stored password")
        
        keychain.set(passwordData, key: passwordKey)
        XCTAssertEqual(keychain.getAsData(usernameKey)!, usernameData, "stored username")
        XCTAssertEqual(keychain.getAsData(passwordKey)!, passwordData, "stored password")
    }
    
    func testInstanceMethodRemoveString() {
        let keychain = Keychain()
        
        XCTAssertNil(keychain.get(usernameKey), "not stored username")
        XCTAssertNil(keychain.get(passwordKey), "not stored password")
        
        keychain.set(username, key: usernameKey)
        XCTAssertEqual(keychain.get(usernameKey)!, username, "stored username")
        
        keychain.set(password, key: passwordKey)
        XCTAssertEqual(keychain.get(passwordKey)!, password, "stored password")
        
        keychain.remove(usernameKey)
        XCTAssertNil(keychain.get(usernameKey), "removed username")
        XCTAssertEqual(keychain.get(passwordKey)!, password, "left password")
        
        keychain.remove(passwordKey)
        XCTAssertNil(keychain.get(usernameKey), "removed username")
        XCTAssertNil(keychain.get(passwordKey), "removed password")
    }
    
    func testInstanceMethodRemoveData() {
        let usernameData = username.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!
        let passwordData = password.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!
        
        let keychain = Keychain()
        
        XCTAssertNil(keychain.getAsData(usernameKey), "not stored username")
        XCTAssertNil(keychain.getAsData(passwordKey), "not stored password")
        
        keychain.set(usernameData, key: usernameKey)
        XCTAssertEqual(keychain.getAsData(usernameKey)!, usernameData, "stored username")
        
        keychain.set(passwordData, key: passwordKey)
        XCTAssertEqual(keychain.getAsData(passwordKey)!, passwordData, "stored password")
        
        keychain.remove(usernameKey)
        XCTAssertNil(keychain.getAsData(usernameKey), "removed username")
        XCTAssertEqual(keychain.getAsData(passwordKey)!, passwordData, "left password")
        
        keychain.remove(passwordKey)
        XCTAssertNil(keychain.getAsData(usernameKey), "removed username")
        XCTAssertNil(keychain.getAsData(passwordKey), "removed password")
    }
    
    func testInstanceMethodRemoveStringBySettingNilValue() {
        let keychain = Keychain()
        
        XCTAssertNil(keychain.get(usernameKey), "not stored username")
        XCTAssertNil(keychain.get(passwordKey), "not stored password")
        
        keychain.set(username, key: usernameKey)
        XCTAssertEqual(keychain.get(usernameKey)!, username, "stored username")
        
        keychain.set(password, key: passwordKey)
        XCTAssertEqual(keychain.get(passwordKey)!, password, "stored password")
        
        keychain.set(nil as String?, key: usernameKey)
        XCTAssertNil(keychain.get(usernameKey), "removed username")
        XCTAssertEqual(keychain.get(passwordKey)!, password, "left password")
        
        keychain.set(nil as String?, key: passwordKey)
        XCTAssertNil(keychain.get(usernameKey), "removed username")
        XCTAssertNil(keychain.get(passwordKey), "removed password")
    }
    
    func testInstanceMethodRemoveDataBySettingNilValue() {
        let usernameData = username.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!
        let passwordData = password.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!
        
        let keychain = Keychain()
        
        XCTAssertNil(keychain.get(usernameKey), "not stored username")
        XCTAssertNil(keychain.get(passwordKey), "not stored password")
        
        keychain.set(usernameData, key: usernameKey)
        XCTAssertEqual(keychain.getAsData(usernameKey)!, usernameData, "stored username")
        
        keychain.set(passwordData, key: passwordKey)
        XCTAssertEqual(keychain.getAsData(passwordKey)!, passwordData, "stored password")
        
        keychain.set(nil as NSData?, key: usernameKey)
        XCTAssertNil(keychain.getAsData(usernameKey), "removed username")
        XCTAssertEqual(keychain.getAsData(passwordKey)!, passwordData, "left password")
        
        keychain.set(nil as NSData?, key: passwordKey)
        XCTAssertNil(keychain.getAsData(usernameKey), "removed username")
        XCTAssertNil(keychain.getAsData(passwordKey), "removed password")
    }
    
    // MARK:
    
    func testSubscripting() {
        let keychain = Keychain()
        
        XCTAssertNil(keychain[usernameKey], "not stored username")
        XCTAssertNil(keychain[passwordKey], "not stored password")
        
        keychain[usernameKey] = username
        XCTAssertEqual(keychain[usernameKey]!, username, "stored username")
        
        keychain[passwordKey] = password
        XCTAssertEqual(keychain[passwordKey]!, password, "stored password")
        
        keychain[usernameKey] = nil
        XCTAssertNil(keychain[usernameKey], "removed username")
        XCTAssertEqual(keychain[passwordKey]!, password, "left password")
        
        keychain[passwordKey] = nil
        XCTAssertNil(keychain[usernameKey], "removed username")
        XCTAssertNil(keychain[passwordKey], "removed password")
    }
    
}
