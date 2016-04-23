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
    /**
    Item data can only be accessed
    while the device is unlocked. This is recommended for items that only
    need be accesible while the application is in the foreground. Items
    with this attribute will migrate to a new device when using encrypted
    backups.
    */
    case WhenUnlocked

    /**
    Item data can only be
    accessed once the device has been unlocked after a restart. This is
    recommended for items that need to be accesible by background
    applications. Items with this attribute will migrate to a new device
    when using encrypted backups.
    */
    case AfterFirstUnlock

    /**
    Item data can always be accessed
    regardless of the lock state of the device. This is not recommended
    for anything except system use. Items with this attribute will migrate
    to a new device when using encrypted backups.
    */
    case Always

    /**
    Item data can
    only be accessed while the device is unlocked. This class is only
    available if a passcode is set on the device. This is recommended for
    items that only need to be accessible while the application is in the
    foreground. Items with this attribute will never migrate to a new
    device, so after a backup is restored to a new device, these items
    will be missing. No items can be stored in this class on devices
    without a passcode. Disabling the device passcode will cause all
    items in this class to be deleted.
    */
    @available(iOS 8.0, OSX 10.10, *)
    case WhenPasscodeSetThisDeviceOnly

    /**
    Item data can only
    be accessed while the device is unlocked. This is recommended for items
    that only need be accesible while the application is in the foreground.
    Items with this attribute will never migrate to a new device, so after
    a backup is restored to a new device, these items will be missing.
    */
    case WhenUnlockedThisDeviceOnly

    /**
    Item data can
    only be accessed once the device has been unlocked after a restart.
    This is recommended for items that need to be accessible by background
    applications. Items with this attribute will never migrate to a new
    device, so after a backup is restored to a new device these items will
    be missing.
    */
    case AfterFirstUnlockThisDeviceOnly

    /**
    Item data can always
    be accessed regardless of the lock state of the device. This option
    is not recommended for anything except system use. Items with this
    attribute will never migrate to a new device, so after a backup is
    restored to a new device, these items will be missing.
    */
    case AlwaysThisDeviceOnly
}

public struct AuthenticationPolicy : OptionSetType {
    /**
    User presence policy using Touch ID or Passcode. Touch ID does not 
    have to be available or enrolled. Item is still accessible by Touch ID
    even if fingers are added or removed.
    */
    @available(iOS 8.0, OSX 10.10, *)
    @available(watchOS, unavailable)
    public static let UserPresence = AuthenticationPolicy(rawValue: 1 << 0)

    /**
    Constraint: Touch ID (any finger). Touch ID must be available and 
    at least one finger must be enrolled. Item is still accessible by 
    Touch ID even if fingers are added or removed.
    */
    @available(iOS 9.0, *)
    @available(OSX, unavailable)
    @available(watchOS, unavailable)
    public static let TouchIDAny = AuthenticationPolicy(rawValue: 1 << 1)

    /**
    Constraint: Touch ID from the set of currently enrolled fingers. 
    Touch ID must be available and at least one finger must be enrolled. 
    When fingers are added or removed, the item is invalidated.
    */
    @available(iOS 9.0, *)
    @available(OSX, unavailable)
    @available(watchOS, unavailable)
    public static let TouchIDCurrentSet = AuthenticationPolicy(rawValue: 1 << 3)

    /**
    Constraint: Device passcode
    */
    @available(iOS 9.0, OSX 10.11, *)
    @available(watchOS, unavailable)
    public static let DevicePasscode = AuthenticationPolicy(rawValue: 1 << 4)

    /**
    Constraint logic operation: when using more than one constraint, 
    at least one of them must be satisfied.
    */
    @available(iOS 9.0, *)
    @available(OSX, unavailable)
    @available(watchOS, unavailable)
    public static let Or = AuthenticationPolicy(rawValue: 1 << 14)

    /**
    Constraint logic operation: when using more than one constraint,
    all must be satisfied.
    */
    @available(iOS 9.0, *)
    @available(OSX, unavailable)
    @available(watchOS, unavailable)
    public static let And = AuthenticationPolicy(rawValue: 1 << 15)

    /**
    Create access control for private key operations (i.e. sign operation)
    */
    @available(iOS 9.0, *)
    @available(OSX, unavailable)
    @available(watchOS, unavailable)
    public static let PrivateKeyUsage = AuthenticationPolicy(rawValue: 1 << 30)

    /**
    Security: Application provided password for data encryption key generation.
    This is not a constraint but additional item encryption mechanism.
    */
    @available(iOS 9.0, *)
    @available(OSX, unavailable)
    @available(watchOS, unavailable)
    public static let ApplicationPassword = AuthenticationPolicy(rawValue: 1 << 31)

    public let rawValue : Int

    public init(rawValue:Int) {
        self.rawValue = rawValue
    }
}

public struct Attributes {
    public var `class`: String? {
        return attributes[Class] as? String
    }
    public var data: NSData? {
        return attributes[ValueData] as? NSData
    }
    public var ref: NSData? {
        return attributes[ValueRef] as? NSData
    }
    public var persistentRef: NSData? {
        return attributes[ValuePersistentRef] as? NSData
    }

