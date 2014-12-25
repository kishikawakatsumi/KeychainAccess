//
//  Keychain.swift
//  KeychainAccess
//
//  Created by kishikawa katsumi on 2014/12/24.
//  Copyright (c) 2014 kishikawa katsumi. All rights reserved.
//

import Foundation
import Security

public class Keychain {
    
    public let service: String
    public let accessGroup: String?
    public let accessibility: Accessibility
    public let synchronizable: Bool
    
    // MARK:
    
    public init(service: String = "", accessibility: Accessibility = .AfterFirstUnlock, synchronizable: Bool = false) {
        self.service = service
        self.accessibility = accessibility
        self.synchronizable = synchronizable
    }
    
    public init(service: String, accessGroup: String, accessibility: Accessibility = .AfterFirstUnlock, synchronizable: Bool = false) {
        self.service = service
        self.accessGroup = accessGroup
        self.accessibility = accessibility
        self.synchronizable = synchronizable
    }
    
    // MARK:
    
    public class func contains(key: String, service: String = "", accessGroup: String? = nil, failure: ((NSError) -> ())? = nil) -> Bool {
        var query = [String: String]()
        query[kSecClass] = kSecClassGenericPassword
        query[kSecAttrSynchronizable] = kSecAttrSynchronizableAny
        query[kSecAttrService] = service
        query[kSecAttrAccount] = key
        #if (!arch(i386) && !arch(x86_64)) || !os(iOS)
        if accessGroup != nil {
            query[kSecAttrAccessGroup] = accessGroup
        }
        #endif
        
        var status = SecItemCopyMatching(query, nil)
        
        switch status {
        case errSecSuccess:
            return true
        case errSecItemNotFound:
            return false
        default:
            failure?(error(status: status))
            return false
        }
    }
    
    public class func allItems(service:String? = nil, accessGroup: String? = nil, failure: ((NSError) -> ())? = nil) -> [[String: AnyObject]]? {
        var query = [String: AnyObject]()
        query[kSecClass] = kSecClassGenericPassword
        query[kSecAttrSynchronizable] = kSecAttrSynchronizableAny
        query[kSecMatchLimit] = kSecMatchLimitAll
        query[kSecReturnAttributes] = kCFBooleanTrue
        query[kSecReturnData] = kCFBooleanTrue
        if service != nil {
            query[kSecAttrService] = service
        }
        #if (!arch(i386) && !arch(x86_64)) || !os(iOS)
        if accessGroup != nil {
            query[kSecAttrAccessGroup] = accessGroup
        }
        #endif
        
        var result: AnyObject?
        var status = withUnsafeMutablePointer(&result) { pointer in
            SecItemCopyMatching(query, UnsafeMutablePointer(pointer))
        }
        
        switch status {
        case errSecSuccess:
            if let attributes = result as [[String: AnyObject]]? {
                let items = map(attributes) { attribute -> [String: AnyObject] in
                    var item = [String: AnyObject]()
                    
                    let key = attribute[kSecAttrAccount] as String
                    item["key"] = key
                    
                    let value = attribute[kSecValueData] as NSData
                    if let text = NSString(data: value, encoding: NSUTF8StringEncoding) {
                        item["value"] = text
                    } else  {
                        item["value"] = value
                    }
                    
                    item["service"] = attribute[kSecAttrService]
                    return item
                }
                return items
            }
        case errSecItemNotFound:
            return []
        default:
            failure?(error(status: status))
        }
        return nil
    }
    
    // MARK:
    
    public class func get(key: String, service: String = "", accessGroup: String? = nil, failure: ((NSError) -> ())? = nil) -> String? {
        if let data = getAsData(key, service: service, accessGroup: accessGroup, failure: failure) {
            return NSString(data: data, encoding: NSUTF8StringEncoding)
        }
        return nil
    }
    
    public class func getAsData(key: String, service: String = "", accessGroup: String? = nil, failure: ((NSError) -> ())? = nil) -> NSData? {
        var query = [String: AnyObject]()
        query[kSecClass] = kSecClassGenericPassword
        query[kSecAttrSynchronizable] = kSecAttrSynchronizableAny
        query[kSecReturnData] = kCFBooleanTrue
        query[kSecMatchLimit] = kSecMatchLimitOne
        query[kSecAttrService] = service
        query[kSecAttrAccount] = key
        #if (!arch(i386) && !arch(x86_64)) || !os(iOS)
        if accessGroup != nil {
            query[kSecAttrAccessGroup] = accessGroup
        }
        #endif
        
        var result: AnyObject?
        var status = withUnsafeMutablePointer(&result) { pointer in
            SecItemCopyMatching(query, UnsafeMutablePointer(pointer))
        }
        
        if status == errSecSuccess {
            if let data = result as NSData? {
                return data
            }
        } else if status != errSecItemNotFound {
            failure?(error(status: status))
        }
        return nil
    }
    
    // MARK:
    
