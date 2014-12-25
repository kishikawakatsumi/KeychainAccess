# KeychainAccess
[![CI Status](http://img.shields.io/travis/kishikawakatsumi/KeychainAccess.svg?style=flat)](https://travis-ci.org/kishikawakatsumi/KeychainAccess)
[![Carthage Compatibility](https://img.shields.io/badge/carthage-✓-f2a77e.svg?style=flat)](https://github.com/Carthage/Carthage/)
[![Version](https://img.shields.io/cocoapods/v/KeychainAccess.svg?style=flat)](http://cocoadocs.org/docsets/KeychainAccess)
[![License](https://img.shields.io/cocoapods/l/KeychainAccess.svg?style=flat)](http://cocoadocs.org/docsets/KeychainAccess)
[![Platform](https://img.shields.io/cocoapods/p/KeychainAccess.svg?style=flat)](http://cocoadocs.org/docsets/KeychainAccess)

KeychainAccess is a simple Swift wrapper for Keychain that works on iOS and OS X. Makes using Keychain APIs exremely easy and much more palatable to use in Swift.

## Usage

### Convienient class methods

#### Adding an item

```swift
Keychain.set("kishikawakatsumi", key: "username")
Keychain.set("abcd1234", key: "password")
```

```swift
Keychain.set("kishikawakatsumi", key: "username", service: "example.com")
Keychain.set("abcd1234", key: "password", service: "example.com")
```

```swift
Keychain.set("kishikawakatsumi", key: "username", service: "example.com", accessGroup: "12ABCD3E4F.shared")
Keychain.set("abcd1234", key: "password", service: "example.com", accessGroup: "12ABCD3E4F.shared")
```

```swift
Keychain.set("kishikawakatsumi", key: "username", service: "example.com", accessGroup: "12ABCD3E4F.shared", accessibility: .WhenUnlocked)
```

```swift
Keychain.set("kishikawakatsumi", key: "username", service: "example.com", accessGroup: "12ABCD3E4F.shared", accessibility: .WhenUnlocked, synchronizable: true)
```

```swift
Keychain.set("kishikawakatsumi", key: "username") { error in
  println("error: \(error)")
}
```

#### Obtaining an item

```swift
let username = Keychain.get("username")
let password = Keychain.get("password")
```

```swift
let username = Keychain.get("username", service: "example.com")
let password = Keychain.get("password", service: "example.com")
```

```swift
let username = Keychain.get("username", service: "example.com", accessGroup: "12ABCD3E4F.shared")
let password = Keychain.get("password", service: "example.com", accessGroup: "12ABCD3E4F.shared")
```

```swift
let username = Keychain.get("username") { error in
  println("error: \(error)")
}
```

#### Removing an item

```swift
Keychain.remove("username")
Keychain.remove("password")
```

```swift
Keychain.remove("username", service: "example.com")
Keychain.remove("password", service: "example.com")
```

```swift
Keychain.remove("username", service: "example.com", accessGroup: "12ABCD3E4F.shared")
Keychain.remove("password", service: "example.com", accessGroup: "12ABCD3E4F.shared")
```

```swift
Keychain.remove("username") { error in
  println("error: \(error)")
}
```

### Configuring various Keychain settings

```swift
let keychain = Keychain(service: "example.com")
```

```swift
let background = Keychain(service: "example.com", accessibility: .AfterFirstUnlock)
```

```swift
let foreground = Keychain(service: "example.com", accessibility: .WhenUnlocked)
```

```swift
let shared = Keychain(service: "example.com", accessGroup: "12ABCD3E4F.shared")
```

```swift
let synchronizable = Keychain(service: "example.com", accessGroup: "com.kishikawakatsumi", synchronizable: true)
```

#### Adding an item

```swift
keychain["username"] = "kishikawakatsumi"
keychain["password"] = "abcd1234"
```

```swift
keychain.set("kishikawakatsumi", key: "username")
keychain.set("abcd1234", key: "password")
```

```swift
keychain.set("kishikawakatsumi", key: "username"){ error in
  println("error: \(error)")
}
```

#### Obtaining an item

```swift
let username = keychain["username"]
let password = keychain["password"]
```

```swift
let username = keychain.get("username")
let password = keychain.get("password")
```

```swift
let username = keychain.get("username") { error in
  println("error: \(error)")
}
```

#### Removing an item

```swift
keychain["username"] = nil
keychain["password"] = nil
```

```swift
keychain.remove("username")
keychain.remove("password")
```

```swift
keychain.remove("username") { error in
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