    public var accessible: String? {
        return attributes[AttributeAccessible] as? String
    }
    public var accessControl: SecAccessControl? {
        if #available(OSX 10.10, *) {
            if let accessControl = attributes[AttributeAccessControl] {
                return (accessControl as! SecAccessControl)
            }
            return nil
        } else {
            return nil
        }
    }
    public var accessGroup: String? {
        return attributes[AttributeAccessGroup] as? String
    }
    public var synchronizable: Bool? {
        return attributes[AttributeSynchronizable] as? Bool
    }
    public var creationDate: NSDate? {
        return attributes[AttributeCreationDate] as? NSDate
    }
    public var modificationDate: NSDate? {
        return attributes[AttributeModificationDate] as? NSDate
    }
    public var attributeDescription: String? {
        return attributes[AttributeDescription] as? String
    }
    public var comment: String? {
        return attributes[AttributeComment] as? String
    }
    public var creator: String? {
        return attributes[AttributeCreator] as? String
    }
    public var type: String? {
        return attributes[AttributeType] as? String
    }
    public var label: String? {
        return attributes[AttributeLabel] as? String
    }
    public var isInvisible: Bool? {
        return attributes[AttributeIsInvisible] as? Bool
    }
    public var isNegative: Bool? {
        return attributes[AttributeIsNegative] as? Bool
    }
    public var account: String? {
        return attributes[AttributeAccount] as? String
    }
    public var service: String? {
        return attributes[AttributeService] as? String
    }
    public var generic: NSData? {
        return attributes[AttributeGeneric] as? NSData
    }
    public var securityDomain: String? {
        return attributes[AttributeSecurityDomain] as? String
    }
    public var server: String? {
        return attributes[AttributeServer] as? String
    }
    public var `protocol`: String? {
        return attributes[AttributeProtocol] as? String
    }
    public var authenticationType: String? {
        return attributes[AttributeAuthenticationType] as? String
    }
    public var port: Int? {
        return attributes[AttributePort] as? Int
    }
    public var path: String? {
        return attributes[AttributePath] as? String
    }

    private let attributes: [String: AnyObject]

    init(attributes: [String: AnyObject]) {
        self.attributes = attributes
    }

    public subscript(key: String) -> AnyObject? {
        get {
            return attributes[key]
        }
    }
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

    @available(iOS 8.0, OSX 10.10, *)
    @available(watchOS, unavailable)
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

    @available(iOS 8.0, OSX 10.10, *)
    @available(watchOS, unavailable)
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
    
    public convenience init(server: String, protocolType: ProtocolType, authenticationType: AuthenticationType = .Default) {
        self.init(server: NSURL(string: server)!, protocolType: protocolType, authenticationType: authenticationType)
    }
    
    public convenience init(server: NSURL, protocolType: ProtocolType, authenticationType: AuthenticationType = .Default) {
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

    @available(iOS 8.0, OSX 10.10, *)
    @available(watchOS, unavailable)
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

    public func attributes(attributes: [String: AnyObject]) -> Keychain {
        var options = self.options
        attributes.forEach { options.attributes.updateValue($1, forKey: $0) }
        return Keychain(options)
    }

    @available(iOS 8.0, OSX 10.10, *)
    @available(watchOS, unavailable)
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

        query[MatchLimit] = MatchLimitOne
        query[ReturnData] = true

        query[AttributeAccount] = key

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

    public func get<T>(key: String, @noescape handler: Attributes? -> T) throws -> T {
        var query = options.query()

        query[MatchLimit] = MatchLimitOne

        query[ReturnData] = true
        query[ReturnAttributes] = true
        query[ReturnRef] = true
        query[ReturnPersistentRef] = true

        query[AttributeAccount] = key

        var result: AnyObject?
        let status = withUnsafeMutablePointer(&result) { SecItemCopyMatching(query, UnsafeMutablePointer($0)) }

        switch status {
        case errSecSuccess:
            guard let attributes = result as? [String: AnyObject] else {
                throw Status.UnexpectedError
            }
            return handler(Attributes(attributes: attributes))
        case errSecItemNotFound:
            return handler(nil)
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
        query[AttributeAccount] = key
        #if os(iOS)
        if #available(iOS 9.0, *) {
            query[UseAuthenticationUI] = UseAuthenticationUIFail
        } else {
            query[UseNoAuthenticationUI] = true
        }
        #elseif os(OSX)
        if #available(OSX 10.11, *) {
            query[UseAuthenticationUI] = UseAuthenticationUIFail
        }
        #endif

        var status = SecItemCopyMatching(query, nil)
        switch status {
        case errSecSuccess, errSecInteractionNotAllowed:
            var query = options.query()
            query[AttributeAccount] = key

            var (attributes, error) = options.attributes(key: nil, value: value)
            if let error = error {
                print(error.localizedDescription)
                throw error
            }

            options.attributes.forEach { attributes.updateValue($1, forKey: $0) }

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
            var (attributes, error) = options.attributes(key: key, value: value)
            if let error = error {
                print(error.localizedDescription)
                throw error
            }

            options.attributes.forEach { attributes.updateValue($1, forKey: $0) }

            status = SecItemAdd(attributes, nil)
            if status != errSecSuccess {
                throw securityError(status: status)
            }
        default:
            throw securityError(status: status)
        }
    }

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

    public subscript(attributes key: String) -> Attributes? {
        get {
            return (try? get(key) { $0 }).flatMap { $0 }
        }
    }
    
    // MARK:
    
    public func remove(key: String) throws {
        var query = options.query()
        query[AttributeAccount] = key
        
        let status = SecItemDelete(query)
        if status != errSecSuccess && status != errSecItemNotFound {
            throw securityError(status: status)
        }
    }
    
    public func removeAll() throws {
        var query = options.query()
        #if !os(iOS) && !os(watchOS) && !os(tvOS)
        query[MatchLimit] = MatchLimitAll
        #endif
        
        let status = SecItemDelete(query)
        if status != errSecSuccess && status != errSecItemNotFound {
            throw securityError(status: status)
        }
    }
    
    // MARK:
    
    public func contains(key: String) throws -> Bool {
        var query = options.query()
        query[AttributeAccount] = key
        
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
    
    public class func allKeys(itemClass: ItemClass) -> [(String, String)] {
        var query = [String: AnyObject]()
        query[Class] = itemClass.rawValue
        query[AttributeSynchronizable] = SynchronizableAny
        query[MatchLimit] = MatchLimitAll
        query[ReturnAttributes] = true
        
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
        query[Class] = itemClass.rawValue
        query[MatchLimit] = MatchLimitAll
        query[ReturnAttributes] = true
        #if os(iOS) || os(watchOS) || os(tvOS)
        query[ReturnData] = true
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
    @available(iOS 8.0, *)
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
    @available(iOS 8.0, *)
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
    @available(iOS 8.0, *)
    public func setSharedPassword(password: String, account: String, completion: (error: NSError?) -> () = { e -> () in }) {
        setSharedPassword(password as String?, account: account, completion: completion)
    }
    #endif

    #if os(iOS)
    @available(iOS 8.0, *)
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
    @available(iOS 8.0, *)
    public func removeSharedPassword(account: String, completion: (error: NSError?) -> () = { e -> () in }) {
        setSharedPassword(nil, account: account, completion: completion)
    }
    #endif

    #if os(iOS)
    @available(iOS 8.0, *)
    public class func requestSharedWebCredential(completion: (credentials: [[String: String]], error: NSError?) -> () = { credentials, error -> () in }) {
        requestSharedWebCredential(domain: nil, account: nil, completion: completion)
    }
    #endif

    #if os(iOS)
    @available(iOS 8.0, *)
    public class func requestSharedWebCredential(domain domain: String, completion: (credentials: [[String: String]], error: NSError?) -> () = { credentials, error -> () in }) {
        requestSharedWebCredential(domain: domain, account: nil, completion: completion)
    }
    #endif

    #if os(iOS)
    @available(iOS 8.0, *)
    public class func requestSharedWebCredential(domain domain: String, account: String, completion: (credentials: [[String: String]], error: NSError?) -> () = { credentials, error -> () in }) {
        requestSharedWebCredential(domain: Optional(domain), account: Optional(account), completion: completion)
    }
    #endif

    #if os(iOS)
    @available(iOS 8.0, *)
    private class func requestSharedWebCredential(domain domain: String?, account: String?, completion: (credentials: [[String: String]], error: NSError?) -> ()) {
        SecRequestSharedWebCredential(domain, account) { (credentials, error) -> () in
            var remoteError: NSError?
            if let error = error {
                remoteError = error.error
                if remoteError?.code != Int(errSecItemNotFound) {
                    print("error:[\(remoteError!.code)] \(remoteError!.localizedDescription)")
                }
            }
            if let credentials = credentials {
                let credentials = (credentials as NSArray).map { credentials -> [String: String] in
                    var credential = [String: String]()
                    if let server = credentials[AttributeServer] as? String {
                        credential["server"] = server
                    }
                    if let account = credentials[AttributeAccount] as? String {
                        credential["account"] = account
                    }
                    if let password = credentials[SharedPassword] as? String {
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
    /**
    @abstract Returns a randomly generated password.
    @return String password in the form xxx-xxx-xxx-xxx where x is taken from the sets "abcdefghkmnopqrstuvwxy", "ABCDEFGHJKLMNPQRSTUVWXYZ", "3456789" with at least one character from each set being present.
    */
    @available(iOS 8.0, *)
    public class func generatePassword() -> String {
        return SecCreateSharedWebCredentialPassword()! as String
    }
    #endif
    
    // MARK:
    
    private func items() -> [[String: AnyObject]] {
        var query = options.query()
        query[MatchLimit] = MatchLimitAll
        query[ReturnAttributes] = true
        #if os(iOS) || os(watchOS) || os(tvOS)
        query[ReturnData] = true
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
                if let service = attributes[AttributeService] as? String {
                    item["service"] = service
                }
                if let accessGroup = attributes[AttributeAccessGroup] as? String {
                    item["accessGroup"] = accessGroup
                }
            case .InternetPassword:
                if let server = attributes[AttributeServer] as? String {
                    item["server"] = server
                }
                if let proto = attributes[AttributeProtocol] as? String {
                    if let protocolType = ProtocolType(rawValue: proto) {
                        item["protocol"] = protocolType.description
                    }
                }
                if let auth = attributes[AttributeAuthenticationType] as? String {
                    if let authenticationType = AuthenticationType(rawValue: auth) {
                        item["authenticationType"] = authenticationType.description
                    }
                }
            }
            
            if let key = attributes[AttributeAccount] as? String {
                item["key"] = key
            }
            if let data = attributes[ValueData] as? NSData {
                if let text = NSString(data: data, encoding: NSUTF8StringEncoding) as? String {
                    item["value"] = text
                } else  {
                    item["value"] = data
                }
            }
            
            if let accessible = attributes[AttributeAccessible] as? String {
                if let accessibility = Accessibility(rawValue: accessible) {
                    item["accessibility"] = accessibility.description
                }
            }
            if let synchronizable = attributes[AttributeSynchronizable] as? Bool {
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
        let message = Status(status: status).description
        
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

    var attributes = [String: AnyObject]()
}

/** Class Key Constant */
private let Class = String(kSecClass)

/** Attribute Key Constants */
private let AttributeAccessible = String(kSecAttrAccessible)

@available(iOS 8.0, OSX 10.10, *)
private let AttributeAccessControl = String(kSecAttrAccessControl)

private let AttributeAccessGroup = String(kSecAttrAccessGroup)
private let AttributeSynchronizable = String(kSecAttrSynchronizable)
private let AttributeCreationDate = String(kSecAttrCreationDate)
private let AttributeModificationDate = String(kSecAttrModificationDate)
private let AttributeDescription = String(kSecAttrDescription)
private let AttributeComment = String(kSecAttrComment)
private let AttributeCreator = String(kSecAttrCreator)
private let AttributeType = String(kSecAttrType)
private let AttributeLabel = String(kSecAttrLabel)
private let AttributeIsInvisible = String(kSecAttrIsInvisible)
private let AttributeIsNegative = String(kSecAttrIsNegative)
private let AttributeAccount = String(kSecAttrAccount)
private let AttributeService = String(kSecAttrService)
private let AttributeGeneric = String(kSecAttrGeneric)
private let AttributeSecurityDomain = String(kSecAttrSecurityDomain)
private let AttributeServer = String(kSecAttrServer)
private let AttributeProtocol = String(kSecAttrProtocol)
private let AttributeAuthenticationType = String(kSecAttrAuthenticationType)
private let AttributePort = String(kSecAttrPort)
private let AttributePath = String(kSecAttrPath)

private let SynchronizableAny = kSecAttrSynchronizableAny

/** Search Constants */
private let MatchLimit = String(kSecMatchLimit)
private let MatchLimitOne = kSecMatchLimitOne
private let MatchLimitAll = kSecMatchLimitAll

/** Return Type Key Constants */
private let ReturnData = String(kSecReturnData)
private let ReturnAttributes = String(kSecReturnAttributes)
private let ReturnRef = String(kSecReturnRef)
private let ReturnPersistentRef = String(kSecReturnPersistentRef)

/** Value Type Key Constants */
private let ValueData = String(kSecValueData)
private let ValueRef = String(kSecValueRef)
private let ValuePersistentRef = String(kSecValuePersistentRef)

/** Other Constants */
@available(iOS 8.0, OSX 10.10, *)
private let UseOperationPrompt = String(kSecUseOperationPrompt)

#if os(iOS)
@available(iOS, introduced=8.0, deprecated=9.0, message="Use a UseAuthenticationUI instead.")
private let UseNoAuthenticationUI = String(kSecUseNoAuthenticationUI)
#endif

@available(iOS 9.0, OSX 10.11, *)
@available(watchOS, unavailable)
private let UseAuthenticationUI = String(kSecUseAuthenticationUI)

@available(iOS 9.0, OSX 10.11, *)
@available(watchOS, unavailable)
private let UseAuthenticationContext = String(kSecUseAuthenticationContext)

@available(iOS 9.0, OSX 10.11, *)
@available(watchOS, unavailable)
private let UseAuthenticationUIAllow = String(kSecUseAuthenticationUIAllow)

@available(iOS 9.0, OSX 10.11, *)
@available(watchOS, unavailable)
private let UseAuthenticationUIFail = String(kSecUseAuthenticationUIFail)

@available(iOS 9.0, OSX 10.11, *)
@available(watchOS, unavailable)
private let UseAuthenticationUISkip = String(kSecUseAuthenticationUISkip)

#if os(iOS)
/** Credential Key Constants */
private let SharedPassword = String(kSecSharedPassword)
#endif

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
        
        query[Class] = itemClass.rawValue
        query[AttributeSynchronizable] = SynchronizableAny
        
        switch itemClass {
        case .GenericPassword:
            query[AttributeService] = service
            // Access group is not supported on any simulators.
            #if (!arch(i386) && !arch(x86_64)) || (!os(iOS) && !os(watchOS) && !os(tvOS))
            if let accessGroup = self.accessGroup {
                query[AttributeAccessGroup] = accessGroup
            }
            #endif
        case .InternetPassword:
            query[AttributeServer] = server.host
            query[AttributePort] = server.port
            query[AttributeProtocol] = protocolType.rawValue
            query[AttributeAuthenticationType] = authenticationType.rawValue
        }

        if #available(OSX 10.10, *) {
            if authenticationPrompt != nil {
                query[UseOperationPrompt] = authenticationPrompt
            }
        }
        
        return query
    }
    
    func attributes(key key: String?, value: NSData) -> ([String: AnyObject], NSError?) {
        var attributes: [String: AnyObject]
        
        if key != nil {
            attributes = query()
            attributes[AttributeAccount] = key
        } else {
            attributes = [String: AnyObject]()
        }
        
        attributes[ValueData] = value
        
        if label != nil {
            attributes[AttributeLabel] = label
        }
        if comment != nil {
            attributes[AttributeComment] = comment
        }

        if let policy = authenticationPolicy {
            if #available(OSX 10.10, *) {
                var error: Unmanaged<CFError>?
                guard let accessControl = SecAccessControlCreateWithFlags(kCFAllocatorDefault, accessibility.rawValue, SecAccessControlCreateFlags(rawValue: policy.rawValue), &error) else {
                    if let error = error?.takeUnretainedValue() {
                        return (attributes, error.error)
                    }
                    let message = Status.UnexpectedError.description
                    return (attributes, NSError(domain: KeychainAccessErrorDomain, code: Int(Status.UnexpectedError.rawValue), userInfo: [NSLocalizedDescriptionKey: message]))
                }
                attributes[AttributeAccessControl] = accessControl
            } else {
                print("Unavailable 'Touch ID integration' on OS X versions prior to 10.10.")
            }
        } else {
            attributes[AttributeAccessible] = accessibility.rawValue
        }
        
        attributes[AttributeSynchronizable] = synchronizable
        
        return (attributes, nil)
    }
}

// MARK:

extension Attributes : CustomStringConvertible, CustomDebugStringConvertible {
    public var description: String {
        return "\(attributes)"
    }

    public var debugDescription: String {
        return description
    }
}

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
            return String(kSecAttrProtocolFTP)
        case FTPAccount:
            return String(kSecAttrProtocolFTPAccount)
        case HTTP:
            return String(kSecAttrProtocolHTTP)
        case IRC:
            return String(kSecAttrProtocolIRC)
        case NNTP:
            return String(kSecAttrProtocolNNTP)
        case POP3:
            return String(kSecAttrProtocolPOP3)
        case SMTP:
            return String(kSecAttrProtocolSMTP)
        case SOCKS:
            return String(kSecAttrProtocolSOCKS)
        case IMAP:
            return String(kSecAttrProtocolIMAP)
        case LDAP:
            return String(kSecAttrProtocolLDAP)
        case AppleTalk:
            return String(kSecAttrProtocolAppleTalk)
        case AFP:
            return String(kSecAttrProtocolAFP)
        case Telnet:
            return String(kSecAttrProtocolTelnet)
        case SSH:
            return String(kSecAttrProtocolSSH)
        case FTPS:
            return String(kSecAttrProtocolFTPS)
        case HTTPS:
            return String(kSecAttrProtocolHTTPS)
        case HTTPProxy:
            return String(kSecAttrProtocolHTTPProxy)
        case HTTPSProxy:
            return String(kSecAttrProtocolHTTPSProxy)
        case FTPProxy:
            return String(kSecAttrProtocolFTPProxy)
        case SMB:
            return String(kSecAttrProtocolSMB)
        case RTSP:
            return String(kSecAttrProtocolRTSP)
        case RTSPProxy:
            return String(kSecAttrProtocolRTSPProxy)
        case DAAP:
            return String(kSecAttrProtocolDAAP)
        case EPPC:
            return String(kSecAttrProtocolEPPC)
        case IPP:
            return String(kSecAttrProtocolIPP)
        case NNTPS:
            return String(kSecAttrProtocolNNTPS)
        case LDAPS:
            return String(kSecAttrProtocolLDAPS)
        case TelnetS:
            return String(kSecAttrProtocolTelnetS)
        case IMAPS:
            return String(kSecAttrProtocolIMAPS)
        case IRCS:
            return String(kSecAttrProtocolIRCS)
        case POP3S:
            return String(kSecAttrProtocolPOP3S)
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
            return String(kSecAttrAuthenticationTypeNTLM)
        case MSN:
            return String(kSecAttrAuthenticationTypeMSN)
        case DPA:
            return String(kSecAttrAuthenticationTypeDPA)
        case RPA:
            return String(kSecAttrAuthenticationTypeRPA)
        case HTTPBasic:
            return String(kSecAttrAuthenticationTypeHTTPBasic)
        case HTTPDigest:
            return String(kSecAttrAuthenticationTypeHTTPDigest)
        case HTMLForm:
            return String(kSecAttrAuthenticationTypeHTMLForm)
        case Default:
            return String(kSecAttrAuthenticationTypeDefault)
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
        if #available(OSX 10.10, *) {
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
        } else {
            switch rawValue {
            case String(kSecAttrAccessibleWhenUnlocked):
                self = WhenUnlocked
            case String(kSecAttrAccessibleAfterFirstUnlock):
                self = AfterFirstUnlock
            case String(kSecAttrAccessibleAlways):
                self = Always
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
    }

    public var rawValue: String {
        switch self {
        case WhenUnlocked:
            return String(kSecAttrAccessibleWhenUnlocked)
        case AfterFirstUnlock:
            return String(kSecAttrAccessibleAfterFirstUnlock)
        case Always:
            return String(kSecAttrAccessibleAlways)
        case WhenPasscodeSetThisDeviceOnly:
            if #available(OSX 10.10, *) {
                return String(kSecAttrAccessibleWhenPasscodeSetThisDeviceOnly)
            } else {
                fatalError("'Accessibility.WhenPasscodeSetThisDeviceOnly' is not available on this version of OS.")
            }
        case WhenUnlockedThisDeviceOnly:
            return String(kSecAttrAccessibleWhenUnlockedThisDeviceOnly)
        case AfterFirstUnlockThisDeviceOnly:
            return String(kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly)
        case AlwaysThisDeviceOnly:
            return String(kSecAttrAccessibleAlwaysThisDeviceOnly)
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

extension CFError {
    var error: NSError {
        let domain = CFErrorGetDomain(self) as String
        let code = CFErrorGetCode(self)
        let userInfo = CFErrorCopyUserInfo(self) as [NSObject: AnyObject]
        
        return NSError(domain: domain, code: code, userInfo: userInfo)
    }
}

public enum Status : OSStatus, ErrorType {
    case Success                            = 0
    case Unimplemented                      = -4
    case DiskFull                           = -34
    case IO                                 = -36
    case OpWr                               = -49
    case Param                              = -50
    case WrPerm                             = -61
    case Allocate                           = -108
    case UserCanceled                       = -128
    case BadReq                             = -909
    case InternalComponent                  = -2070
    case NotAvailable                       = -25291
    case ReadOnly                           = -25292
    case AuthFailed                         = -25293
    case NoSuchKeychain                     = -25294
    case InvalidKeychain                    = -25295
    case DuplicateKeychain                  = -25296
    case DuplicateCallback                  = -25297
    case InvalidCallback                    = -25298
    case DuplicateItem                      = -25299
    case ItemNotFound                       = -25300
    case BufferTooSmall                     = -25301
    case DataTooLarge                       = -25302
    case NoSuchAttr                         = -25303
    case InvalidItemRef                     = -25304
    case InvalidSearchRef                   = -25305
    case NoSuchClass                        = -25306
    case NoDefaultKeychain                  = -25307
    case InteractionNotAllowed              = -25308
    case ReadOnlyAttr                       = -25309
    case WrongSecVersion                    = -25310
    case KeySizeNotAllowed                  = -25311
    case NoStorageModule                    = -25312
    case NoCertificateModule                = -25313
    case NoPolicyModule                     = -25314
    case InteractionRequired                = -25315
    case DataNotAvailable                   = -25316
    case DataNotModifiable                  = -25317
    case CreateChainFailed                  = -25318
    case InvalidPrefsDomain                 = -25319
    case InDarkWake                         = -25320
    case ACLNotSimple                       = -25240
    case PolicyNotFound                     = -25241
    case InvalidTrustSetting                = -25242
    case NoAccessForItem                    = -25243
    case InvalidOwnerEdit                   = -25244
    case TrustNotAvailable                  = -25245
    case UnsupportedFormat                  = -25256
    case UnknownFormat                      = -25257
    case KeyIsSensitive                     = -25258
    case MultiplePrivKeys                   = -25259
    case PassphraseRequired                 = -25260
    case InvalidPasswordRef                 = -25261
    case InvalidTrustSettings               = -25262
    case NoTrustSettings                    = -25263
    case Pkcs12VerifyFailure                = -25264
    case InvalidCertificate                 = -26265
    case NotSigner                          = -26267
    case PolicyDenied                       = -26270
    case InvalidKey                         = -26274
    case Decode                             = -26275
    case Internal                           = -26276
    case UnsupportedAlgorithm               = -26268
    case UnsupportedOperation               = -26271
    case UnsupportedPadding                 = -26273
    case ItemInvalidKey                     = -34000
    case ItemInvalidKeyType                 = -34001
    case ItemInvalidValue                   = -34002
    case ItemClassMissing                   = -34003
    case ItemMatchUnsupported               = -34004
    case UseItemListUnsupported             = -34005
    case UseKeychainUnsupported             = -34006
    case UseKeychainListUnsupported         = -34007
    case ReturnDataUnsupported              = -34008
    case ReturnAttributesUnsupported        = -34009
    case ReturnRefUnsupported               = -34010
    case ReturnPersitentRefUnsupported      = -34011
    case ValueRefUnsupported                = -34012
    case ValuePersistentRefUnsupported      = -34013
    case ReturnMissingPointer               = -34014
    case MatchLimitUnsupported              = -34015
    case ItemIllegalQuery                   = -34016
    case WaitForCallback                    = -34017
    case MissingEntitlement                 = -34018
    case UpgradePending                     = -34019
    case MPSignatureInvalid                 = -25327
    case OTRTooOld                          = -25328
    case OTRIDTooNew                        = -25329
    case ServiceNotAvailable                = -67585
    case InsufficientClientID               = -67586
    case DeviceReset                        = -67587
    case DeviceFailed                       = -67588
    case AppleAddAppACLSubject              = -67589
    case ApplePublicKeyIncomplete           = -67590
    case AppleSignatureMismatch             = -67591
    case AppleInvalidKeyStartDate           = -67592
    case AppleInvalidKeyEndDate             = -67593
    case ConversionError                    = -67594
    case AppleSSLv2Rollback                 = -67595
    case QuotaExceeded                      = -67596
    case FileTooBig                         = -67597
    case InvalidDatabaseBlob                = -67598
    case InvalidKeyBlob                     = -67599
    case IncompatibleDatabaseBlob           = -67600
    case IncompatibleKeyBlob                = -67601
    case HostNameMismatch                   = -67602
    case UnknownCriticalExtensionFlag       = -67603
    case NoBasicConstraints                 = -67604
    case NoBasicConstraintsCA               = -67605
    case InvalidAuthorityKeyID              = -67606
    case InvalidSubjectKeyID                = -67607
    case InvalidKeyUsageForPolicy           = -67608
    case InvalidExtendedKeyUsage            = -67609
    case InvalidIDLinkage                   = -67610
    case PathLengthConstraintExceeded       = -67611
    case InvalidRoot                        = -67612
    case CRLExpired                         = -67613
    case CRLNotValidYet                     = -67614
    case CRLNotFound                        = -67615
    case CRLServerDown                      = -67616
    case CRLBadURI                          = -67617
    case UnknownCertExtension               = -67618
    case UnknownCRLExtension                = -67619
    case CRLNotTrusted                      = -67620
    case CRLPolicyFailed                    = -67621
    case IDPFailure                         = -67622
    case SMIMEEmailAddressesNotFound        = -67623
    case SMIMEBadExtendedKeyUsage           = -67624
    case SMIMEBadKeyUsage                   = -67625
    case SMIMEKeyUsageNotCritical           = -67626
    case SMIMENoEmailAddress                = -67627
    case SMIMESubjAltNameNotCritical        = -67628
    case SSLBadExtendedKeyUsage             = -67629
    case OCSPBadResponse                    = -67630
    case OCSPBadRequest                     = -67631
    case OCSPUnavailable                    = -67632
    case OCSPStatusUnrecognized             = -67633
    case EndOfData                          = -67634
    case IncompleteCertRevocationCheck      = -67635
    case NetworkFailure                     = -67636
    case OCSPNotTrustedToAnchor             = -67637
    case RecordModified                     = -67638
    case OCSPSignatureError                 = -67639
    case OCSPNoSigner                       = -67640
    case OCSPResponderMalformedReq          = -67641
    case OCSPResponderInternalError         = -67642
    case OCSPResponderTryLater              = -67643
    case OCSPResponderSignatureRequired     = -67644
    case OCSPResponderUnauthorized          = -67645
    case OCSPResponseNonceMismatch          = -67646
    case CodeSigningBadCertChainLength      = -67647
    case CodeSigningNoBasicConstraints      = -67648
    case CodeSigningBadPathLengthConstraint = -67649
    case CodeSigningNoExtendedKeyUsage      = -67650
    case CodeSigningDevelopment             = -67651
    case ResourceSignBadCertChainLength     = -67652
    case ResourceSignBadExtKeyUsage         = -67653
    case TrustSettingDeny                   = -67654
    case InvalidSubjectName                 = -67655
    case UnknownQualifiedCertStatement      = -67656
    case MobileMeRequestQueued              = -67657
    case MobileMeRequestRedirected          = -67658
    case MobileMeServerError                = -67659
    case MobileMeServerNotAvailable         = -67660
    case MobileMeServerAlreadyExists        = -67661
    case MobileMeServerServiceErr           = -67662
    case MobileMeRequestAlreadyPending      = -67663
    case MobileMeNoRequestPending           = -67664
    case MobileMeCSRVerifyFailure           = -67665
    case MobileMeFailedConsistencyCheck     = -67666
    case NotInitialized                     = -67667
    case InvalidHandleUsage                 = -67668
    case PVCReferentNotFound                = -67669
    case FunctionIntegrityFail              = -67670
    case InternalError                      = -67671
    case MemoryError                        = -67672
    case InvalidData                        = -67673
    case MDSError                           = -67674
    case InvalidPointer                     = -67675
    case SelfCheckFailed                    = -67676
    case FunctionFailed                     = -67677
    case ModuleManifestVerifyFailed         = -67678
    case InvalidGUID                        = -67679
    case InvalidHandle                      = -67680
    case InvalidDBList                      = -67681
    case InvalidPassthroughID               = -67682
    case InvalidNetworkAddress              = -67683
    case CRLAlreadySigned                   = -67684
    case InvalidNumberOfFields              = -67685
    case VerificationFailure                = -67686
    case UnknownTag                         = -67687
    case InvalidSignature                   = -67688
    case InvalidName                        = -67689
    case InvalidCertificateRef              = -67690
    case InvalidCertificateGroup            = -67691
    case TagNotFound                        = -67692
    case InvalidQuery                       = -67693
    case InvalidValue                       = -67694
    case CallbackFailed                     = -67695
    case ACLDeleteFailed                    = -67696
    case ACLReplaceFailed                   = -67697
    case ACLAddFailed                       = -67698
    case ACLChangeFailed                    = -67699
    case InvalidAccessCredentials           = -67700
    case InvalidRecord                      = -67701
    case InvalidACL                         = -67702
    case InvalidSampleValue                 = -67703
    case IncompatibleVersion                = -67704
    case PrivilegeNotGranted                = -67705
    case InvalidScope                       = -67706
    case PVCAlreadyConfigured               = -67707
    case InvalidPVC                         = -67708
    case EMMLoadFailed                      = -67709
    case EMMUnloadFailed                    = -67710
    case AddinLoadFailed                    = -67711
    case InvalidKeyRef                      = -67712
    case InvalidKeyHierarchy                = -67713
    case AddinUnloadFailed                  = -67714
    case LibraryReferenceNotFound           = -67715
    case InvalidAddinFunctionTable          = -67716
    case InvalidServiceMask                 = -67717
    case ModuleNotLoaded                    = -67718
    case InvalidSubServiceID                = -67719
    case AttributeNotInContext              = -67720
    case ModuleManagerInitializeFailed      = -67721
    case ModuleManagerNotFound              = -67722
    case EventNotificationCallbackNotFound  = -67723
    case InputLengthError                   = -67724
    case OutputLengthError                  = -67725
    case PrivilegeNotSupported              = -67726
    case DeviceError                        = -67727
    case AttachHandleBusy                   = -67728
    case NotLoggedIn                        = -67729
    case AlgorithmMismatch                  = -67730
    case KeyUsageIncorrect                  = -67731
    case KeyBlobTypeIncorrect               = -67732
    case KeyHeaderInconsistent              = -67733
    case UnsupportedKeyFormat               = -67734
    case UnsupportedKeySize                 = -67735
    case InvalidKeyUsageMask                = -67736
    case UnsupportedKeyUsageMask            = -67737
    case InvalidKeyAttributeMask            = -67738
    case UnsupportedKeyAttributeMask        = -67739
    case InvalidKeyLabel                    = -67740
    case UnsupportedKeyLabel                = -67741
    case InvalidKeyFormat                   = -67742
    case UnsupportedVectorOfBuffers         = -67743
    case InvalidInputVector                 = -67744
    case InvalidOutputVector                = -67745
    case InvalidContext                     = -67746
    case InvalidAlgorithm                   = -67747
    case InvalidAttributeKey                = -67748
    case MissingAttributeKey                = -67749
    case InvalidAttributeInitVector         = -67750
    case MissingAttributeInitVector         = -67751
    case InvalidAttributeSalt               = -67752
    case MissingAttributeSalt               = -67753
    case InvalidAttributePadding            = -67754
    case MissingAttributePadding            = -67755
    case InvalidAttributeRandom             = -67756
    case MissingAttributeRandom             = -67757
    case InvalidAttributeSeed               = -67758
    case MissingAttributeSeed               = -67759
    case InvalidAttributePassphrase         = -67760
    case MissingAttributePassphrase         = -67761
    case InvalidAttributeKeyLength          = -67762
    case MissingAttributeKeyLength          = -67763
    case InvalidAttributeBlockSize          = -67764
    case MissingAttributeBlockSize          = -67765
    case InvalidAttributeOutputSize         = -67766
    case MissingAttributeOutputSize         = -67767
    case InvalidAttributeRounds             = -67768
    case MissingAttributeRounds             = -67769
    case InvalidAlgorithmParms              = -67770
    case MissingAlgorithmParms              = -67771
    case InvalidAttributeLabel              = -67772
    case MissingAttributeLabel              = -67773
    case InvalidAttributeKeyType            = -67774
    case MissingAttributeKeyType            = -67775
    case InvalidAttributeMode               = -67776
    case MissingAttributeMode               = -67777
    case InvalidAttributeEffectiveBits      = -67778
    case MissingAttributeEffectiveBits      = -67779
    case InvalidAttributeStartDate          = -67780
    case MissingAttributeStartDate          = -67781
    case InvalidAttributeEndDate            = -67782
    case MissingAttributeEndDate            = -67783
    case InvalidAttributeVersion            = -67784
    case MissingAttributeVersion            = -67785
    case InvalidAttributePrime              = -67786
    case MissingAttributePrime              = -67787
    case InvalidAttributeBase               = -67788
    case MissingAttributeBase               = -67789
    case InvalidAttributeSubprime           = -67790
    case MissingAttributeSubprime           = -67791
    case InvalidAttributeIterationCount     = -67792
    case MissingAttributeIterationCount     = -67793
    case InvalidAttributeDLDBHandle         = -67794
    case MissingAttributeDLDBHandle         = -67795
    case InvalidAttributeAccessCredentials  = -67796
    case MissingAttributeAccessCredentials  = -67797
    case InvalidAttributePublicKeyFormat    = -67798
    case MissingAttributePublicKeyFormat    = -67799
    case InvalidAttributePrivateKeyFormat   = -67800
    case MissingAttributePrivateKeyFormat   = -67801
    case InvalidAttributeSymmetricKeyFormat = -67802
    case MissingAttributeSymmetricKeyFormat = -67803
    case InvalidAttributeWrappedKeyFormat   = -67804
    case MissingAttributeWrappedKeyFormat   = -67805
    case StagedOperationInProgress          = -67806
    case StagedOperationNotStarted          = -67807
    case VerifyFailed                       = -67808
    case QuerySizeUnknown                   = -67809
    case BlockSizeMismatch                  = -67810
    case PublicKeyInconsistent              = -67811
    case DeviceVerifyFailed                 = -67812
    case InvalidLoginName                   = -67813
    case AlreadyLoggedIn                    = -67814
    case InvalidDigestAlgorithm             = -67815
    case InvalidCRLGroup                    = -67816
    case CertificateCannotOperate           = -67817
    case CertificateExpired                 = -67818
    case CertificateNotValidYet             = -67819
    case CertificateRevoked                 = -67820
    case CertificateSuspended               = -67821
    case InsufficientCredentials            = -67822
    case InvalidAction                      = -67823
    case InvalidAuthority                   = -67824
    case VerifyActionFailed                 = -67825
    case InvalidCertAuthority               = -67826
    case InvaldCRLAuthority                 = -67827
    case InvalidCRLEncoding                 = -67828
    case InvalidCRLType                     = -67829
    case InvalidCRL                         = -67830
    case InvalidFormType                    = -67831
    case InvalidID                          = -67832
    case InvalidIdentifier                  = -67833
    case InvalidIndex                       = -67834
    case InvalidPolicyIdentifiers           = -67835
    case InvalidTimeString                  = -67836
    case InvalidReason                      = -67837
    case InvalidRequestInputs               = -67838
    case InvalidResponseVector              = -67839
    case InvalidStopOnPolicy                = -67840
    case InvalidTuple                       = -67841
    case MultipleValuesUnsupported          = -67842
    case NotTrusted                         = -67843
    case NoDefaultAuthority                 = -67844
    case RejectedForm                       = -67845
    case RequestLost                        = -67846
    case RequestRejected                    = -67847
    case UnsupportedAddressType             = -67848
    case UnsupportedService                 = -67849
    case InvalidTupleGroup                  = -67850
    case InvalidBaseACLs                    = -67851
    case InvalidTupleCredendtials           = -67852
    case InvalidEncoding                    = -67853
    case InvalidValidityPeriod              = -67854
    case InvalidRequestor                   = -67855
    case RequestDescriptor                  = -67856
    case InvalidBundleInfo                  = -67857
    case InvalidCRLIndex                    = -67858
    case NoFieldValues                      = -67859
    case UnsupportedFieldFormat             = -67860
    case UnsupportedIndexInfo               = -67861
    case UnsupportedLocality                = -67862
    case UnsupportedNumAttributes           = -67863
    case UnsupportedNumIndexes              = -67864
    case UnsupportedNumRecordTypes          = -67865
    case FieldSpecifiedMultiple             = -67866
    case IncompatibleFieldFormat            = -67867
    case InvalidParsingModule               = -67868
    case DatabaseLocked                     = -67869
    case DatastoreIsOpen                    = -67870
    case MissingValue                       = -67871
    case UnsupportedQueryLimits             = -67872
    case UnsupportedNumSelectionPreds       = -67873
    case UnsupportedOperator                = -67874
    case InvalidDBLocation                  = -67875
    case InvalidAccessRequest               = -67876
    case InvalidIndexInfo                   = -67877
    case InvalidNewOwner                    = -67878
    case InvalidModifyMode                  = -67879
    case MissingRequiredExtension           = -67880
    case ExtendedKeyUsageNotCritical        = -67881
    case TimestampMissing                   = -67882
    case TimestampInvalid                   = -67883
    case TimestampNotTrusted                = -67884
    case TimestampServiceNotAvailable       = -67885
    case TimestampBadAlg                    = -67886
    case TimestampBadRequest                = -67887
    case TimestampBadDataFormat             = -67888
    case TimestampTimeNotAvailable          = -67889
    case TimestampUnacceptedPolicy          = -67890
    case TimestampUnacceptedExtension       = -67891
    case TimestampAddInfoNotAvailable       = -67892
    case TimestampSystemFailure             = -67893
    case SigningTimeMissing                 = -67894
    case TimestampRejection                 = -67895
    case TimestampWaiting                   = -67896
    case TimestampRevocationWarning         = -67897
    case TimestampRevocationNotification    = -67898
    case UnexpectedError                    = -99999
}

extension Status : RawRepresentable, CustomStringConvertible {
    
    public init(status: OSStatus) {
        if let mappedStatus = Status(rawValue: status) {
            self = mappedStatus
        } else {
            self = .UnexpectedError
        }
    }
    
    public var description : String {
        switch self {
        case Success:
            return "No error."
        case Unimplemented:
            return "Function or operation not implemented."
        case DiskFull:
            return "The disk is full."
        case IO:
            return "I/O error (bummers)"
        case OpWr:
            return "file already open with with write permission"
        case Param:
            return "One or more parameters passed to a function were not valid."
        case WrPerm:
            return "write permissions error"
        case Allocate:
            return "Failed to allocate memory."
        case UserCanceled:
            return "User canceled the operation."
        case BadReq:
            return "Bad parameter or invalid state for operation."
        case InternalComponent:
            return ""
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
        case InDarkWake:
            return "In dark wake, no UI possible"
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
            return "An internal error occurred in the Security framework."
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
        case MissingRequiredExtension:
            return "A required certificate extension is missing."
        case ExtendedKeyUsageNotCritical:
            return "The extended key usage extension was not marked critical."
        case TimestampMissing:
            return "A timestamp was expected but was not found."
        case TimestampInvalid:
            return "The timestamp was not valid."
        case TimestampNotTrusted:
            return "The timestamp was not trusted."
        case TimestampServiceNotAvailable:
            return "The timestamp service is not available."
        case TimestampBadAlg:
            return "An unrecognized or unsupported Algorithm Identifier in timestamp."
        case TimestampBadRequest:
            return "The timestamp transaction is not permitted or supported."
        case TimestampBadDataFormat:
            return "The timestamp data submitted has the wrong format."
        case TimestampTimeNotAvailable:
            return "The time source for the Timestamp Authority is not available."
        case TimestampUnacceptedPolicy:
            return "The requested policy is not supported by the Timestamp Authority."
        case TimestampUnacceptedExtension:
            return "The requested extension is not supported by the Timestamp Authority."
        case TimestampAddInfoNotAvailable:
            return "The additional information requested is not available."
        case TimestampSystemFailure:
            return "The timestamp request cannot be handled due to system failure."
        case SigningTimeMissing:
            return "A signing time was expected but was not found."
        case TimestampRejection:
            return "A timestamp transaction was rejected."
        case TimestampWaiting:
            return "A timestamp transaction is waiting."
        case TimestampRevocationWarning:
            return "A timestamp authority revocation warning was issued."
        case TimestampRevocationNotification:
            return "A timestamp authority revocation notification was issued."
        case UnexpectedError:
            return "Unexpected error has occurred."
        }
    }
}