    public class func set(value: String?, key: String, service: String = "", accessGroup: String? = nil, accessibility: Accessibility = .AfterFirstUnlock, synchronizable: Bool = false, failure: ((NSError) -> ())? = nil) -> Bool {
        if let data: NSData = value?.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false) {
            return set(data, key: key, service: service, accessGroup: accessGroup, accessibility: accessibility, synchronizable: synchronizable, failure: failure)
        } else {
            return remove(key, service: service, accessGroup: accessGroup)
        }
    }
    
    public class func set(value: NSData?, key: String, service: String = "", accessGroup: String? = nil, accessibility: Accessibility = .AfterFirstUnlock, synchronizable: Bool = false, failure: ((NSError) -> ())? = nil) -> Bool {
        var query = [String: String]()
        query[kSecClass] = kSecClassGenericPassword
        query[kSecAttrSynchronizable] = kSecAttrSynchronizableAny
        query[kSecAttrService] = service
        query[kSecAttrAccount] = key
        #if (!arch(i386) && !arch(x86_64)) || !os(iOS)
        if accessGroup != nil {
            query[kSecAttrAccessGroup] = accessGroup
        }
        #endif
        
        var status = SecItemCopyMatching(query, nil)
        if status == errSecSuccess {
            if value != nil  {
                var attributes = [String: AnyObject]()
                attributes[kSecValueData] = value
                status = SecItemUpdate(query, attributes)
                if status != errSecSuccess {
                    failure?(error(status: status))
                    return false
                }
            } else {
                self.remove(key, service: service, accessGroup: accessGroup)
            }
        } else if status == errSecItemNotFound {
            var attributes = [String: AnyObject]()
            attributes[kSecClass] = kSecClassGenericPassword
            attributes[kSecAttrService] = service
            attributes[kSecAttrAccount] = key
            attributes[kSecAttrAccessible] = accessibility.rawValue
            attributes[kSecAttrSynchronizable] = synchronizable ? kCFBooleanTrue : kCFBooleanFalse
            #if (!arch(i386) && !arch(x86_64)) || !os(iOS)
            if accessGroup != nil {
                query[kSecAttrAccessGroup] = accessGroup
            }
            #endif
            attributes[kSecValueData] = value
            
            status = SecItemAdd(attributes, nil)
            if status != errSecSuccess {
                failure?(error(status: status))
                return false
            }
        } else {
            failure?(error(status: status))
            return false
        }
        return true
    }
    
    // MARK:
    
    public class func remove(key: String, service: String = "", accessGroup: String? = nil, failure: ((NSError) -> ())? = nil) -> Bool {
        var query = [String: String]()
        query[kSecClass] = kSecClassGenericPassword
        query[kSecAttrSynchronizable] = kSecAttrSynchronizableAny
        query[kSecAttrService] = service
        query[kSecAttrAccount] = key
        #if (!arch(i386) && !arch(x86_64)) || !os(iOS)
        if accessGroup != nil {
            query[kSecAttrAccessGroup] = accessGroup
        }
        #endif
        
        let status = SecItemDelete(query)
        if status != errSecSuccess && status != errSecItemNotFound {
            failure?(error(status: status))
            return false
        }
        return true
    }
    
    public class func removeAll(service: String? = nil, accessGroup: String? = nil, failure: ((NSError) -> ())? = nil) -> Bool {
        var query = [String: AnyObject]()
        query[kSecClass] = kSecClassGenericPassword
        query[kSecAttrSynchronizable] = kSecAttrSynchronizableAny
        if service != nil {
            query[kSecAttrService] = service
        }
        #if (!arch(i386) && !arch(x86_64)) || !os(iOS)
        if accessGroup != nil {
            query[kSecAttrAccessGroup] = accessGroup
        }
        #endif
        
        let status = SecItemDelete(query)
        if status != errSecSuccess && status != errSecItemNotFound {
            failure?(error(status: status))
            return false
        }
        
        return true
    }
    
    // MARK:
    
    public func get(key: String, failure: ((NSError) -> ())? = nil) -> String? {
        return self.dynamicType.get(key, service: service, accessGroup: accessGroup, failure: failure)
    }
    
    public func getAsData(key: String, failure: ((NSError) -> ())? = nil) -> NSData? {
        return self.dynamicType.getAsData(key, service: service, accessGroup: accessGroup, failure: failure)
    }
    
    // MARK:
    
    public func set(value: String?, key: String, failure: ((NSError) -> ())? = nil) -> Bool {
        return self.dynamicType.set(value, key: key, service: service, accessGroup: accessGroup, failure: failure)
    }
    
    public func set(value: NSData?, key: String, failure: ((NSError) -> ())? = nil) -> Bool {
        return self.dynamicType.set(value, key: key, service: service, accessGroup: accessGroup, failure: failure)
    }
    
    // MARK:
    
    public func remove(key: String, failure: ((NSError) -> ())? = nil) -> Bool {
        return self.dynamicType.remove(key, service: service, accessGroup: accessGroup, failure: failure)
    }
    
    public func removeAll(failure: ((NSError) -> ())? = nil) -> Bool {
        return self.dynamicType.removeAll(service: service, accessGroup: accessGroup, failure: failure)
    }
    
    // MARK:
    
    public subscript(key: String) -> String? {
        get {
            return get(key)
        }
        
        set {
            if let value = newValue {
                set(value, key: key)
            } else {
                remove(key)
            }
        }
    }
    
    // MARK:
    
    private class func debugItems(service: String?, accessGroup: String?, failure: ((NSError) -> ())? = nil) -> [[String: AnyObject]]? {
        var query = [String: AnyObject]()
        query[kSecClass] = kSecClassGenericPassword
        query[kSecAttrSynchronizable] = kSecAttrSynchronizableAny
        query[kSecMatchLimit] = kSecMatchLimitAll
        query[kSecReturnAttributes] = kCFBooleanTrue
        query[kSecReturnData] = kCFBooleanTrue
        if service != nil {
            query[kSecAttrService] = service
        }
        #if (!arch(i386) && !arch(x86_64)) || !os(iOS)
            if accessGroup != nil {
            query[kSecAttrAccessGroup] = accessGroup
            }
        #endif
        
        var result: AnyObject?
        var status = withUnsafeMutablePointer(&result) { pointer in
            SecItemCopyMatching(query, UnsafeMutablePointer(pointer))
        }
        
        if status == errSecSuccess {
            if let entries = result as [[String: AnyObject]]? {
                return entries
            }
        } else if status == errSecItemNotFound {
            return []
        }
        return nil
    }
    
    private class func error(#status: OSStatus) -> NSError {
        return NSError(domain: "com.kishikawakatsumi.KeychainAccess", code: Int(status), userInfo: nil)
    }
    
}

