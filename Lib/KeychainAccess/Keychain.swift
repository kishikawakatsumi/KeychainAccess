//
//  Keychain.swift
//  KeychainAccess
//
//  Created by kishikawa katsumi on 2014/12/24.
//  Copyright (c) 2014 kishikawa katsumi. All rights reserved.
//

import Foundation
import Security

public struct Options {
    public var itemClass: ItemClass = .GenericPassword
    
    public var service: String = ""
    public var accessGroup: String? = nil
    
    public var server: NSURL!
    public var protocolType: ProtocolType!
    public var authenticationType: AuthenticationType = .Default
    
    public var accessibility: Accessibility = .AfterFirstUnlock
    public var synchronizable: Bool = false
    
    init() {
        
    }
    
    func query() -> [String: AnyObject] {
        var query = [String: AnyObject]()
        query[kSecClass] = itemClass.rawValue
        query[kSecAttrSynchronizable] = kSecAttrSynchronizableAny
        
        switch itemClass {
        case .GenericPassword:
            query[kSecAttrService] = service
            #if (!arch(i386) && !arch(x86_64)) || !os(iOS)
            if let accessGroup = self.accessGroup {
                query[kSecAttrAccessGroup] = accessGroup
            }
            #endif
        case .InternetPassword:
            query[kSecAttrServer] = server.host
            query[kSecAttrPort] = server.port
            query[kSecAttrProtocol] = protocolType.rawValue
            query[kSecAttrAuthenticationType] = authenticationType.rawValue
        }
        
        return query
    }
    
    func attributes(#key: String, value: NSData) -> [String: AnyObject] {
        var attributes = query()
        
        attributes[kSecAttrAccount] = key
        attributes[kSecValueData] = value
        
        attributes[kSecAttrAccessible] = accessibility.rawValue
        attributes[kSecAttrSynchronizable] = synchronizable
        
        return attributes
    }
    
    func attributes(#value: NSData) -> [String: AnyObject] {
        var attributes = [String: AnyObject]()
        
        attributes[kSecValueData] = value
        
        attributes[kSecAttrAccessible] = accessibility.rawValue
        attributes[kSecAttrSynchronizable] = synchronizable
        
        return attributes
    }
}

public enum ItemClass {
    case GenericPassword
    case InternetPassword
}

public enum Accessibility {
    case WhenUnlocked
    case AfterFirstUnlock
    case Always
    case WhenPasscodeSetThisDeviceOnly
    case WhenUnlockedThisDeviceOnly
    case AfterFirstUnlockThisDeviceOnly
    case AlwaysThisDeviceOnly
}

public enum ProtocolType {
    case FTP
    case FTPAccount
    case HTTP
    case IRC
    case NNTP
    case POP3
    case SMTP
    case SOCKS
    case IMAP
    case LDAP
    case AppleTalk
    case AFP
    case Telnet
    case SSH
    case FTPS
    case HTTPS
    case HTTPProxy
    case HTTPSProxy
    case FTPProxy
    case SMB
    case RTSP
    case RTSPProxy
    case DAAP
    case EPPC
    case IPP
    case NNTPS
    case LDAPS
    case TelnetS
    case IMAPS
    case IRCS
    case POP3S
}

public enum AuthenticationType {
    case NTLM
    case MSN
    case DPA
    case RPA
    case HTTPBasic
    case HTTPDigest
    case HTMLForm
    case Default
}

public class Keychain {
    private let options: Options
    
    public var service: String {
        return options.service
    }
    
    public var accessGroup: String? {
        return options.accessGroup
    }
    
    public var server: NSURL {
        return options.server
    }
    
    public var protocolType: ProtocolType {
        return options.protocolType
    }
    
    public var authenticationType: AuthenticationType {
        return options.authenticationType
    }
    
    public var accessibility: Accessibility {
        return options.accessibility
    }
    
    public var synchronizable: Bool {
        return options.synchronizable
    }
    
    public var itemClass: ItemClass {
        return options.itemClass
    }
    
