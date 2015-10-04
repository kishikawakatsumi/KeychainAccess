//
//  Keychain.swift
//  KeychainAccess
//
//  Created by kishikawa katsumi on 2014/12/24.
//  Copyright (c) 2014 kishikawa katsumi. All rights reserved.
//

import Foundation
import Security

public let KeychainAccessErrorDomain = "com.kishikawakatsumi.KeychainAccess.error"

public enum ItemClass {
    case GenericPassword
    case InternetPassword
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

public enum Accessibility {
    case WhenUnlocked
    case AfterFirstUnlock
    case Always
    case WhenPasscodeSetThisDeviceOnly
    case WhenUnlockedThisDeviceOnly
    case AfterFirstUnlockThisDeviceOnly
    case AlwaysThisDeviceOnly
}

public enum AuthenticationPolicy : Int {
    case UserPresence
}

public class Keychain {
    public var itemClass: ItemClass {
        return options.itemClass
    }
    
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
    
    @available(iOS, introduced=8.0)
    @available(OSX, introduced=10.10)
    public var authenticationPolicy: AuthenticationPolicy? {
        return options.authenticationPolicy
    }
    
    public var synchronizable: Bool {
        return options.synchronizable
    }
    
    public var label: String? {
        return options.label
    }
    
    public var comment: String? {
        return options.comment
    }
    
    @available(iOS, introduced=8.0)
    @available(OSX, unavailable)
    public var authenticationPrompt: String? {
        return options.authenticationPrompt
    }
    
    private let options: Options
    
    // MARK:
    
    public convenience init() {
        var options = Options()
        if let bundleIdentifier = NSBundle.mainBundle().bundleIdentifier {
            options.service = bundleIdentifier
        }
        self.init(options)
    }
    
    public convenience init(service: String) {
        var options = Options()
        options.service = service
        self.init(options)
    }
    
    public convenience init(accessGroup: String) {
        var options = Options()
        if let bundleIdentifier = NSBundle.mainBundle().bundleIdentifier {
            options.service = bundleIdentifier
        }
        options.accessGroup = accessGroup
        self.init(options)
    }
    
    public convenience init(service: String, accessGroup: String) {
        var options = Options()
        options.service = service
        options.accessGroup = accessGroup
        self.init(options)
    }
    
    public convenience init(server: String, protocolType: ProtocolType) {
        self.init(server: NSURL(string: server)!, protocolType: protocolType)
    }
    
    public convenience init(server: String, protocolType: ProtocolType, authenticationType: AuthenticationType) {
        self.init(server: NSURL(string: server)!, protocolType: protocolType, authenticationType: .Default)
    }
    
    public convenience init(server: NSURL, protocolType: ProtocolType) {
        self.init(server: server, protocolType: protocolType, authenticationType: .Default)
    }
    
    public convenience init(server: NSURL, protocolType: ProtocolType, authenticationType: AuthenticationType) {
        var options = Options()
        options.itemClass = .InternetPassword
        options.server = server
        options.protocolType = protocolType
        options.authenticationType = authenticationType
        self.init(options)
    }
    
    private init(_ opts: Options) {
        options = opts
    }
    
    // MARK:
    
    public func accessibility(accessibility: Accessibility) -> Keychain {
        var options = self.options
        options.accessibility = accessibility
        return Keychain(options)
    }
    
    @available(iOS, introduced=8.0)
    @available(OSX, introduced=10.10)
    public func accessibility(accessibility: Accessibility, authenticationPolicy: AuthenticationPolicy) -> Keychain {
        var options = self.options
        options.accessibility = accessibility
        options.authenticationPolicy = authenticationPolicy
        return Keychain(options)
    }
    
    public func synchronizable(synchronizable: Bool) -> Keychain {
        var options = self.options
        options.synchronizable = synchronizable
        return Keychain(options)
    }
    
    public func label(label: String) -> Keychain {
        var options = self.options
        options.label = label
        return Keychain(options)
    }
    
    public func comment(comment: String) -> Keychain {
        var options = self.options
        options.comment = comment
        return Keychain(options)
    }
    
    @available(iOS, introduced=8.0)
    @available(OSX, unavailable)
    public func authenticationPrompt(authenticationPrompt: String) -> Keychain {
        var options = self.options
        options.authenticationPrompt = authenticationPrompt
        return Keychain(options)
    }
    
    // MARK:
    
    public func get(key: String) throws -> String? {
        return try getString(key)
    }
    
    public func getString(key: String) throws -> String? {
        guard let data = try getData(key) else  {
            return nil
        }
        guard let string = NSString(data: data, encoding: NSUTF8StringEncoding) as? String else {
            throw conversionError(message: "failed to convert data to string")
        }
        return string
    }

    public func getData(key: String) throws -> NSData? {
        var query = options.query()

        query[kSecMatchLimit as String] = kSecMatchLimitOne
        query[kSecReturnData as String] = kCFBooleanTrue

        query[kSecAttrAccount as String] = key

        var result: AnyObject?
        let status = withUnsafeMutablePointer(&result) { SecItemCopyMatching(query, UnsafeMutablePointer($0)) }

        switch status {
        case errSecSuccess:
            guard let data = result as? NSData else {
                throw Status.UnexpectedError
            }
            return data
        case errSecItemNotFound:
            return nil
        default:
            throw securityError(status: status)
        }
    }

    // MARK:
    
    public func set(value: String, key: String) throws {
        guard let data = value.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false) else {
            throw conversionError(message: "failed to convert string to data")
        }
        try set(data, key: key)
    }
    
    public func set(value: NSData, key: String) throws {
        var query = options.query()
        
        query[kSecAttrAccount as String] = key
        #if os(iOS)
        if #available(iOS 9.0, *) {
            query[kSecUseAuthenticationUI as String] = kCFBooleanFalse
        } else if #available(iOS 8.0, *) {
            query[kSecUseNoAuthenticationUI as String] = kCFBooleanTrue
        }
        #endif
        
        var status = SecItemCopyMatching(query, nil)
        switch status {
        case errSecSuccess, errSecInteractionNotAllowed:
            var query = options.query()
            query[kSecAttrAccount as String] = key
            
            let (attributes, error) = options.attributes(key: nil, value: value)
            if let error = error {
                print("error:[\(error.code)] \(error.localizedDescription)")
                throw error
            }

            #if os(iOS)
            if status == errSecInteractionNotAllowed && floor(NSFoundationVersionNumber) <= floor(NSFoundationVersionNumber_iOS_8_0) {
                try remove(key)
                try set(value, key: key)
            } else {
                status = SecItemUpdate(query, attributes)
                if status != errSecSuccess {
                    throw securityError(status: status)
                }
            }
            #else
                status = SecItemUpdate(query, attributes)
                if status != errSecSuccess {
                    throw securityError(status: status)
                }
            #endif
        case errSecItemNotFound:
            let (attributes, error) = options.attributes(key: key, value: value)
            if let error = error {
                print("error:[\(error.code)] \(error.localizedDescription)")
                throw error
            }

            status = SecItemAdd(attributes, nil)
            if status != errSecSuccess {
                throw securityError(status: status)
            }
        default:
            throw securityError(status: status)
        }
    }
    
    // MARK:
    
    public func remove(key: String) throws {
        var query = options.query()
        query[kSecAttrAccount as String] = key
        
        let status = SecItemDelete(query)
        if status != errSecSuccess && status != errSecItemNotFound {
            throw securityError(status: status)
        }
    }
    
    public func removeAll() throws {
        var query = options.query()
        #if !os(iOS) && !os(watchOS) && !os(tvOS)
        query[kSecMatchLimit as String] = kSecMatchLimitAll
        #endif
        
        let status = SecItemDelete(query)
        if status != errSecSuccess && status != errSecItemNotFound {
            throw securityError(status: status)
        }
    }
    
    // MARK:
    
    public func contains(key: String) throws -> Bool {
        var query = options.query()
        query[kSecAttrAccount as String] = key
        
        let status = SecItemCopyMatching(query, nil)
        switch status {
        case errSecSuccess:
            return true
        case errSecItemNotFound:
            return false
        default:
            throw securityError(status: status)
        }
    }
    
    // MARK:
    
    public subscript(key: String) -> String? {
        get {
            return (try? get(key)).flatMap { $0 }
        }
        
        set {
            if let value = newValue {
                do {
                    try set(value, key: key)
                } catch {}
            } else {
                do {
                    try remove(key)
                } catch {}
            }
        }
    }

    public subscript(string key: String) -> String? {
        get {
            return self[key]
        }

        set {
            self[key] = newValue
        }
    }

    public subscript(data key: String) -> NSData? {
        get {
            return (try? getData(key)).flatMap { $0 }
        }

        set {
            if let value = newValue {
                do {
                    try set(value, key: key)
                } catch {}
            } else {
                do {
                    try remove(key)
                } catch {}
            }
        }
    }
    
    // MARK:
    
    public class func allKeys(itemClass: ItemClass) -> [(String, String)] {
        var query = [String: AnyObject]()
        query[kSecClass as String] = itemClass.rawValue
        query[kSecMatchLimit as String] = kSecMatchLimitAll
        query[kSecReturnAttributes as String] = kCFBooleanTrue
        
        var result: AnyObject?
        let status = withUnsafeMutablePointer(&result) { SecItemCopyMatching(query, UnsafeMutablePointer($0)) }
        
        switch status {
        case errSecSuccess:
            if let items = result as? [[String: AnyObject]] {
                return prettify(itemClass: itemClass, items: items).map {
                    switch itemClass {
                    case .GenericPassword:
                        return (($0["service"] ?? "") as! String, ($0["key"] ?? "") as! String)
                    case .InternetPassword:
                        return (($0["server"] ?? "") as! String, ($0["key"] ?? "") as! String)
                    }
                }
            }
        case errSecItemNotFound:
            return []
        default: ()
        }
        
        securityError(status: status)
        return []
    }
    
    public func allKeys() -> [String] {
        return self.dynamicType.prettify(itemClass: itemClass, items: items()).map { $0["key"] as! String }
    }
    
    public class func allItems(itemClass: ItemClass) -> [[String: AnyObject]] {
        var query = [String: AnyObject]()
        query[kSecClass as String] = itemClass.rawValue
        query[kSecMatchLimit as String] = kSecMatchLimitAll
        query[kSecReturnAttributes as String] = kCFBooleanTrue
        #if os(iOS)
        query[kSecReturnData as String] = kCFBooleanTrue
        #endif
        
        var result: AnyObject?
        let status = withUnsafeMutablePointer(&result) { SecItemCopyMatching(query, UnsafeMutablePointer($0)) }
        
        switch status {
        case errSecSuccess:
            if let items = result as? [[String: AnyObject]] {
                return prettify(itemClass: itemClass, items: items)
            }
        case errSecItemNotFound:
            return []
        default: ()
        }
        
        securityError(status: status)
        return []
    }
    
    public func allItems() -> [[String: AnyObject]] {
        return self.dynamicType.prettify(itemClass: itemClass, items: items())
    }
    
    #if os(iOS)
    @available(iOS, introduced=8.0)
    public func getSharedPassword(completion: (account: String?, password: String?, error: NSError?) -> () = { account, password, error -> () in }) {
        if let domain = server.host {
            self.dynamicType.requestSharedWebCredential(domain: domain, account: nil) { (credentials, error) -> () in
                if let credential = credentials.first {
                    let account = credential["account"]
                    let password = credential["password"]
                    completion(account: account, password: password, error: error)
                } else {
                    completion(account: nil, password: nil, error: error)
                }
            }
        } else {
            let error = securityError(status: Status.Param.rawValue)
            completion(account: nil, password: nil, error: error)
        }
    }
    #endif

    #if os(iOS)
    @available(iOS, introduced=8.0)
    public func getSharedPassword(account: String, completion: (password: String?, error: NSError?) -> () = { password, error -> () in }) {
        if let domain = server.host {
            self.dynamicType.requestSharedWebCredential(domain: domain, account: account) { (credentials, error) -> () in
                if let credential = credentials.first {
                    if let password = credential["password"] {
                        completion(password: password, error: error)
                    } else {
                        completion(password: nil, error: error)
                    }
                } else {
                    completion(password: nil, error: error)
                }
            }
        } else {
            let error = securityError(status: Status.Param.rawValue)
            completion(password: nil, error: error)
        }
    }
    #endif

    #if os(iOS)
    @available(iOS, introduced=8.0)
    public func setSharedPassword(password: String, account: String, completion: (error: NSError?) -> () = { e -> () in }) {
        setSharedPassword(password as String?, account: account, completion: completion)
    }
    #endif

    #if os(iOS)
    @available(iOS, introduced=8.0)
    private func setSharedPassword(password: String?, account: String, completion: (error: NSError?) -> () = { e -> () in }) {
        if let domain = server.host {
            SecAddSharedWebCredential(domain, account, password) { error -> () in
                if let error = error {
                    completion(error: error.error)
                } else {
                    completion(error: nil)
                }
            }
        } else {
            let error = securityError(status: Status.Param.rawValue)
            completion(error: error)
        }
    }
    #endif

    #if os(iOS)
    @available(iOS, introduced=8.0)
    public func removeSharedPassword(account: String, completion: (error: NSError?) -> () = { e -> () in }) {
        setSharedPassword(nil, account: account, completion: completion)
    }
    #endif

    #if os(iOS)
    @available(iOS, introduced=8.0)
    public class func requestSharedWebCredential(completion: (credentials: [[String: String]], error: NSError?) -> () = { credentials, error -> () in }) {
        requestSharedWebCredential(domain: nil, account: nil, completion: completion)
    }
    #endif

    #if os(iOS)
    @available(iOS, introduced=8.0)
    public class func requestSharedWebCredential(domain domain: String, completion: (credentials: [[String: String]], error: NSError?) -> () = { credentials, error -> () in }) {
        requestSharedWebCredential(domain: domain, account: nil, completion: completion)
    }
    #endif

    #if os(iOS)
    @available(iOS, introduced=8.0)
    public class func requestSharedWebCredential(domain domain: String, account: String, completion: (credentials: [[String: String]], error: NSError?) -> () = { credentials, error -> () in }) {
        requestSharedWebCredential(domain: domain as String?, account: account as String?, completion: completion)
    }
    #endif

    #if os(iOS)
    @available(iOS, introduced=8.0)
    private class func requestSharedWebCredential(domain domain: String?, account: String?, completion: (credentials: [[String: String]], error: NSError?) -> ()) {
        SecRequestSharedWebCredential(domain, account) { (credentials, error) -> () in
            var remoteError: NSError?
            if let error = error {
                remoteError = error.error
                if remoteError?.code != Int(errSecItemNotFound) {
                    print("error:[\(remoteError!.code)] \(remoteError!.localizedDescription)")
                }
            }
            if let credentials = credentials as? [[String: AnyObject]] {
                let credentials = credentials.map { credentials -> [String: String] in
                    var credential = [String: String]()
                    if let server = credentials[kSecAttrServer as String] as? String {
                        credential["server"] = server
                    }
                    if let account = credentials[kSecAttrAccount as String] as? String {
                        credential["account"] = account
                    }
                    if let password = credentials[kSecSharedPassword as String] as? String {
                        credential["password"] = password
                    }
                    return credential
                }
                completion(credentials: credentials, error: remoteError)
            } else {
                completion(credentials: [], error: remoteError)
            }
        }
    }
    #endif

    #if os(iOS)
    @available(iOS, introduced=8.0)
    public class func generatePassword() -> String {
        return SecCreateSharedWebCredentialPassword() as! String
    }
    #endif
    
    // MARK:
    
    private func items() -> [[String: AnyObject]] {
        var query = options.query()
        query[kSecMatchLimit as String] = kSecMatchLimitAll
        query[kSecReturnAttributes as String] = kCFBooleanTrue
        #if os(iOS)
        query[kSecReturnData as String] = kCFBooleanTrue
        #endif
        
        var result: AnyObject?
        let status = withUnsafeMutablePointer(&result) { SecItemCopyMatching(query, UnsafeMutablePointer($0)) }
        
        switch status {
        case errSecSuccess:
            if let items = result as? [[String: AnyObject]] {
                return items
            }
        case errSecItemNotFound:
            return []
        default: ()
        }
        
        securityError(status: status)
        return []
    }
    
    private class func prettify(itemClass itemClass: ItemClass, items: [[String: AnyObject]]) -> [[String: AnyObject]] {
        let items = items.map { attributes -> [String: AnyObject] in
            var item = [String: AnyObject]()
            
            item["class"] = itemClass.description
            
            switch itemClass {
            case .GenericPassword:
                if let service = attributes[kSecAttrService as String] as? String {
                    item["service"] = service
                }
                if let accessGroup = attributes[kSecAttrAccessGroup as String] as? String {
                    item["accessGroup"] = accessGroup
                }
            case .InternetPassword:
                if let server = attributes[kSecAttrServer as String] as? String {
                    item["server"] = server
                }
                if let proto = attributes[kSecAttrProtocol as String] as? String {
                    if let protocolType = ProtocolType(rawValue: proto) {
                        item["protocol"] = protocolType.description
                    }
                }
                if let auth = attributes[kSecAttrAuthenticationType as String] as? String {
                    if let authenticationType = AuthenticationType(rawValue: auth) {
                        item["authenticationType"] = authenticationType.description
                    }
                }
            }
            
            if let key = attributes[kSecAttrAccount as String] as? String {
                item["key"] = key
            }
            if let data = attributes[kSecValueData as String] as? NSData {
                if let text = NSString(data: data, encoding: NSUTF8StringEncoding) as? String {
                    item["value"] = text
                } else  {
                    item["value"] = data
                }
            }
            
            if let accessible = attributes[kSecAttrAccessible as String] as? String {
                if let accessibility = Accessibility(rawValue: accessible) {
                    item["accessibility"] = accessibility.description
                }
            }
            if let synchronizable = attributes[kSecAttrSynchronizable as String] as? Bool {
                item["synchronizable"] = synchronizable ? "true" : "false"
            }

            return item
        }
        return items
    }
    
    // MARK:
    
    private class func conversionError(message message: String) -> NSError {
        let error = NSError(domain: KeychainAccessErrorDomain, code: Int(Status.ConversionError.rawValue), userInfo: [NSLocalizedDescriptionKey: message])
        print("error:[\(error.code)] \(error.localizedDescription)")
        
        return error
    }
    
    private func conversionError(message message: String) -> NSError {
        return self.dynamicType.conversionError(message: message)
    }
    
    private class func securityError(status status: OSStatus) -> NSError {
        let message = Status(rawValue: status)!.description
        
        let error = NSError(domain: KeychainAccessErrorDomain, code: Int(status), userInfo: [NSLocalizedDescriptionKey: message])
        print("OSStatus error:[\(error.code)] \(error.localizedDescription)")
        
        return error
    }
    
    private func securityError(status status: OSStatus) -> NSError {
        return self.dynamicType.securityError(status: status)
    }
}

