import UIKit
import XCPlayground

import KeychainAccess

var keychain: Keychain

/***************
 * Instantiation
 ***************/

/* for Application Password */
keychain = Keychain(service: "com.example.github-token")

/* for Internet Password */
let URL = NSURL(string: "https://github.com")!
keychain = Keychain(server: URL, protocolType: .HTTPS)


/**************
 * Adding items
 **************/

/* subscripting */
keychain["kishikawakatsumi"] = "01234567-89ab-cdef-0123-456789abcdef"

/* set method */
try! keychain.set("01234567-89ab-cdef-0123-456789abcdef", key: "kishikawakatsumi")


/*****************
 * Obtaining items
 *****************/

var token: String?
/* subscripting (automatically convert to String) */
token = keychain["kishikawakatsumi"]

/* get method */

// as String
token = try! keychain.get("kishikawakatsumi")
token = try! keychain.getString("kishikawakatsumi")

// as Data
let data = try! keychain.getData("kishikawakatsumi")

/****************
 * Removing items
 ****************/

/* subscripting */
keychain["kishikawakatsumi"] = nil

/* remove method */
try! keychain.remove("kishikawakatsumi")


/****************
 * Error handling
 ****************/

/* set */
do {
    try keychain.set("01234567-89ab-cdef-0123-456789abcdef", key: "kishikawakatsumi")
} catch let error as NSError {
    print("error: \(error.localizedDescription)")
}

/* get */
// First, get the failable (value or error) object
do {
    let token = try keychain.get("kishikawakatsumi")
} catch let error as NSError {
    print("error: \(error.localizedDescription)")
}

/* remove */
do {
    try keychain.remove("kishikawakatsumi")
} catch let error as NSError {
    print("error: \(error.localizedDescription)")
}


/*******************
 * Label and Comment
 *******************/

keychain = Keychain(server: NSURL(string: "https://github.com")!, protocolType: .HTTPS)
    .label("github.com (kishikawakatsumi)")
    .comment("github access token")


/***************
 * Configuration
 ***************/

/* for background application */
let background = Keychain(service: "com.example.github-token")
    .accessibility(.AfterFirstUnlock)

/* for forground application */
let forground = Keychain(service: "com.example.github-token")
    .accessibility(.WhenUnlocked)

/* Sharing Keychain Items */
let shared = Keychain(service: "com.example.github-token", accessGroup: "12ABCD3E4F.shared")

/* Synchronizing Keychain items with iCloud */
let iCloud = Keychain(service: "com.example.github-token")
    .synchronizable(true)

/* One-Shot configuration change */

try! keychain
    .accessibility(.AfterFirstUnlock)
    .synchronizable(true)
    .set("01234567-89ab-cdef-0123-456789abcdef", key: "kishikawakatsumi")

try! keychain
    .accessibility(.WhenUnlocked)
    .set("01234567-89ab-cdef-0123-456789abcdef", key: "kishikawakatsumi")


/***********
 * Debugging
 ***********/

/* Display all stored items if print keychain object */
keychain = Keychain(server: NSURL(string: "https://github.com")!, protocolType: .HTTPS)
print("\(keychain)")

/* Obtaining all stored keys */
let keys = keychain.allKeys()
for key in keys {
    print("key: \(key)")
}

/* Obtaining all stored items */
let items = keychain.allItems()
for item in items {
    print("item: \(item)")
}
