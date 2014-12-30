# KeychainAccess
[![CI Status](http://img.shields.io/travis/kishikawakatsumi/KeychainAccess.svg?style=flat)](https://travis-ci.org/kishikawakatsumi/KeychainAccess)
[![Carthage Compatibility](https://img.shields.io/badge/carthage-✓-f2a77e.svg?style=flat)](https://github.com/Carthage/Carthage/)
[![Version](https://img.shields.io/cocoapods/v/KeychainAccess.svg?style=flat)](http://cocoadocs.org/docsets/KeychainAccess)
[![License](https://img.shields.io/cocoapods/l/KeychainAccess.svg?style=flat)](http://cocoadocs.org/docsets/KeychainAccess)
[![Platform](https://img.shields.io/cocoapods/p/KeychainAccess.svg?style=flat)](http://cocoadocs.org/docsets/KeychainAccess)

KeychainAccess is a simple Swift wrapper for Keychain that works on iOS and OS X. Makes using Keychain APIs exremely easy and much more palatable to use in Swift.

## Usage

See also [Playground](https://github.com/kishikawakatsumi/KeychainAccess/blob/master/Examples/Playground-iOS.playground/section-1.swift).

#### Instantiation

##### Create Keychain for Generic Password

```swift
let keychain = Keychain(service: "Twitter")
```

```swift
let keychain = Keychain(service: "Twitter", accessGroup: "12ABCD3E4F.shared")
```

##### Create Keychain for Internet Password

```swift
let keychain = Keychain(server: NSURL(string: "https://example.com")!, protocolType: .HTTPS)
```

```swift
let keychain = Keychain(server: NSURL(string: "https://example.com")!, protocolType: .HTTPS, authenticationType: .HTMLForm)
```

#### Adding an item

##### subscripting

```swift
keychain["username"] = "kishikawakatsumi"
keychain["password"] = "abcd1234"
```

##### set method

```swift
keychain.set("kishikawakatsumi", key: "username")
keychain.set("abcd1234", key: "password")
```

##### error handling

```swift
if let error = keychain.set("kishikawakatsumi", key: "username") {
    println("error: \(error)")
}
```

#### Obtaining an item

##### subscripting (automatically converts to string)

```swift
let username = keychain["username"]
let password = keychain["password"]
```

##### get methods

###### as String

```swift
username = keychain.get("username")
password = keychain.getString("password")
```

###### as NSData

```swift
let data = keychain.getData("username")
```

##### error handling

```swift
let failable = keychain.getStringOrError("username")
```

1. check enum state

```swift
switch failable {
case .Success:
  println("username: \(failable.value)")
case .Failure:
  println("error: \(failable.error)")
}
```

2. check error object

```swift
if let error = failable.error {
    println("error: \(failable.error)")
} else {
    println("username: \(failable.value)")
}
```

3. by failed property

```swift
if failable.failed {
    println("error: \(failable.error)")
} else {
    println("username: \(failable.value)")
}
```

#### Removing an item

##### subscripting

```swift
keychain["username"] = nil
keychain["password"] = nil
```

##### remove method

```swift
keychain.remove("username")
keychain.remove("password")
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
let keychain = Keychain(service: "Twitter")
    .synchronizable(true)
    .accessibility(.AfterFirstUnlock)
```

#### Accessibility

##### Default (=kSecAttrAccessibleAfterFirstUnlock)

```swift
let keychain = Keychain(service: "Twitter")
```

##### For background application

###### Creating instance

```swift
let keychain = Keychain(service: "Twitter")
    .accessibility(.AfterFirstUnlock)

keychain["password"] = password
```

###### One-shot

```swift
let keychain = Keychain(service: "Twitter")

keychain
    .accessibility(.AfterFirstUnlock)
    .set(password, key: "password")
```

##### For foreground application

###### Creating instance

```swift
let keychain = Keychain(service: "Twitter")
    .accessibility(.WhenUnlocked)

keychain["password"] = password
```

###### One-shot

```swift
let keychain = Keychain(service: "Twitter")

keychain
    .accessibility(.WhenUnlocked)
    .set(password, key: "password")
```

##### Sharing Keychain items

```swift
let keychain = Keychain(service: "Twitter", accessGroup: "12ABCD3E4F.shared")
```

##### Synchronizing Keychain items with iCloud

###### Creating instance

```swift
let keychain = Keychain(service: "Twitter")
    .synchronizable(true)

keychain["password"] = password
```

###### One-shot

```swift
let keychain = Keychain(service: "Twitter")

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
