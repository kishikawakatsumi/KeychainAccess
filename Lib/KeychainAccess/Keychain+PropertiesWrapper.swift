//
//  Keychain+PropertiesWrapper.swift
//
//
//  Created by Stuart Nguyen on 9/12/20.
//

import Foundation

@propertyWrapper
public struct KeychainString {
    private let keychain: Keychain
    private let key: String

    public init(serviceName: String, key: String) {
        self.keychain = Keychain(service: serviceName)
        self.key = key
    }

    public var wrappedValue: String? {
        get {
            return try? keychain.getString(key)
        }
        set {
            if let value = newValue {
                try? keychain.set(value, key: key)
            } else {
                try? keychain.remove(key)
            }
        }
    }
}

@propertyWrapper
public struct KeychainData {
    private let keychain: Keychain
    private let key: String

    public init(serviceName: String, key: String) {
        self.keychain = Keychain(service: serviceName)
        self.key = key
    }

    public var wrappedValue: Data? {
        get {
            return try? keychain.getData(key)
        }
        set {
            if let value = newValue {
                try? keychain.set(value, key: key)
            } else {
                try? keychain.remove(key)
            }
        }
    }
}