struct Options {
    var itemClass: ItemClass = .GenericPassword
    
    var service: String = ""
    var accessGroup: String? = nil
    
    var server: NSURL!
    var protocolType: ProtocolType!
    var authenticationType: AuthenticationType = .Default
    
    var accessibility: Accessibility = .AfterFirstUnlock
    var authenticationPolicy: AuthenticationPolicy?
    
    var synchronizable: Bool = false
    
    var label: String?
    var comment: String?
    
    var authenticationPrompt: String?
    
    init() {}
}

extension Keychain : CustomStringConvertible, CustomDebugStringConvertible {
    public var description: String {
        let items = allItems()
        if items.isEmpty {
            return "[]"
        }
        var description = "[\n"
        for item in items {
            description += "  "
            description += "\(item)\n"
        }
        description += "]"
        return description
    }
    
    public var debugDescription: String {
        return "\(items())"
    }
}

extension Options {
    
    func query() -> [String: AnyObject] {
        var query = [String: AnyObject]()
        
        query[kSecClass as String] = itemClass.rawValue
        query[kSecAttrSynchronizable as String] = kSecAttrSynchronizableAny
        
        switch itemClass {
        case .GenericPassword:
            query[kSecAttrService as String] = service
            // Access group is not supported on any simulators.
            #if (!arch(i386) && !arch(x86_64)) || (!os(iOS) && !os(watchOS) && !os(tvOS))
            if let accessGroup = self.accessGroup {
                query[kSecAttrAccessGroup as String] = accessGroup
            }
            #endif
        case .InternetPassword:
            query[kSecAttrServer as String] = server.host
            query[kSecAttrPort as String] = server.port
            query[kSecAttrProtocol as String] = protocolType.rawValue
            query[kSecAttrAuthenticationType as String] = authenticationType.rawValue
        }
        
        #if os(iOS)
        if #available(iOS 8.0, *) {
            if authenticationPrompt != nil {
                query[kSecUseOperationPrompt as String] = authenticationPrompt
            }
        }
        #endif
        
        return query
    }
    
    func attributes(key key: String?, value: NSData) -> ([String: AnyObject], NSError?) {
        var attributes: [String: AnyObject]
        
        if key != nil {
            attributes = query()
            attributes[kSecAttrAccount as String] = key
        } else {
            attributes = [String: AnyObject]()
        }
        
        attributes[kSecValueData as String] = value
        
        if label != nil {
            attributes[kSecAttrLabel as String] = label
        }
        if comment != nil {
            attributes[kSecAttrComment as String] = comment
        }

        if let policy = authenticationPolicy {
            if #available(OSX 10.10, iOS 8.0, *) {
                var error: Unmanaged<CFError>?
                guard let accessControl = SecAccessControlCreateWithFlags(kCFAllocatorDefault, accessibility.rawValue, SecAccessControlCreateFlags(rawValue: policy.rawValue), &error) else {
                    if let error = error?.takeUnretainedValue() {
                        return (attributes, error.error)
                    }
                    let message = Status.UnexpectedError.description
                    return (attributes, NSError(domain: KeychainAccessErrorDomain, code: Int(Status.UnexpectedError.rawValue), userInfo: [NSLocalizedDescriptionKey: message]))
                }
                attributes[kSecAttrAccessControl as String] = accessControl
            } else {
                print("Unavailable 'Touch ID integration' on OS X versions prior to 10.10.")
            }
        } else {
            attributes[kSecAttrAccessible as String] = accessibility.rawValue
        }
        
        attributes[kSecAttrSynchronizable as String] = synchronizable
        
        return (attributes, nil)
    }
}

// MARK:

extension ItemClass : RawRepresentable, CustomStringConvertible {
    
    public init?(rawValue: String) {
        switch rawValue {
        case String(kSecClassGenericPassword):
            self = GenericPassword
        case String(kSecClassInternetPassword):
            self = InternetPassword
        default:
            return nil
        }
    }
    
