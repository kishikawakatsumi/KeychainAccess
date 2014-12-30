import UIKit
import XCPlayground

import KeychainAccess

var keychain: Keychain

/***************
 * Instantiation
 ***************/

/* for Generic Password */

keychain = Keychain(service: "Twitter")

/* for Internet Password */

let URL = NSURL(string: "https://example.com")!
keychain = Keychain(server: URL, protocolType: .HTTPS)


/**************
 * Adding items
 **************/

/* subscripting */

keychain["username"] = "kishikawakatsumi"
keychain["password"] = "abcd1234"

/* set method */

keychain.set("kishikawakatsumi", key: "username")
keychain.set("abcd1234", key: "password")


/*****************
 * Obtaining items
 *****************/

/* subscripting (automatically convert to String) */

var username = keychain["username"]
var password = keychain["password"]

/* get method */

// as String
username = keychain.get("username")
password = keychain.getString("password")

// as Data
let data = keychain.getData("username")

/****************
 * Removing items
 ****************/

/* subscripting */

keychain["username"] = nil
keychain["password"] = nil

/* remove method */

keychain.remove("username")
keychain.remove("password")


/****************
 * Error handling
*****************/

/* set */

if let error = keychain.set("kishikawakatsumi", key: "username") {
    println("error: \(error.localizedDescription)")
}


/* get */

let failable = keychain.getStringOrError("username")

// 1. check enum state
switch failable {
case .Success:
    println("username: \(failable.value)")
case .Failure:
    println("error: \(failable.error)")
}

// 2. check error object
if let error = failable.error {
    println("error: \(failable.error)")
} else {
    println("username: \(failable.value)")
}

// 3. by failed property
if failable.failed {
    println("error: \(failable.error)")
} else {
    println("username: \(failable.value)")
}


/* remove */

if let error = keychain.remove("username") {
    println("error: \(error.localizedDescription)")
}


/***************
 * Configuration
 ***************/

let background = Keychain(service: "Twitter")
    .accessibility(.AfterFirstUnlock) // for background application

let forground = Keychain(service: "Twitter")
    .accessibility(.WhenUnlocked) // for forground application

/* Sharing Keychain Items */

let shared = Keychain(service: "Twitter", accessGroup: "12ABCD3E4F.shared")

let iCloud = Keychain(service: "Twitter", accessGroup: "12ABCD3E4F.shared")
    .synchronizable(true)

/* One-Shot configuration change */

keychain
    .accessibility(.AfterFirstUnlock)
    .synchronizable(true)
    .set("kishikawakatsumi", key: "username")

keychain
    .accessibility(.WhenUnlocked)
    .set("abcd1234", key: "password")
