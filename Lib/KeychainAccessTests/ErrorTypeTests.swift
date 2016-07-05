//
//  ErrorTypeTests.swift
//  KeychainAccessTests
//
//  Created by kishikawa katsumi on 10/12/15.
//  Copyright © 2015 kishikawa katsumi. All rights reserved.
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

import XCTest
import KeychainAccess

class ErrorTypeTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }
    
    func testErrorType() {
        do {
            let status = Status(rawValue: errSecSuccess)
            XCTAssertEqual(status, .Success)
            XCTAssertEqual(status?.description, "No error.")
        }
        do {
            let status = Status(rawValue: errSecUnimplemented)
            XCTAssertEqual(status, .Unimplemented)
            XCTAssertEqual(status?.description, "Function or operation not implemented.")
        }
        #if os(OSX)
        do {
            let status = Status(rawValue: errSecDskFull)
            XCTAssertEqual(status, .DiskFull)
            XCTAssertEqual(status?.description, "The disk is full.")
        }
        #endif
        do {
            let status = Status(rawValue: errSecIO)
            XCTAssertEqual(status, .IO)
            XCTAssertEqual(status?.description, "I/O error (bummers)")
        }
        #if os(iOS)
        do {
            let status = Status(rawValue: errSecOpWr)
            XCTAssertEqual(status, .OpWr)
            XCTAssertEqual(status?.description, "file already open with with write permission")
        }
        #endif
        do {
            let status = Status(rawValue: errSecParam)
            XCTAssertEqual(status, .Param)
            XCTAssertEqual(status?.description, "One or more parameters passed to a function were not valid.")
        }
        #if os(OSX)
        do {
            let status = Status(rawValue: errSecWrPerm)
            XCTAssertEqual(status, .WrPerm)
            XCTAssertEqual(status?.description, "write permissions error")
        }
        #endif
        do {
            let status = Status(rawValue: errSecAllocate)
            XCTAssertEqual(status, .Allocate)
            XCTAssertEqual(status?.description, "Failed to allocate memory.")
        }
        do {
            let status = Status(rawValue: errSecUserCanceled)
            XCTAssertEqual(status, .UserCanceled)
            XCTAssertEqual(status?.description, "User canceled the operation.")
        }
        do {
            let status = Status(rawValue: errSecBadReq)
            XCTAssertEqual(status, .BadReq)
            XCTAssertEqual(status?.description, "Bad parameter or invalid state for operation.")
        }
        do {
            let status = Status(rawValue: errSecInternalComponent)
            XCTAssertEqual(status, .InternalComponent)
            XCTAssertEqual(status?.description, "")
        }
        do {
            let status = Status(rawValue: errSecNotAvailable)
            XCTAssertEqual(status, .NotAvailable)
            XCTAssertEqual(status?.description, "No keychain is available. You may need to restart your computer.")
        }
        #if os(OSX)
        do {
            let status = Status(rawValue: errSecReadOnly)
            XCTAssertEqual(status, .ReadOnly)
            XCTAssertEqual(status?.description, "This keychain cannot be modified.")
        }
        #endif
        do {
            let status = Status(rawValue: errSecAuthFailed)
            XCTAssertEqual(status, .AuthFailed)
            XCTAssertEqual(status?.description, "The user name or passphrase you entered is not correct.")
        }
        #if os(OSX)
        do {
            let status = Status(rawValue: errSecNoSuchKeychain)
            XCTAssertEqual(status, .NoSuchKeychain)
            XCTAssertEqual(status?.description, "The specified keychain could not be found.")
        }
        do {
            let status = Status(rawValue: errSecInvalidKeychain)
            XCTAssertEqual(status, .InvalidKeychain)
            XCTAssertEqual(status?.description, "The specified keychain is not a valid keychain file.")
        }
        do {
            let status = Status(rawValue: errSecDuplicateKeychain)
            XCTAssertEqual(status, .DuplicateKeychain)
            XCTAssertEqual(status?.description, "A keychain with the same name already exists.")
        }
        do {
            let status = Status(rawValue: errSecDuplicateCallback)
            XCTAssertEqual(status, .DuplicateCallback)
            XCTAssertEqual(status?.description, "The specified callback function is already installed.")
        }
        do {
            let status = Status(rawValue: errSecInvalidCallback)
            XCTAssertEqual(status, .InvalidCallback)
            XCTAssertEqual(status?.description, "The specified callback function is not valid.")
        }
        #endif
        do {
            let status = Status(rawValue: errSecDuplicateItem)
            XCTAssertEqual(status, .DuplicateItem)
            XCTAssertEqual(status?.description, "The specified item already exists in the keychain.")
        }
        do {
            let status = Status(rawValue: errSecItemNotFound)
            XCTAssertEqual(status, .ItemNotFound)
            XCTAssertEqual(status?.description, "The specified item could not be found in the keychain.")
        }
        #if os(OSX)
        do {
            let status = Status(rawValue: errSecBufferTooSmall)
            XCTAssertEqual(status, .BufferTooSmall)
            XCTAssertEqual(status?.description, "There is not enough memory available to use the specified item.")
        }
        do {
            let status = Status(rawValue: errSecDataTooLarge)
            XCTAssertEqual(status, .DataTooLarge)
            XCTAssertEqual(status?.description, "This item contains information which is too large or in a format that cannot be displayed.")
        }
        do {
            let status = Status(rawValue: errSecNoSuchAttr)
            XCTAssertEqual(status, .NoSuchAttr)
            XCTAssertEqual(status?.description, "The specified attribute does not exist.")
        }
        do {
            let status = Status(rawValue: errSecInvalidItemRef)
            XCTAssertEqual(status, .InvalidItemRef)
            XCTAssertEqual(status?.description, "The specified item is no longer valid. It may have been deleted from the keychain.")
        }
        do {
            let status = Status(rawValue: errSecInvalidSearchRef)
            XCTAssertEqual(status, .InvalidSearchRef)
            XCTAssertEqual(status?.description, "Unable to search the current keychain.")
        }
        do {
            let status = Status(rawValue: errSecNoSuchClass)
            XCTAssertEqual(status, .NoSuchClass)
            XCTAssertEqual(status?.description, "The specified item does not appear to be a valid keychain item.")
        }
        do {
            let status = Status(rawValue: errSecNoDefaultKeychain)
            XCTAssertEqual(status, .NoDefaultKeychain)
            XCTAssertEqual(status?.description, "A default keychain could not be found.")
        }
        #endif
        do {
            let status = Status(rawValue: errSecInteractionNotAllowed)
            XCTAssertEqual(status, .InteractionNotAllowed)
            XCTAssertEqual(status?.description, "User interaction is not allowed.")
        }
        #if os(OSX)
        do {
            let status = Status(rawValue: errSecReadOnlyAttr)
            XCTAssertEqual(status, .ReadOnlyAttr)
            XCTAssertEqual(status?.description, "The specified attribute could not be modified.")
        }
        do {
            let status = Status(rawValue: errSecWrongSecVersion)
            XCTAssertEqual(status, .WrongSecVersion)
            XCTAssertEqual(status?.description, "This keychain was created by a different version of the system software and cannot be opened.")
        }
        do {
            let status = Status(rawValue: errSecKeySizeNotAllowed)
            XCTAssertEqual(status, .KeySizeNotAllowed)
            XCTAssertEqual(status?.description, "This item specifies a key size which is too large.")
        }
        do {
            let status = Status(rawValue: errSecNoStorageModule)
            XCTAssertEqual(status, .NoStorageModule)
            XCTAssertEqual(status?.description, "A required component (data storage module) could not be loaded. You may need to restart your computer.")
        }
        do {
            let status = Status(rawValue: errSecNoCertificateModule)
            XCTAssertEqual(status, .NoCertificateModule)
            XCTAssertEqual(status?.description, "A required component (certificate module) could not be loaded. You may need to restart your computer.")
        }
        do {
            let status = Status(rawValue: errSecNoPolicyModule)
            XCTAssertEqual(status, .NoPolicyModule)
            XCTAssertEqual(status?.description, "A required component (policy module) could not be loaded. You may need to restart your computer.")
        }
        do {
            let status = Status(rawValue: errSecInteractionRequired)
            XCTAssertEqual(status, .InteractionRequired)
            XCTAssertEqual(status?.description, "User interaction is required, but is currently not allowed.")
        }
        do {
            let status = Status(rawValue: errSecDataNotAvailable)
            XCTAssertEqual(status, .DataNotAvailable)
            XCTAssertEqual(status?.description, "The contents of this item cannot be retrieved.")
        }
        do {
            let status = Status(rawValue: errSecDataNotModifiable)
            XCTAssertEqual(status, .DataNotModifiable)
            XCTAssertEqual(status?.description, "The contents of this item cannot be modified.")
        }
        do {
            let status = Status(rawValue: errSecCreateChainFailed)
            XCTAssertEqual(status, .CreateChainFailed)
            XCTAssertEqual(status?.description, "One or more certificates required to validate this certificate cannot be found.")
        }
        do {
            let status = Status(rawValue: errSecInvalidPrefsDomain)
            XCTAssertEqual(status, .InvalidPrefsDomain)
            XCTAssertEqual(status?.description, "The specified preferences domain is not valid.")
        }
        do {
            let status = Status(rawValue: errSecInDarkWake)
            XCTAssertEqual(status, .InDarkWake)
            XCTAssertEqual(status?.description, "In dark wake, no UI possible")
        }
        do {
            let status = Status(rawValue: errSecACLNotSimple)
            XCTAssertEqual(status, .ACLNotSimple)
            XCTAssertEqual(status?.description, "The specified access control list is not in standard (simple) form.")
        }
        do {
            let status = Status(rawValue: errSecPolicyNotFound)
            XCTAssertEqual(status, .PolicyNotFound)
            XCTAssertEqual(status?.description, "The specified policy cannot be found.")
        }
        do {
            let status = Status(rawValue: errSecInvalidTrustSetting)
            XCTAssertEqual(status, .InvalidTrustSetting)
            XCTAssertEqual(status?.description, "The specified trust setting is invalid.")
        }
        do {
            let status = Status(rawValue: errSecNoAccessForItem)
            XCTAssertEqual(status, .NoAccessForItem)
            XCTAssertEqual(status?.description, "The specified item has no access control.")
        }
        do {
            let status = Status(rawValue: errSecInvalidOwnerEdit)
            XCTAssertEqual(status, .InvalidOwnerEdit)
            XCTAssertEqual(status?.description, "Invalid attempt to change the owner of this item.")
        }
        do {
            let status = Status(rawValue: errSecTrustNotAvailable)
            XCTAssertEqual(status, .TrustNotAvailable)
            XCTAssertEqual(status?.description, "No trust results are available.")
        }
        do {
            let status = Status(rawValue: errSecUnsupportedFormat)
            XCTAssertEqual(status, .UnsupportedFormat)
            XCTAssertEqual(status?.description, "Import/Export format unsupported.")
        }
        do {
            let status = Status(rawValue: errSecUnknownFormat)
            XCTAssertEqual(status, .UnknownFormat)
            XCTAssertEqual(status?.description, "Unknown format in import.")
        }
        do {
            let status = Status(rawValue: errSecKeyIsSensitive)
            XCTAssertEqual(status, .KeyIsSensitive)
            XCTAssertEqual(status?.description, "Key material must be wrapped for export.")
        }
        do {
            let status = Status(rawValue: errSecMultiplePrivKeys)
            XCTAssertEqual(status, .MultiplePrivKeys)
            XCTAssertEqual(status?.description, "An attempt was made to import multiple private keys.")
        }
        do {
            let status = Status(rawValue: errSecPassphraseRequired)
            XCTAssertEqual(status, .PassphraseRequired)
            XCTAssertEqual(status?.description, "Passphrase is required for import/export.")
        }
        do {
            let status = Status(rawValue: errSecInvalidPasswordRef)
            XCTAssertEqual(status, .InvalidPasswordRef)
            XCTAssertEqual(status?.description, "The password reference was invalid.")
        }
        do {
            let status = Status(rawValue: errSecInvalidTrustSettings)
            XCTAssertEqual(status, .InvalidTrustSettings)
            XCTAssertEqual(status?.description, "The Trust Settings Record was corrupted.")
        }
        do {
            let status = Status(rawValue: errSecNoTrustSettings)
            XCTAssertEqual(status, .NoTrustSettings)
            XCTAssertEqual(status?.description, "No Trust Settings were found.")
        }
        do {
            let status = Status(rawValue: errSecPkcs12VerifyFailure)
            XCTAssertEqual(status, .Pkcs12VerifyFailure)
            XCTAssertEqual(status?.description, "MAC verification failed during PKCS12 import (wrong password?)")
        }
        do {
            let errSecInvalidCertificate: OSStatus = -26265
            let status = Status(rawValue: errSecInvalidCertificate)
            XCTAssertEqual(status, .InvalidCertificate)
            XCTAssertEqual(status?.description, "This certificate could not be decoded.")
        }
        do {
            let status = Status(rawValue: errSecNotSigner)
            XCTAssertEqual(status, .NotSigner)
            XCTAssertEqual(status?.description, "A certificate was not signed by its proposed parent.")
        }
        do {
            let errSecPolicyDenied: OSStatus = -26270
            let status = Status(rawValue: errSecPolicyDenied)
            XCTAssertEqual(status, .PolicyDenied)
            XCTAssertEqual(status?.description, "The certificate chain was not trusted due to a policy not accepting it.")
        }
        do {
            let errSecInvalidKey: OSStatus = -26274
            let status = Status(rawValue: errSecInvalidKey)
            XCTAssertEqual(status, .InvalidKey)
            XCTAssertEqual(status?.description, "The provided key material was not valid.")
        }
        #endif
        do {
            let status = Status(rawValue: errSecDecode)
            XCTAssertEqual(status, .Decode)
            XCTAssertEqual(status?.description, "Unable to decode the provided data.")
        }
        do {
            let errSecInternal: OSStatus = -26276
            let status = Status(rawValue: errSecInternal)
            XCTAssertEqual(status, .Internal)
            XCTAssertEqual(status?.description, "An internal error occurred in the Security framework.")
        }
        #if os(OSX)
        do {
            let status = Status(rawValue: errSecServiceNotAvailable)
            XCTAssertEqual(status, .ServiceNotAvailable)
            XCTAssertEqual(status?.description, "The required service is not available.")
        }
        do {
            let errSecUnsupportedAlgorithm: OSStatus = -26268
            let status = Status(rawValue: errSecUnsupportedAlgorithm)
            XCTAssertEqual(status, .UnsupportedAlgorithm)
            XCTAssertEqual(status?.description, "An unsupported algorithm was encountered.")
        }
            do {
            let errSecUnsupportedOperation: OSStatus = -26271
            let status = Status(rawValue: errSecUnsupportedOperation)
            XCTAssertEqual(status, .UnsupportedOperation)
            XCTAssertEqual(status?.description, "The operation you requested is not supported by this key.")
        }
        do {
            let errSecUnsupportedPadding: OSStatus = -26273
            let status = Status(rawValue: errSecUnsupportedPadding)
            XCTAssertEqual(status, .UnsupportedPadding)
            XCTAssertEqual(status?.description, "The padding you requested is not supported.")
        }
        do {
            let errSecItemInvalidKey: OSStatus = -34000
            let status = Status(rawValue: errSecItemInvalidKey)
            XCTAssertEqual(status, .ItemInvalidKey)
            XCTAssertEqual(status?.description, "A string key in dictionary is not one of the supported keys.")
        }
        do {
            let errSecItemInvalidKeyType: OSStatus = -34001
            let status = Status(rawValue: errSecItemInvalidKeyType)
            XCTAssertEqual(status, .ItemInvalidKeyType)
            XCTAssertEqual(status?.description, "A key in a dictionary is neither a CFStringRef nor a CFNumberRef.")
        }
        do {
            let errSecItemInvalidValue: OSStatus = -34002
            let status = Status(rawValue: errSecItemInvalidValue)
            XCTAssertEqual(status, .ItemInvalidValue)
            XCTAssertEqual(status?.description, "A value in a dictionary is an invalid (or unsupported) CF type.")
        }
        do {
            let errSecItemClassMissing: OSStatus = -34003
            let status = Status(rawValue: errSecItemClassMissing)
            XCTAssertEqual(status, .ItemClassMissing)
            XCTAssertEqual(status?.description, "No kSecItemClass key was specified in a dictionary.")
        }
        do {
            let errSecItemMatchUnsupported: OSStatus = -34004
            let status = Status(rawValue: errSecItemMatchUnsupported)
            XCTAssertEqual(status, .ItemMatchUnsupported)
            XCTAssertEqual(status?.description, "The caller passed one or more kSecMatch keys to a function which does not support matches.")
        }
        do {
            let errSecUseItemListUnsupported: OSStatus = -34005
            let status = Status(rawValue: errSecUseItemListUnsupported)
            XCTAssertEqual(status, .UseItemListUnsupported)
            XCTAssertEqual(status?.description, "The caller passed in a kSecUseItemList key to a function which does not support it.")
        }
        do {
            let errSecUseKeychainUnsupported: OSStatus = -34006
            let status = Status(rawValue: errSecUseKeychainUnsupported)
            XCTAssertEqual(status, .UseKeychainUnsupported)
            XCTAssertEqual(status?.description, "The caller passed in a kSecUseKeychain key to a function which does not support it.")
        }
        do {
            let errSecUseKeychainListUnsupported: OSStatus = -34007
            let status = Status(rawValue: errSecUseKeychainListUnsupported)
            XCTAssertEqual(status, .UseKeychainListUnsupported)
            XCTAssertEqual(status?.description, "The caller passed in a kSecUseKeychainList key to a function which does not support it.")
        }
        do {
            let errSecReturnDataUnsupported: OSStatus = -34008
            let status = Status(rawValue: errSecReturnDataUnsupported)
            XCTAssertEqual(status, .ReturnDataUnsupported)
            XCTAssertEqual(status?.description, "The caller passed in a kSecReturnData key to a function which does not support it.")
        }
        do {
            let errSecReturnAttributesUnsupported: OSStatus = -34009
            let status = Status(rawValue: errSecReturnAttributesUnsupported)
            XCTAssertEqual(status, .ReturnAttributesUnsupported)
            XCTAssertEqual(status?.description, "The caller passed in a kSecReturnAttributes key to a function which does not support it.")
        }
        do {
            let errSecReturnRefUnsupported: OSStatus = -34010
            let status = Status(rawValue: errSecReturnRefUnsupported)
            XCTAssertEqual(status, .ReturnRefUnsupported)
            XCTAssertEqual(status?.description, "The caller passed in a kSecReturnRef key to a function which does not support it.")
        }
        do {
            let errSecReturnPersitentRefUnsupported: OSStatus = -34011
            let status = Status(rawValue: errSecReturnPersitentRefUnsupported)
            XCTAssertEqual(status, .ReturnPersitentRefUnsupported)
            XCTAssertEqual(status?.description, "The caller passed in a kSecReturnPersistentRef key to a function which does not support it.")
        }
        do {
            let errSecValueRefUnsupported: OSStatus = -34012
            let status = Status(rawValue: errSecValueRefUnsupported)
            XCTAssertEqual(status, .ValueRefUnsupported)
            XCTAssertEqual(status?.description, "The caller passed in a kSecValueRef key to a function which does not support it.")
        }
        do {
            let errSecValuePersistentRefUnsupported: OSStatus = -34013
            let status = Status(rawValue: errSecValuePersistentRefUnsupported)
            XCTAssertEqual(status, .ValuePersistentRefUnsupported)
            XCTAssertEqual(status?.description, "The caller passed in a kSecValuePersistentRef key to a function which does not support it.")
        }
        do {
            let errSecReturnMissingPointer: OSStatus = -34014
            let status = Status(rawValue: errSecReturnMissingPointer)
            XCTAssertEqual(status, .ReturnMissingPointer)
            XCTAssertEqual(status?.description, "The caller passed asked for something to be returned but did not pass in a result pointer.")
        }
        do {
            let errSecMatchLimitUnsupported: OSStatus = -34015
            let status = Status(rawValue: errSecMatchLimitUnsupported)
            XCTAssertEqual(status, .MatchLimitUnsupported)
            XCTAssertEqual(status?.description, "The caller passed in a kSecMatchLimit key to a call which does not support limits.")
        }
        do {
            let errSecItemIllegalQuery: OSStatus = -34016
            let status = Status(rawValue: errSecItemIllegalQuery)
            XCTAssertEqual(status, .ItemIllegalQuery)
            XCTAssertEqual(status?.description, "The caller passed in a query which contained too many keys.")
        }
        do {
            let errSecWaitForCallback: OSStatus = -34017
            let status = Status(rawValue: errSecWaitForCallback)
            XCTAssertEqual(status, .WaitForCallback)
            XCTAssertEqual(status?.description, "This operation is incomplete, until the callback is invoked (not an error).")
        }
        do {
            let errSecMissingEntitlement: OSStatus = -34018
            let status = Status(rawValue: errSecMissingEntitlement)
            XCTAssertEqual(status, .MissingEntitlement)
            XCTAssertEqual(status?.description, "Internal error when a required entitlement isn't present, client has neither application-identifier nor keychain-access-groups entitlements.")
        }
        do {
            let errSecUpgradePending: OSStatus = -34019
            let status = Status(rawValue: errSecUpgradePending)
            XCTAssertEqual(status, .UpgradePending)
            XCTAssertEqual(status?.description, "Error returned if keychain database needs a schema migration but the device is locked, clients should wait for a device unlock notification and retry the command.")
        }
        do {
            let errSecMPSignatureInvalid: OSStatus = -25327
            let status = Status(rawValue: errSecMPSignatureInvalid)
            XCTAssertEqual(status, .MPSignatureInvalid)
            XCTAssertEqual(status?.description, "Signature invalid on MP message")
        }
        do {
            let errSecOTRTooOld: OSStatus = -25328
            let status = Status(rawValue: errSecOTRTooOld)
            XCTAssertEqual(status, .OTRTooOld)
            XCTAssertEqual(status?.description, "Message is too old to use")
        }
        do {
            let errSecOTRIDTooNew: OSStatus = -25329
            let status = Status(rawValue: errSecOTRIDTooNew)
            XCTAssertEqual(status, .OTRIDTooNew)
            XCTAssertEqual(status?.description, "Key ID is too new to use! Message from the future?")
        }
        do {
            let status = Status(rawValue: errSecInsufficientClientID)
            XCTAssertEqual(status, .InsufficientClientID)
            XCTAssertEqual(status?.description, "The client ID is not correct.")
        }
        do {
            let status = Status(rawValue: errSecDeviceReset)
            XCTAssertEqual(status, .DeviceReset)
            XCTAssertEqual(status?.description, "A device reset has occurred.")
        }
        do {
            let status = Status(rawValue: errSecDeviceFailed)
            XCTAssertEqual(status, .DeviceFailed)
            XCTAssertEqual(status?.description, "A device failure has occurred.")
        }
        do {
            let status = Status(rawValue: errSecAppleAddAppACLSubject)
            XCTAssertEqual(status, .AppleAddAppACLSubject)
            XCTAssertEqual(status?.description, "Adding an application ACL subject failed.")
        }
        do {
            let status = Status(rawValue: errSecApplePublicKeyIncomplete)
            XCTAssertEqual(status, .ApplePublicKeyIncomplete)
            XCTAssertEqual(status?.description, "The public key is incomplete.")
        }
        do {
            let status = Status(rawValue: errSecAppleSignatureMismatch)
            XCTAssertEqual(status, .AppleSignatureMismatch)
            XCTAssertEqual(status?.description, "A signature mismatch has occurred.")
        }
        do {
            let status = Status(rawValue: errSecAppleInvalidKeyStartDate)
            XCTAssertEqual(status, .AppleInvalidKeyStartDate)
            XCTAssertEqual(status?.description, "The specified key has an invalid start date.")
        }
        do {
            let status = Status(rawValue: errSecAppleInvalidKeyEndDate)
            XCTAssertEqual(status, .AppleInvalidKeyEndDate)
            XCTAssertEqual(status?.description, "The specified key has an invalid end date.")
        }
        do {
            let status = Status(rawValue: errSecConversionError)
            XCTAssertEqual(status, .ConversionError)
            XCTAssertEqual(status?.description, "A conversion error has occurred.")
        }
        do {
            let status = Status(rawValue: errSecAppleSSLv2Rollback)
            XCTAssertEqual(status, .AppleSSLv2Rollback)
            XCTAssertEqual(status?.description, "A SSLv2 rollback error has occurred.")
        }
        do {
            let status = Status(rawValue: errSecDiskFull)
            XCTAssertEqual(status, .DiskFull)
            XCTAssertEqual(status?.description, "The disk is full.")
        }
        do {
            let status = Status(rawValue: errSecQuotaExceeded)
            XCTAssertEqual(status, .QuotaExceeded)
            XCTAssertEqual(status?.description, "The quota was exceeded.")
        }
        do {
            let status = Status(rawValue: errSecFileTooBig)
            XCTAssertEqual(status, .FileTooBig)
            XCTAssertEqual(status?.description, "The file is too big.")
        }
        do {
            let status = Status(rawValue: errSecInvalidDatabaseBlob)
            XCTAssertEqual(status, .InvalidDatabaseBlob)
            XCTAssertEqual(status?.description, "The specified database has an invalid blob.")
        }
        do {
            let status = Status(rawValue: errSecInvalidKeyBlob)
            XCTAssertEqual(status, .InvalidKeyBlob)
            XCTAssertEqual(status?.description, "The specified database has an invalid key blob.")
        }
        do {
            let status = Status(rawValue: errSecIncompatibleDatabaseBlob)
            XCTAssertEqual(status, .IncompatibleDatabaseBlob)
            XCTAssertEqual(status?.description, "The specified database has an incompatible blob.")
        }
        do {
            let status = Status(rawValue: errSecIncompatibleKeyBlob)
            XCTAssertEqual(status, .IncompatibleKeyBlob)
            XCTAssertEqual(status?.description, "The specified database has an incompatible key blob.")
        }
        do {
            let status = Status(rawValue: errSecHostNameMismatch)
            XCTAssertEqual(status, .HostNameMismatch)
            XCTAssertEqual(status?.description, "A host name mismatch has occurred.")
        }
        do {
            let status = Status(rawValue: errSecUnknownCriticalExtensionFlag)
            XCTAssertEqual(status, .UnknownCriticalExtensionFlag)
            XCTAssertEqual(status?.description, "There is an unknown critical extension flag.")
        }
        do {
            let status = Status(rawValue: errSecNoBasicConstraints)
            XCTAssertEqual(status, .NoBasicConstraints)
            XCTAssertEqual(status?.description, "No basic constraints were found.")
        }
        do {
            let status = Status(rawValue: errSecNoBasicConstraintsCA)
            XCTAssertEqual(status, .NoBasicConstraintsCA)
            XCTAssertEqual(status?.description, "No basic CA constraints were found.")
        }
        do {
            let status = Status(rawValue: errSecInvalidAuthorityKeyID)
            XCTAssertEqual(status, .InvalidAuthorityKeyID)
            XCTAssertEqual(status?.description, "The authority key ID is not valid.")
        }
        do {
            let status = Status(rawValue: errSecInvalidSubjectKeyID)
            XCTAssertEqual(status, .InvalidSubjectKeyID)
            XCTAssertEqual(status?.description, "The subject key ID is not valid.")
        }
        do {
            let status = Status(rawValue: errSecInvalidKeyUsageForPolicy)
            XCTAssertEqual(status, .InvalidKeyUsageForPolicy)
            XCTAssertEqual(status?.description, "The key usage is not valid for the specified policy.")
        }
        do {
            let status = Status(rawValue: errSecInvalidExtendedKeyUsage)
            XCTAssertEqual(status, .InvalidExtendedKeyUsage)
            XCTAssertEqual(status?.description, "The extended key usage is not valid.")
        }
        do {
            let status = Status(rawValue: errSecInvalidIDLinkage)
            XCTAssertEqual(status, .InvalidIDLinkage)
            XCTAssertEqual(status?.description, "The ID linkage is not valid.")
        }
        do {
            let status = Status(rawValue: errSecPathLengthConstraintExceeded)
            XCTAssertEqual(status, .PathLengthConstraintExceeded)
            XCTAssertEqual(status?.description, "The path length constraint was exceeded.")
        }
        do {
            let status = Status(rawValue: errSecInvalidRoot)
            XCTAssertEqual(status, .InvalidRoot)
            XCTAssertEqual(status?.description, "The root or anchor certificate is not valid.")
        }
        do {
            let status = Status(rawValue: errSecCRLExpired)
            XCTAssertEqual(status, .CRLExpired)
            XCTAssertEqual(status?.description, "The CRL has expired.")
        }
        do {
            let status = Status(rawValue: errSecCRLNotValidYet)
            XCTAssertEqual(status, .CRLNotValidYet)
            XCTAssertEqual(status?.description, "The CRL is not yet valid.")
        }
        do {
            let status = Status(rawValue: errSecCRLNotFound)
            XCTAssertEqual(status, .CRLNotFound)
            XCTAssertEqual(status?.description, "The CRL was not found.")
        }
        do {
            let status = Status(rawValue: errSecCRLServerDown)
            XCTAssertEqual(status, .CRLServerDown)
            XCTAssertEqual(status?.description, "The CRL server is down.")
        }
        do {
            let status = Status(rawValue: errSecCRLBadURI)
            XCTAssertEqual(status, .CRLBadURI)
            XCTAssertEqual(status?.description, "The CRL has a bad Uniform Resource Identifier.")
        }
        do {
            let status = Status(rawValue: errSecUnknownCertExtension)
            XCTAssertEqual(status, .UnknownCertExtension)
            XCTAssertEqual(status?.description, "An unknown certificate extension was encountered.")
        }
        do {
            let status = Status(rawValue: errSecUnknownCRLExtension)
            XCTAssertEqual(status, .UnknownCRLExtension)
            XCTAssertEqual(status?.description, "An unknown CRL extension was encountered.")
        }
        do {
            let status = Status(rawValue: errSecCRLNotTrusted)
            XCTAssertEqual(status, .CRLNotTrusted)
            XCTAssertEqual(status?.description, "The CRL is not trusted.")
        }
        do {
            let status = Status(rawValue: errSecCRLPolicyFailed)
            XCTAssertEqual(status, .CRLPolicyFailed)
            XCTAssertEqual(status?.description, "The CRL policy failed.")
        }
        do {
            let status = Status(rawValue: errSecIDPFailure)
            XCTAssertEqual(status, .IDPFailure)
            XCTAssertEqual(status?.description, "The issuing distribution point was not valid.")
        }
        do {
            let status = Status(rawValue: errSecSMIMEEmailAddressesNotFound)
            XCTAssertEqual(status, .SMIMEEmailAddressesNotFound)
            XCTAssertEqual(status?.description, "An email address mismatch was encountered.")
        }
        do {
            let status = Status(rawValue: errSecSMIMEBadExtendedKeyUsage)
            XCTAssertEqual(status, .SMIMEBadExtendedKeyUsage)
            XCTAssertEqual(status?.description, "The appropriate extended key usage for SMIME was not found.")
        }
        do {
            let status = Status(rawValue: errSecSMIMEBadKeyUsage)
            XCTAssertEqual(status, .SMIMEBadKeyUsage)
            XCTAssertEqual(status?.description, "The key usage is not compatible with SMIME.")
        }
        do {
            let status = Status(rawValue: errSecSMIMEKeyUsageNotCritical)
            XCTAssertEqual(status, .SMIMEKeyUsageNotCritical)
            XCTAssertEqual(status?.description, "The key usage extension is not marked as critical.")
        }
        do {
            let status = Status(rawValue: errSecSMIMENoEmailAddress)
            XCTAssertEqual(status, .SMIMENoEmailAddress)
            XCTAssertEqual(status?.description, "No email address was found in the certificate.")
        }
        do {
            let status = Status(rawValue: errSecSMIMESubjAltNameNotCritical)
            XCTAssertEqual(status, .SMIMESubjAltNameNotCritical)
            XCTAssertEqual(status?.description, "The subject alternative name extension is not marked as critical.")
        }
        do {
            let status = Status(rawValue: errSecSSLBadExtendedKeyUsage)
            XCTAssertEqual(status, .SSLBadExtendedKeyUsage)
            XCTAssertEqual(status?.description, "The appropriate extended key usage for SSL was not found.")
        }
        do {
            let status = Status(rawValue: errSecOCSPBadResponse)
            XCTAssertEqual(status, .OCSPBadResponse)
            XCTAssertEqual(status?.description, "The OCSP response was incorrect or could not be parsed.")
        }
        do {
            let status = Status(rawValue: errSecOCSPBadRequest)
            XCTAssertEqual(status, .OCSPBadRequest)
            XCTAssertEqual(status?.description, "The OCSP request was incorrect or could not be parsed.")
        }
        do {
            let status = Status(rawValue: errSecOCSPUnavailable)
            XCTAssertEqual(status, .OCSPUnavailable)
            XCTAssertEqual(status?.description, "OCSP service is unavailable.")
        }
        do {
            let status = Status(rawValue: errSecOCSPStatusUnrecognized)
            XCTAssertEqual(status, .OCSPStatusUnrecognized)
            XCTAssertEqual(status?.description, "The OCSP server did not recognize this certificate.")
        }
        do {
            let status = Status(rawValue: errSecEndOfData)
            XCTAssertEqual(status, .EndOfData)
            XCTAssertEqual(status?.description, "An end-of-data was detected.")
        }
        do {
            let status = Status(rawValue: errSecIncompleteCertRevocationCheck)
            XCTAssertEqual(status, .IncompleteCertRevocationCheck)
            XCTAssertEqual(status?.description, "An incomplete certificate revocation check occurred.")
        }
        do {
            let status = Status(rawValue: errSecNetworkFailure)
            XCTAssertEqual(status, .NetworkFailure)
            XCTAssertEqual(status?.description, "A network failure occurred.")
        }
        do {
            let status = Status(rawValue: errSecOCSPNotTrustedToAnchor)
            XCTAssertEqual(status, .OCSPNotTrustedToAnchor)
            XCTAssertEqual(status?.description, "The OCSP response was not trusted to a root or anchor certificate.")
        }
        do {
            let status = Status(rawValue: errSecRecordModified)
            XCTAssertEqual(status, .RecordModified)
            XCTAssertEqual(status?.description, "The record was modified.")
        }
        do {
            let status = Status(rawValue: errSecOCSPSignatureError)
            XCTAssertEqual(status, .OCSPSignatureError)
            XCTAssertEqual(status?.description, "The OCSP response had an invalid signature.")
        }
        do {
            let status = Status(rawValue: errSecOCSPNoSigner)
            XCTAssertEqual(status, .OCSPNoSigner)
            XCTAssertEqual(status?.description, "The OCSP response had no signer.")
        }
        do {
            let status = Status(rawValue: errSecOCSPResponderMalformedReq)
            XCTAssertEqual(status, .OCSPResponderMalformedReq)
            XCTAssertEqual(status?.description, "The OCSP responder was given a malformed request.")
        }
        do {
            let status = Status(rawValue: errSecOCSPResponderInternalError)
            XCTAssertEqual(status, .OCSPResponderInternalError)
            XCTAssertEqual(status?.description, "The OCSP responder encountered an internal error.")
        }
        do {
            let status = Status(rawValue: errSecOCSPResponderTryLater)
            XCTAssertEqual(status, .OCSPResponderTryLater)
            XCTAssertEqual(status?.description, "The OCSP responder is busy, try again later.")
        }
        do {
            let status = Status(rawValue: errSecOCSPResponderSignatureRequired)
            XCTAssertEqual(status, .OCSPResponderSignatureRequired)
            XCTAssertEqual(status?.description, "The OCSP responder requires a signature.")
        }
        do {
            let status = Status(rawValue: errSecOCSPResponderUnauthorized)
            XCTAssertEqual(status, .OCSPResponderUnauthorized)
            XCTAssertEqual(status?.description, "The OCSP responder rejected this request as unauthorized.")
        }
        do {
            let status = Status(rawValue: errSecOCSPResponseNonceMismatch)
            XCTAssertEqual(status, .OCSPResponseNonceMismatch)
            XCTAssertEqual(status?.description, "The OCSP response nonce did not match the request.")
        }
        do {
            let status = Status(rawValue: errSecCodeSigningBadCertChainLength)
            XCTAssertEqual(status, .CodeSigningBadCertChainLength)
            XCTAssertEqual(status?.description, "Code signing encountered an incorrect certificate chain length.")
        }
        do {
            let status = Status(rawValue: errSecCodeSigningNoBasicConstraints)
            XCTAssertEqual(status, .CodeSigningNoBasicConstraints)
            XCTAssertEqual(status?.description, "Code signing found no basic constraints.")
        }
        do {
            let status = Status(rawValue: errSecCodeSigningBadPathLengthConstraint)
            XCTAssertEqual(status, .CodeSigningBadPathLengthConstraint)
            XCTAssertEqual(status?.description, "Code signing encountered an incorrect path length constraint.")
        }
        do {
            let status = Status(rawValue: errSecCodeSigningNoExtendedKeyUsage)
            XCTAssertEqual(status, .CodeSigningNoExtendedKeyUsage)
            XCTAssertEqual(status?.description, "Code signing found no extended key usage.")
        }
        do {
            let status = Status(rawValue: errSecCodeSigningDevelopment)
            XCTAssertEqual(status, .CodeSigningDevelopment)
            XCTAssertEqual(status?.description, "Code signing indicated use of a development-only certificate.")
        }
        do {
            let status = Status(rawValue: errSecResourceSignBadCertChainLength)
            XCTAssertEqual(status, .ResourceSignBadCertChainLength)
            XCTAssertEqual(status?.description, "Resource signing has encountered an incorrect certificate chain length.")
        }
        do {
            let status = Status(rawValue: errSecResourceSignBadExtKeyUsage)
            XCTAssertEqual(status, .ResourceSignBadExtKeyUsage)
            XCTAssertEqual(status?.description, "Resource signing has encountered an error in the extended key usage.")
        }
        do {
            let status = Status(rawValue: errSecTrustSettingDeny)
            XCTAssertEqual(status, .TrustSettingDeny)
            XCTAssertEqual(status?.description, "The trust setting for this policy was set to Deny.")
        }
        do {
            let status = Status(rawValue: errSecInvalidSubjectName)
            XCTAssertEqual(status, .InvalidSubjectName)
            XCTAssertEqual(status?.description, "An invalid certificate subject name was encountered.")
        }
        do {
            let status = Status(rawValue: errSecUnknownQualifiedCertStatement)
            XCTAssertEqual(status, .UnknownQualifiedCertStatement)
            XCTAssertEqual(status?.description, "An unknown qualified certificate statement was encountered.")
        }
        do {
            let status = Status(rawValue: errSecMobileMeRequestQueued)
            XCTAssertEqual(status, .MobileMeRequestQueued)
            XCTAssertEqual(status?.description, "The MobileMe request will be sent during the next connection.")
        }
        do {
            let status = Status(rawValue: errSecMobileMeRequestRedirected)
            XCTAssertEqual(status, .MobileMeRequestRedirected)
            XCTAssertEqual(status?.description, "The MobileMe request was redirected.")
        }
        do {
            let status = Status(rawValue: errSecMobileMeServerError)
            XCTAssertEqual(status, .MobileMeServerError)
            XCTAssertEqual(status?.description, "A MobileMe server error occurred.")
        }
        do {
            let status = Status(rawValue: errSecMobileMeServerNotAvailable)
            XCTAssertEqual(status, .MobileMeServerNotAvailable)
            XCTAssertEqual(status?.description, "The MobileMe server is not available.")
        }
        do {
            let status = Status(rawValue: errSecMobileMeServerAlreadyExists)
            XCTAssertEqual(status, .MobileMeServerAlreadyExists)
            XCTAssertEqual(status?.description, "The MobileMe server reported that the item already exists.")
        }
        do {
            let status = Status(rawValue: errSecMobileMeServerServiceErr)
            XCTAssertEqual(status, .MobileMeServerServiceErr)
            XCTAssertEqual(status?.description, "A MobileMe service error has occurred.")
        }
        do {
            let status = Status(rawValue: errSecMobileMeRequestAlreadyPending)
            XCTAssertEqual(status, .MobileMeRequestAlreadyPending)
            XCTAssertEqual(status?.description, "A MobileMe request is already pending.")
        }
        do {
            let status = Status(rawValue: errSecMobileMeNoRequestPending)
            XCTAssertEqual(status, .MobileMeNoRequestPending)
            XCTAssertEqual(status?.description, "MobileMe has no request pending.")
        }
        do {
            let status = Status(rawValue: errSecMobileMeCSRVerifyFailure)
            XCTAssertEqual(status, .MobileMeCSRVerifyFailure)
            XCTAssertEqual(status?.description, "A MobileMe CSR verification failure has occurred.")
        }
        do {
            let status = Status(rawValue: errSecMobileMeFailedConsistencyCheck)
            XCTAssertEqual(status, .MobileMeFailedConsistencyCheck)
            XCTAssertEqual(status?.description, "MobileMe has found a failed consistency check.")
        }
        do {
            let status = Status(rawValue: errSecNotInitialized)
            XCTAssertEqual(status, .NotInitialized)
            XCTAssertEqual(status?.description, "A function was called without initializing CSSM.")
        }
        do {
            let status = Status(rawValue: errSecInvalidHandleUsage)
            XCTAssertEqual(status, .InvalidHandleUsage)
            XCTAssertEqual(status?.description, "The CSSM handle does not match with the service type.")
        }
        do {
            let status = Status(rawValue: errSecPVCReferentNotFound)
            XCTAssertEqual(status, .PVCReferentNotFound)
            XCTAssertEqual(status?.description, "A reference to the calling module was not found in the list of authorized callers.")
        }
        do {
            let status = Status(rawValue: errSecFunctionIntegrityFail)
            XCTAssertEqual(status, .FunctionIntegrityFail)
            XCTAssertEqual(status?.description, "A function address was not within the verified module.")
        }
        do {
            let status = Status(rawValue: errSecInternalError)
            XCTAssertEqual(status, .InternalError)
            XCTAssertEqual(status?.description, "An internal error has occurred.")
        }
        do {
            let status = Status(rawValue: errSecMemoryError)
            XCTAssertEqual(status, .MemoryError)
            XCTAssertEqual(status?.description, "A memory error has occurred.")
        }
        do {
            let status = Status(rawValue: errSecInvalidData)
            XCTAssertEqual(status, .InvalidData)
            XCTAssertEqual(status?.description, "Invalid data was encountered.")
        }
        do {
            let status = Status(rawValue: errSecMDSError)
            XCTAssertEqual(status, .MDSError)
            XCTAssertEqual(status?.description, "A Module Directory Service error has occurred.")
        }
        do {
            let status = Status(rawValue: errSecInvalidPointer)
            XCTAssertEqual(status, .InvalidPointer)
            XCTAssertEqual(status?.description, "An invalid pointer was encountered.")
        }
        do {
            let status = Status(rawValue: errSecSelfCheckFailed)
            XCTAssertEqual(status, .SelfCheckFailed)
            XCTAssertEqual(status?.description, "Self-check has failed.")
        }
        do {
            let status = Status(rawValue: errSecFunctionFailed)
            XCTAssertEqual(status, .FunctionFailed)
            XCTAssertEqual(status?.description, "A function has failed.")
        }
        do {
            let status = Status(rawValue: errSecModuleManifestVerifyFailed)
            XCTAssertEqual(status, .ModuleManifestVerifyFailed)
            XCTAssertEqual(status?.description, "A module manifest verification failure has occurred.")
        }
        do {
            let status = Status(rawValue: errSecInvalidGUID)
            XCTAssertEqual(status, .InvalidGUID)
            XCTAssertEqual(status?.description, "An invalid GUID was encountered.")
        }
        do {
            let status = Status(rawValue: errSecInvalidHandle)
            XCTAssertEqual(status, .InvalidHandle)
            XCTAssertEqual(status?.description, "An invalid handle was encountered.")
        }
        do {
            let status = Status(rawValue: errSecInvalidDBList)
            XCTAssertEqual(status, .InvalidDBList)
            XCTAssertEqual(status?.description, "An invalid DB list was encountered.")
        }
        do {
            let status = Status(rawValue: errSecInvalidPassthroughID)
            XCTAssertEqual(status, .InvalidPassthroughID)
            XCTAssertEqual(status?.description, "An invalid passthrough ID was encountered.")
        }
        do {
            let status = Status(rawValue: errSecInvalidNetworkAddress)
            XCTAssertEqual(status, .InvalidNetworkAddress)
            XCTAssertEqual(status?.description, "An invalid network address was encountered.")
        }
        do {
            let status = Status(rawValue: errSecCRLAlreadySigned)
            XCTAssertEqual(status, .CRLAlreadySigned)
            XCTAssertEqual(status?.description, "The certificate revocation list is already signed.")
        }
        do {
            let status = Status(rawValue: errSecInvalidNumberOfFields)
            XCTAssertEqual(status, .InvalidNumberOfFields)
            XCTAssertEqual(status?.description, "An invalid number of fields were encountered.")
        }
        do {
            let status = Status(rawValue: errSecVerificationFailure)
            XCTAssertEqual(status, .VerificationFailure)
            XCTAssertEqual(status?.description, "A verification failure occurred.")
        }
        do {
            let status = Status(rawValue: errSecUnknownTag)
            XCTAssertEqual(status, .UnknownTag)
            XCTAssertEqual(status?.description, "An unknown tag was encountered.")
        }
        do {
            let status = Status(rawValue: errSecInvalidSignature)
            XCTAssertEqual(status, .InvalidSignature)
            XCTAssertEqual(status?.description, "An invalid signature was encountered.")
        }
        do {
            let status = Status(rawValue: errSecInvalidName)
            XCTAssertEqual(status, .InvalidName)
            XCTAssertEqual(status?.description, "An invalid name was encountered.")
        }
        do {
            let status = Status(rawValue: errSecInvalidCertificateRef)
            XCTAssertEqual(status, .InvalidCertificateRef)
            XCTAssertEqual(status?.description, "An invalid certificate reference was encountered.")
        }
        do {
            let status = Status(rawValue: errSecInvalidCertificateGroup)
            XCTAssertEqual(status, .InvalidCertificateGroup)
            XCTAssertEqual(status?.description, "An invalid certificate group was encountered.")
        }
        do {
            let status = Status(rawValue: errSecTagNotFound)
            XCTAssertEqual(status, .TagNotFound)
            XCTAssertEqual(status?.description, "The specified tag was not found.")
        }
        do {
            let status = Status(rawValue: errSecInvalidQuery)
            XCTAssertEqual(status, .InvalidQuery)
            XCTAssertEqual(status?.description, "The specified query was not valid.")
        }
        do {
            let status = Status(rawValue: errSecInvalidValue)
            XCTAssertEqual(status, .InvalidValue)
            XCTAssertEqual(status?.description, "An invalid value was detected.")
        }
        do {
            let status = Status(rawValue: errSecCallbackFailed)
            XCTAssertEqual(status, .CallbackFailed)
            XCTAssertEqual(status?.description, "A callback has failed.")
        }
        do {
            let status = Status(rawValue: errSecACLDeleteFailed)
            XCTAssertEqual(status, .ACLDeleteFailed)
            XCTAssertEqual(status?.description, "An ACL delete operation has failed.")
        }
        do {
            let status = Status(rawValue: errSecACLReplaceFailed)
            XCTAssertEqual(status, .ACLReplaceFailed)
            XCTAssertEqual(status?.description, "An ACL replace operation has failed.")
        }
        do {
            let status = Status(rawValue: errSecACLAddFailed)
            XCTAssertEqual(status, .ACLAddFailed)
            XCTAssertEqual(status?.description, "An ACL add operation has failed.")
        }
        do {
            let status = Status(rawValue: errSecACLChangeFailed)
            XCTAssertEqual(status, .ACLChangeFailed)
            XCTAssertEqual(status?.description, "An ACL change operation has failed.")
        }
        do {
            let status = Status(rawValue: errSecInvalidAccessCredentials)
            XCTAssertEqual(status, .InvalidAccessCredentials)
            XCTAssertEqual(status?.description, "Invalid access credentials were encountered.")
        }
        do {
            let status = Status(rawValue: errSecInvalidRecord)
            XCTAssertEqual(status, .InvalidRecord)
            XCTAssertEqual(status?.description, "An invalid record was encountered.")
        }
        do {
            let status = Status(rawValue: errSecInvalidACL)
            XCTAssertEqual(status, .InvalidACL)
            XCTAssertEqual(status?.description, "An invalid ACL was encountered.")
        }
        do {
            let status = Status(rawValue: errSecInvalidSampleValue)
            XCTAssertEqual(status, .InvalidSampleValue)
            XCTAssertEqual(status?.description, "An invalid sample value was encountered.")
        }
        do {
            let status = Status(rawValue: errSecIncompatibleVersion)
            XCTAssertEqual(status, .IncompatibleVersion)
            XCTAssertEqual(status?.description, "An incompatible version was encountered.")
        }
        do {
            let status = Status(rawValue: errSecPrivilegeNotGranted)
            XCTAssertEqual(status, .PrivilegeNotGranted)
            XCTAssertEqual(status?.description, "The privilege was not granted.")
        }
        do {
            let status = Status(rawValue: errSecInvalidScope)
            XCTAssertEqual(status, .InvalidScope)
            XCTAssertEqual(status?.description, "An invalid scope was encountered.")
        }
        do {
            let status = Status(rawValue: errSecPVCAlreadyConfigured)
            XCTAssertEqual(status, .PVCAlreadyConfigured)
            XCTAssertEqual(status?.description, "The PVC is already configured.")
        }
        do {
            let status = Status(rawValue: errSecInvalidPVC)
            XCTAssertEqual(status, .InvalidPVC)
            XCTAssertEqual(status?.description, "An invalid PVC was encountered.")
        }
        do {
            let status = Status(rawValue: errSecEMMLoadFailed)
            XCTAssertEqual(status, .EMMLoadFailed)
            XCTAssertEqual(status?.description, "The EMM load has failed.")
        }
        do {
            let status = Status(rawValue: errSecEMMUnloadFailed)
            XCTAssertEqual(status, .EMMUnloadFailed)
            XCTAssertEqual(status?.description, "The EMM unload has failed.")
        }
        do {
            let status = Status(rawValue: errSecAddinLoadFailed)
            XCTAssertEqual(status, .AddinLoadFailed)
            XCTAssertEqual(status?.description, "The add-in load operation has failed.")
        }
        do {
            let status = Status(rawValue: errSecInvalidKeyRef)
            XCTAssertEqual(status, .InvalidKeyRef)
            XCTAssertEqual(status?.description, "An invalid key was encountered.")
        }
        do {
            let status = Status(rawValue: errSecInvalidKeyHierarchy)
            XCTAssertEqual(status, .InvalidKeyHierarchy)
            XCTAssertEqual(status?.description, "An invalid key hierarchy was encountered.")
        }
        do {
            let status = Status(rawValue: errSecAddinUnloadFailed)
            XCTAssertEqual(status, .AddinUnloadFailed)
            XCTAssertEqual(status?.description, "The add-in unload operation has failed.")
        }
        do {
            let status = Status(rawValue: errSecLibraryReferenceNotFound)
            XCTAssertEqual(status, .LibraryReferenceNotFound)
            XCTAssertEqual(status?.description, "A library reference was not found.")
        }
        do {
            let status = Status(rawValue: errSecInvalidAddinFunctionTable)
            XCTAssertEqual(status, .InvalidAddinFunctionTable)
            XCTAssertEqual(status?.description, "An invalid add-in function table was encountered.")
        }
        do {
            let status = Status(rawValue: errSecInvalidServiceMask)
            XCTAssertEqual(status, .InvalidServiceMask)
            XCTAssertEqual(status?.description, "An invalid service mask was encountered.")
        }
        do {
            let status = Status(rawValue: errSecModuleNotLoaded)
            XCTAssertEqual(status, .ModuleNotLoaded)
            XCTAssertEqual(status?.description, "A module was not loaded.")
        }
        do {
            let status = Status(rawValue: errSecInvalidSubServiceID)
            XCTAssertEqual(status, .InvalidSubServiceID)
            XCTAssertEqual(status?.description, "An invalid subservice ID was encountered.")
        }
        do {
            let status = Status(rawValue: errSecAttributeNotInContext)
            XCTAssertEqual(status, .AttributeNotInContext)
            XCTAssertEqual(status?.description, "An attribute was not in the context.")
        }
        do {
            let status = Status(rawValue: errSecModuleManagerInitializeFailed)
            XCTAssertEqual(status, .ModuleManagerInitializeFailed)
            XCTAssertEqual(status?.description, "A module failed to initialize.")
        }
        do {
            let status = Status(rawValue: errSecModuleManagerNotFound)
            XCTAssertEqual(status, .ModuleManagerNotFound)
            XCTAssertEqual(status?.description, "A module was not found.")
        }
        do {
            let status = Status(rawValue: errSecEventNotificationCallbackNotFound)
            XCTAssertEqual(status, .EventNotificationCallbackNotFound)
            XCTAssertEqual(status?.description, "An event notification callback was not found.")
        }
        do {
            let status = Status(rawValue: errSecInputLengthError)
            XCTAssertEqual(status, .InputLengthError)
            XCTAssertEqual(status?.description, "An input length error was encountered.")
        }
        do {
            let status = Status(rawValue: errSecOutputLengthError)
            XCTAssertEqual(status, .OutputLengthError)
            XCTAssertEqual(status?.description, "An output length error was encountered.")
        }
        do {
            let status = Status(rawValue: errSecPrivilegeNotSupported)
            XCTAssertEqual(status, .PrivilegeNotSupported)
            XCTAssertEqual(status?.description, "The privilege is not supported.")
        }
        do {
            let status = Status(rawValue: errSecDeviceError)
            XCTAssertEqual(status, .DeviceError)
            XCTAssertEqual(status?.description, "A device error was encountered.")
        }
        do {
            let status = Status(rawValue: errSecAttachHandleBusy)
            XCTAssertEqual(status, .AttachHandleBusy)
            XCTAssertEqual(status?.description, "The CSP handle was busy.")
        }
        do {
            let status = Status(rawValue: errSecNotLoggedIn)
            XCTAssertEqual(status, .NotLoggedIn)
            XCTAssertEqual(status?.description, "You are not logged in.")
        }
        do {
            let status = Status(rawValue: errSecAlgorithmMismatch)
            XCTAssertEqual(status, .AlgorithmMismatch)
            XCTAssertEqual(status?.description, "An algorithm mismatch was encountered.")
        }
        do {
            let status = Status(rawValue: errSecKeyUsageIncorrect)
            XCTAssertEqual(status, .KeyUsageIncorrect)
            XCTAssertEqual(status?.description, "The key usage is incorrect.")
        }
        do {
            let status = Status(rawValue: errSecKeyBlobTypeIncorrect)
            XCTAssertEqual(status, .KeyBlobTypeIncorrect)
            XCTAssertEqual(status?.description, "The key blob type is incorrect.")
        }
        do {
            let status = Status(rawValue: errSecKeyHeaderInconsistent)
            XCTAssertEqual(status, .KeyHeaderInconsistent)
            XCTAssertEqual(status?.description, "The key header is inconsistent.")
        }
        do {
            let status = Status(rawValue: errSecUnsupportedKeyFormat)
            XCTAssertEqual(status, .UnsupportedKeyFormat)
            XCTAssertEqual(status?.description, "The key header format is not supported.")
        }
        do {
            let status = Status(rawValue: errSecUnsupportedKeySize)
            XCTAssertEqual(status, .UnsupportedKeySize)
            XCTAssertEqual(status?.description, "The key size is not supported.")
        }
        do {
            let status = Status(rawValue: errSecInvalidKeyUsageMask)
            XCTAssertEqual(status, .InvalidKeyUsageMask)
            XCTAssertEqual(status?.description, "The key usage mask is not valid.")
        }
        do {
            let status = Status(rawValue: errSecUnsupportedKeyUsageMask)
            XCTAssertEqual(status, .UnsupportedKeyUsageMask)
            XCTAssertEqual(status?.description, "The key usage mask is not supported.")
        }
        do {
            let status = Status(rawValue: errSecInvalidKeyAttributeMask)
            XCTAssertEqual(status, .InvalidKeyAttributeMask)
            XCTAssertEqual(status?.description, "The key attribute mask is not valid.")
        }
        do {
            let status = Status(rawValue: errSecUnsupportedKeyAttributeMask)
            XCTAssertEqual(status, .UnsupportedKeyAttributeMask)
            XCTAssertEqual(status?.description, "The key attribute mask is not supported.")
        }
        do {
            let status = Status(rawValue: errSecInvalidKeyLabel)
            XCTAssertEqual(status, .InvalidKeyLabel)
            XCTAssertEqual(status?.description, "The key label is not valid.")
        }
        do {
            let status = Status(rawValue: errSecUnsupportedKeyLabel)
            XCTAssertEqual(status, .UnsupportedKeyLabel)
            XCTAssertEqual(status?.description, "The key label is not supported.")
        }
        do {
            let status = Status(rawValue: errSecInvalidKeyFormat)
            XCTAssertEqual(status, .InvalidKeyFormat)
            XCTAssertEqual(status?.description, "The key format is not valid.")
        }
        do {
            let status = Status(rawValue: errSecUnsupportedVectorOfBuffers)
            XCTAssertEqual(status, .UnsupportedVectorOfBuffers)
            XCTAssertEqual(status?.description, "The vector of buffers is not supported.")
        }
        do {
            let status = Status(rawValue: errSecInvalidInputVector)
            XCTAssertEqual(status, .InvalidInputVector)
            XCTAssertEqual(status?.description, "The input vector is not valid.")
        }
        do {
            let status = Status(rawValue: errSecInvalidOutputVector)
            XCTAssertEqual(status, .InvalidOutputVector)
            XCTAssertEqual(status?.description, "The output vector is not valid.")
        }
        do {
            let status = Status(rawValue: errSecInvalidContext)
            XCTAssertEqual(status, .InvalidContext)
            XCTAssertEqual(status?.description, "An invalid context was encountered.")
        }
        do {
            let status = Status(rawValue: errSecInvalidAlgorithm)
            XCTAssertEqual(status, .InvalidAlgorithm)
            XCTAssertEqual(status?.description, "An invalid algorithm was encountered.")
        }
        do {
            let status = Status(rawValue: errSecInvalidAttributeKey)
            XCTAssertEqual(status, .InvalidAttributeKey)
            XCTAssertEqual(status?.description, "A key attribute was not valid.")
        }
        do {
            let status = Status(rawValue: errSecMissingAttributeKey)
            XCTAssertEqual(status, .MissingAttributeKey)
            XCTAssertEqual(status?.description, "A key attribute was missing.")
        }
        do {
            let status = Status(rawValue: errSecInvalidAttributeInitVector)
            XCTAssertEqual(status, .InvalidAttributeInitVector)
            XCTAssertEqual(status?.description, "An init vector attribute was not valid.")
        }
        do {
            let status = Status(rawValue: errSecMissingAttributeInitVector)
            XCTAssertEqual(status, .MissingAttributeInitVector)
            XCTAssertEqual(status?.description, "An init vector attribute was missing.")
        }
        do {
            let status = Status(rawValue: errSecInvalidAttributeSalt)
            XCTAssertEqual(status, .InvalidAttributeSalt)
            XCTAssertEqual(status?.description, "A salt attribute was not valid.")
        }
        do {
            let status = Status(rawValue: errSecMissingAttributeSalt)
            XCTAssertEqual(status, .MissingAttributeSalt)
            XCTAssertEqual(status?.description, "A salt attribute was missing.")
        }
        do {
            let status = Status(rawValue: errSecInvalidAttributePadding)
            XCTAssertEqual(status, .InvalidAttributePadding)
            XCTAssertEqual(status?.description, "A padding attribute was not valid.")
        }
        do {
            let status = Status(rawValue: errSecMissingAttributePadding)
            XCTAssertEqual(status, .MissingAttributePadding)
            XCTAssertEqual(status?.description, "A padding attribute was missing.")
        }
        do {
            let status = Status(rawValue: errSecInvalidAttributeRandom)
            XCTAssertEqual(status, .InvalidAttributeRandom)
            XCTAssertEqual(status?.description, "A random number attribute was not valid.")
        }
        do {
            let status = Status(rawValue: errSecMissingAttributeRandom)
            XCTAssertEqual(status, .MissingAttributeRandom)
            XCTAssertEqual(status?.description, "A random number attribute was missing.")
        }
        do {
            let status = Status(rawValue: errSecInvalidAttributeSeed)
            XCTAssertEqual(status, .InvalidAttributeSeed)
            XCTAssertEqual(status?.description, "A seed attribute was not valid.")
        }
        do {
            let status = Status(rawValue: errSecMissingAttributeSeed)
            XCTAssertEqual(status, .MissingAttributeSeed)
            XCTAssertEqual(status?.description, "A seed attribute was missing.")
        }
        do {
            let status = Status(rawValue: errSecInvalidAttributePassphrase)
            XCTAssertEqual(status, .InvalidAttributePassphrase)
            XCTAssertEqual(status?.description, "A passphrase attribute was not valid.")
        }
        do {
            let status = Status(rawValue: errSecMissingAttributePassphrase)
            XCTAssertEqual(status, .MissingAttributePassphrase)
            XCTAssertEqual(status?.description, "A passphrase attribute was missing.")
        }
        do {
            let status = Status(rawValue: errSecInvalidAttributeKeyLength)
            XCTAssertEqual(status, .InvalidAttributeKeyLength)
            XCTAssertEqual(status?.description, "A key length attribute was not valid.")
        }
        do {
            let status = Status(rawValue: errSecMissingAttributeKeyLength)
            XCTAssertEqual(status, .MissingAttributeKeyLength)
            XCTAssertEqual(status?.description, "A key length attribute was missing.")
        }
        do {
            let status = Status(rawValue: errSecInvalidAttributeBlockSize)
            XCTAssertEqual(status, .InvalidAttributeBlockSize)
            XCTAssertEqual(status?.description, "A block size attribute was not valid.")
        }
        do {
            let status = Status(rawValue: errSecMissingAttributeBlockSize)
            XCTAssertEqual(status, .MissingAttributeBlockSize)
            XCTAssertEqual(status?.description, "A block size attribute was missing.")
        }
        do {
            let status = Status(rawValue: errSecInvalidAttributeOutputSize)
            XCTAssertEqual(status, .InvalidAttributeOutputSize)
            XCTAssertEqual(status?.description, "An output size attribute was not valid.")
        }
        do {
            let status = Status(rawValue: errSecMissingAttributeOutputSize)
            XCTAssertEqual(status, .MissingAttributeOutputSize)
            XCTAssertEqual(status?.description, "An output size attribute was missing.")
        }
        do {
            let status = Status(rawValue: errSecInvalidAttributeRounds)
            XCTAssertEqual(status, .InvalidAttributeRounds)
            XCTAssertEqual(status?.description, "The number of rounds attribute was not valid.")
        }
        do {
            let status = Status(rawValue: errSecMissingAttributeRounds)
            XCTAssertEqual(status, .MissingAttributeRounds)
            XCTAssertEqual(status?.description, "The number of rounds attribute was missing.")
        }
        do {
            let status = Status(rawValue: errSecInvalidAlgorithmParms)
            XCTAssertEqual(status, .InvalidAlgorithmParms)
            XCTAssertEqual(status?.description, "An algorithm parameters attribute was not valid.")
        }
        do {
            let status = Status(rawValue: errSecMissingAlgorithmParms)
            XCTAssertEqual(status, .MissingAlgorithmParms)
            XCTAssertEqual(status?.description, "An algorithm parameters attribute was missing.")
        }
        do {
            let status = Status(rawValue: errSecInvalidAttributeLabel)
            XCTAssertEqual(status, .InvalidAttributeLabel)
            XCTAssertEqual(status?.description, "A label attribute was not valid.")
        }
        do {
            let status = Status(rawValue: errSecMissingAttributeLabel)
            XCTAssertEqual(status, .MissingAttributeLabel)
            XCTAssertEqual(status?.description, "A label attribute was missing.")
        }
        do {
            let status = Status(rawValue: errSecInvalidAttributeKeyType)
            XCTAssertEqual(status, .InvalidAttributeKeyType)
            XCTAssertEqual(status?.description, "A key type attribute was not valid.")
        }
        do {
            let status = Status(rawValue: errSecMissingAttributeKeyType)
            XCTAssertEqual(status, .MissingAttributeKeyType)
            XCTAssertEqual(status?.description, "A key type attribute was missing.")
        }
        do {
            let status = Status(rawValue: errSecInvalidAttributeMode)
            XCTAssertEqual(status, .InvalidAttributeMode)
            XCTAssertEqual(status?.description, "A mode attribute was not valid.")
        }
        do {
            let status = Status(rawValue: errSecMissingAttributeMode)
            XCTAssertEqual(status, .MissingAttributeMode)
            XCTAssertEqual(status?.description, "A mode attribute was missing.")
        }
        do {
            let status = Status(rawValue: errSecInvalidAttributeEffectiveBits)
            XCTAssertEqual(status, .InvalidAttributeEffectiveBits)
            XCTAssertEqual(status?.description, "An effective bits attribute was not valid.")
        }
        do {
            let status = Status(rawValue: errSecMissingAttributeEffectiveBits)
            XCTAssertEqual(status, .MissingAttributeEffectiveBits)
            XCTAssertEqual(status?.description, "An effective bits attribute was missing.")
        }
        do {
            let status = Status(rawValue: errSecInvalidAttributeStartDate)
            XCTAssertEqual(status, .InvalidAttributeStartDate)
            XCTAssertEqual(status?.description, "A start date attribute was not valid.")
        }
        do {
            let status = Status(rawValue: errSecMissingAttributeStartDate)
            XCTAssertEqual(status, .MissingAttributeStartDate)
            XCTAssertEqual(status?.description, "A start date attribute was missing.")
        }
        do {
            let status = Status(rawValue: errSecInvalidAttributeEndDate)
            XCTAssertEqual(status, .InvalidAttributeEndDate)
            XCTAssertEqual(status?.description, "An end date attribute was not valid.")
        }
        do {
            let status = Status(rawValue: errSecMissingAttributeEndDate)
            XCTAssertEqual(status, .MissingAttributeEndDate)
            XCTAssertEqual(status?.description, "An end date attribute was missing.")
        }
        do {
            let status = Status(rawValue: errSecInvalidAttributeVersion)
            XCTAssertEqual(status, .InvalidAttributeVersion)
            XCTAssertEqual(status?.description, "A version attribute was not valid.")
        }
        do {
            let status = Status(rawValue: errSecMissingAttributeVersion)
            XCTAssertEqual(status, .MissingAttributeVersion)
            XCTAssertEqual(status?.description, "A version attribute was missing.")
        }
        do {
            let status = Status(rawValue: errSecInvalidAttributePrime)
            XCTAssertEqual(status, .InvalidAttributePrime)
            XCTAssertEqual(status?.description, "A prime attribute was not valid.")
        }
        do {
            let status = Status(rawValue: errSecMissingAttributePrime)
            XCTAssertEqual(status, .MissingAttributePrime)
            XCTAssertEqual(status?.description, "A prime attribute was missing.")
        }
        do {
            let status = Status(rawValue: errSecInvalidAttributeBase)
            XCTAssertEqual(status, .InvalidAttributeBase)
            XCTAssertEqual(status?.description, "A base attribute was not valid.")
        }
        do {
            let status = Status(rawValue: errSecMissingAttributeBase)
            XCTAssertEqual(status, .MissingAttributeBase)
            XCTAssertEqual(status?.description, "A base attribute was missing.")
        }
        do {
            let status = Status(rawValue: errSecInvalidAttributeSubprime)
            XCTAssertEqual(status, .InvalidAttributeSubprime)
            XCTAssertEqual(status?.description, "A subprime attribute was not valid.")
        }
        do {
            let status = Status(rawValue: errSecMissingAttributeSubprime)
            XCTAssertEqual(status, .MissingAttributeSubprime)
            XCTAssertEqual(status?.description, "A subprime attribute was missing.")
        }
        do {
            let status = Status(rawValue: errSecInvalidAttributeIterationCount)
            XCTAssertEqual(status, .InvalidAttributeIterationCount)
            XCTAssertEqual(status?.description, "An iteration count attribute was not valid.")
        }
        do {
            let status = Status(rawValue: errSecMissingAttributeIterationCount)
            XCTAssertEqual(status, .MissingAttributeIterationCount)
            XCTAssertEqual(status?.description, "An iteration count attribute was missing.")
        }
        do {
            let status = Status(rawValue: errSecInvalidAttributeDLDBHandle)
            XCTAssertEqual(status, .InvalidAttributeDLDBHandle)
            XCTAssertEqual(status?.description, "A database handle attribute was not valid.")
        }
        do {
            let status = Status(rawValue: errSecMissingAttributeDLDBHandle)
            XCTAssertEqual(status, .MissingAttributeDLDBHandle)
            XCTAssertEqual(status?.description, "A database handle attribute was missing.")
        }
        do {
            let status = Status(rawValue: errSecInvalidAttributeAccessCredentials)
            XCTAssertEqual(status, .InvalidAttributeAccessCredentials)
            XCTAssertEqual(status?.description, "An access credentials attribute was not valid.")
        }
        do {
            let status = Status(rawValue: errSecMissingAttributeAccessCredentials)
            XCTAssertEqual(status, .MissingAttributeAccessCredentials)
            XCTAssertEqual(status?.description, "An access credentials attribute was missing.")
        }
        do {
            let status = Status(rawValue: errSecInvalidAttributePublicKeyFormat)
            XCTAssertEqual(status, .InvalidAttributePublicKeyFormat)
            XCTAssertEqual(status?.description, "A public key format attribute was not valid.")
        }
        do {
            let status = Status(rawValue: errSecMissingAttributePublicKeyFormat)
            XCTAssertEqual(status, .MissingAttributePublicKeyFormat)
            XCTAssertEqual(status?.description, "A public key format attribute was missing.")
        }
        do {
            let status = Status(rawValue: errSecInvalidAttributePrivateKeyFormat)
            XCTAssertEqual(status, .InvalidAttributePrivateKeyFormat)
            XCTAssertEqual(status?.description, "A private key format attribute was not valid.")
        }
        do {
            let status = Status(rawValue: errSecMissingAttributePrivateKeyFormat)
            XCTAssertEqual(status, .MissingAttributePrivateKeyFormat)
            XCTAssertEqual(status?.description, "A private key format attribute was missing.")
        }
        do {
            let status = Status(rawValue: errSecInvalidAttributeSymmetricKeyFormat)
            XCTAssertEqual(status, .InvalidAttributeSymmetricKeyFormat)
            XCTAssertEqual(status?.description, "A symmetric key format attribute was not valid.")
        }
        do {
            let status = Status(rawValue: errSecMissingAttributeSymmetricKeyFormat)
            XCTAssertEqual(status, .MissingAttributeSymmetricKeyFormat)
            XCTAssertEqual(status?.description, "A symmetric key format attribute was missing.")
        }
        do {
            let status = Status(rawValue: errSecInvalidAttributeWrappedKeyFormat)
            XCTAssertEqual(status, .InvalidAttributeWrappedKeyFormat)
            XCTAssertEqual(status?.description, "A wrapped key format attribute was not valid.")
        }
        do {
            let status = Status(rawValue: errSecMissingAttributeWrappedKeyFormat)
            XCTAssertEqual(status, .MissingAttributeWrappedKeyFormat)
            XCTAssertEqual(status?.description, "A wrapped key format attribute was missing.")
        }
        do {
            let status = Status(rawValue: errSecStagedOperationInProgress)
            XCTAssertEqual(status, .StagedOperationInProgress)
            XCTAssertEqual(status?.description, "A staged operation is in progress.")
        }
        do {
            let status = Status(rawValue: errSecStagedOperationNotStarted)
            XCTAssertEqual(status, .StagedOperationNotStarted)
            XCTAssertEqual(status?.description, "A staged operation was not started.")
        }
        do {
            let status = Status(rawValue: errSecVerifyFailed)
            XCTAssertEqual(status, .VerifyFailed)
            XCTAssertEqual(status?.description, "A cryptographic verification failure has occurred.")
        }
        do {
            let status = Status(rawValue: errSecQuerySizeUnknown)
            XCTAssertEqual(status, .QuerySizeUnknown)
            XCTAssertEqual(status?.description, "The query size is unknown.")
        }
        do {
            let status = Status(rawValue: errSecBlockSizeMismatch)
            XCTAssertEqual(status, .BlockSizeMismatch)
            XCTAssertEqual(status?.description, "A block size mismatch occurred.")
        }
        do {
            let status = Status(rawValue: errSecPublicKeyInconsistent)
            XCTAssertEqual(status, .PublicKeyInconsistent)
            XCTAssertEqual(status?.description, "The public key was inconsistent.")
        }
        do {
            let status = Status(rawValue: errSecDeviceVerifyFailed)
            XCTAssertEqual(status, .DeviceVerifyFailed)
            XCTAssertEqual(status?.description, "A device verification failure has occurred.")
        }
        do {
            let status = Status(rawValue: errSecInvalidLoginName)
            XCTAssertEqual(status, .InvalidLoginName)
            XCTAssertEqual(status?.description, "An invalid login name was detected.")
        }
        do {
            let status = Status(rawValue: errSecAlreadyLoggedIn)
            XCTAssertEqual(status, .AlreadyLoggedIn)
            XCTAssertEqual(status?.description, "The user is already logged in.")
        }
        do {
            let status = Status(rawValue: errSecInvalidDigestAlgorithm)
            XCTAssertEqual(status, .InvalidDigestAlgorithm)
            XCTAssertEqual(status?.description, "An invalid digest algorithm was detected.")
        }
        do {
            let status = Status(rawValue: errSecInvalidCRLGroup)
            XCTAssertEqual(status, .InvalidCRLGroup)
            XCTAssertEqual(status?.description, "An invalid CRL group was detected.")
        }
        do {
            let status = Status(rawValue: errSecCertificateCannotOperate)
            XCTAssertEqual(status, .CertificateCannotOperate)
            XCTAssertEqual(status?.description, "The certificate cannot operate.")
        }
        do {
            let status = Status(rawValue: errSecCertificateExpired)
            XCTAssertEqual(status, .CertificateExpired)
            XCTAssertEqual(status?.description, "An expired certificate was detected.")
        }
        do {
            let status = Status(rawValue: errSecCertificateNotValidYet)
            XCTAssertEqual(status, .CertificateNotValidYet)
            XCTAssertEqual(status?.description, "The certificate is not yet valid.")
        }
        do {
            let status = Status(rawValue: errSecCertificateRevoked)
            XCTAssertEqual(status, .CertificateRevoked)
            XCTAssertEqual(status?.description, "The certificate was revoked.")
        }
        do {
            let status = Status(rawValue: errSecCertificateSuspended)
            XCTAssertEqual(status, .CertificateSuspended)
            XCTAssertEqual(status?.description, "The certificate was suspended.")
        }
        do {
            let status = Status(rawValue: errSecInsufficientCredentials)
            XCTAssertEqual(status, .InsufficientCredentials)
            XCTAssertEqual(status?.description, "Insufficient credentials were detected.")
        }
        do {
            let status = Status(rawValue: errSecInvalidAction)
            XCTAssertEqual(status, .InvalidAction)
            XCTAssertEqual(status?.description, "The action was not valid.")
        }
        do {
            let status = Status(rawValue: errSecInvalidAuthority)
            XCTAssertEqual(status, .InvalidAuthority)
            XCTAssertEqual(status?.description, "The authority was not valid.")
        }
        do {
            let status = Status(rawValue: errSecVerifyActionFailed)
            XCTAssertEqual(status, .VerifyActionFailed)
            XCTAssertEqual(status?.description, "A verify action has failed.")
        }
        do {
            let status = Status(rawValue: errSecInvalidCertAuthority)
            XCTAssertEqual(status, .InvalidCertAuthority)
            XCTAssertEqual(status?.description, "The certificate authority was not valid.")
        }
        do {
            let status = Status(rawValue: errSecInvaldCRLAuthority)
            XCTAssertEqual(status, .InvaldCRLAuthority)
            XCTAssertEqual(status?.description, "The CRL authority was not valid.")
        }
        do {
            let status = Status(rawValue: errSecInvalidCRLEncoding)
            XCTAssertEqual(status, .InvalidCRLEncoding)
            XCTAssertEqual(status?.description, "The CRL encoding was not valid.")
        }
        do {
            let status = Status(rawValue: errSecInvalidCRLType)
            XCTAssertEqual(status, .InvalidCRLType)
            XCTAssertEqual(status?.description, "The CRL type was not valid.")
        }
        do {
            let status = Status(rawValue: errSecInvalidCRL)
            XCTAssertEqual(status, .InvalidCRL)
            XCTAssertEqual(status?.description, "The CRL was not valid.")
        }
        do {
            let status = Status(rawValue: errSecInvalidFormType)
            XCTAssertEqual(status, .InvalidFormType)
            XCTAssertEqual(status?.description, "The form type was not valid.")
        }
        do {
            let status = Status(rawValue: errSecInvalidID)
            XCTAssertEqual(status, .InvalidID)
            XCTAssertEqual(status?.description, "The ID was not valid.")
        }
        do {
            let status = Status(rawValue: errSecInvalidIdentifier)
            XCTAssertEqual(status, .InvalidIdentifier)
            XCTAssertEqual(status?.description, "The identifier was not valid.")
        }
        do {
            let status = Status(rawValue: errSecInvalidIndex)
            XCTAssertEqual(status, .InvalidIndex)
            XCTAssertEqual(status?.description, "The index was not valid.")
        }
        do {
            let status = Status(rawValue: errSecInvalidPolicyIdentifiers)
            XCTAssertEqual(status, .InvalidPolicyIdentifiers)
            XCTAssertEqual(status?.description, "The policy identifiers are not valid.")
        }
        do {
            let status = Status(rawValue: errSecInvalidTimeString)
            XCTAssertEqual(status, .InvalidTimeString)
            XCTAssertEqual(status?.description, "The time specified was not valid.")
        }
        do {
            let status = Status(rawValue: errSecInvalidReason)
            XCTAssertEqual(status, .InvalidReason)
            XCTAssertEqual(status?.description, "The trust policy reason was not valid.")
        }
        do {
            let status = Status(rawValue: errSecInvalidRequestInputs)
            XCTAssertEqual(status, .InvalidRequestInputs)
            XCTAssertEqual(status?.description, "The request inputs are not valid.")
        }
        do {
            let status = Status(rawValue: errSecInvalidResponseVector)
            XCTAssertEqual(status, .InvalidResponseVector)
            XCTAssertEqual(status?.description, "The response vector was not valid.")
        }
        do {
            let status = Status(rawValue: errSecInvalidStopOnPolicy)
            XCTAssertEqual(status, .InvalidStopOnPolicy)
            XCTAssertEqual(status?.description, "The stop-on policy was not valid.")
        }
        do {
            let status = Status(rawValue: errSecInvalidTuple)
            XCTAssertEqual(status, .InvalidTuple)
            XCTAssertEqual(status?.description, "The tuple was not valid.")
        }
        do {
            let status = Status(rawValue: errSecMultipleValuesUnsupported)
            XCTAssertEqual(status, .MultipleValuesUnsupported)
            XCTAssertEqual(status?.description, "Multiple values are not supported.")
        }
        do {
            let status = Status(rawValue: errSecNotTrusted)
            XCTAssertEqual(status, .NotTrusted)
            XCTAssertEqual(status?.description, "The trust policy was not trusted.")
        }
        do {
            let status = Status(rawValue: errSecNoDefaultAuthority)
            XCTAssertEqual(status, .NoDefaultAuthority)
            XCTAssertEqual(status?.description, "No default authority was detected.")
        }
        do {
            let status = Status(rawValue: errSecRejectedForm)
            XCTAssertEqual(status, .RejectedForm)
            XCTAssertEqual(status?.description, "The trust policy had a rejected form.")
        }
        do {
            let status = Status(rawValue: errSecRequestLost)
            XCTAssertEqual(status, .RequestLost)
            XCTAssertEqual(status?.description, "The request was lost.")
        }
        do {
            let status = Status(rawValue: errSecRequestRejected)
            XCTAssertEqual(status, .RequestRejected)
            XCTAssertEqual(status?.description, "The request was rejected.")
        }
        do {
            let status = Status(rawValue: errSecUnsupportedAddressType)
            XCTAssertEqual(status, .UnsupportedAddressType)
            XCTAssertEqual(status?.description, "The address type is not supported.")
        }
        do {
            let status = Status(rawValue: errSecUnsupportedService)
            XCTAssertEqual(status, .UnsupportedService)
            XCTAssertEqual(status?.description, "The service is not supported.")
        }
        do {
            let status = Status(rawValue: errSecInvalidTupleGroup)
            XCTAssertEqual(status, .InvalidTupleGroup)
            XCTAssertEqual(status?.description, "The tuple group was not valid.")
        }
        do {
            let status = Status(rawValue: errSecInvalidBaseACLs)
            XCTAssertEqual(status, .InvalidBaseACLs)
            XCTAssertEqual(status?.description, "The base ACLs are not valid.")
        }
        do {
            let status = Status(rawValue: errSecInvalidTupleCredendtials)
            XCTAssertEqual(status, .InvalidTupleCredendtials)
            XCTAssertEqual(status?.description, "The tuple credentials are not valid.")
        }
        do {
            let status = Status(rawValue: errSecInvalidEncoding)
            XCTAssertEqual(status, .InvalidEncoding)
            XCTAssertEqual(status?.description, "The encoding was not valid.")
        }
        do {
            let status = Status(rawValue: errSecInvalidValidityPeriod)
            XCTAssertEqual(status, .InvalidValidityPeriod)
            XCTAssertEqual(status?.description, "The validity period was not valid.")
        }
        do {
            let status = Status(rawValue: errSecInvalidRequestor)
            XCTAssertEqual(status, .InvalidRequestor)
            XCTAssertEqual(status?.description, "The requestor was not valid.")
        }
        do {
            let status = Status(rawValue: errSecRequestDescriptor)
            XCTAssertEqual(status, .RequestDescriptor)
            XCTAssertEqual(status?.description, "The request descriptor was not valid.")
        }
        do {
            let status = Status(rawValue: errSecInvalidBundleInfo)
            XCTAssertEqual(status, .InvalidBundleInfo)
            XCTAssertEqual(status?.description, "The bundle information was not valid.")
        }
        do {
            let status = Status(rawValue: errSecInvalidCRLIndex)
            XCTAssertEqual(status, .InvalidCRLIndex)
            XCTAssertEqual(status?.description, "The CRL index was not valid.")
        }
        do {
            let status = Status(rawValue: errSecNoFieldValues)
            XCTAssertEqual(status, .NoFieldValues)
            XCTAssertEqual(status?.description, "No field values were detected.")
        }
        do {
            let status = Status(rawValue: errSecUnsupportedFieldFormat)
            XCTAssertEqual(status, .UnsupportedFieldFormat)
            XCTAssertEqual(status?.description, "The field format is not supported.")
        }
        do {
            let status = Status(rawValue: errSecUnsupportedIndexInfo)
            XCTAssertEqual(status, .UnsupportedIndexInfo)
            XCTAssertEqual(status?.description, "The index information is not supported.")
        }
        do {
            let status = Status(rawValue: errSecUnsupportedLocality)
            XCTAssertEqual(status, .UnsupportedLocality)
            XCTAssertEqual(status?.description, "The locality is not supported.")
        }
        do {
            let status = Status(rawValue: errSecUnsupportedNumAttributes)
            XCTAssertEqual(status, .UnsupportedNumAttributes)
            XCTAssertEqual(status?.description, "The number of attributes is not supported.")
        }
        do {
            let status = Status(rawValue: errSecUnsupportedNumIndexes)
            XCTAssertEqual(status, .UnsupportedNumIndexes)
            XCTAssertEqual(status?.description, "The number of indexes is not supported.")
        }
        do {
            let status = Status(rawValue: errSecUnsupportedNumRecordTypes)
            XCTAssertEqual(status, .UnsupportedNumRecordTypes)
            XCTAssertEqual(status?.description, "The number of record types is not supported.")
        }
        do {
            let status = Status(rawValue: errSecFieldSpecifiedMultiple)
            XCTAssertEqual(status, .FieldSpecifiedMultiple)
            XCTAssertEqual(status?.description, "Too many fields were specified.")
        }
        do {
            let status = Status(rawValue: errSecIncompatibleFieldFormat)
            XCTAssertEqual(status, .IncompatibleFieldFormat)
            XCTAssertEqual(status?.description, "The field format was incompatible.")
        }
        do {
            let status = Status(rawValue: errSecInvalidParsingModule)
            XCTAssertEqual(status, .InvalidParsingModule)
            XCTAssertEqual(status?.description, "The parsing module was not valid.")
        }
        do {
            let status = Status(rawValue: errSecDatabaseLocked)
            XCTAssertEqual(status, .DatabaseLocked)
            XCTAssertEqual(status?.description, "The database is locked.")
        }
        do {
            let status = Status(rawValue: errSecDatastoreIsOpen)
            XCTAssertEqual(status, .DatastoreIsOpen)
            XCTAssertEqual(status?.description, "The data store is open.")
        }
        do {
            let status = Status(rawValue: errSecMissingValue)
            XCTAssertEqual(status, .MissingValue)
            XCTAssertEqual(status?.description, "A missing value was detected.")
        }
        do {
            let status = Status(rawValue: errSecUnsupportedQueryLimits)
            XCTAssertEqual(status, .UnsupportedQueryLimits)
            XCTAssertEqual(status?.description, "The query limits are not supported.")
        }
        do {
            let status = Status(rawValue: errSecUnsupportedNumSelectionPreds)
            XCTAssertEqual(status, .UnsupportedNumSelectionPreds)
            XCTAssertEqual(status?.description, "The number of selection predicates is not supported.")
        }
        do {
            let status = Status(rawValue: errSecUnsupportedOperator)
            XCTAssertEqual(status, .UnsupportedOperator)
            XCTAssertEqual(status?.description, "The operator is not supported.")
        }
        do {
            let status = Status(rawValue: errSecInvalidDBLocation)
            XCTAssertEqual(status, .InvalidDBLocation)
            XCTAssertEqual(status?.description, "The database location is not valid.")
        }
        do {
            let status = Status(rawValue: errSecInvalidAccessRequest)
            XCTAssertEqual(status, .InvalidAccessRequest)
            XCTAssertEqual(status?.description, "The access request is not valid.")
        }
        do {
            let status = Status(rawValue: errSecInvalidIndexInfo)
            XCTAssertEqual(status, .InvalidIndexInfo)
            XCTAssertEqual(status?.description, "The index information is not valid.")
        }
        do {
            let status = Status(rawValue: errSecInvalidNewOwner)
            XCTAssertEqual(status, .InvalidNewOwner)
            XCTAssertEqual(status?.description, "The new owner is not valid.")
        }
        do {
            let status = Status(rawValue: errSecInvalidModifyMode)
            XCTAssertEqual(status, .InvalidModifyMode)
            XCTAssertEqual(status?.description, "The modify mode is not valid.")
        }
        do {
            let status = Status(rawValue: errSecMissingRequiredExtension)
            XCTAssertEqual(status, .MissingRequiredExtension)
            XCTAssertEqual(status?.description, "A required certificate extension is missing.")
        }
        do {
            let status = Status(rawValue: errSecExtendedKeyUsageNotCritical)
            XCTAssertEqual(status, .ExtendedKeyUsageNotCritical)
            XCTAssertEqual(status?.description, "The extended key usage extension was not marked critical.")
        }
        do {
            let status = Status(rawValue: errSecTimestampMissing)
            XCTAssertEqual(status, .TimestampMissing)
            XCTAssertEqual(status?.description, "A timestamp was expected but was not found.")
        }
        do {
            let status = Status(rawValue: errSecTimestampInvalid)
            XCTAssertEqual(status, .TimestampInvalid)
            XCTAssertEqual(status?.description, "The timestamp was not valid.")
        }
        do {
            let status = Status(rawValue: errSecTimestampNotTrusted)
            XCTAssertEqual(status, .TimestampNotTrusted)
            XCTAssertEqual(status?.description, "The timestamp was not trusted.")
        }
        do {
            let status = Status(rawValue: errSecTimestampServiceNotAvailable)
            XCTAssertEqual(status, .TimestampServiceNotAvailable)
            XCTAssertEqual(status?.description, "The timestamp service is not available.")
        }
        do {
            let status = Status(rawValue: errSecTimestampBadAlg)
            XCTAssertEqual(status, .TimestampBadAlg)
            XCTAssertEqual(status?.description, "An unrecognized or unsupported Algorithm Identifier in timestamp.")
        }
        do {
            let status = Status(rawValue: errSecTimestampBadRequest)
            XCTAssertEqual(status, .TimestampBadRequest)
            XCTAssertEqual(status?.description, "The timestamp transaction is not permitted or supported.")
        }
        do {
            let status = Status(rawValue: errSecTimestampBadDataFormat)
            XCTAssertEqual(status, .TimestampBadDataFormat)
            XCTAssertEqual(status?.description, "The timestamp data submitted has the wrong format.")
        }
        do {
            let status = Status(rawValue: errSecTimestampTimeNotAvailable)
            XCTAssertEqual(status, .TimestampTimeNotAvailable)
            XCTAssertEqual(status?.description, "The time source for the Timestamp Authority is not available.")
        }
        do {
            let status = Status(rawValue: errSecTimestampUnacceptedPolicy)
            XCTAssertEqual(status, .TimestampUnacceptedPolicy)
            XCTAssertEqual(status?.description, "The requested policy is not supported by the Timestamp Authority.")
        }
        do {
            let status = Status(rawValue: errSecTimestampUnacceptedExtension)
            XCTAssertEqual(status, .TimestampUnacceptedExtension)
            XCTAssertEqual(status?.description, "The requested extension is not supported by the Timestamp Authority.")
        }
        do {
            let status = Status(rawValue: errSecTimestampAddInfoNotAvailable)
            XCTAssertEqual(status, .TimestampAddInfoNotAvailable)
            XCTAssertEqual(status?.description, "The additional information requested is not available.")
        }
        do {
            let status = Status(rawValue: errSecTimestampSystemFailure)
            XCTAssertEqual(status, .TimestampSystemFailure)
            XCTAssertEqual(status?.description, "The timestamp request cannot be handled due to system failure.")
        }
        do {
            let status = Status(rawValue: errSecSigningTimeMissing)
            XCTAssertEqual(status, .SigningTimeMissing)
            XCTAssertEqual(status?.description, "A signing time was expected but was not found.")
        }
        do {
            let status = Status(rawValue: errSecTimestampRejection)
            XCTAssertEqual(status, .TimestampRejection)
            XCTAssertEqual(status?.description, "A timestamp transaction was rejected.")
        }
        do {
            let status = Status(rawValue: errSecTimestampWaiting)
            XCTAssertEqual(status, .TimestampWaiting)
            XCTAssertEqual(status?.description, "A timestamp transaction is waiting.")
        }
        do {
            let status = Status(rawValue: errSecTimestampRevocationWarning)
            XCTAssertEqual(status, .TimestampRevocationWarning)
            XCTAssertEqual(status?.description, "A timestamp authority revocation warning was issued.")
        }
        do {
            let status = Status(rawValue: errSecTimestampRevocationNotification)
            XCTAssertEqual(status, .TimestampRevocationNotification)
            XCTAssertEqual(status?.description, "A timestamp authority revocation notification was issued.")
        }
        #endif
    }
}
