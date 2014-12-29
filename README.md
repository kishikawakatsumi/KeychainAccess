# KeychainAccess
[![CI Status](http://img.shields.io/travis/kishikawakatsumi/KeychainAccess.svg?style=flat)](https://travis-ci.org/kishikawakatsumi/KeychainAccess)
[![Carthage Compatibility](https://img.shields.io/badge/carthage-✓-f2a77e.svg?style=flat)](https://github.com/Carthage/Carthage/)
[![Version](https://img.shields.io/cocoapods/v/KeychainAccess.svg?style=flat)](http://cocoadocs.org/docsets/KeychainAccess)
[![License](https://img.shields.io/cocoapods/l/KeychainAccess.svg?style=flat)](http://cocoadocs.org/docsets/KeychainAccess)
[![Platform](https://img.shields.io/cocoapods/p/KeychainAccess.svg?style=flat)](http://cocoadocs.org/docsets/KeychainAccess)

KeychainAccess is a simple Swift wrapper for Keychain that works on iOS and OS X. Makes using Keychain APIs exremely easy and much more palatable to use in Swift.

## Usage

#### Initialization

##### Create Keychain for Generic Password

```swift
let keychain = Keychain(service: "example.com")
```

```swift
let keychain = Keychain(service: "example.com", accessGroup: "12ABCD3E4F.shared")
```

##### Create Keychain for Internet Password

```swift
let keychain = Keychain(server: NSURL(string: "https://kishikawakatsumi.com")!, protocolType: .HTTPS)
```

```swift
let keychain = Keychain(server: NSURL(string: "https://kishikawakatsumi.com")!, protocolType: .HTTPS, authenticationType: .Default)
```

#### Adding an item

```swift
keychain.set("kishikawakatsumi", key: "username")
keychain.set("abcd1234", key: "password")
```

##### subscripting

```swift
keychain["username"] = "kishikawakatsumi"
keychain["password"] = "abcd1234"
```

##### error handling

```swift
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
let username = keychain.get("username").asString
let password = keychain.get("password").asString
```

##### as NSData

```swift
let data = keychain.get("data").asData
```

##### subscripting (automatically converts to string)

```swift
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
keychain.remove("username")
keychain.remove("password")
```

##### subscripting

```swift
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

### Configuration

###### *Provides fluent interfaces*

```swift
let keychain = Keychain(service: "example.com")
    .synchronizable(true)
    .accessibility(.AfterFirstUnlock)
```

#### Accessibility

##### Default (=kSecAttrAccessibleAfterFirstUnlock)

```swift
let keychain = Keychain(service: "example.com")
```

##### For background application

###### Creating instance

```swift
let keychain = Keychain(service: "example.com")
    .accessibility(.AfterFirstUnlock)

keychain["password"] = password
```

###### One shot

```swift
let keychain = Keychain(service: "example.com")

keychain
    .accessibility(.AfterFirstUnlock)
    .set(password, key: "password")
```

##### For foreground application

###### Creating instance

```swift
let keychain = Keychain(service: "example.com")
    .accessibility(.WhenUnlocked)

keychain["password"] = password
```

###### One shot

```swift
let keychain = Keychain(service: "example.com")

keychain
    .accessibility(.WhenUnlocked)
    .set(password, key: "password")
```

##### Sharing Keychain items

```swift
let keychain = Keychain(service: "example.com", accessGroup: "12ABCD3E4F.shared")
```

##### Synchronizing Keychain items with iCloud

###### Creating instance

```swift
let keychain = Keychain(service: "example.com")
    .synchronizable(true)

keychain["password"] = password
```

###### One shot

```swift
let keychain = Keychain(service: "example.com")

keychain
    .synchronizable(true)
    .set(password, key: "password")
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