extension Keychain : Printable {
    public var description: String {
        var items = self.dynamicType.allItems(service: service, accessGroup: accessGroup)
        return "\(items)"
    }
}

extension Keychain : DebugPrintable {
    public var debugDescription: String {
        var entries = self.dynamicType.debugItems(service, accessGroup: accessGroup)
        return "\(entries)"
    }
}

public enum Accessibility : RawRepresentable, Printable {
    case WhenUnlocked
    case AfterFirstUnlock
    case Always
    case WhenPasscodeSetThisDeviceOnly
    case WhenUnlockedThisDeviceOnly
    case AfterFirstUnlockThisDeviceOnly
    case AlwaysThisDeviceOnly
    
    public static let allValues: [Accessibility] = [WhenUnlocked, AfterFirstUnlock, Always, WhenPasscodeSetThisDeviceOnly, WhenUnlockedThisDeviceOnly, AfterFirstUnlockThisDeviceOnly, AlwaysThisDeviceOnly]
    
    public init?(rawValue: String) {
        if rawValue == kSecAttrAccessibleWhenUnlocked {
            self = WhenUnlocked
        } else if rawValue == kSecAttrAccessibleAfterFirstUnlock {
            self = AfterFirstUnlock
        } else if rawValue == kSecAttrAccessibleAlways {
            self = Always
        } else if rawValue == kSecAttrAccessibleWhenPasscodeSetThisDeviceOnly {
            self = WhenPasscodeSetThisDeviceOnly
        } else if rawValue == kSecAttrAccessibleWhenUnlockedThisDeviceOnly {
            self = WhenUnlockedThisDeviceOnly
        }  else if rawValue == kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly {
            self = AfterFirstUnlockThisDeviceOnly
        } else if rawValue == kSecAttrAccessibleAlwaysThisDeviceOnly {
            self = AlwaysThisDeviceOnly
        } else {
            return nil
        }
    }
    
    public var rawValue: String {
        switch self {
        case WhenUnlocked:
            return kSecAttrAccessibleWhenUnlocked
        case AfterFirstUnlock:
            return kSecAttrAccessibleAfterFirstUnlock
        case Always:
            return kSecAttrAccessibleAlways
        case WhenPasscodeSetThisDeviceOnly:
            return kSecAttrAccessibleWhenPasscodeSetThisDeviceOnly
        case WhenUnlockedThisDeviceOnly:
            return kSecAttrAccessibleWhenUnlockedThisDeviceOnly
        case AfterFirstUnlockThisDeviceOnly:
            return kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly
        case AlwaysThisDeviceOnly:
            return kSecAttrAccessibleAlwaysThisDeviceOnly
        }
    }
    
    public var description : String {
        switch self {
        case WhenUnlocked:
            return "WhenUnlocked"
        case AfterFirstUnlock:
            return "AfterFirstUnlock"
        case Always:
            return "Always"
        case WhenPasscodeSetThisDeviceOnly:
            return "WhenPasscodeSetThisDeviceOnly"
        case WhenUnlockedThisDeviceOnly:
            return "WhenUnlockedThisDeviceOnly"
        case AfterFirstUnlockThisDeviceOnly:
            return "AfterFirstUnlockThisDeviceOnly"
        case AlwaysThisDeviceOnly:
            return "AlwaysThisDeviceOnly"
        }
    }
}