    public init(service: String = "") {
        options = Options()
        options.service = service
    }
    
    public init(service: String = "", accessGroup: String) {
        options = Options()
        options.service = service
        options.accessGroup = accessGroup
    }
    
    public init(server: NSURL, protocolType: ProtocolType, authenticationType: AuthenticationType = .Default) {
        options = Options()
        options.itemClass = .InternetPassword
        options.server = server
        options.protocolType = protocolType
        options.authenticationType = authenticationType
    }
    
    private init(options opts: Options) {
        options = opts
    }
    
    // MARK:
    
    public func accessibility(accessibility: Accessibility) -> Keychain {
        var options = self.options
        options.accessibility = accessibility
        return Keychain(options: options)
    }
    
    public func synchronizable(synchronizable: Bool) -> Keychain {
        var options = self.options
        options.synchronizable = synchronizable
        return Keychain(options: options)
    }
    
    // MARK:
    
    public func get(key: String) -> (asString: String?, asData: NSData?, error: NSError?) {
        var query = options.query()
        query[kSecReturnData] = kCFBooleanTrue
        query[kSecMatchLimit] = kSecMatchLimitOne
        
        query[kSecAttrAccount] = key
        
        var result: AnyObject?
        var status = withUnsafeMutablePointer(&result) { SecItemCopyMatching(query, UnsafeMutablePointer($0)) }
        
        if status == errSecSuccess {
            if let data = result as NSData? {
                return (NSString(data: data, encoding: NSUTF8StringEncoding), data, nil)
            }
        } else if status != errSecItemNotFound {
            return (nil, nil, error(status: status))
        }
        return (nil, nil, nil)
    }
    
    // MARK:
    