    public var rawValue: String {
        switch self {
        case GenericPassword:
            return String(kSecClassGenericPassword)
        case InternetPassword:
            return String(kSecClassInternetPassword)
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

extension ProtocolType : RawRepresentable, CustomStringConvertible {
    
    public init?(rawValue: String) {
        switch rawValue {
        case String(kSecAttrProtocolFTP):
            self = FTP
        case String(kSecAttrProtocolFTPAccount):
            self = FTPAccount
        case String(kSecAttrProtocolHTTP):
            self = HTTP
        case String(kSecAttrProtocolIRC):
            self = IRC
        case String(kSecAttrProtocolNNTP):
            self = NNTP
        case String(kSecAttrProtocolPOP3):
            self = POP3
        case String(kSecAttrProtocolSMTP):
            self = SMTP
        case String(kSecAttrProtocolSOCKS):
            self = SOCKS
        case String(kSecAttrProtocolIMAP):
            self = IMAP
        case String(kSecAttrProtocolLDAP):
            self = LDAP
        case String(kSecAttrProtocolAppleTalk):
            self = AppleTalk
        case String(kSecAttrProtocolAFP):
            self = AFP
        case String(kSecAttrProtocolTelnet):
            self = Telnet
        case String(kSecAttrProtocolSSH):
            self = SSH
        case String(kSecAttrProtocolFTPS):
            self = FTPS
        case String(kSecAttrProtocolHTTPS):
            self = HTTPS
        case String(kSecAttrProtocolHTTPProxy):
            self = HTTPProxy
        case String(kSecAttrProtocolHTTPSProxy):
            self = HTTPSProxy
        case String(kSecAttrProtocolFTPProxy):
            self = FTPProxy
        case String(kSecAttrProtocolSMB):
            self = SMB
        case String(kSecAttrProtocolRTSP):
            self = RTSP
        case String(kSecAttrProtocolRTSPProxy):
            self = RTSPProxy
        case String(kSecAttrProtocolDAAP):
            self = DAAP
        case String(kSecAttrProtocolEPPC):
            self = EPPC
        case String(kSecAttrProtocolIPP):
            self = IPP
        case String(kSecAttrProtocolNNTPS):
            self = NNTPS
        case String(kSecAttrProtocolLDAPS):
            self = LDAPS
        case String(kSecAttrProtocolTelnetS):
            self = TelnetS
        case String(kSecAttrProtocolIMAPS):
            self = IMAPS
        case String(kSecAttrProtocolIRCS):
            self = IRCS
        case String(kSecAttrProtocolPOP3S):
            self = POP3S
        default:
            return nil
        }
    }
    
    public var rawValue: String {
        switch self {
        case FTP:
            return kSecAttrProtocolFTP as String
        case FTPAccount:
            return kSecAttrProtocolFTPAccount as String
        case HTTP:
            return kSecAttrProtocolHTTP as String
        case IRC:
            return kSecAttrProtocolIRC as String
        case NNTP:
            return kSecAttrProtocolNNTP as String
        case POP3:
            return kSecAttrProtocolPOP3 as String
        case SMTP:
            return kSecAttrProtocolSMTP as String
        case SOCKS:
            return kSecAttrProtocolSOCKS as String
        case IMAP:
            return kSecAttrProtocolIMAP as String
        case LDAP:
            return kSecAttrProtocolLDAP as String
        case AppleTalk:
            return kSecAttrProtocolAppleTalk as String
        case AFP:
            return kSecAttrProtocolAFP as String
        case Telnet:
            return kSecAttrProtocolTelnet as String
        case SSH:
            return kSecAttrProtocolSSH as String
        case FTPS:
            return kSecAttrProtocolFTPS as String
        case HTTPS:
            return kSecAttrProtocolHTTPS as String
        case HTTPProxy:
            return kSecAttrProtocolHTTPProxy as String
        case HTTPSProxy:
            return kSecAttrProtocolHTTPSProxy as String
        case FTPProxy:
            return kSecAttrProtocolFTPProxy as String
        case SMB:
            return kSecAttrProtocolSMB as String
        case RTSP:
            return kSecAttrProtocolRTSP as String
        case RTSPProxy:
            return kSecAttrProtocolRTSPProxy as String
        case DAAP:
            return kSecAttrProtocolDAAP as String
        case EPPC:
            return kSecAttrProtocolEPPC as String
        case IPP:
            return kSecAttrProtocolIPP as String
        case NNTPS:
            return kSecAttrProtocolNNTPS as String
        case LDAPS:
            return kSecAttrProtocolLDAPS as String
        case TelnetS:
            return kSecAttrProtocolTelnetS as String
        case IMAPS:
            return kSecAttrProtocolIMAPS as String
        case IRCS:
            return kSecAttrProtocolIRCS as String
        case POP3S:
            return kSecAttrProtocolPOP3S as String
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

extension AuthenticationType : RawRepresentable, CustomStringConvertible {
    
    public init?(rawValue: String) {
        switch rawValue {
        case String(kSecAttrAuthenticationTypeNTLM):
            self = NTLM
        case String(kSecAttrAuthenticationTypeMSN):
            self = MSN
        case String(kSecAttrAuthenticationTypeDPA):
            self = DPA
        case String(kSecAttrAuthenticationTypeRPA):
            self = RPA
        case String(kSecAttrAuthenticationTypeHTTPBasic):
            self = HTTPBasic
        case String(kSecAttrAuthenticationTypeHTTPDigest):
            self = HTTPDigest
        case String(kSecAttrAuthenticationTypeHTMLForm):
            self = HTMLForm
        case String(kSecAttrAuthenticationTypeDefault):
            self = Default
        default:
            return nil
        }
    }
    
    public var rawValue: String {
        switch self {
        case NTLM:
            return kSecAttrAuthenticationTypeNTLM as String
        case MSN:
            return kSecAttrAuthenticationTypeMSN as String
        case DPA:
            return kSecAttrAuthenticationTypeDPA as String
        case RPA:
            return kSecAttrAuthenticationTypeRPA as String
        case HTTPBasic:
            return kSecAttrAuthenticationTypeHTTPBasic as String
        case HTTPDigest:
            return kSecAttrAuthenticationTypeHTTPDigest as String
        case HTMLForm:
            return kSecAttrAuthenticationTypeHTMLForm as String
        case Default:
            return kSecAttrAuthenticationTypeDefault as String
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

extension Accessibility : RawRepresentable, CustomStringConvertible {
    
    public init?(rawValue: String) {
        guard #available(OSX 10.10, iOS 8.0, *) else  {
            return nil
        }
        switch rawValue {
        case String(kSecAttrAccessibleWhenUnlocked):
            self = WhenUnlocked
        case String(kSecAttrAccessibleAfterFirstUnlock):
            self = AfterFirstUnlock
        case String(kSecAttrAccessibleAlways):
            self = Always
        case String(kSecAttrAccessibleWhenPasscodeSetThisDeviceOnly):
            self = WhenPasscodeSetThisDeviceOnly
        case String(kSecAttrAccessibleWhenUnlockedThisDeviceOnly):
            self = WhenUnlockedThisDeviceOnly
        case String(kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly):
            self = AfterFirstUnlockThisDeviceOnly
        case String(kSecAttrAccessibleAlwaysThisDeviceOnly):
            self = AlwaysThisDeviceOnly
        default:
            return nil
        }
    }
    
    public var rawValue: String {
        switch self {
        case WhenUnlocked:
            return kSecAttrAccessibleWhenUnlocked as String
        case AfterFirstUnlock:
            return kSecAttrAccessibleAfterFirstUnlock as String
        case Always:
            return kSecAttrAccessibleAlways as String
        case WhenPasscodeSetThisDeviceOnly:
            if #available(OSX 10.10, iOS 8.0, *) {
                return kSecAttrAccessibleWhenPasscodeSetThisDeviceOnly as String
            } else {
                fatalError("Unavailable 'Touch ID integration' on OS X versions prior to 10.10.")
            }
        case WhenUnlockedThisDeviceOnly:
            return kSecAttrAccessibleWhenUnlockedThisDeviceOnly as String
        case AfterFirstUnlockThisDeviceOnly:
            return kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly as String
        case AlwaysThisDeviceOnly:
            return kSecAttrAccessibleAlwaysThisDeviceOnly as String
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

extension AuthenticationPolicy : RawRepresentable, CustomStringConvertible {
    
    public init?(rawValue: Int) {
        guard #available(OSX 10.10, iOS 8.0, *) else  {
            return nil
        }
        let flags = SecAccessControlCreateFlags.UserPresence
        
        switch rawValue {
        case flags.rawValue:
            self = UserPresence
        default:
            return nil
        }
    }
    
    public var rawValue: Int {
        switch self {
        case UserPresence:
            if #available(OSX 10.10, iOS 8.0, *) {
                return SecAccessControlCreateFlags.UserPresence.rawValue
            } else {
                fatalError("Unavailable 'Touch ID integration' on OS X versions prior to 10.10.")
            }
        }
    }
    
    public var description : String {
        switch self {
        case UserPresence:
            return "UserPresence"
        }
    }
}

extension CFError {
    var error: NSError {
        let domain = CFErrorGetDomain(self) as String
        let code = CFErrorGetCode(self)
        let userInfo = CFErrorCopyUserInfo(self) as [NSObject: AnyObject]
        
        return NSError(domain: domain, code: code, userInfo: userInfo)
    }
}

public enum Status : OSStatus, ErrorType {
    case Success
    case Unimplemented
    case Param
    case Allocate
    case NotAvailable
    case ReadOnly
    case AuthFailed
    case NoSuchKeychain
    case InvalidKeychain
    case DuplicateKeychain
    case DuplicateCallback
    case InvalidCallback
    case DuplicateItem
    case ItemNotFound
    case BufferTooSmall
    case DataTooLarge
    case NoSuchAttr
    case InvalidItemRef
    case InvalidSearchRef
    case NoSuchClass
    case NoDefaultKeychain
    case InteractionNotAllowed
    case ReadOnlyAttr
    case WrongSecVersion
    case KeySizeNotAllowed
    case NoStorageModule
    case NoCertificateModule
    case NoPolicyModule
    case InteractionRequired
    case DataNotAvailable
    case DataNotModifiable
    case CreateChainFailed
    case InvalidPrefsDomain
    case ACLNotSimple
    case PolicyNotFound
    case InvalidTrustSetting
    case NoAccessForItem
    case InvalidOwnerEdit
    case TrustNotAvailable
    case UnsupportedFormat
    case UnknownFormat
    case KeyIsSensitive
    case MultiplePrivKeys
    case PassphraseRequired
    case InvalidPasswordRef
    case InvalidTrustSettings
    case NoTrustSettings
    case Pkcs12VerifyFailure
    case InvalidCertificate
    case NotSigner
    case PolicyDenied
    case InvalidKey
    case Decode
    case Internal
    case UnsupportedAlgorithm
    case UnsupportedOperation
    case UnsupportedPadding
    case ItemInvalidKey
    case ItemInvalidKeyType
    case ItemInvalidValue
    case ItemClassMissing
    case ItemMatchUnsupported
    case UseItemListUnsupported
    case UseKeychainUnsupported
    case UseKeychainListUnsupported
    case ReturnDataUnsupported
    case ReturnAttributesUnsupported
    case ReturnRefUnsupported
    case ReturnPersitentRefUnsupported
    case ValueRefUnsupported
    case ValuePersistentRefUnsupported
    case ReturnMissingPointer
    case MatchLimitUnsupported
    case ItemIllegalQuery
    case WaitForCallback
    case MissingEntitlement
    case UpgradePending
    case MPSignatureInvalid
    case OTRTooOld
    case OTRIDTooNew
    case ServiceNotAvailable
    case InsufficientClientID
    case DeviceReset
    case DeviceFailed
    case AppleAddAppACLSubject
    case ApplePublicKeyIncomplete
    case AppleSignatureMismatch
    case AppleInvalidKeyStartDate
    case AppleInvalidKeyEndDate
    case ConversionError
    case AppleSSLv2Rollback
    case DiskFull
    case QuotaExceeded
    case FileTooBig
    case InvalidDatabaseBlob
    case InvalidKeyBlob
    case IncompatibleDatabaseBlob
    case IncompatibleKeyBlob
    case HostNameMismatch
    case UnknownCriticalExtensionFlag
    case NoBasicConstraints
    case NoBasicConstraintsCA
    case InvalidAuthorityKeyID
    case InvalidSubjectKeyID
    case InvalidKeyUsageForPolicy
    case InvalidExtendedKeyUsage
    case InvalidIDLinkage
    case PathLengthConstraintExceeded
    case InvalidRoot
    case CRLExpired
    case CRLNotValidYet
    case CRLNotFound
    case CRLServerDown
    case CRLBadURI
    case UnknownCertExtension
    case UnknownCRLExtension
    case CRLNotTrusted
    case CRLPolicyFailed
    case IDPFailure
    case SMIMEEmailAddressesNotFound
    case SMIMEBadExtendedKeyUsage
    case SMIMEBadKeyUsage
    case SMIMEKeyUsageNotCritical
    case SMIMENoEmailAddress
    case SMIMESubjAltNameNotCritical
    case SSLBadExtendedKeyUsage
    case OCSPBadResponse
    case OCSPBadRequest
    case OCSPUnavailable
    case OCSPStatusUnrecognized
    case EndOfData
    case IncompleteCertRevocationCheck
    case NetworkFailure
    case OCSPNotTrustedToAnchor
    case RecordModified
    case OCSPSignatureError
    case OCSPNoSigner
    case OCSPResponderMalformedReq
    case OCSPResponderInternalError
    case OCSPResponderTryLater
    case OCSPResponderSignatureRequired
    case OCSPResponderUnauthorized
    case OCSPResponseNonceMismatch
    case CodeSigningBadCertChainLength
    case CodeSigningNoBasicConstraints
    case CodeSigningBadPathLengthConstraint
    case CodeSigningNoExtendedKeyUsage
    case CodeSigningDevelopment
    case ResourceSignBadCertChainLength
    case ResourceSignBadExtKeyUsage
    case TrustSettingDeny
    case InvalidSubjectName
    case UnknownQualifiedCertStatement
    case MobileMeRequestQueued
    case MobileMeRequestRedirected
    case MobileMeServerError
    case MobileMeServerNotAvailable
    case MobileMeServerAlreadyExists
    case MobileMeServerServiceErr
    case MobileMeRequestAlreadyPending
    case MobileMeNoRequestPending
    case MobileMeCSRVerifyFailure
    case MobileMeFailedConsistencyCheck
    case NotInitialized
    case InvalidHandleUsage
    case PVCReferentNotFound
    case FunctionIntegrityFail
    case InternalError
    case MemoryError
    case InvalidData
    case MDSError
    case InvalidPointer
    case SelfCheckFailed
    case FunctionFailed
    case ModuleManifestVerifyFailed
    case InvalidGUID
    case InvalidHandle
    case InvalidDBList
    case InvalidPassthroughID
    case InvalidNetworkAddress
    case CRLAlreadySigned
    case InvalidNumberOfFields
    case VerificationFailure
    case UnknownTag
    case InvalidSignature
    case InvalidName
    case InvalidCertificateRef
    case InvalidCertificateGroup
    case TagNotFound
    case InvalidQuery
    case InvalidValue
    case CallbackFailed
    case ACLDeleteFailed
    case ACLReplaceFailed
    case ACLAddFailed
    case ACLChangeFailed
    case InvalidAccessCredentials
    case InvalidRecord
    case InvalidACL
    case InvalidSampleValue
    case IncompatibleVersion
    case PrivilegeNotGranted
    case InvalidScope
    case PVCAlreadyConfigured
    case InvalidPVC
    case EMMLoadFailed
    case EMMUnloadFailed
    case AddinLoadFailed
    case InvalidKeyRef
    case InvalidKeyHierarchy
    case AddinUnloadFailed
    case LibraryReferenceNotFound
    case InvalidAddinFunctionTable
    case InvalidServiceMask
    case ModuleNotLoaded
    case InvalidSubServiceID
    case AttributeNotInContext
    case ModuleManagerInitializeFailed
    case ModuleManagerNotFound
    case EventNotificationCallbackNotFound
    case InputLengthError
    case OutputLengthError
    case PrivilegeNotSupported
    case DeviceError
    case AttachHandleBusy
    case NotLoggedIn
    case AlgorithmMismatch
    case KeyUsageIncorrect
    case KeyBlobTypeIncorrect
    case KeyHeaderInconsistent
    case UnsupportedKeyFormat
    case UnsupportedKeySize
    case InvalidKeyUsageMask
    case UnsupportedKeyUsageMask
    case InvalidKeyAttributeMask
    case UnsupportedKeyAttributeMask
    case InvalidKeyLabel
    case UnsupportedKeyLabel
    case InvalidKeyFormat
    case UnsupportedVectorOfBuffers
    case InvalidInputVector
    case InvalidOutputVector
    case InvalidContext
    case InvalidAlgorithm
    case InvalidAttributeKey
    case MissingAttributeKey
    case InvalidAttributeInitVector
    case MissingAttributeInitVector
    case InvalidAttributeSalt
    case MissingAttributeSalt
    case InvalidAttributePadding
    case MissingAttributePadding
    case InvalidAttributeRandom
    case MissingAttributeRandom
    case InvalidAttributeSeed
    case MissingAttributeSeed
    case InvalidAttributePassphrase
    case MissingAttributePassphrase
    case InvalidAttributeKeyLength
    case MissingAttributeKeyLength
    case InvalidAttributeBlockSize
    case MissingAttributeBlockSize
    case InvalidAttributeOutputSize
    case MissingAttributeOutputSize
    case InvalidAttributeRounds
    case MissingAttributeRounds
    case InvalidAlgorithmParms
    case MissingAlgorithmParms
    case InvalidAttributeLabel
    case MissingAttributeLabel
    case InvalidAttributeKeyType
    case MissingAttributeKeyType
    case InvalidAttributeMode
    case MissingAttributeMode
    case InvalidAttributeEffectiveBits
    case MissingAttributeEffectiveBits
    case InvalidAttributeStartDate
    case MissingAttributeStartDate
    case InvalidAttributeEndDate
    case MissingAttributeEndDate
    case InvalidAttributeVersion
    case MissingAttributeVersion
    case InvalidAttributePrime
    case MissingAttributePrime
    case InvalidAttributeBase
    case MissingAttributeBase
    case InvalidAttributeSubprime
    case MissingAttributeSubprime
    case InvalidAttributeIterationCount
    case MissingAttributeIterationCount
    case InvalidAttributeDLDBHandle
    case MissingAttributeDLDBHandle
    case InvalidAttributeAccessCredentials
    case MissingAttributeAccessCredentials
    case InvalidAttributePublicKeyFormat
    case MissingAttributePublicKeyFormat
    case InvalidAttributePrivateKeyFormat
    case MissingAttributePrivateKeyFormat
    case InvalidAttributeSymmetricKeyFormat
    case MissingAttributeSymmetricKeyFormat
    case InvalidAttributeWrappedKeyFormat
    case MissingAttributeWrappedKeyFormat
    case StagedOperationInProgress
    case StagedOperationNotStarted
    case VerifyFailed
    case QuerySizeUnknown
    case BlockSizeMismatch
    case PublicKeyInconsistent
    case DeviceVerifyFailed
    case InvalidLoginName
    case AlreadyLoggedIn
    case InvalidDigestAlgorithm
    case InvalidCRLGroup
    case CertificateCannotOperate
    case CertificateExpired
    case CertificateNotValidYet
    case CertificateRevoked
    case CertificateSuspended
    case InsufficientCredentials
    case InvalidAction
    case InvalidAuthority
    case VerifyActionFailed
    case InvalidCertAuthority
    case InvaldCRLAuthority
    case InvalidCRLEncoding
    case InvalidCRLType
    case InvalidCRL
    case InvalidFormType
    case InvalidID
    case InvalidIdentifier
    case InvalidIndex
    case InvalidPolicyIdentifiers
    case InvalidTimeString
    case InvalidReason
    case InvalidRequestInputs
    case InvalidResponseVector
    case InvalidStopOnPolicy
    case InvalidTuple
    case MultipleValuesUnsupported
    case NotTrusted
    case NoDefaultAuthority
    case RejectedForm
    case RequestLost
    case RequestRejected
    case UnsupportedAddressType
    case UnsupportedService
    case InvalidTupleGroup
    case InvalidBaseACLs
    case InvalidTupleCredendtials
    case InvalidEncoding
    case InvalidValidityPeriod
    case InvalidRequestor
    case RequestDescriptor
    case InvalidBundleInfo
    case InvalidCRLIndex
    case NoFieldValues
    case UnsupportedFieldFormat
    case UnsupportedIndexInfo
    case UnsupportedLocality
    case UnsupportedNumAttributes
    case UnsupportedNumIndexes
    case UnsupportedNumRecordTypes
    case FieldSpecifiedMultiple
    case IncompatibleFieldFormat
    case InvalidParsingModule
    case DatabaseLocked
    case DatastoreIsOpen
    case MissingValue
    case UnsupportedQueryLimits
    case UnsupportedNumSelectionPreds
    case UnsupportedOperator
    case InvalidDBLocation
    case InvalidAccessRequest
    case InvalidIndexInfo
    case InvalidNewOwner
    case InvalidModifyMode
    case UnexpectedError
}

extension Status : RawRepresentable, CustomStringConvertible {
    
    public init?(rawValue: OSStatus) {
        switch rawValue {
        case 0:
            self = Success
        case -4:
            self = Unimplemented
        case -50:
            self = Param
        case -108:
            self = Allocate
        case -25291:
            self = NotAvailable
        case -25292:
            self = ReadOnly
        case -25293:
            self = AuthFailed
        case -25294:
            self = NoSuchKeychain
        case -25295:
            self = InvalidKeychain
        case -25296:
            self = DuplicateKeychain
        case -25297:
            self = DuplicateCallback
        case -25298:
            self = InvalidCallback
        case -25299:
            self = DuplicateItem
        case -25300:
            self = ItemNotFound
        case -25301:
            self = BufferTooSmall
        case -25302:
            self = DataTooLarge
        case -25303:
            self = NoSuchAttr
        case -25304:
            self = InvalidItemRef
        case -25305:
            self = InvalidSearchRef
        case -25306:
            self = NoSuchClass
        case -25307:
            self = NoDefaultKeychain
        case -25308:
            self = InteractionNotAllowed
        case -25309:
            self = ReadOnlyAttr
        case -25310:
            self = WrongSecVersion
        case -25311:
            self = KeySizeNotAllowed
        case -25312:
            self = NoStorageModule
        case -25313:
            self = NoCertificateModule
        case -25314:
            self = NoPolicyModule
        case -25315:
            self = InteractionRequired
        case -25316:
            self = DataNotAvailable
        case -25317:
            self = DataNotModifiable
        case -25318:
            self = CreateChainFailed
        case -25319:
            self = InvalidPrefsDomain
        case -25240:
            self = ACLNotSimple
        case -25241:
            self = PolicyNotFound
        case -25242:
            self = InvalidTrustSetting
        case -25243:
            self = NoAccessForItem
        case -25244:
            self = InvalidOwnerEdit
        case -25245:
            self = TrustNotAvailable
        case -25256:
            self = UnsupportedFormat
        case -25257:
            self = UnknownFormat
        case -25258:
            self = KeyIsSensitive
        case -25259:
            self = MultiplePrivKeys
        case -25260:
            self = PassphraseRequired
        case -25261:
            self = InvalidPasswordRef
        case -25262:
            self = InvalidTrustSettings
        case -25263:
            self = NoTrustSettings
        case -25264:
            self = Pkcs12VerifyFailure
        case -26265:
            self = InvalidCertificate
        case -26267:
            self = NotSigner
        case -26270:
            self = PolicyDenied
        case -26274:
            self = InvalidKey
        case -26275:
            self = Decode
        case -26276:
            self = Internal
        case -26268:
            self = UnsupportedAlgorithm
        case -26271:
            self = UnsupportedOperation
        case -26273:
            self = UnsupportedPadding
        case -34000:
            self = ItemInvalidKey
        case -34001:
            self = ItemInvalidKeyType
        case -34002:
            self = ItemInvalidValue
        case -34003:
            self = ItemClassMissing
        case -34004:
            self = ItemMatchUnsupported
        case -34005:
            self = UseItemListUnsupported
        case -34006:
            self = UseKeychainUnsupported
        case -34007:
            self = UseKeychainListUnsupported
        case -34008:
            self = ReturnDataUnsupported
        case -34009:
            self = ReturnAttributesUnsupported
        case -34010:
            self = ReturnRefUnsupported
        case -34011:
            self = ReturnPersitentRefUnsupported
        case -34012:
            self = ValueRefUnsupported
        case -34013:
            self = ValuePersistentRefUnsupported
        case -34014:
            self = ReturnMissingPointer
        case -34015:
            self = MatchLimitUnsupported
        case -34016:
            self = ItemIllegalQuery
        case -34017:
            self = WaitForCallback
        case -34018:
            self = MissingEntitlement
        case -34019:
            self = UpgradePending
        case -25327:
            self = MPSignatureInvalid
        case -25328:
            self = OTRTooOld
        case -25329:
            self = OTRIDTooNew
        case -67585:
            self = ServiceNotAvailable
        case -67586:
            self = InsufficientClientID
        case -67587:
            self = DeviceReset
        case -67588:
            self = DeviceFailed
        case -67589:
            self = AppleAddAppACLSubject
        case -67590:
            self = ApplePublicKeyIncomplete
        case -67591:
            self = AppleSignatureMismatch
        case -67592:
            self = AppleInvalidKeyStartDate
        case -67593:
            self = AppleInvalidKeyEndDate
        case -67594:
            self = ConversionError
        case -67595:
            self = AppleSSLv2Rollback
        case -34:
            self = DiskFull
        case -67596:
            self = QuotaExceeded
        case -67597:
            self = FileTooBig
        case -67598:
            self = InvalidDatabaseBlob
        case -67599:
            self = InvalidKeyBlob
        case -67600:
            self = IncompatibleDatabaseBlob
        case -67601:
            self = IncompatibleKeyBlob
        case -67602:
            self = HostNameMismatch
        case -67603:
            self = UnknownCriticalExtensionFlag
        case -67604:
            self = NoBasicConstraints
        case -67605:
            self = NoBasicConstraintsCA
        case -67606:
            self = InvalidAuthorityKeyID
        case -67607:
            self = InvalidSubjectKeyID
        case -67608:
            self = InvalidKeyUsageForPolicy
        case -67609:
            self = InvalidExtendedKeyUsage
        case -67610:
            self = InvalidIDLinkage
        case -67611:
            self = PathLengthConstraintExceeded
        case -67612:
            self = InvalidRoot
        case -67613:
            self = CRLExpired
        case -67614:
            self = CRLNotValidYet
        case -67615:
            self = CRLNotFound
        case -67616:
            self = CRLServerDown
        case -67617:
            self = CRLBadURI
        case -67618:
            self = UnknownCertExtension
        case -67619:
            self = UnknownCRLExtension
        case -67620:
            self = CRLNotTrusted
        case -67621:
            self = CRLPolicyFailed
        case -67622:
            self = IDPFailure
        case -67623:
            self = SMIMEEmailAddressesNotFound
        case -67624:
            self = SMIMEBadExtendedKeyUsage
        case -67625:
            self = SMIMEBadKeyUsage
        case -67626:
            self = SMIMEKeyUsageNotCritical
        case -67627:
            self = SMIMENoEmailAddress
        case -67628:
            self = SMIMESubjAltNameNotCritical
        case -67629:
            self = SSLBadExtendedKeyUsage
        case -67630:
            self = OCSPBadResponse
        case -67631:
            self = OCSPBadRequest
        case -67632:
            self = OCSPUnavailable
        case -67633:
            self = OCSPStatusUnrecognized
        case -67634:
            self = EndOfData
        case -67635:
            self = IncompleteCertRevocationCheck
        case -67636:
            self = NetworkFailure
        case -67637:
            self = OCSPNotTrustedToAnchor
        case -67638:
            self = RecordModified
        case -67639:
            self = OCSPSignatureError
        case -67640:
            self = OCSPNoSigner
        case -67641:
            self = OCSPResponderMalformedReq
        case -67642:
            self = OCSPResponderInternalError
        case -67643:
            self = OCSPResponderTryLater
        case -67644:
            self = OCSPResponderSignatureRequired
        case -67645:
            self = OCSPResponderUnauthorized
        case -67646:
            self = OCSPResponseNonceMismatch
        case -67647:
            self = CodeSigningBadCertChainLength
        case -67648:
            self = CodeSigningNoBasicConstraints
        case -67649:
            self = CodeSigningBadPathLengthConstraint
        case -67650:
            self = CodeSigningNoExtendedKeyUsage
        case -67651:
            self = CodeSigningDevelopment
        case -67652:
            self = ResourceSignBadCertChainLength
        case -67653:
            self = ResourceSignBadExtKeyUsage
        case -67654:
            self = TrustSettingDeny
        case -67655:
            self = InvalidSubjectName
        case -67656:
            self = UnknownQualifiedCertStatement
        case -67657:
            self = MobileMeRequestQueued
        case -67658:
            self = MobileMeRequestRedirected
        case -67659:
            self = MobileMeServerError
        case -67660:
            self = MobileMeServerNotAvailable
        case -67661:
            self = MobileMeServerAlreadyExists
        case -67662:
            self = MobileMeServerServiceErr
        case -67663:
            self = MobileMeRequestAlreadyPending
        case -67664:
            self = MobileMeNoRequestPending
        case -67665:
            self = MobileMeCSRVerifyFailure
        case -67666:
            self = MobileMeFailedConsistencyCheck
        case -67667:
            self = NotInitialized
        case -67668:
            self = InvalidHandleUsage
        case -67669:
            self = PVCReferentNotFound
        case -67670:
            self = FunctionIntegrityFail
        case -67671:
            self = InternalError
        case -67672:
            self = MemoryError
        case -67673:
            self = InvalidData
        case -67674:
            self = MDSError
        case -67675:
            self = InvalidPointer
        case -67676:
            self = SelfCheckFailed
        case -67677:
            self = FunctionFailed
        case -67678:
            self = ModuleManifestVerifyFailed
        case -67679:
            self = InvalidGUID
        case -67680:
            self = InvalidHandle
        case -67681:
            self = InvalidDBList
        case -67682:
            self = InvalidPassthroughID
        case -67683:
            self = InvalidNetworkAddress
        case -67684:
            self = CRLAlreadySigned
        case -67685:
            self = InvalidNumberOfFields
        case -67686:
            self = VerificationFailure
        case -67687:
            self = UnknownTag
        case -67688:
            self = InvalidSignature
        case -67689:
            self = InvalidName
        case -67690:
            self = InvalidCertificateRef
        case -67691:
            self = InvalidCertificateGroup
        case -67692:
            self = TagNotFound
        case -67693:
            self = InvalidQuery
        case -67694:
            self = InvalidValue
        case -67695:
            self = CallbackFailed
        case -67696:
            self = ACLDeleteFailed
        case -67697:
            self = ACLReplaceFailed
        case -67698:
            self = ACLAddFailed
        case -67699:
            self = ACLChangeFailed
        case -67700:
            self = InvalidAccessCredentials
        case -67701:
            self = InvalidRecord
        case -67702:
            self = InvalidACL
        case -67703:
            self = InvalidSampleValue
        case -67704:
            self = IncompatibleVersion
        case -67705:
            self = PrivilegeNotGranted
        case -67706:
            self = InvalidScope
        case -67707:
            self = PVCAlreadyConfigured
        case -67708:
            self = InvalidPVC
        case -67709:
            self = EMMLoadFailed
        case -67710:
            self = EMMUnloadFailed
        case -67711:
            self = AddinLoadFailed
        case -67712:
            self = InvalidKeyRef
        case -67713:
            self = InvalidKeyHierarchy
        case -67714:
            self = AddinUnloadFailed
        case -67715:
            self = LibraryReferenceNotFound
        case -67716:
            self = InvalidAddinFunctionTable
        case -67717:
            self = InvalidServiceMask
        case -67718:
            self = ModuleNotLoaded
        case -67719:
            self = InvalidSubServiceID
        case -67720:
            self = AttributeNotInContext
        case -67721:
            self = ModuleManagerInitializeFailed
        case -67722:
            self = ModuleManagerNotFound
        case -67723:
            self = EventNotificationCallbackNotFound
        case -67724:
            self = InputLengthError
        case -67725:
            self = OutputLengthError
        case -67726:
            self = PrivilegeNotSupported
        case -67727:
            self = DeviceError
        case -67728:
            self = AttachHandleBusy
        case -67729:
            self = NotLoggedIn
        case -67730:
            self = AlgorithmMismatch
        case -67731:
            self = KeyUsageIncorrect
        case -67732:
            self = KeyBlobTypeIncorrect
        case -67733:
            self = KeyHeaderInconsistent
        case -67734:
            self = UnsupportedKeyFormat
        case -67735:
            self = UnsupportedKeySize
        case -67736:
            self = InvalidKeyUsageMask
        case -67737:
            self = UnsupportedKeyUsageMask
        case -67738:
            self = InvalidKeyAttributeMask
        case -67739:
            self = UnsupportedKeyAttributeMask
        case -67740:
            self = InvalidKeyLabel
        case -67741:
            self = UnsupportedKeyLabel
        case -67742:
            self = InvalidKeyFormat
        case -67743:
            self = UnsupportedVectorOfBuffers
        case -67744:
            self = InvalidInputVector
        case -67745:
            self = InvalidOutputVector
        case -67746:
            self = InvalidContext
        case -67747:
            self = InvalidAlgorithm
        case -67748:
            self = InvalidAttributeKey
        case -67749:
            self = MissingAttributeKey
        case -67750:
            self = InvalidAttributeInitVector
        case -67751:
            self = MissingAttributeInitVector
        case -67752:
            self = InvalidAttributeSalt
        case -67753:
            self = MissingAttributeSalt
        case -67754:
            self = InvalidAttributePadding
        case -67755:
            self = MissingAttributePadding
        case -67756:
            self = InvalidAttributeRandom
        case -67757:
            self = MissingAttributeRandom
        case -67758:
            self = InvalidAttributeSeed
        case -67759:
            self = MissingAttributeSeed
        case -67760:
            self = InvalidAttributePassphrase
        case -67761:
            self = MissingAttributePassphrase
        case -67762:
            self = InvalidAttributeKeyLength
        case -67763:
            self = MissingAttributeKeyLength
        case -67764:
            self = InvalidAttributeBlockSize
        case -67765:
            self = MissingAttributeBlockSize
        case -67766:
            self = InvalidAttributeOutputSize
        case -67767:
            self = MissingAttributeOutputSize
        case -67768:
            self = InvalidAttributeRounds
        case -67769:
            self = MissingAttributeRounds
        case -67770:
            self = InvalidAlgorithmParms
        case -67771:
            self = MissingAlgorithmParms
        case -67772:
            self = InvalidAttributeLabel
        case -67773:
            self = MissingAttributeLabel
        case -67774:
            self = InvalidAttributeKeyType
        case -67775:
            self = MissingAttributeKeyType
        case -67776:
            self = InvalidAttributeMode
        case -67777:
            self = MissingAttributeMode
        case -67778:
            self = InvalidAttributeEffectiveBits
        case -67779:
            self = MissingAttributeEffectiveBits
        case -67780:
            self = InvalidAttributeStartDate
        case -67781:
            self = MissingAttributeStartDate
        case -67782:
            self = InvalidAttributeEndDate
        case -67783:
            self = MissingAttributeEndDate
        case -67784:
            self = InvalidAttributeVersion
        case -67785:
            self = MissingAttributeVersion
        case -67786:
            self = InvalidAttributePrime
        case -67787:
            self = MissingAttributePrime
        case -67788:
            self = InvalidAttributeBase
        case -67789:
            self = MissingAttributeBase
        case -67790:
            self = InvalidAttributeSubprime
        case -67791:
            self = MissingAttributeSubprime
        case -67792:
            self = InvalidAttributeIterationCount
        case -67793:
            self = MissingAttributeIterationCount
        case -67794:
            self = InvalidAttributeDLDBHandle
        case -67795:
            self = MissingAttributeDLDBHandle
        case -67796:
            self = InvalidAttributeAccessCredentials
        case -67797:
            self = MissingAttributeAccessCredentials
        case -67798:
            self = InvalidAttributePublicKeyFormat
        case -67799:
            self = MissingAttributePublicKeyFormat
        case -67800:
            self = InvalidAttributePrivateKeyFormat
        case -67801:
            self = MissingAttributePrivateKeyFormat
        case -67802:
            self = InvalidAttributeSymmetricKeyFormat
        case -67803:
            self = MissingAttributeSymmetricKeyFormat
        case -67804:
            self = InvalidAttributeWrappedKeyFormat
        case -67805:
            self = MissingAttributeWrappedKeyFormat
        case -67806:
            self = StagedOperationInProgress
        case -67807:
            self = StagedOperationNotStarted
        case -67808:
            self = VerifyFailed
        case -67809:
            self = QuerySizeUnknown
        case -67810:
            self = BlockSizeMismatch
        case -67811:
            self = PublicKeyInconsistent
        case -67812:
            self = DeviceVerifyFailed
        case -67813:
            self = InvalidLoginName
        case -67814:
            self = AlreadyLoggedIn
        case -67815:
            self = InvalidDigestAlgorithm
        case -67816:
            self = InvalidCRLGroup
        case -67817:
            self = CertificateCannotOperate
        case -67818:
            self = CertificateExpired
        case -67819:
            self = CertificateNotValidYet
        case -67820:
            self = CertificateRevoked
        case -67821:
            self = CertificateSuspended
        case -67822:
            self = InsufficientCredentials
        case -67823:
            self = InvalidAction
        case -67824:
            self = InvalidAuthority
        case -67825:
            self = VerifyActionFailed
        case -67826:
            self = InvalidCertAuthority
        case -67827:
            self = InvaldCRLAuthority
        case -67828:
            self = InvalidCRLEncoding
        case -67829:
            self = InvalidCRLType
        case -67830:
            self = InvalidCRL
        case -67831:
            self = InvalidFormType
        case -67832:
            self = InvalidID
        case -67833:
            self = InvalidIdentifier
        case -67834:
            self = InvalidIndex
        case -67835:
            self = InvalidPolicyIdentifiers
        case -67836:
            self = InvalidTimeString
        case -67837:
            self = InvalidReason
        case -67838:
            self = InvalidRequestInputs
        case -67839:
            self = InvalidResponseVector
        case -67840:
            self = InvalidStopOnPolicy
        case -67841:
            self = InvalidTuple
        case -67842:
            self = MultipleValuesUnsupported
        case -67843:
            self = NotTrusted
        case -67844:
            self = NoDefaultAuthority
        case -67845:
            self = RejectedForm
        case -67846:
            self = RequestLost
        case -67847:
            self = RequestRejected
        case -67848:
            self = UnsupportedAddressType
        case -67849:
            self = UnsupportedService
        case -67850:
            self = InvalidTupleGroup
        case -67851:
            self = InvalidBaseACLs
        case -67852:
            self = InvalidTupleCredendtials
        case -67853:
            self = InvalidEncoding
        case -67854:
            self = InvalidValidityPeriod
        case -67855:
            self = InvalidRequestor
        case -67856:
            self = RequestDescriptor
        case -67857:
            self = InvalidBundleInfo
        case -67858:
            self = InvalidCRLIndex
        case -67859:
            self = NoFieldValues
        case -67860:
            self = UnsupportedFieldFormat
        case -67861:
            self = UnsupportedIndexInfo
        case -67862:
            self = UnsupportedLocality
        case -67863:
            self = UnsupportedNumAttributes
        case -67864:
            self = UnsupportedNumIndexes
        case -67865:
            self = UnsupportedNumRecordTypes
        case -67866:
            self = FieldSpecifiedMultiple
        case -67867:
            self = IncompatibleFieldFormat
        case -67868:
            self = InvalidParsingModule
        case -67869:
            self = DatabaseLocked
        case -67870:
            self = DatastoreIsOpen
        case -67871:
            self = MissingValue
        case -67872:
            self = UnsupportedQueryLimits
        case -67873:
            self = UnsupportedNumSelectionPreds
        case -67874:
            self = UnsupportedOperator
        case -67875:
            self = InvalidDBLocation
        case -67876:
            self = InvalidAccessRequest
        case -67877:
            self = InvalidIndexInfo
        case -67878:
            self = InvalidNewOwner
        case -67879:
            self = InvalidModifyMode
        default:
            self = UnexpectedError
        }
    }
    
    public var rawValue: OSStatus {
        switch self {
        case Success:
            return 0
        case Unimplemented:
            return -4
        case Param:
            return -50
        case Allocate:
            return -108
        case NotAvailable:
            return -25291
        case ReadOnly:
            return -25292
        case AuthFailed:
            return -25293
        case NoSuchKeychain:
            return -25294
        case InvalidKeychain:
            return -25295
        case DuplicateKeychain:
            return -25296
        case DuplicateCallback:
            return -25297
        case InvalidCallback:
            return -25298
        case DuplicateItem:
            return -25299
        case ItemNotFound:
            return -25300
        case BufferTooSmall:
            return -25301
        case DataTooLarge:
            return -25302
        case NoSuchAttr:
            return -25303
        case InvalidItemRef:
            return -25304
        case InvalidSearchRef:
            return -25305
        case NoSuchClass:
            return -25306
        case NoDefaultKeychain:
            return -25307
        case InteractionNotAllowed:
            return -25308
        case ReadOnlyAttr:
            return -25309
        case WrongSecVersion:
            return -25310
        case KeySizeNotAllowed:
            return -25311
        case NoStorageModule:
            return -25312
        case NoCertificateModule:
            return -25313
        case NoPolicyModule:
            return -25314
        case InteractionRequired:
            return -25315
        case DataNotAvailable:
            return -25316
        case DataNotModifiable:
            return -25317
        case CreateChainFailed:
            return -25318
        case InvalidPrefsDomain:
            return -25319
        case ACLNotSimple:
            return -25240
        case PolicyNotFound:
            return -25241
        case InvalidTrustSetting:
            return -25242
        case NoAccessForItem:
            return -25243
        case InvalidOwnerEdit:
            return -25244
        case TrustNotAvailable:
            return -25245
        case UnsupportedFormat:
            return -25256
        case UnknownFormat:
            return -25257
        case KeyIsSensitive:
            return -25258
        case MultiplePrivKeys:
            return -25259
        case PassphraseRequired:
            return -25260
        case InvalidPasswordRef:
            return -25261
        case InvalidTrustSettings:
            return -25262
        case NoTrustSettings:
            return -25263
        case Pkcs12VerifyFailure:
            return -25264
        case InvalidCertificate:
            return -26265
        case NotSigner:
            return -26267
        case PolicyDenied:
            return -26270
        case InvalidKey:
            return -26274
        case Decode:
            return -26275
        case Internal:
            return -26276
        case UnsupportedAlgorithm:
            return -26268
        case UnsupportedOperation:
            return -26271
        case UnsupportedPadding:
            return -26273
        case ItemInvalidKey:
            return -34000
        case ItemInvalidKeyType:
            return -34001
        case ItemInvalidValue:
            return -34002
        case ItemClassMissing:
            return -34003
        case ItemMatchUnsupported:
            return -34004
        case UseItemListUnsupported:
            return -34005
        case UseKeychainUnsupported:
            return -34006
        case UseKeychainListUnsupported:
            return -34007
        case ReturnDataUnsupported:
            return -34008
        case ReturnAttributesUnsupported:
            return -34009
        case ReturnRefUnsupported:
            return -34010
        case ReturnPersitentRefUnsupported:
            return -34011
        case ValueRefUnsupported:
            return -34012
        case ValuePersistentRefUnsupported:
            return -34013
        case ReturnMissingPointer:
            return -34014
        case MatchLimitUnsupported:
            return -34015
        case ItemIllegalQuery:
            return -34016
        case WaitForCallback:
            return -34017
        case MissingEntitlement:
            return -34018
        case UpgradePending:
            return -34019
        case MPSignatureInvalid:
            return -25327
        case OTRTooOld:
            return -25328
        case OTRIDTooNew:
            return -25329
        case ServiceNotAvailable:
            return -67585
        case InsufficientClientID:
            return -67586
        case DeviceReset:
            return -67587
        case DeviceFailed:
            return -67588
        case AppleAddAppACLSubject:
            return -67589
        case ApplePublicKeyIncomplete:
            return -67590
        case AppleSignatureMismatch:
            return -67591
        case AppleInvalidKeyStartDate:
            return -67592
        case AppleInvalidKeyEndDate:
            return -67593
        case ConversionError:
            return -67594
        case AppleSSLv2Rollback:
            return -67595
        case DiskFull:
            return -34
        case QuotaExceeded:
            return -67596
        case FileTooBig:
            return -67597
        case InvalidDatabaseBlob:
            return -67598
        case InvalidKeyBlob:
            return -67599
        case IncompatibleDatabaseBlob:
            return -67600
        case IncompatibleKeyBlob:
            return -67601
        case HostNameMismatch:
            return -67602
        case UnknownCriticalExtensionFlag:
            return -67603
        case NoBasicConstraints:
            return -67604
        case NoBasicConstraintsCA:
            return -67605
        case InvalidAuthorityKeyID:
            return -67606
        case InvalidSubjectKeyID:
            return -67607
        case InvalidKeyUsageForPolicy:
            return -67608
        case InvalidExtendedKeyUsage:
            return -67609
        case InvalidIDLinkage:
            return -67610
        case PathLengthConstraintExceeded:
            return -67611
        case InvalidRoot:
            return -67612
        case CRLExpired:
            return -67613
        case CRLNotValidYet:
            return -67614
        case CRLNotFound:
            return -67615
        case CRLServerDown:
            return -67616
        case CRLBadURI:
            return -67617
        case UnknownCertExtension:
            return -67618
        case UnknownCRLExtension:
            return -67619
        case CRLNotTrusted:
            return -67620
        case CRLPolicyFailed:
            return -67621
        case IDPFailure:
            return -67622
        case SMIMEEmailAddressesNotFound:
            return -67623
        case SMIMEBadExtendedKeyUsage:
            return -67624
        case SMIMEBadKeyUsage:
            return -67625
        case SMIMEKeyUsageNotCritical:
            return -67626
        case SMIMENoEmailAddress:
            return -67627
        case SMIMESubjAltNameNotCritical:
            return -67628
        case SSLBadExtendedKeyUsage:
            return -67629
        case OCSPBadResponse:
            return -67630
        case OCSPBadRequest:
            return -67631
        case OCSPUnavailable:
            return -67632
        case OCSPStatusUnrecognized:
            return -67633
        case EndOfData:
            return -67634
        case IncompleteCertRevocationCheck:
            return -67635
        case NetworkFailure:
            return -67636
        case OCSPNotTrustedToAnchor:
            return -67637
        case RecordModified:
            return -67638
        case OCSPSignatureError:
            return -67639
        case OCSPNoSigner:
            return -67640
        case OCSPResponderMalformedReq:
            return -67641
        case OCSPResponderInternalError:
            return -67642
        case OCSPResponderTryLater:
            return -67643
        case OCSPResponderSignatureRequired:
            return -67644
        case OCSPResponderUnauthorized:
            return -67645
        case OCSPResponseNonceMismatch:
            return -67646
        case CodeSigningBadCertChainLength:
            return -67647
        case CodeSigningNoBasicConstraints:
            return -67648
        case CodeSigningBadPathLengthConstraint:
            return -67649
        case CodeSigningNoExtendedKeyUsage:
            return -67650
        case CodeSigningDevelopment:
            return -67651
        case ResourceSignBadCertChainLength:
            return -67652
        case ResourceSignBadExtKeyUsage:
            return -67653
        case TrustSettingDeny:
            return -67654
        case InvalidSubjectName:
            return -67655
        case UnknownQualifiedCertStatement:
            return -67656
        case MobileMeRequestQueued:
            return -67657
        case MobileMeRequestRedirected:
            return -67658
        case MobileMeServerError:
            return -67659
        case MobileMeServerNotAvailable:
            return -67660
        case MobileMeServerAlreadyExists:
            return -67661
        case MobileMeServerServiceErr:
            return -67662
        case MobileMeRequestAlreadyPending:
            return -67663
        case MobileMeNoRequestPending:
            return -67664
        case MobileMeCSRVerifyFailure:
            return -67665
        case MobileMeFailedConsistencyCheck:
            return -67666
        case NotInitialized:
            return -67667
        case InvalidHandleUsage:
            return -67668
        case PVCReferentNotFound:
            return -67669
        case FunctionIntegrityFail:
            return -67670
        case InternalError:
            return -67671
        case MemoryError:
            return -67672
        case InvalidData:
            return -67673
        case MDSError:
            return -67674
        case InvalidPointer:
            return -67675
        case SelfCheckFailed:
            return -67676
        case FunctionFailed:
            return -67677
        case ModuleManifestVerifyFailed:
            return -67678
        case InvalidGUID:
            return -67679
        case InvalidHandle:
            return -67680
        case InvalidDBList:
            return -67681
        case InvalidPassthroughID:
            return -67682
        case InvalidNetworkAddress:
            return -67683
        case CRLAlreadySigned:
            return -67684
        case InvalidNumberOfFields:
            return -67685
        case VerificationFailure:
            return -67686
        case UnknownTag:
            return -67687
        case InvalidSignature:
            return -67688
        case InvalidName:
            return -67689
        case InvalidCertificateRef:
            return -67690
        case InvalidCertificateGroup:
            return -67691
        case TagNotFound:
            return -67692
        case InvalidQuery:
            return -67693
        case InvalidValue:
            return -67694
        case CallbackFailed:
            return -67695
        case ACLDeleteFailed:
            return -67696
        case ACLReplaceFailed:
            return -67697
        case ACLAddFailed:
            return -67698
        case ACLChangeFailed:
            return -67699
        case InvalidAccessCredentials:
            return -67700
        case InvalidRecord:
            return -67701
        case InvalidACL:
            return -67702
        case InvalidSampleValue:
            return -67703
        case IncompatibleVersion:
            return -67704
        case PrivilegeNotGranted:
            return -67705
        case InvalidScope:
            return -67706
        case PVCAlreadyConfigured:
            return -67707
        case InvalidPVC:
            return -67708
        case EMMLoadFailed:
            return -67709
        case EMMUnloadFailed:
            return -67710
        case AddinLoadFailed:
            return -67711
        case InvalidKeyRef:
            return -67712
        case InvalidKeyHierarchy:
            return -67713
        case AddinUnloadFailed:
            return -67714
        case LibraryReferenceNotFound:
            return -67715
        case InvalidAddinFunctionTable:
            return -67716
        case InvalidServiceMask:
            return -67717
        case ModuleNotLoaded:
            return -67718
        case InvalidSubServiceID:
            return -67719
        case AttributeNotInContext:
            return -67720
        case ModuleManagerInitializeFailed:
            return -67721
        case ModuleManagerNotFound:
            return -67722
        case EventNotificationCallbackNotFound:
            return -67723
        case InputLengthError:
            return -67724
        case OutputLengthError:
            return -67725
        case PrivilegeNotSupported:
            return -67726
        case DeviceError:
            return -67727
        case AttachHandleBusy:
            return -67728
        case NotLoggedIn:
            return -67729
        case AlgorithmMismatch:
            return -67730
        case KeyUsageIncorrect:
            return -67731
        case KeyBlobTypeIncorrect:
            return -67732
        case KeyHeaderInconsistent:
            return -67733
        case UnsupportedKeyFormat:
            return -67734
        case UnsupportedKeySize:
            return -67735
        case InvalidKeyUsageMask:
            return -67736
        case UnsupportedKeyUsageMask:
            return -67737
        case InvalidKeyAttributeMask:
            return -67738
        case UnsupportedKeyAttributeMask:
            return -67739
        case InvalidKeyLabel:
            return -67740
        case UnsupportedKeyLabel:
            return -67741
        case InvalidKeyFormat:
            return -67742
        case UnsupportedVectorOfBuffers:
            return -67743
        case InvalidInputVector:
            return -67744
        case InvalidOutputVector:
            return -67745
        case InvalidContext:
            return -67746
        case InvalidAlgorithm:
            return -67747
        case InvalidAttributeKey:
            return -67748
        case MissingAttributeKey:
            return -67749
        case InvalidAttributeInitVector:
            return -67750
        case MissingAttributeInitVector:
            return -67751
        case InvalidAttributeSalt:
            return -67752
        case MissingAttributeSalt:
            return -67753
        case InvalidAttributePadding:
            return -67754
        case MissingAttributePadding:
            return -67755
        case InvalidAttributeRandom:
            return -67756
        case MissingAttributeRandom:
            return -67757
        case InvalidAttributeSeed:
            return -67758
        case MissingAttributeSeed:
            return -67759
        case InvalidAttributePassphrase:
            return -67760
        case MissingAttributePassphrase:
            return -67761
        case InvalidAttributeKeyLength:
            return -67762
        case MissingAttributeKeyLength:
            return -67763
        case InvalidAttributeBlockSize:
            return -67764
        case MissingAttributeBlockSize:
            return -67765
        case InvalidAttributeOutputSize:
            return -67766
        case MissingAttributeOutputSize:
            return -67767
        case InvalidAttributeRounds:
            return -67768
        case MissingAttributeRounds:
            return -67769
        case InvalidAlgorithmParms:
            return -67770
        case MissingAlgorithmParms:
            return -67771
        case InvalidAttributeLabel:
            return -67772
        case MissingAttributeLabel:
            return -67773
        case InvalidAttributeKeyType:
            return -67774
        case MissingAttributeKeyType:
            return -67775
        case InvalidAttributeMode:
            return -67776
        case MissingAttributeMode:
            return -67777
        case InvalidAttributeEffectiveBits:
            return -67778
        case MissingAttributeEffectiveBits:
            return -67779
        case InvalidAttributeStartDate:
            return -67780
        case MissingAttributeStartDate:
            return -67781
        case InvalidAttributeEndDate:
            return -67782
        case MissingAttributeEndDate:
            return -67783
        case InvalidAttributeVersion:
            return -67784
        case MissingAttributeVersion:
            return -67785
        case InvalidAttributePrime:
            return -67786
        case MissingAttributePrime:
            return -67787
        case InvalidAttributeBase:
            return -67788
        case MissingAttributeBase:
            return -67789
        case InvalidAttributeSubprime:
            return -67790
        case MissingAttributeSubprime:
            return -67791
        case InvalidAttributeIterationCount:
            return -67792
        case MissingAttributeIterationCount:
            return -67793
        case InvalidAttributeDLDBHandle:
            return -67794
        case MissingAttributeDLDBHandle:
            return -67795
        case InvalidAttributeAccessCredentials:
            return -67796
        case MissingAttributeAccessCredentials:
            return -67797
        case InvalidAttributePublicKeyFormat:
            return -67798
        case MissingAttributePublicKeyFormat:
            return -67799
        case InvalidAttributePrivateKeyFormat:
            return -67800
        case MissingAttributePrivateKeyFormat:
            return -67801
        case InvalidAttributeSymmetricKeyFormat:
            return -67802
        case MissingAttributeSymmetricKeyFormat:
            return -67803
        case InvalidAttributeWrappedKeyFormat:
            return -67804
        case MissingAttributeWrappedKeyFormat:
            return -67805
        case StagedOperationInProgress:
            return -67806
        case StagedOperationNotStarted:
            return -67807
        case VerifyFailed:
            return -67808
        case QuerySizeUnknown:
            return -67809
        case BlockSizeMismatch:
            return -67810
        case PublicKeyInconsistent:
            return -67811
        case DeviceVerifyFailed:
            return -67812
        case InvalidLoginName:
            return -67813
        case AlreadyLoggedIn:
            return -67814
        case InvalidDigestAlgorithm:
            return -67815
        case InvalidCRLGroup:
            return -67816
        case CertificateCannotOperate:
            return -67817
        case CertificateExpired:
            return -67818
        case CertificateNotValidYet:
            return -67819
        case CertificateRevoked:
            return -67820
        case CertificateSuspended:
            return -67821
        case InsufficientCredentials:
            return -67822
        case InvalidAction:
            return -67823
        case InvalidAuthority:
            return -67824
        case VerifyActionFailed:
            return -67825
        case InvalidCertAuthority:
            return -67826
        case InvaldCRLAuthority:
            return -67827
        case InvalidCRLEncoding:
            return -67828
        case InvalidCRLType:
            return -67829
        case InvalidCRL:
            return -67830
        case InvalidFormType:
            return -67831
        case InvalidID:
            return -67832
        case InvalidIdentifier:
            return -67833
        case InvalidIndex:
            return -67834
        case InvalidPolicyIdentifiers:
            return -67835
        case InvalidTimeString:
            return -67836
        case InvalidReason:
            return -67837
        case InvalidRequestInputs:
            return -67838
        case InvalidResponseVector:
            return -67839
        case InvalidStopOnPolicy:
            return -67840
        case InvalidTuple:
            return -67841
        case MultipleValuesUnsupported:
            return -67842
        case NotTrusted:
            return -67843
        case NoDefaultAuthority:
            return -67844
        case RejectedForm:
            return -67845
        case RequestLost:
            return -67846
        case RequestRejected:
            return -67847
        case UnsupportedAddressType:
            return -67848
        case UnsupportedService:
            return -67849
        case InvalidTupleGroup:
            return -67850
        case InvalidBaseACLs:
            return -67851
        case InvalidTupleCredendtials:
            return -67852
        case InvalidEncoding:
            return -67853
        case InvalidValidityPeriod:
            return -67854
        case InvalidRequestor:
            return -67855
        case RequestDescriptor:
            return -67856
        case InvalidBundleInfo:
            return -67857
        case InvalidCRLIndex:
            return -67858
        case NoFieldValues:
            return -67859
        case UnsupportedFieldFormat:
            return -67860
        case UnsupportedIndexInfo:
            return -67861
        case UnsupportedLocality:
            return -67862
        case UnsupportedNumAttributes:
            return -67863
        case UnsupportedNumIndexes:
            return -67864
        case UnsupportedNumRecordTypes:
            return -67865
        case FieldSpecifiedMultiple:
            return -67866
        case IncompatibleFieldFormat:
            return -67867
        case InvalidParsingModule:
            return -67868
        case DatabaseLocked:
            return -67869
        case DatastoreIsOpen:
            return -67870
        case MissingValue:
            return -67871
        case UnsupportedQueryLimits:
            return -67872
        case UnsupportedNumSelectionPreds:
            return -67873
        case UnsupportedOperator:
            return -67874
        case InvalidDBLocation:
            return -67875
        case InvalidAccessRequest:
            return -67876
        case InvalidIndexInfo:
            return -67877
        case InvalidNewOwner:
            return -67878
        case InvalidModifyMode:
            return -67879
        default:
            return -99999
        }
    }
    
    public var description : String {
        switch self {
        case Success:
            return "No error."
        case Unimplemented:
            return "Function or operation not implemented."
        case Param:
            return "One or more parameters passed to a function were not valid."
        case Allocate:
            return "Failed to allocate memory."
        case NotAvailable:
            return "No keychain is available. You may need to restart your computer."
        case ReadOnly:
            return "This keychain cannot be modified."
        case AuthFailed:
            return "The user name or passphrase you entered is not correct."
        case NoSuchKeychain:
            return "The specified keychain could not be found."
        case InvalidKeychain:
            return "The specified keychain is not a valid keychain file."
        case DuplicateKeychain:
            return "A keychain with the same name already exists."
        case DuplicateCallback:
            return "The specified callback function is already installed."
        case InvalidCallback:
            return "The specified callback function is not valid."
        case DuplicateItem:
            return "The specified item already exists in the keychain."
        case ItemNotFound:
            return "The specified item could not be found in the keychain."
        case BufferTooSmall:
            return "There is not enough memory available to use the specified item."
        case DataTooLarge:
            return "This item contains information which is too large or in a format that cannot be displayed."
        case NoSuchAttr:
            return "The specified attribute does not exist."
        case InvalidItemRef:
            return "The specified item is no longer valid. It may have been deleted from the keychain."
        case InvalidSearchRef:
            return "Unable to search the current keychain."
        case NoSuchClass:
            return "The specified item does not appear to be a valid keychain item."
        case NoDefaultKeychain:
            return "A default keychain could not be found."
        case InteractionNotAllowed:
            return "User interaction is not allowed."
        case ReadOnlyAttr:
            return "The specified attribute could not be modified."
        case WrongSecVersion:
            return "This keychain was created by a different version of the system software and cannot be opened."
        case KeySizeNotAllowed:
            return "This item specifies a key size which is too large."
        case NoStorageModule:
            return "A required component (data storage module) could not be loaded. You may need to restart your computer."
        case NoCertificateModule:
            return "A required component (certificate module) could not be loaded. You may need to restart your computer."
        case NoPolicyModule:
            return "A required component (policy module) could not be loaded. You may need to restart your computer."
        case InteractionRequired:
            return "User interaction is required, but is currently not allowed."
        case DataNotAvailable:
            return "The contents of this item cannot be retrieved."
        case DataNotModifiable:
            return "The contents of this item cannot be modified."
        case CreateChainFailed:
            return "One or more certificates required to validate this certificate cannot be found."
        case InvalidPrefsDomain:
            return "The specified preferences domain is not valid."
        case ACLNotSimple:
            return "The specified access control list is not in standard (simple) form."
        case PolicyNotFound:
            return "The specified policy cannot be found."
        case InvalidTrustSetting:
            return "The specified trust setting is invalid."
        case NoAccessForItem:
            return "The specified item has no access control."
        case InvalidOwnerEdit:
            return "Invalid attempt to change the owner of this item."
        case TrustNotAvailable:
            return "No trust results are available."
        case UnsupportedFormat:
            return "Import/Export format unsupported."
        case UnknownFormat:
            return "Unknown format in import."
        case KeyIsSensitive:
            return "Key material must be wrapped for export."
        case MultiplePrivKeys:
            return "An attempt was made to import multiple private keys."
        case PassphraseRequired:
            return "Passphrase is required for import/export."
        case InvalidPasswordRef:
            return "The password reference was invalid."
        case InvalidTrustSettings:
            return "The Trust Settings Record was corrupted."
        case NoTrustSettings:
            return "No Trust Settings were found."
        case Pkcs12VerifyFailure:
            return "MAC verification failed during PKCS12 import (wrong password?)"
        case InvalidCertificate:
            return "This certificate could not be decoded."
        case NotSigner:
            return "A certificate was not signed by its proposed parent."
        case PolicyDenied:
            return "The certificate chain was not trusted due to a policy not accepting it."
        case InvalidKey:
            return "The provided key material was not valid."
        case Decode:
            return "Unable to decode the provided data."
        case Internal:
            return "An internal error occured in the Security framework."
        case UnsupportedAlgorithm:
            return "An unsupported algorithm was encountered."
        case UnsupportedOperation:
            return "The operation you requested is not supported by this key."
        case UnsupportedPadding:
            return "The padding you requested is not supported."
        case ItemInvalidKey:
            return "A string key in dictionary is not one of the supported keys."
        case ItemInvalidKeyType:
            return "A key in a dictionary is neither a CFStringRef nor a CFNumberRef."
        case ItemInvalidValue:
            return "A value in a dictionary is an invalid (or unsupported) CF type."
        case ItemClassMissing:
            return "No kSecItemClass key was specified in a dictionary."
        case ItemMatchUnsupported:
            return "The caller passed one or more kSecMatch keys to a function which does not support matches."
        case UseItemListUnsupported:
            return "The caller passed in a kSecUseItemList key to a function which does not support it."
        case UseKeychainUnsupported:
            return "The caller passed in a kSecUseKeychain key to a function which does not support it."
        case UseKeychainListUnsupported:
            return "The caller passed in a kSecUseKeychainList key to a function which does not support it."
        case ReturnDataUnsupported:
            return "The caller passed in a kSecReturnData key to a function which does not support it."
        case ReturnAttributesUnsupported:
            return "The caller passed in a kSecReturnAttributes key to a function which does not support it."
        case ReturnRefUnsupported:
            return "The caller passed in a kSecReturnRef key to a function which does not support it."
        case ReturnPersitentRefUnsupported:
            return "The caller passed in a kSecReturnPersistentRef key to a function which does not support it."
        case ValueRefUnsupported:
            return "The caller passed in a kSecValueRef key to a function which does not support it."
        case ValuePersistentRefUnsupported:
            return "The caller passed in a kSecValuePersistentRef key to a function which does not support it."
        case ReturnMissingPointer:
            return "The caller passed asked for something to be returned but did not pass in a result pointer."
        case MatchLimitUnsupported:
            return "The caller passed in a kSecMatchLimit key to a call which does not support limits."
        case ItemIllegalQuery:
            return "The caller passed in a query which contained too many keys."
        case WaitForCallback:
            return "This operation is incomplete, until the callback is invoked (not an error)."
        case MissingEntitlement:
            return "Internal error when a required entitlement isn't present, client has neither application-identifier nor keychain-access-groups entitlements."
        case UpgradePending:
            return "Error returned if keychain database needs a schema migration but the device is locked, clients should wait for a device unlock notification and retry the command."
        case MPSignatureInvalid:
            return "Signature invalid on MP message"
        case OTRTooOld:
            return "Message is too old to use"
        case OTRIDTooNew:
            return "Key ID is too new to use! Message from the future?"
        case ServiceNotAvailable:
            return "The required service is not available."
        case InsufficientClientID:
            return "The client ID is not correct."
        case DeviceReset:
            return "A device reset has occurred."
        case DeviceFailed:
            return "A device failure has occurred."
        case AppleAddAppACLSubject:
            return "Adding an application ACL subject failed."
        case ApplePublicKeyIncomplete:
            return "The public key is incomplete."
        case AppleSignatureMismatch:
            return "A signature mismatch has occurred."
        case AppleInvalidKeyStartDate:
            return "The specified key has an invalid start date."
        case AppleInvalidKeyEndDate:
            return "The specified key has an invalid end date."
        case ConversionError:
            return "A conversion error has occurred."
        case AppleSSLv2Rollback:
            return "A SSLv2 rollback error has occurred."
        case DiskFull:
            return "The disk is full."
        case QuotaExceeded:
            return "The quota was exceeded."
        case FileTooBig:
            return "The file is too big."
        case InvalidDatabaseBlob:
            return "The specified database has an invalid blob."
        case InvalidKeyBlob:
            return "The specified database has an invalid key blob."
        case IncompatibleDatabaseBlob:
            return "The specified database has an incompatible blob."
        case IncompatibleKeyBlob:
            return "The specified database has an incompatible key blob."
        case HostNameMismatch:
            return "A host name mismatch has occurred."
        case UnknownCriticalExtensionFlag:
            return "There is an unknown critical extension flag."
        case NoBasicConstraints:
            return "No basic constraints were found."
        case NoBasicConstraintsCA:
            return "No basic CA constraints were found."
        case InvalidAuthorityKeyID:
            return "The authority key ID is not valid."
        case InvalidSubjectKeyID:
            return "The subject key ID is not valid."
        case InvalidKeyUsageForPolicy:
            return "The key usage is not valid for the specified policy."
        case InvalidExtendedKeyUsage:
            return "The extended key usage is not valid."
        case InvalidIDLinkage:
            return "The ID linkage is not valid."
        case PathLengthConstraintExceeded:
            return "The path length constraint was exceeded."
        case InvalidRoot:
            return "The root or anchor certificate is not valid."
        case CRLExpired:
            return "The CRL has expired."
        case CRLNotValidYet:
            return "The CRL is not yet valid."
        case CRLNotFound:
            return "The CRL was not found."
        case CRLServerDown:
            return "The CRL server is down."
        case CRLBadURI:
            return "The CRL has a bad Uniform Resource Identifier."
        case UnknownCertExtension:
            return "An unknown certificate extension was encountered."
        case UnknownCRLExtension:
            return "An unknown CRL extension was encountered."
        case CRLNotTrusted:
            return "The CRL is not trusted."
        case CRLPolicyFailed:
            return "The CRL policy failed."
        case IDPFailure:
            return "The issuing distribution point was not valid."
        case SMIMEEmailAddressesNotFound:
            return "An email address mismatch was encountered."
        case SMIMEBadExtendedKeyUsage:
            return "The appropriate extended key usage for SMIME was not found."
        case SMIMEBadKeyUsage:
            return "The key usage is not compatible with SMIME."
        case SMIMEKeyUsageNotCritical:
            return "The key usage extension is not marked as critical."
        case SMIMENoEmailAddress:
            return "No email address was found in the certificate."
        case SMIMESubjAltNameNotCritical:
            return "The subject alternative name extension is not marked as critical."
        case SSLBadExtendedKeyUsage:
            return "The appropriate extended key usage for SSL was not found."
        case OCSPBadResponse:
            return "The OCSP response was incorrect or could not be parsed."
        case OCSPBadRequest:
            return "The OCSP request was incorrect or could not be parsed."
        case OCSPUnavailable:
            return "OCSP service is unavailable."
        case OCSPStatusUnrecognized:
            return "The OCSP server did not recognize this certificate."
        case EndOfData:
            return "An end-of-data was detected."
        case IncompleteCertRevocationCheck:
            return "An incomplete certificate revocation check occurred."
        case NetworkFailure:
            return "A network failure occurred."
        case OCSPNotTrustedToAnchor:
            return "The OCSP response was not trusted to a root or anchor certificate."
        case RecordModified:
            return "The record was modified."
        case OCSPSignatureError:
            return "The OCSP response had an invalid signature."
        case OCSPNoSigner:
            return "The OCSP response had no signer."
        case OCSPResponderMalformedReq:
            return "The OCSP responder was given a malformed request."
        case OCSPResponderInternalError:
            return "The OCSP responder encountered an internal error."
        case OCSPResponderTryLater:
            return "The OCSP responder is busy, try again later."
        case OCSPResponderSignatureRequired:
            return "The OCSP responder requires a signature."
        case OCSPResponderUnauthorized:
            return "The OCSP responder rejected this request as unauthorized."
        case OCSPResponseNonceMismatch:
            return "The OCSP response nonce did not match the request."
        case CodeSigningBadCertChainLength:
            return "Code signing encountered an incorrect certificate chain length."
        case CodeSigningNoBasicConstraints:
            return "Code signing found no basic constraints."
        case CodeSigningBadPathLengthConstraint:
            return "Code signing encountered an incorrect path length constraint."
        case CodeSigningNoExtendedKeyUsage:
            return "Code signing found no extended key usage."
        case CodeSigningDevelopment:
            return "Code signing indicated use of a development-only certificate."
        case ResourceSignBadCertChainLength:
            return "Resource signing has encountered an incorrect certificate chain length."
        case ResourceSignBadExtKeyUsage:
            return "Resource signing has encountered an error in the extended key usage."
        case TrustSettingDeny:
            return "The trust setting for this policy was set to Deny."
        case InvalidSubjectName:
            return "An invalid certificate subject name was encountered."
        case UnknownQualifiedCertStatement:
            return "An unknown qualified certificate statement was encountered."
        case MobileMeRequestQueued:
            return "The MobileMe request will be sent during the next connection."
        case MobileMeRequestRedirected:
            return "The MobileMe request was redirected."
        case MobileMeServerError:
            return "A MobileMe server error occurred."
        case MobileMeServerNotAvailable:
            return "The MobileMe server is not available."
        case MobileMeServerAlreadyExists:
            return "The MobileMe server reported that the item already exists."
        case MobileMeServerServiceErr:
            return "A MobileMe service error has occurred."
        case MobileMeRequestAlreadyPending:
            return "A MobileMe request is already pending."
        case MobileMeNoRequestPending:
            return "MobileMe has no request pending."
        case MobileMeCSRVerifyFailure:
            return "A MobileMe CSR verification failure has occurred."
        case MobileMeFailedConsistencyCheck:
            return "MobileMe has found a failed consistency check."
        case NotInitialized:
            return "A function was called without initializing CSSM."
        case InvalidHandleUsage:
            return "The CSSM handle does not match with the service type."
        case PVCReferentNotFound:
            return "A reference to the calling module was not found in the list of authorized callers."
        case FunctionIntegrityFail:
            return "A function address was not within the verified module."
        case InternalError:
            return "An internal error has occurred."
        case MemoryError:
            return "A memory error has occurred."
        case InvalidData:
            return "Invalid data was encountered."
        case MDSError:
            return "A Module Directory Service error has occurred."
        case InvalidPointer:
            return "An invalid pointer was encountered."
        case SelfCheckFailed:
            return "Self-check has failed."
        case FunctionFailed:
            return "A function has failed."
        case ModuleManifestVerifyFailed:
            return "A module manifest verification failure has occurred."
        case InvalidGUID:
            return "An invalid GUID was encountered."
        case InvalidHandle:
            return "An invalid handle was encountered."
        case InvalidDBList:
            return "An invalid DB list was encountered."
        case InvalidPassthroughID:
            return "An invalid passthrough ID was encountered."
        case InvalidNetworkAddress:
            return "An invalid network address was encountered."
        case CRLAlreadySigned:
            return "The certificate revocation list is already signed."
        case InvalidNumberOfFields:
            return "An invalid number of fields were encountered."
        case VerificationFailure:
            return "A verification failure occurred."
        case UnknownTag:
            return "An unknown tag was encountered."
        case InvalidSignature:
            return "An invalid signature was encountered."
        case InvalidName:
            return "An invalid name was encountered."
        case InvalidCertificateRef:
            return "An invalid certificate reference was encountered."
        case InvalidCertificateGroup:
            return "An invalid certificate group was encountered."
        case TagNotFound:
            return "The specified tag was not found."
        case InvalidQuery:
            return "The specified query was not valid."
        case InvalidValue:
            return "An invalid value was detected."
        case CallbackFailed:
            return "A callback has failed."
        case ACLDeleteFailed:
            return "An ACL delete operation has failed."
        case ACLReplaceFailed:
            return "An ACL replace operation has failed."
        case ACLAddFailed:
            return "An ACL add operation has failed."
        case ACLChangeFailed:
            return "An ACL change operation has failed."
        case InvalidAccessCredentials:
            return "Invalid access credentials were encountered."
        case InvalidRecord:
            return "An invalid record was encountered."
        case InvalidACL:
            return "An invalid ACL was encountered."
        case InvalidSampleValue:
            return "An invalid sample value was encountered."
        case IncompatibleVersion:
            return "An incompatible version was encountered."
        case PrivilegeNotGranted:
            return "The privilege was not granted."
        case InvalidScope:
            return "An invalid scope was encountered."
        case PVCAlreadyConfigured:
            return "The PVC is already configured."
        case InvalidPVC:
            return "An invalid PVC was encountered."
        case EMMLoadFailed:
            return "The EMM load has failed."
        case EMMUnloadFailed:
            return "The EMM unload has failed."
        case AddinLoadFailed:
            return "The add-in load operation has failed."
        case InvalidKeyRef:
            return "An invalid key was encountered."
        case InvalidKeyHierarchy:
            return "An invalid key hierarchy was encountered."
        case AddinUnloadFailed:
            return "The add-in unload operation has failed."
        case LibraryReferenceNotFound:
            return "A library reference was not found."
        case InvalidAddinFunctionTable:
            return "An invalid add-in function table was encountered."
        case InvalidServiceMask:
            return "An invalid service mask was encountered."
        case ModuleNotLoaded:
            return "A module was not loaded."
        case InvalidSubServiceID:
            return "An invalid subservice ID was encountered."
        case AttributeNotInContext:
            return "An attribute was not in the context."
        case ModuleManagerInitializeFailed:
            return "A module failed to initialize."
        case ModuleManagerNotFound:
            return "A module was not found."
        case EventNotificationCallbackNotFound:
            return "An event notification callback was not found."
        case InputLengthError:
            return "An input length error was encountered."
        case OutputLengthError:
            return "An output length error was encountered."
        case PrivilegeNotSupported:
            return "The privilege is not supported."
        case DeviceError:
            return "A device error was encountered."
        case AttachHandleBusy:
            return "The CSP handle was busy."
        case NotLoggedIn:
            return "You are not logged in."
        case AlgorithmMismatch:
            return "An algorithm mismatch was encountered."
        case KeyUsageIncorrect:
            return "The key usage is incorrect."
        case KeyBlobTypeIncorrect:
            return "The key blob type is incorrect."
        case KeyHeaderInconsistent:
            return "The key header is inconsistent."
        case UnsupportedKeyFormat:
            return "The key header format is not supported."
        case UnsupportedKeySize:
            return "The key size is not supported."
        case InvalidKeyUsageMask:
            return "The key usage mask is not valid."
        case UnsupportedKeyUsageMask:
            return "The key usage mask is not supported."
        case InvalidKeyAttributeMask:
            return "The key attribute mask is not valid."
        case UnsupportedKeyAttributeMask:
            return "The key attribute mask is not supported."
        case InvalidKeyLabel:
            return "The key label is not valid."
        case UnsupportedKeyLabel:
            return "The key label is not supported."
        case InvalidKeyFormat:
            return "The key format is not valid."
        case UnsupportedVectorOfBuffers:
            return "The vector of buffers is not supported."
        case InvalidInputVector:
            return "The input vector is not valid."
        case InvalidOutputVector:
            return "The output vector is not valid."
        case InvalidContext:
            return "An invalid context was encountered."
        case InvalidAlgorithm:
            return "An invalid algorithm was encountered."
        case InvalidAttributeKey:
            return "A key attribute was not valid."
        case MissingAttributeKey:
            return "A key attribute was missing."
        case InvalidAttributeInitVector:
            return "An init vector attribute was not valid."
        case MissingAttributeInitVector:
            return "An init vector attribute was missing."
        case InvalidAttributeSalt:
            return "A salt attribute was not valid."
        case MissingAttributeSalt:
            return "A salt attribute was missing."
        case InvalidAttributePadding:
            return "A padding attribute was not valid."
        case MissingAttributePadding:
            return "A padding attribute was missing."
        case InvalidAttributeRandom:
            return "A random number attribute was not valid."
        case MissingAttributeRandom:
            return "A random number attribute was missing."
        case InvalidAttributeSeed:
            return "A seed attribute was not valid."
        case MissingAttributeSeed:
            return "A seed attribute was missing."
        case InvalidAttributePassphrase:
            return "A passphrase attribute was not valid."
        case MissingAttributePassphrase:
            return "A passphrase attribute was missing."
        case InvalidAttributeKeyLength:
            return "A key length attribute was not valid."
        case MissingAttributeKeyLength:
            return "A key length attribute was missing."
        case InvalidAttributeBlockSize:
            return "A block size attribute was not valid."
        case MissingAttributeBlockSize:
            return "A block size attribute was missing."
        case InvalidAttributeOutputSize:
            return "An output size attribute was not valid."
        case MissingAttributeOutputSize:
            return "An output size attribute was missing."
        case InvalidAttributeRounds:
            return "The number of rounds attribute was not valid."
        case MissingAttributeRounds:
            return "The number of rounds attribute was missing."
        case InvalidAlgorithmParms:
            return "An algorithm parameters attribute was not valid."
        case MissingAlgorithmParms:
            return "An algorithm parameters attribute was missing."
        case InvalidAttributeLabel:
            return "A label attribute was not valid."
        case MissingAttributeLabel:
            return "A label attribute was missing."
        case InvalidAttributeKeyType:
            return "A key type attribute was not valid."
        case MissingAttributeKeyType:
            return "A key type attribute was missing."
        case InvalidAttributeMode:
            return "A mode attribute was not valid."
        case MissingAttributeMode:
            return "A mode attribute was missing."
        case InvalidAttributeEffectiveBits:
            return "An effective bits attribute was not valid."
        case MissingAttributeEffectiveBits:
            return "An effective bits attribute was missing."
        case InvalidAttributeStartDate:
            return "A start date attribute was not valid."
        case MissingAttributeStartDate:
            return "A start date attribute was missing."
        case InvalidAttributeEndDate:
            return "An end date attribute was not valid."
        case MissingAttributeEndDate:
            return "An end date attribute was missing."
        case InvalidAttributeVersion:
            return "A version attribute was not valid."
        case MissingAttributeVersion:
            return "A version attribute was missing."
        case InvalidAttributePrime:
            return "A prime attribute was not valid."
        case MissingAttributePrime:
            return "A prime attribute was missing."
        case InvalidAttributeBase:
            return "A base attribute was not valid."
        case MissingAttributeBase:
            return "A base attribute was missing."
        case InvalidAttributeSubprime:
            return "A subprime attribute was not valid."
        case MissingAttributeSubprime:
            return "A subprime attribute was missing."
        case InvalidAttributeIterationCount:
            return "An iteration count attribute was not valid."
        case MissingAttributeIterationCount:
            return "An iteration count attribute was missing."
        case InvalidAttributeDLDBHandle:
            return "A database handle attribute was not valid."
        case MissingAttributeDLDBHandle:
            return "A database handle attribute was missing."
        case InvalidAttributeAccessCredentials:
            return "An access credentials attribute was not valid."
        case MissingAttributeAccessCredentials:
            return "An access credentials attribute was missing."
        case InvalidAttributePublicKeyFormat:
            return "A public key format attribute was not valid."
        case MissingAttributePublicKeyFormat:
            return "A public key format attribute was missing."
        case InvalidAttributePrivateKeyFormat:
            return "A private key format attribute was not valid."
        case MissingAttributePrivateKeyFormat:
            return "A private key format attribute was missing."
        case InvalidAttributeSymmetricKeyFormat:
            return "A symmetric key format attribute was not valid."
        case MissingAttributeSymmetricKeyFormat:
            return "A symmetric key format attribute was missing."
        case InvalidAttributeWrappedKeyFormat:
            return "A wrapped key format attribute was not valid."
        case MissingAttributeWrappedKeyFormat:
            return "A wrapped key format attribute was missing."
        case StagedOperationInProgress:
            return "A staged operation is in progress."
        case StagedOperationNotStarted:
            return "A staged operation was not started."
        case VerifyFailed:
            return "A cryptographic verification failure has occurred."
        case QuerySizeUnknown:
            return "The query size is unknown."
        case BlockSizeMismatch:
            return "A block size mismatch occurred."
        case PublicKeyInconsistent:
            return "The public key was inconsistent."
        case DeviceVerifyFailed:
            return "A device verification failure has occurred."
        case InvalidLoginName:
            return "An invalid login name was detected."
        case AlreadyLoggedIn:
            return "The user is already logged in."
        case InvalidDigestAlgorithm:
            return "An invalid digest algorithm was detected."
        case InvalidCRLGroup:
            return "An invalid CRL group was detected."
        case CertificateCannotOperate:
            return "The certificate cannot operate."
        case CertificateExpired:
            return "An expired certificate was detected."
        case CertificateNotValidYet:
            return "The certificate is not yet valid."
        case CertificateRevoked:
            return "The certificate was revoked."
        case CertificateSuspended:
            return "The certificate was suspended."
        case InsufficientCredentials:
            return "Insufficient credentials were detected."
        case InvalidAction:
            return "The action was not valid."
        case InvalidAuthority:
            return "The authority was not valid."
        case VerifyActionFailed:
            return "A verify action has failed."
        case InvalidCertAuthority:
            return "The certificate authority was not valid."
        case InvaldCRLAuthority:
            return "The CRL authority was not valid."
        case InvalidCRLEncoding:
            return "The CRL encoding was not valid."
        case InvalidCRLType:
            return "The CRL type was not valid."
        case InvalidCRL:
            return "The CRL was not valid."
        case InvalidFormType:
            return "The form type was not valid."
        case InvalidID:
            return "The ID was not valid."
        case InvalidIdentifier:
            return "The identifier was not valid."
        case InvalidIndex:
            return "The index was not valid."
        case InvalidPolicyIdentifiers:
            return "The policy identifiers are not valid."
        case InvalidTimeString:
            return "The time specified was not valid."
        case InvalidReason:
            return "The trust policy reason was not valid."
        case InvalidRequestInputs:
            return "The request inputs are not valid."
        case InvalidResponseVector:
            return "The response vector was not valid."
        case InvalidStopOnPolicy:
            return "The stop-on policy was not valid."
        case InvalidTuple:
            return "The tuple was not valid."
        case MultipleValuesUnsupported:
            return "Multiple values are not supported."
        case NotTrusted:
            return "The trust policy was not trusted."
        case NoDefaultAuthority:
            return "No default authority was detected."
        case RejectedForm:
            return "The trust policy had a rejected form."
        case RequestLost:
            return "The request was lost."
        case RequestRejected:
            return "The request was rejected."
        case UnsupportedAddressType:
            return "The address type is not supported."
        case UnsupportedService:
            return "The service is not supported."
        case InvalidTupleGroup:
            return "The tuple group was not valid."
        case InvalidBaseACLs:
            return "The base ACLs are not valid."
        case InvalidTupleCredendtials:
            return "The tuple credentials are not valid."
        case InvalidEncoding:
            return "The encoding was not valid."
        case InvalidValidityPeriod:
            return "The validity period was not valid."
        case InvalidRequestor:
            return "The requestor was not valid."
        case RequestDescriptor:
            return "The request descriptor was not valid."
        case InvalidBundleInfo:
            return "The bundle information was not valid."
        case InvalidCRLIndex:
            return "The CRL index was not valid."
        case NoFieldValues:
            return "No field values were detected."
        case UnsupportedFieldFormat:
            return "The field format is not supported."
        case UnsupportedIndexInfo:
            return "The index information is not supported."
        case UnsupportedLocality:
            return "The locality is not supported."
        case UnsupportedNumAttributes:
            return "The number of attributes is not supported."
        case UnsupportedNumIndexes:
            return "The number of indexes is not supported."
        case UnsupportedNumRecordTypes:
            return "The number of record types is not supported."
        case FieldSpecifiedMultiple:
            return "Too many fields were specified."
        case IncompatibleFieldFormat:
            return "The field format was incompatible."
        case InvalidParsingModule:
            return "The parsing module was not valid."
        case DatabaseLocked:
            return "The database is locked."
        case DatastoreIsOpen:
            return "The data store is open."
        case MissingValue:
            return "A missing value was detected."
        case UnsupportedQueryLimits:
            return "The query limits are not supported."
        case UnsupportedNumSelectionPreds:
            return "The number of selection predicates is not supported."
        case UnsupportedOperator:
            return "The operator is not supported."
        case InvalidDBLocation:
            return "The database location is not valid."
        case InvalidAccessRequest:
            return "The access request is not valid."
        case InvalidIndexInfo:
            return "The index information is not valid."
        case InvalidNewOwner:
            return "The new owner is not valid."
        case InvalidModifyMode:
            return "The modify mode is not valid."
        default:
            return "Unexpected error has occurred."
        }
    }
}
