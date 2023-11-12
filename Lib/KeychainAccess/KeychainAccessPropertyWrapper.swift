//
//  Created by Gunnar Herzog - KF Interactive on 22.01.21.
//  Copyright © 2021 KF Interactive GmbH. All rights reserved.
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

@propertyWrapper
public final class KeychainAccess<T: KeychainSerializable> {
    private let key: String
    private let keychain: Keychain

    public var wrappedValue: T? {
        get {
            let foo = keychain[data: key]
            return T.asValue(data: foo) as? T
        }
        set {
            keychain[data: key] = newValue?.data
        }
    }

    public init(_ key: String, keychain: Keychain = Keychain()) {
        self.key = key
        self.keychain = keychain
    }
}

public protocol KeychainSerializable {
    associatedtype Value
    var data: Data { get }
    static func asValue(data: Data?) -> Value?
}

extension String: KeychainSerializable {
    public var data: Data { data(using: .utf8)! }
    public static func asValue(data: Data?) -> String? {
        guard let data = data else { return nil }
        return String(data: data, encoding: .utf8)
    }
}

extension Data: KeychainSerializable {
    public var data: Data { self }
    public static func asValue(data: Data?) -> Data? { data }
}

public extension KeychainSerializable where Self: Codable {
    var data: Data {
        do {
            return try JSONEncoder().encode(self)
        } catch {
            fatalError("Failure encoding type \(Self.self): \(error.localizedDescription)")
        }
    }

    static func asValue(data: Data?) -> Self? {
        guard let data = data else { return nil }
        return try? JSONDecoder().decode(Self.self, from: data)
    }
}