    public func set(value: String, key: String) -> NSError? {
        if let data = value.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false) {
            return set(data, key: key)
        }
        return NSError(domain: "com.kishikawakatsumi.KeychainAccess", code: 0, userInfo: nil)
    }
    
    public func set(value: NSData, key: String) -> NSError? {
        var query = options.query()
        query[kSecAttrAccount] = key
        
        var status = SecItemCopyMatching(query, nil)
        if status == errSecSuccess {
            var attributes = options.attributes(value: value)
            
            status = SecItemUpdate(query, attributes)
            if status != errSecSuccess {
                return error(status: status)
            }
        } else if status == errSecItemNotFound {
            var attributes = options.attributes(key: key, value: value)
            
            status = SecItemAdd(attributes, nil)
            if status != errSecSuccess {
                return error(status: status)
            }
        } else {
            return error(status: status)
        }
        return nil
    }
    
    // MARK:
    
    public func remove(key: String) -> NSError? {
        var query = options.query()
        query[kSecAttrAccount] = key
        
        let status = SecItemDelete(query)
        if status != errSecSuccess && status != errSecItemNotFound {
            return error(status: status)
        }
        return nil
    }
    
    public func removeAll() -> NSError? {
        var query = options.query()
        #if !os(iOS)
        query[kSecMatchLimit] = kSecMatchLimitAll
        #endif
        
        let status = SecItemDelete(query)
        if status != errSecSuccess && status != errSecItemNotFound {
            return error(status: status)
        }
        return nil
    }
    
    // MARK:
    
    public func contains(key: String) -> Bool? {
        var query = options.query()
        query[kSecAttrAccount] = key
        
        var status = SecItemCopyMatching(query, nil)
        
        switch status {
        case errSecSuccess:
            return true
        case errSecItemNotFound:
            return false
        default:
            return nil
        }
    }
    
    // MARK:
    
    public subscript(key: String) -> String? {
        get {
            return get(key).asString
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
    
    public func allItems(service:String? = nil, accessGroup: String? = nil, failure: ((NSError) -> ())? = nil) -> [[String: AnyObject]]? {
        var query = [String: AnyObject]()
        query[kSecClass] = itemClass.rawValue
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
        var status = withUnsafeMutablePointer(&result) { SecItemCopyMatching(query, UnsafeMutablePointer($0)) }
        
        switch status {
        case errSecSuccess:
            if let attributes = result as [[String: AnyObject]]? {
                let items = attributes.map() { attribute -> [String: AnyObject] in
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
                    item["accessGroup"] = attribute[kSecAttrAccessGroup]
                    item["accessibility"] = Accessibility(rawValue: attribute[kSecAttrAccessible] as String)?.description
                    item["synchronizable"] = attribute[kSecAttrSynchronizable]
                    
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
    
    private func debugItems(service: String?, accessGroup: String?) -> [[String: AnyObject]]? {
        var query = [String: AnyObject]()
        query[kSecClass] = itemClass.rawValue
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
        var status = withUnsafeMutablePointer(&result) { SecItemCopyMatching(query, UnsafeMutablePointer($0)) }
        
        if status == errSecSuccess {
            if let entries = result as [[String: AnyObject]]? {
                return entries
            }
        } else if status == errSecItemNotFound {
            return []
        }
        return nil
    }
    
    private func error(#status: OSStatus) -> NSError {
        return NSError(domain: "com.kishikawakatsumi.KeychainAccess", code: Int(status), userInfo: nil)
    }
}

extension Keychain : Printable, DebugPrintable {
    public var description: String {
        var items = self.allItems(service: service, accessGroup: accessGroup)
        return "\(items)"
    }
    
    public var debugDescription: String {
        var items = self.debugItems(service, accessGroup: accessGroup)
        return "\(items)"
    }
}

extension ItemClass : RawRepresentable, Printable {
    public static let allValues: [ItemClass] = [GenericPassword, InternetPassword]
    
    public init?(rawValue: String) {
        if rawValue == kSecClassGenericPassword {
            self = GenericPassword
        } else if rawValue == kSecClassInternetPassword {
            self = InternetPassword
        } else {
            return nil
        }
    }
    
    public var rawValue: String {
        switch self {
        case GenericPassword:
            return kSecClassGenericPassword
        case InternetPassword:
            return kSecClassInternetPassword
        }
    }
    
    public var description : String {
        switch self {
        case GenericPassword:
            return "GenericPassword"
        case InternetPassword:
            return "InternetPassword"
        }
    }
}

extension Accessibility : RawRepresentable, Printable {
    public static let allValues: [Accessibility] = [
        WhenUnlocked,
        AfterFirstUnlock,
        Always,
        WhenPasscodeSetThisDeviceOnly,
        WhenUnlockedThisDeviceOnly,
        AfterFirstUnlockThisDeviceOnly,
        AlwaysThisDeviceOnly,
    ]
    
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

extension ProtocolType : RawRepresentable, Printable {
    public static let allValues: [ProtocolType] = [
        FTP,
        FTPAccount,
        HTTP,
        IRC,
        NNTP,
        POP3,
        SMTP,
        SOCKS,
        IMAP,
        LDAP,
        AppleTalk,
        AFP,
        Telnet,
        SSH,
        FTPS,
        HTTPS,
        HTTPProxy,
        HTTPSProxy,
        FTPProxy,
        SMB,
        RTSP,
        RTSPProxy,
        DAAP,
        EPPC,
        IPP,
        NNTPS,
        LDAPS,
        TelnetS,
        IMAPS,
        IRCS,
        POP3S,
    ]
    
    public init?(rawValue: String) {
        if rawValue == kSecAttrProtocolFTP {
            self = FTP
        } else if rawValue == kSecAttrProtocolFTPAccount {
            self = FTPAccount
        } else if rawValue == kSecAttrProtocolHTTP {
            self = HTTP
        } else if rawValue == kSecAttrProtocolIRC {
            self = IRC
        }  else if rawValue == kSecAttrProtocolNNTP {
            self = NNTP
        } else if rawValue == kSecAttrProtocolPOP3 {
            self = POP3
        } else if rawValue == kSecAttrProtocolSMTP {
            self = SMTP
        } else if rawValue == kSecAttrProtocolPOP3 {
            self = POP3
        } else if rawValue == kSecAttrProtocolSOCKS {
            self = SOCKS
        } else if rawValue == kSecAttrProtocolIMAP {
            self = IMAP
        } else if rawValue == kSecAttrProtocolLDAP {
            self = LDAP
        } else if rawValue == kSecAttrProtocolAppleTalk {
            self = AppleTalk
        } else if rawValue == kSecAttrProtocolAFP {
            self = AFP
        } else if rawValue == kSecAttrProtocolTelnet {
            self = Telnet
        } else if rawValue == kSecAttrProtocolSSH {
            self = SSH
        } else if rawValue == kSecAttrProtocolFTPS {
            self = FTPS
        } else if rawValue == kSecAttrProtocolHTTPS {
            self = HTTPS
        } else if rawValue == kSecAttrProtocolHTTPProxy {
            self = HTTPProxy
        } else if rawValue == kSecAttrProtocolHTTPSProxy {
            self = HTTPSProxy
        } else if rawValue == kSecAttrProtocolFTPProxy {
            self = FTPProxy
        } else if rawValue == kSecAttrProtocolSMB {
            self = SMB
        } else if rawValue == kSecAttrProtocolRTSP {
            self = RTSP
        } else if rawValue == kSecAttrProtocolRTSPProxy {
            self = RTSPProxy
        } else if rawValue == kSecAttrProtocolDAAP {
            self = DAAP
        } else if rawValue == kSecAttrProtocolEPPC {
            self = EPPC
        } else if rawValue == kSecAttrProtocolIPP {
            self = IPP
        } else if rawValue == kSecAttrProtocolNNTPS {
            self = NNTPS
        } else if rawValue == kSecAttrProtocolLDAPS {
            self = LDAPS
        } else if rawValue == kSecAttrProtocolTelnetS {
            self = TelnetS
        } else if rawValue == kSecAttrProtocolIMAPS {
            self = IMAPS
        } else if rawValue == kSecAttrProtocolIRCS {
            self = IRCS
        } else if rawValue == kSecAttrProtocolPOP3S {
            self = POP3S
        } else {
            return nil
        }
    }
    
    public var rawValue: String {
        switch self {
        case FTP:
            return kSecAttrProtocolFTP
        case FTPAccount:
            return kSecAttrProtocolFTPAccount
        case HTTP:
            return kSecAttrProtocolHTTP
        case IRC:
            return kSecAttrProtocolIRC
        case NNTP:
            return kSecAttrProtocolNNTP
        case POP3:
            return kSecAttrProtocolPOP3
        case SMTP:
            return kSecAttrProtocolSMTP
        case SOCKS:
            return kSecAttrProtocolSOCKS
        case IMAP:
            return kSecAttrProtocolIMAP
        case LDAP:
            return kSecAttrProtocolLDAP
        case AppleTalk:
            return kSecAttrProtocolAppleTalk
        case AFP:
            return kSecAttrProtocolAFP
        case Telnet:
            return kSecAttrProtocolTelnet
        case SSH:
            return kSecAttrProtocolSSH
        case FTPS:
            return kSecAttrProtocolFTPS
        case HTTPS:
            return kSecAttrProtocolHTTPS
        case HTTPProxy:
            return kSecAttrProtocolHTTPProxy
        case HTTPSProxy:
            return kSecAttrProtocolHTTPSProxy
        case FTPProxy:
            return kSecAttrProtocolFTPProxy
        case SMB:
            return kSecAttrProtocolSMB
        case RTSP:
            return kSecAttrProtocolRTSP
        case RTSPProxy:
            return kSecAttrProtocolRTSPProxy
        case DAAP:
            return kSecAttrProtocolDAAP
        case EPPC:
            return kSecAttrProtocolEPPC
        case IPP:
            return kSecAttrProtocolIPP
        case NNTPS:
            return kSecAttrProtocolNNTPS
        case LDAPS:
            return kSecAttrProtocolLDAPS
        case TelnetS:
            return kSecAttrProtocolTelnetS
        case IMAPS:
            return kSecAttrProtocolIMAPS
        case IRCS:
            return kSecAttrProtocolIRCS
        case POP3S:
            return kSecAttrProtocolPOP3S
        }
    }
    
    public var description : String {
        switch self {
        case FTP:
            return "FTP"
        case FTPAccount:
            return "FTPAccount"
        case HTTP:
            return "HTTP"
        case IRC:
            return "IRC"
        case NNTP:
            return "NNTP"
        case POP3:
            return "POP3"
        case SMTP:
            return "SMTP"
        case SOCKS:
            return "SOCKS"
        case IMAP:
            return "IMAP"
        case LDAP:
            return "LDAP"
        case AppleTalk:
            return "AppleTalk"
        case AFP:
            return "AFP"
        case Telnet:
            return "Telnet"
        case SSH:
            return "SSH"
        case FTPS:
            return "FTPS"
        case HTTPS:
            return "HTTPS"
        case HTTPProxy:
            return "HTTPProxy"
        case HTTPSProxy:
            return "HTTPSProxy"
        case FTPProxy:
            return "FTPProxy"
        case SMB:
            return "SMB"
        case RTSP:
            return "RTSP"
        case RTSPProxy:
            return "RTSPProxy"
        case DAAP:
            return "DAAP"
        case EPPC:
            return "EPPC"
        case IPP:
            return "IPP"
        case NNTPS:
            return "NNTPS"
        case LDAPS:
            return "LDAPS"
        case TelnetS:
            return "TelnetS"
        case IMAPS:
            return "IMAPS"
        case IRCS:
            return "IRCS"
        case POP3S:
            return "POP3S"
        }
    }
}

extension AuthenticationType : RawRepresentable, Printable {
    public static let allValues: [AuthenticationType] = [
        NTLM,
        MSN,
        DPA,
        RPA,
        HTTPBasic,
        HTTPDigest,
        HTMLForm,
        Default,
    ]
    
    public init?(rawValue: String) {
        if rawValue == kSecAttrAuthenticationTypeNTLM {
            self = NTLM
        } else if rawValue == kSecAttrAuthenticationTypeMSN {
            self = MSN
        } else if rawValue == kSecAttrAuthenticationTypeDPA {
            self = DPA
        } else if rawValue == kSecAttrAuthenticationTypeRPA {
            self = RPA
        } else if rawValue == kSecAttrAuthenticationTypeHTTPBasic {
            self = HTTPBasic
        }  else if rawValue == kSecAttrAuthenticationTypeHTTPDigest {
            self = HTTPDigest
        } else if rawValue == kSecAttrAuthenticationTypeHTMLForm {
            self = HTMLForm
        } else if rawValue == kSecAttrAuthenticationTypeDefault {
            self = Default
        } else {
            return nil
        }
    }
    
    public var rawValue: String {
        switch self {
        case NTLM:
            return kSecAttrAuthenticationTypeNTLM
        case MSN:
            return kSecAttrAuthenticationTypeMSN
        case DPA:
            return kSecAttrAuthenticationTypeDPA
        case RPA:
            return kSecAttrAuthenticationTypeRPA
        case HTTPBasic:
            return kSecAttrAuthenticationTypeHTTPBasic
        case HTTPDigest:
            return kSecAttrAuthenticationTypeHTTPDigest
        case HTMLForm:
            return kSecAttrAuthenticationTypeHTMLForm
        case Default:
            return kSecAttrAuthenticationTypeDefault
        }
    }
    
    public var description : String {
        switch self {
        case NTLM:
            return "NTLM"
        case MSN:
            return "MSN"
        case DPA:
            return "DPA"
        case RPA:
            return "RPA"
        case HTTPBasic:
            return "HTTPBasic"
        case HTTPDigest:
            return "HTTPDigest"
        case HTMLForm:
            return "HTMLForm"
        case Default:
            return "Default"
        }
    }
}
