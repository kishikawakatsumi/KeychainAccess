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
keychain.set("01234567-89ab-cdef-0123-456789abcdef", key: "kishikawakatsumi")


/*****************
 * Obtaining items
 *****************/

var token: String?
/* subscripting (automatically convert to String) */
token = keychain["kishikawakatsumi"]

/* get method */

// as String
token = keychain.get("kishikawakatsumi")
token = keychain.getString("kishikawakatsumi")

// as Data
let data = keychain.getData("kishikawakatsumi")

/****************
 * Removing items
 ****************/

/* subscripting */
keychain["kishikawakatsumi"] = nil

/* remove method */
keychain.remove("kishikawakatsumi")


/****************
 * Error handling
*****************/

/* set */
if let error = keychain.set("01234567-89ab-cdef-0123-456789abcdef", key: "kishikawakatsumi") {
    print("error: \(error.localizedDescription)")
}

/* get */
// First, get the failable (value or error) object
let failable = keychain.getStringOrError("kishikawakatsumi")

// 1. check the enum state
switch failable {
case .Success:
    print("token: \(failable.value)")
case .Failure:
    print("error: \(failable.error)")
}

// 2. check the error object
if let error = failable.error {
    print("error: \(failable.error)")
} else {
    print("token: \(failable.value)")
}

// 3. check the failed property
if failable.failed {
    print("error: \(failable.error)")
} else {
    print("token: \(failable.value)")
}

/* remove */
if let error = keychain.remove("kishikawakatsumi") {
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

keychain
    .accessibility(.AfterFirstUnlock)
    .synchronizable(true)
    .set("01234567-89ab-cdef-0123-456789abcdef", key: "kishikawakatsumi")

keychain
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
