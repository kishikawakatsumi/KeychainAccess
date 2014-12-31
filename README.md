# KeychainAccess
[![CI Status](http://img.shields.io/travis/kishikawakatsumi/KeychainAccess.svg?style=flat)](https://travis-ci.org/kishikawakatsumi/KeychainAccess)
[![Carthage Compatibility](https://img.shields.io/badge/carthage-✓-f2a77e.svg?style=flat)](https://github.com/Carthage/Carthage/)
[![Version](https://img.shields.io/cocoapods/v/KeychainAccess.svg?style=flat)](http://cocoadocs.org/docsets/KeychainAccess)
[![License](https://img.shields.io/cocoapods/l/KeychainAccess.svg?style=flat)](http://cocoadocs.org/docsets/KeychainAccess)
[![Platform](https://img.shields.io/cocoapods/p/KeychainAccess.svg?style=flat)](http://cocoadocs.org/docsets/KeychainAccess)

KeychainAccess is a simple Swift wrapper for Keychain that works on iOS and OS X. Makes using Keychain APIs exremely easy and much more palatable to use in Swift.

<img src="https://raw.githubusercontent.com/kishikawakatsumi/KeychainAccess/master/Screenshots/01.png" width="320px" />

## Usage

See also [Playground](https://github.com/kishikawakatsumi/KeychainAccess/blob/master/Examples/Playground-iOS.playground/section-1.swift).

### Basics

#### Saving Application Password

```swift
let keychain = Keychain(service: "com.example.github-token")
keychain["kishikawakatsumi"] = "01234567-89ab-cdef-0123-456789abcdef"
```

#### Saving Internet Password

```swift
let keychain = Keychain(server: NSURL(string: "https://github.com")!, protocolType: .HTTPS)
    .label("github.com (kishikawakatsumi)")

keychain["kishikawakatsumi"] = "01234567-89ab-cdef-0123-456789abcdef"
```

### Instantiation

#### Create Keychain for Application Password

```swift
let keychain = Keychain(service: "com.example.github-token")
```

```swift
let keychain = Keychain(service: "com.example.github-token", accessGroup: "12ABCD3E4F.shared")
```

#### Create Keychain for Internet Password

```swift
let keychain = Keychain(server: NSURL(string: "https://github.com")!, protocolType: .HTTPS)
```

```swift
let keychain = Keychain(server: NSURL(string: "https://github.com")!, protocolType: .HTTPS, authenticationType: .HTMLForm)
```

### Adding an item

#### subscripting

```swift
keychain["kishikawakatsumi"] = "01234567-89ab-cdef-0123-456789abcdef"
```

#### set method

```swift
keychain.set("01234567-89ab-cdef-0123-456789abcdef", key: "kishikawakatsumi")
```

#### error handling

```swift
if let error = keychain.set("01234567-89ab-cdef-0123-456789abcdef", key: "kishikawakatsumi") {
    println("error: \(error)")
}
```

#### Obtaining an item

##### subscripting (automatically converts to string)

```swift
let token = keychain["kishikawakatsumi"]
```

##### get methods

###### as String

```swift
let token = keychain.get("kishikawakatsumi")
```

```swift
let token = keychain.getString("kishikawakatsumi")
```

###### as NSData

```swift
let data = keychain.getData("kishikawakatsumi")
```

##### error handling

**First, get the `failable` (value or error) object**

```swift
let failable = keychain.getStringOrError("kishikawakatsumi")
```

**1. check `enum` state**

```swift
switch failable {
case .Success:
  println("token: \(failable.value)")
case .Failure:
  println("error: \(failable.error)")
}
```

**2. check `error` object**

```swift
if let error = failable.error {
    println("error: \(failable.error)")
} else {
    println("token: \(failable.value)")
}
```

**3. check `failed` property**

```swift
if failable.failed {
    println("error: \(failable.error)")
} else {
    println("token: \(failable.value)")
}
```

#### Removing an item

##### subscripting

```swift
keychain["kishikawakatsumi"] = nil
```

##### remove method

```swift
keychain.remove("kishikawakatsumi")
```

##### error handling

```swift
if let error = keychain.remove("kishikawakatsumi") {
    println("error: \(error)")
}
```

### Label and Comment

```swift
let keychain = Keychain(server: NSURL(string: "https://github.com")!, protocolType: .HTTPS)
    .label("github.com (kishikawakatsumi)")
    .comment("github access token")
```

### Configuration

**Provides fluent interfaces**

```swift
let keychain = Keychain(service: "com.example.github-token")
    .label("github.com (kishikawakatsumi)")
    .synchronizable(true)
    .accessibility(.AfterFirstUnlock)
```

#### Accessibility

##### Default accessibility matches background application (=kSecAttrAccessibleAfterFirstUnlock)

```swift
let keychain = Keychain(service: "com.example.github-token")
```

##### For background application

###### Creating instance

```swift
let keychain = Keychain(service: "com.example.github-token")
    .accessibility(.AfterFirstUnlock)

keychain["kishikawakatsumi"] = "01234567-89ab-cdef-0123-456789abcdef"
```

###### One-shot

```swift
let keychain = Keychain(service: "com.example.github-token")

keychain
    .accessibility(.AfterFirstUnlock)
    .set("01234567-89ab-cdef-0123-456789abcdef", key: "kishikawakatsumi")
```

##### For foreground application

###### Creating instance

```swift
let keychain = Keychain(service: "com.example.github-token")
    .accessibility(.WhenUnlocked)

keychain["kishikawakatsumi"] = "01234567-89ab-cdef-0123-456789abcdef"
```

###### One-shot

```swift
let keychain = Keychain(service: "Twitter")

keychain
    .accessibility(.WhenUnlocked)
    .set("01234567-89ab-cdef-0123-456789abcdef", key: "kishikawakatsumi")
```

#### Sharing Keychain items

```swift
let keychain = Keychain(service: "com.example.github-token", accessGroup: "12ABCD3E4F.shared")
```

#### Synchronizing Keychain items with iCloud

###### Creating instance

```swift
let keychain = Keychain(service: "com.example.github-token")
    .synchronizable(true)

keychain["kishikawakatsumi"] = "01234567-89ab-cdef-0123-456789abcdef"
```

###### One-shot

```swift
let keychain = Keychain(service: "com.example.github-token")

keychain
    .synchronizable(true)
    .set("01234567-89ab-cdef-0123-456789abcdef", key: "kishikawakatsumi")
```

### Debugging

#### Display all stored items if print keychain object

```swift
let keychain = Keychain(server: NSURL(string: "https://github.com")!, protocolType: .HTTPS)
println("\(keychain)")
```

```
=>
[
  [authenticationType: Default, key: kishikawakatsumi, server: github.com, class: InternetPassword, protocol: HTTPS]
  [authenticationType: Default, key: hirohamada, server: github.com, class: InternetPassword, protocol: HTTPS]
  [authenticationType: Default, key: honeylemon, server: github.com, class: InternetPassword, protocol: HTTPS]
]
```

#### Obtaining all stored keys

```swift
let keychain = Keychain(server: NSURL(string: "https://github.com")!, protocolType: .HTTPS)

let keys = keychain.allKeys()
for key in keys {
  println("key: \(key)")
}
```

```
=>
key: kishikawakatsumi
key: hirohamada
key: honeylemon
```

#### Obtaining all stored items

```swift
let keychain = Keychain(server: NSURL(string: "https://github.com")!, protocolType: .HTTPS)

let items = keychain.allItems()
for item in items {
  println("item: \(item)")
}
```

```
=>
item: [authenticationType: Default, key: kishikawakatsumi, server: github.com, class: InternetPassword, protocol: HTTPS]
item: [authenticationType: Default, key: hirohamada, server: github.com, class: InternetPassword, protocol: HTTPS]
item: [authenticationType: Default, key: honeylemon, server: github.com, class: InternetPassword, protocol: HTTPS]
```

## Requirements

iOS 7 or later
OS X 10.9 or later

## Installation

### CocoaPods

KeychainAccess is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

`pod 'KeychainAccess'`

### Carthage

KeychainAccess is available through [Carthage](https://github.com/Carthage/Carthage). To install
it, simply add the following line to your Cartfile:

`github "kishikawakatsumi/KeychainAccess"`

## Author

kishikawa katsumi, kishikawakatsumi@mac.com

## License

KeychainAccess is available under the MIT license. See the LICENSE file for more info.
