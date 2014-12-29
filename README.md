# KeychainAccess
[![CI Status](http://img.shields.io/travis/kishikawakatsumi/KeychainAccess.svg?style=flat)](https://travis-ci.org/kishikawakatsumi/KeychainAccess)
[![Carthage Compatibility](https://img.shields.io/badge/carthage-✓-f2a77e.svg?style=flat)](https://github.com/Carthage/Carthage/)
[![Version](https://img.shields.io/cocoapods/v/KeychainAccess.svg?style=flat)](http://cocoadocs.org/docsets/KeychainAccess)
[![License](https://img.shields.io/cocoapods/l/KeychainAccess.svg?style=flat)](http://cocoadocs.org/docsets/KeychainAccess)
[![Platform](https://img.shields.io/cocoapods/p/KeychainAccess.svg?style=flat)](http://cocoadocs.org/docsets/KeychainAccess)

KeychainAccess is a simple Swift wrapper for Keychain that works on iOS and OS X. Makes using Keychain APIs exremely easy and much more palatable to use in Swift.

## Usage

#### Adding an item

```swift
let keychain = Keychain(service: "example.com")

keychain.set("kishikawakatsumi", key: "username")
keychain.set("abcd1234", key: "password")
```

##### subscripting

```swift
let keychain = Keychain(service: "example.com")

keychain["username"] = "kishikawakatsumi"
keychain["password"] = "abcd1234"
```

##### error handling

```swift
let keychain = Keychain(service: "example.com")

if let error = keychain.set("kishikawakatsumi", key: "username") {
    println("error: \(error)")
}
if let error = keychain.set("abcd1234", key: "password") {
    println("error: \(error)")
}
```

#### Obtaining an item

##### as String

```swift
let keychain = Keychain(service: "example.com")

let username = keychain.get("username").asString
let password = keychain.get("password").asString
```

##### as NSData

```swift
let keychain = Keychain(service: "example.com")

let data = keychain.get("data").asData
```

##### subscripting (automatically converts to string)

```swift
let keychain = Keychain(service: "example.com")

let username = keychain["username"]
let password = keychain["password"]
```

##### error handling

```swift
let username = keychain.get("username")
if let error = username.error {
    println("error: \(error)")
} else {
    println("username: \(username.asString)")
}
```

#### Removing an item

```swift
let keychain = Keychain(service: "example.com")

keychain.remove("username")
keychain.remove("password")
```

##### subscripting

```swift
let keychain = Keychain(service: "example.com")

keychain["username"] = nil
keychain["password"] = nil
```

##### error handling

```swift
if let error = keychain.remove("username") {
    println("error: \(error)")
}
if let error = keychain.remove("password") {
    println("error: \(error)")
}
```

## Requirements

iOS 7 or later
OS X 10.9 or later

## Installation

KeychainAccess is available through [Carthage](https://github.com/Carthage/Carthage). To install
it, simply add the following line to your Cartfile:

`github "kishikawakatsumi/KeychainAccess"`

## Author

kishikawa katsumi, kishikawakatsumi@mac.com

## License

KeychainAccess is available under the MIT license. See the LICENSE file for more info.
