import UIKit
import XCPlayground

import KeychainAccess

var keychain: Keychain

keychain = Keychain(service: "example.com") // Generic Password

let URL = NSURL(string: "https://kishikawakatsumi.com")!
keychain = Keychain(server: URL, protocolType: .HTTPS) // Internet Password


// Adding items
keychain["username"] = "kishikawakatsumi"
keychain["password"] = "abcd1234"

keychain.set("kishikawakatsumi", key: "username")
keychain.set("abcd1234", key: "password")


// Obtaining items
var username = keychain["username"]
var password = keychain["password"]

username = keychain.get("username").asString
password = keychain.get("password").asString


// Removing items
keychain["username"] = nil
keychain["password"] = nil

keychain.remove("username")
keychain.remove("password")


// Configuration

let background = Keychain(service: "example.com")
    .accessibility(.AfterFirstUnlock) // for background application

let forground = Keychain(service: "example.com")
    .accessibility(.WhenUnlocked) // for forground application

// Sharing Keychain Items
let shared = Keychain(service: "example.com", accessGroup: "12ABCD3E4F.shared")

let iCloud = Keychain(service: "example.com", accessGroup: "12ABCD3E4F.shared")
    .synchronizable(true)

// One-Shot configuration change
keychain
    .accessibility(.AfterFirstUnlock)
    .synchronizable(true)
    .set("kishikawakatsumi", key: "username")

keychain
    .accessibility(.WhenUnlocked)
    .set("abcd1234", key: "password")
