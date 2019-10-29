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
            XCTAssertEqual(status, .success)
            XCTAssertEqual(status?.description, "No error.")
        }
        do {
            let status = Status(rawValue: errSecUnimplemented)
            XCTAssertEqual(status, .unimplemented)
            XCTAssertEqual(status?.description, "Function or operation not implemented.")
        }
        #if os(OSX)
        do {
            let status = Status(rawValue: errSecDiskFull)
            XCTAssertEqual(status, .diskFull)
            XCTAssertEqual(status?.description, "The disk is full.")
        }
        #endif
        do {
            let status = Status(rawValue: errSecIO)
            XCTAssertEqual(status, .io)
            XCTAssertEqual(status?.description, "I/O error (bummers)")
        }
        #if os(iOS)
        do {
            let status = Status(rawValue: errSecOpWr)
            XCTAssertEqual(status, .opWr)
            XCTAssertEqual(status?.description, "file already open with with write permission")
        }
        #endif
        do {
            let status = Status(rawValue: errSecParam)
            XCTAssertEqual(status, .param)
            XCTAssertEqual(status?.description, "One or more parameters passed to a function were not valid.")
        }
        #if os(OSX)
        do {
            let status = Status(rawValue: errSecWrPerm)
            XCTAssertEqual(status, .wrPerm)
            XCTAssertEqual(status?.description, "write permissions error")
        }
        #endif
        do {
            let status = Status(rawValue: errSecAllocate)
            XCTAssertEqual(status, .allocate)
            XCTAssertEqual(status?.description, "Failed to allocate memory.")
        }
        do {
            let status = Status(rawValue: errSecUserCanceled)
            XCTAssertEqual(status, .userCanceled)
            XCTAssertEqual(status?.description, "User canceled the operation.")
        }
        do {
            let status = Status(rawValue: errSecBadReq)
            XCTAssertEqual(status, .badReq)
            XCTAssertEqual(status?.description, "Bad parameter or invalid state for operation.")
        }
        do {
            let status = Status(rawValue: errSecInternalComponent)
            XCTAssertEqual(status, .internalComponent)
            XCTAssertEqual(status?.description, "")
        }
        do {
            let status = Status(rawValue: errSecNotAvailable)
            XCTAssertEqual(status, .notAvailable)
            XCTAssertEqual(status?.description, "No keychain is available. You may need to restart your computer.")
        }
        #if os(OSX)
        do {
            let status = Status(rawValue: errSecReadOnly)
            XCTAssertEqual(status, .readOnly)
            XCTAssertEqual(status?.description, "This keychain cannot be modified.")
        }
        #endif
        do {
            let status = Status(rawValue: errSecAuthFailed)
            XCTAssertEqual(status, .authFailed)
            XCTAssertEqual(status?.description, "The user name or passphrase you entered is not correct.")
        }
        #if os(OSX)
        do {
            let status = Status(rawValue: errSecNoSuchKeychain)
            XCTAssertEqual(status, .noSuchKeychain)
            XCTAssertEqual(status?.description, "The specified keychain could not be found.")
        }
        do {
            let status = Status(rawValue: errSecInvalidKeychain)
            XCTAssertEqual(status, .invalidKeychain)
            XCTAssertEqual(status?.description, "The specified keychain is not a valid keychain file.")
        }
        do {
            let status = Status(rawValue: errSecDuplicateKeychain)
            XCTAssertEqual(status, .duplicateKeychain)
            XCTAssertEqual(status?.description, "A keychain with the same name already exists.")
        }
        do {
            let status = Status(rawValue: errSecDuplicateCallback)
            XCTAssertEqual(status, .duplicateCallback)
            XCTAssertEqual(status?.description, "The specified callback function is already installed.")
        }
        do {
            let status = Status(rawValue: errSecInvalidCallback)
            XCTAssertEqual(status, .invalidCallback)
            XCTAssertEqual(status?.description, "The specified callback function is not valid.")
        }
        #endif
        do {
            let status = Status(rawValue: errSecDuplicateItem)
            XCTAssertEqual(status, .duplicateItem)
            XCTAssertEqual(status?.description, "The specified item already exists in the keychain.")
        }
        do {
            let status = Status(rawValue: errSecItemNotFound)
            XCTAssertEqual(status, .itemNotFound)
            XCTAssertEqual(status?.description, "The specified item could not be found in the keychain.")
        }
        #if os(OSX)
        do {
            let status = Status(rawValue: errSecBufferTooSmall)
            XCTAssertEqual(status, .bufferTooSmall)
            XCTAssertEqual(status?.description, "There is not enough memory available to use the specified item.")
        }
        do {
            let status = Status(rawValue: errSecDataTooLarge)
            XCTAssertEqual(status, .dataTooLarge)
            XCTAssertEqual(status?.description, "This item contains information which is too large or in a format that cannot be displayed.")
        }
        do {
            let status = Status(rawValue: errSecNoSuchAttr)
            XCTAssertEqual(status, .noSuchAttr)
            XCTAssertEqual(status?.description, "The specified attribute does not exist.")
        }
        do {
            let status = Status(rawValue: errSecInvalidItemRef)
            XCTAssertEqual(status, .invalidItemRef)
            XCTAssertEqual(status?.description, "The specified item is no longer valid. It may have been deleted from the keychain.")
        }
        do {
            let status = Status(rawValue: errSecInvalidSearchRef)
            XCTAssertEqual(status, .invalidSearchRef)
            XCTAssertEqual(status?.description, "Unable to search the current keychain.")
        }
        do {
            let status = Status(rawValue: errSecNoSuchClass)
            XCTAssertEqual(status, .noSuchClass)
            XCTAssertEqual(status?.description, "The specified item does not appear to be a valid keychain item.")
        }
        do {
            let status = Status(rawValue: errSecNoDefaultKeychain)
            XCTAssertEqual(status, .noDefaultKeychain)
            XCTAssertEqual(status?.description, "A default keychain could not be found.")
        }
        #endif
        do {
            let status = Status(rawValue: errSecInteractionNotAllowed)
            XCTAssertEqual(status, .interactionNotAllowed)
            XCTAssertEqual(status?.description, "User interaction is not allowed.")
        }
        #if os(OSX)
        do {
            let status = Status(rawValue: errSecReadOnlyAttr)
            XCTAssertEqual(status, .readOnlyAttr)
            XCTAssertEqual(status?.description, "The specified attribute could not be modified.")
        }
        do {
            let status = Status(rawValue: errSecWrongSecVersion)
            XCTAssertEqual(status, .wrongSecVersion)
            XCTAssertEqual(status?.description, "This keychain was created by a different version of the system software and cannot be opened.")
        }
        do {
            let status = Status(rawValue: errSecKeySizeNotAllowed)
            XCTAssertEqual(status, .keySizeNotAllowed)
            XCTAssertEqual(status?.description, "This item specifies a key size which is too large.")
        }
        do {
            let status = Status(rawValue: errSecNoStorageModule)
            XCTAssertEqual(status, .noStorageModule)
            XCTAssertEqual(status?.description, "A required component (data storage module) could not be loaded. You may need to restart your computer.")
        }
        do {
            let status = Status(rawValue: errSecNoCertificateModule)
            XCTAssertEqual(status, .noCertificateModule)
            XCTAssertEqual(status?.description, "A required component (certificate module) could not be loaded. You may need to restart your computer.")
        }
        do {
            let status = Status(rawValue: errSecNoPolicyModule)
            XCTAssertEqual(status, .noPolicyModule)
            XCTAssertEqual(status?.description, "A required component (policy module) could not be loaded. You may need to restart your computer.")
        }
        do {
            let status = Status(rawValue: errSecInteractionRequired)
            XCTAssertEqual(status, .interactionRequired)
            XCTAssertEqual(status?.description, "User interaction is required, but is currently not allowed.")
        }
        do {
            let status = Status(rawValue: errSecDataNotAvailable)
            XCTAssertEqual(status, .dataNotAvailable)
            XCTAssertEqual(status?.description, "The contents of this item cannot be retrieved.")
        }
        do {
            let status = Status(rawValue: errSecDataNotModifiable)
            XCTAssertEqual(status, .dataNotModifiable)
            XCTAssertEqual(status?.description, "The contents of this item cannot be modified.")
        }
        do {
            let status = Status(rawValue: errSecCreateChainFailed)
            XCTAssertEqual(status, .createChainFailed)
            XCTAssertEqual(status?.description, "One or more certificates required to validate this certificate cannot be found.")
        }
        do {
            let status = Status(rawValue: errSecInvalidPrefsDomain)
            XCTAssertEqual(status, .invalidPrefsDomain)
            XCTAssertEqual(status?.description, "The specified preferences domain is not valid.")
        }
        do {
            let status = Status(rawValue: errSecInDarkWake)
            XCTAssertEqual(status, .inDarkWake)
            XCTAssertEqual(status?.description, "In dark wake, no UI possible")
        }
        do {
            let status = Status(rawValue: errSecACLNotSimple)
            XCTAssertEqual(status, .aclNotSimple)
            XCTAssertEqual(status?.description, "The specified access control list is not in standard (simple) form.")
        }
        do {
            let status = Status(rawValue: errSecPolicyNotFound)
            XCTAssertEqual(status, .policyNotFound)
            XCTAssertEqual(status?.description, "The specified policy cannot be found.")
        }
        do {
            let status = Status(rawValue: errSecInvalidTrustSetting)
            XCTAssertEqual(status, .invalidTrustSetting)
            XCTAssertEqual(status?.description, "The specified trust setting is invalid.")
        }
        do {
            let status = Status(rawValue: errSecNoAccessForItem)
            XCTAssertEqual(status, .noAccessForItem)
            XCTAssertEqual(status?.description, "The specified item has no access control.")
        }
        do {
            let status = Status(rawValue: errSecInvalidOwnerEdit)
            XCTAssertEqual(status, .invalidOwnerEdit)
            XCTAssertEqual(status?.description, "Invalid attempt to change the owner of this item.")
        }
        do {
            let status = Status(rawValue: errSecTrustNotAvailable)
            XCTAssertEqual(status, .trustNotAvailable)
            XCTAssertEqual(status?.description, "No trust results are available.")
        }
        do {
            let status = Status(rawValue: errSecUnsupportedFormat)
            XCTAssertEqual(status, .unsupportedFormat)
            XCTAssertEqual(status?.description, "Import/Export format unsupported.")
        }
        do {
            let status = Status(rawValue: errSecUnknownFormat)
            XCTAssertEqual(status, .unknownFormat)
            XCTAssertEqual(status?.description, "Unknown format in import.")
        }
        do {
            let status = Status(rawValue: errSecKeyIsSensitive)
            XCTAssertEqual(status, .keyIsSensitive)
            XCTAssertEqual(status?.description, "Key material must be wrapped for export.")
        }
        do {
            let status = Status(rawValue: errSecMultiplePrivKeys)
            XCTAssertEqual(status, .multiplePrivKeys)
            XCTAssertEqual(status?.description, "An attempt was made to import multiple private keys.")
        }
        do {
            let status = Status(rawValue: errSecPassphraseRequired)
            XCTAssertEqual(status, .passphraseRequired)
            XCTAssertEqual(status?.description, "Passphrase is required for import/export.")
        }
        do {
            let status = Status(rawValue: errSecInvalidPasswordRef)
            XCTAssertEqual(status, .invalidPasswordRef)
            XCTAssertEqual(status?.description, "The password reference was invalid.")
        }
        do {
            let status = Status(rawValue: errSecInvalidTrustSettings)
            XCTAssertEqual(status, .invalidTrustSettings)
            XCTAssertEqual(status?.description, "The Trust Settings Record was corrupted.")
        }
        do {
            let status = Status(rawValue: errSecNoTrustSettings)
            XCTAssertEqual(status, .noTrustSettings)
            XCTAssertEqual(status?.description, "No Trust Settings were found.")
        }
        do {
            let status = Status(rawValue: errSecPkcs12VerifyFailure)
            XCTAssertEqual(status, .pkcs12VerifyFailure)
            XCTAssertEqual(status?.description, "MAC verification failed during PKCS12 import (wrong password?)")
        }
        do {
            let errSecInvalidCertificate: OSStatus = -26265
            let status = Status(rawValue: errSecInvalidCertificate)
            XCTAssertEqual(status, .invalidCertificate)
            XCTAssertEqual(status?.description, "This certificate could not be decoded.")
        }
        do {
            let status = Status(rawValue: errSecNotSigner)
            XCTAssertEqual(status, .notSigner)
            XCTAssertEqual(status?.description, "A certificate was not signed by its proposed parent.")
        }
        do {
            let errSecPolicyDenied: OSStatus = -26270
            let status = Status(rawValue: errSecPolicyDenied)
            XCTAssertEqual(status, .policyDenied)
            XCTAssertEqual(status?.description, "The certificate chain was not trusted due to a policy not accepting it.")
        }
        do {
            let errSecInvalidKey: OSStatus = -26274
            let status = Status(rawValue: errSecInvalidKey)
            XCTAssertEqual(status, .invalidKey)
            XCTAssertEqual(status?.description, "The provided key material was not valid.")
        }
        #endif
        do {
            let status = Status(rawValue: errSecDecode)
            XCTAssertEqual(status, .decode)
            XCTAssertEqual(status?.description, "Unable to decode the provided data.")
        }
        do {
            let errSecInternal: OSStatus = -26276
            let status = Status(rawValue: errSecInternal)
            XCTAssertEqual(status, .internal)
            XCTAssertEqual(status?.description, "An internal error occurred in the Security framework.")
        }
        #if os(OSX)
        do {
            let status = Status(rawValue: errSecServiceNotAvailable)
            XCTAssertEqual(status, .serviceNotAvailable)
            XCTAssertEqual(status?.description, "The required service is not available.")
        }
        do {
            let errSecUnsupportedAlgorithm: OSStatus = -26268
            let status = Status(rawValue: errSecUnsupportedAlgorithm)
            XCTAssertEqual(status, .unsupportedAlgorithm)
            XCTAssertEqual(status?.description, "An unsupported algorithm was encountered.")
        }
        do {
            let errSecUnsupportedOperation: OSStatus = -26271
            let status = Status(rawValue: errSecUnsupportedOperation)
            XCTAssertEqual(status, .unsupportedOperation)
            XCTAssertEqual(status?.description, "The operation you requested is not supported by this key.")
        }
        do {
            let errSecUnsupportedPadding: OSStatus = -26273
            let status = Status(rawValue: errSecUnsupportedPadding)
            XCTAssertEqual(status, .unsupportedPadding)
            XCTAssertEqual(status?.description, "The padding you requested is not supported.")
        }
        do {
            let errSecItemInvalidKey: OSStatus = -34000
            let status = Status(rawValue: errSecItemInvalidKey)
            XCTAssertEqual(status, .itemInvalidKey)
            XCTAssertEqual(status?.description, "A string key in dictionary is not one of the supported keys.")
        }
        do {
            let errSecItemInvalidKeyType: OSStatus = -34001
            let status = Status(rawValue: errSecItemInvalidKeyType)
            XCTAssertEqual(status, .itemInvalidKeyType)
            XCTAssertEqual(status?.description, "A key in a dictionary is neither a CFStringRef nor a CFNumberRef.")
        }
        do {
            let errSecItemInvalidValue: OSStatus = -34002
            let status = Status(rawValue: errSecItemInvalidValue)
            XCTAssertEqual(status, .itemInvalidValue)
            XCTAssertEqual(status?.description, "A value in a dictionary is an invalid (or unsupported) CF type.")
        }
        do {
            let errSecItemClassMissing: OSStatus = -34003
            let status = Status(rawValue: errSecItemClassMissing)
            XCTAssertEqual(status, .itemClassMissing)
            XCTAssertEqual(status?.description, "No kSecItemClass key was specified in a dictionary.")
        }
        do {
            let errSecItemMatchUnsupported: OSStatus = -34004
            let status = Status(rawValue: errSecItemMatchUnsupported)
            XCTAssertEqual(status, .itemMatchUnsupported)
            XCTAssertEqual(status?.description, "The caller passed one or more kSecMatch keys to a function which does not support matches.")
        }
        do {
            let errSecUseItemListUnsupported: OSStatus = -34005
            let status = Status(rawValue: errSecUseItemListUnsupported)
            XCTAssertEqual(status, .useItemListUnsupported)
            XCTAssertEqual(status?.description, "The caller passed in a kSecUseItemList key to a function which does not support it.")
        }
        do {
            let errSecUseKeychainUnsupported: OSStatus = -34006
            let status = Status(rawValue: errSecUseKeychainUnsupported)
            XCTAssertEqual(status, .useKeychainUnsupported)
            XCTAssertEqual(status?.description, "The caller passed in a kSecUseKeychain key to a function which does not support it.")
        }
        do {
            let errSecUseKeychainListUnsupported: OSStatus = -34007
            let status = Status(rawValue: errSecUseKeychainListUnsupported)
            XCTAssertEqual(status, .useKeychainListUnsupported)
            XCTAssertEqual(status?.description, "The caller passed in a kSecUseKeychainList key to a function which does not support it.")
        }
        do {
            let errSecReturnDataUnsupported: OSStatus = -34008
            let status = Status(rawValue: errSecReturnDataUnsupported)
            XCTAssertEqual(status, .returnDataUnsupported)
            XCTAssertEqual(status?.description, "The caller passed in a kSecReturnData key to a function which does not support it.")
        }
        do {
            let errSecReturnAttributesUnsupported: OSStatus = -34009
            let status = Status(rawValue: errSecReturnAttributesUnsupported)
            XCTAssertEqual(status, .returnAttributesUnsupported)
            XCTAssertEqual(status?.description, "The caller passed in a kSecReturnAttributes key to a function which does not support it.")
        }
        do {
            let errSecReturnRefUnsupported: OSStatus = -34010
            let status = Status(rawValue: errSecReturnRefUnsupported)
            XCTAssertEqual(status, .returnRefUnsupported)
            XCTAssertEqual(status?.description, "The caller passed in a kSecReturnRef key to a function which does not support it.")
        }
        do {
            let errSecReturnPersitentRefUnsupported: OSStatus = -34011
            let status = Status(rawValue: errSecReturnPersitentRefUnsupported)
            XCTAssertEqual(status, .returnPersitentRefUnsupported)
            XCTAssertEqual(status?.description, "The caller passed in a kSecReturnPersistentRef key to a function which does not support it.")
        }
        do {
            let errSecValueRefUnsupported: OSStatus = -34012
            let status = Status(rawValue: errSecValueRefUnsupported)
            XCTAssertEqual(status, .valueRefUnsupported)
            XCTAssertEqual(status?.description, "The caller passed in a kSecValueRef key to a function which does not support it.")
        }
        do {
            let errSecValuePersistentRefUnsupported: OSStatus = -34013
            let status = Status(rawValue: errSecValuePersistentRefUnsupported)
            XCTAssertEqual(status, .valuePersistentRefUnsupported)
            XCTAssertEqual(status?.description, "The caller passed in a kSecValuePersistentRef key to a function which does not support it.")
        }
        do {
            let errSecReturnMissingPointer: OSStatus = -34014
            let status = Status(rawValue: errSecReturnMissingPointer)
            XCTAssertEqual(status, .returnMissingPointer)
            XCTAssertEqual(status?.description, "The caller passed asked for something to be returned but did not pass in a result pointer.")
        }
        do {
            let errSecMatchLimitUnsupported: OSStatus = -34015
            let status = Status(rawValue: errSecMatchLimitUnsupported)
            XCTAssertEqual(status, .matchLimitUnsupported)
            XCTAssertEqual(status?.description, "The caller passed in a kSecMatchLimit key to a call which does not support limits.")
        }
        do {
            let errSecItemIllegalQuery: OSStatus = -34016
            let status = Status(rawValue: errSecItemIllegalQuery)
            XCTAssertEqual(status, .itemIllegalQuery)
            XCTAssertEqual(status?.description, "The caller passed in a query which contained too many keys.")
        }
        do {
            let errSecWaitForCallback: OSStatus = -34017
            let status = Status(rawValue: errSecWaitForCallback)
            XCTAssertEqual(status, .waitForCallback)
            XCTAssertEqual(status?.description, "This operation is incomplete, until the callback is invoked (not an error).")
        }
        do {
            let errSecMissingEntitlement: OSStatus = -34018
            let status = Status(rawValue: errSecMissingEntitlement)
            XCTAssertEqual(status, .missingEntitlement)
            XCTAssertEqual(status?.description, "Internal error when a required entitlement isn't present, client has neither application-identifier nor keychain-access-groups entitlements.")
        }
        do {
            let errSecUpgradePending: OSStatus = -34019
            let status = Status(rawValue: errSecUpgradePending)
            XCTAssertEqual(status, .upgradePending)
            XCTAssertEqual(status?.description, "Error returned if keychain database needs a schema migration but the device is locked, clients should wait for a device unlock notification and retry the command.")
        }
        do {
            let errSecMPSignatureInvalid: OSStatus = -25327
            let status = Status(rawValue: errSecMPSignatureInvalid)
            XCTAssertEqual(status, .mpSignatureInvalid)
            XCTAssertEqual(status?.description, "Signature invalid on MP message")
        }
        do {
            let errSecOTRTooOld: OSStatus = -25328
            let status = Status(rawValue: errSecOTRTooOld)
            XCTAssertEqual(status, .otrTooOld)
            XCTAssertEqual(status?.description, "Message is too old to use")
        }
        do {
            let errSecOTRIDTooNew: OSStatus = -25329
            let status = Status(rawValue: errSecOTRIDTooNew)
            XCTAssertEqual(status, .otrIDTooNew)
            XCTAssertEqual(status?.description, "Key ID is too new to use! Message from the future?")
        }
        do {
            let status = Status(rawValue: errSecInsufficientClientID)
            XCTAssertEqual(status, .insufficientClientID)
            XCTAssertEqual(status?.description, "The client ID is not correct.")
        }
        do {
            let status = Status(rawValue: errSecDeviceReset)
            XCTAssertEqual(status, .deviceReset)
            XCTAssertEqual(status?.description, "A device reset has occurred.")
        }
        do {
            let status = Status(rawValue: errSecDeviceFailed)
            XCTAssertEqual(status, .deviceFailed)
            XCTAssertEqual(status?.description, "A device failure has occurred.")
        }
        do {
            let status = Status(rawValue: errSecAppleAddAppACLSubject)
            XCTAssertEqual(status, .appleAddAppACLSubject)
            XCTAssertEqual(status?.description, "Adding an application ACL subject failed.")
        }
        do {
            let status = Status(rawValue: errSecApplePublicKeyIncomplete)
            XCTAssertEqual(status, .applePublicKeyIncomplete)
            XCTAssertEqual(status?.description, "The public key is incomplete.")
        }
        do {
            let status = Status(rawValue: errSecAppleSignatureMismatch)
            XCTAssertEqual(status, .appleSignatureMismatch)
            XCTAssertEqual(status?.description, "A signature mismatch has occurred.")
        }
        do {
            let status = Status(rawValue: errSecAppleInvalidKeyStartDate)
            XCTAssertEqual(status, .appleInvalidKeyStartDate)
            XCTAssertEqual(status?.description, "The specified key has an invalid start date.")
        }
        do {
            let status = Status(rawValue: errSecAppleInvalidKeyEndDate)
            XCTAssertEqual(status, .appleInvalidKeyEndDate)
            XCTAssertEqual(status?.description, "The specified key has an invalid end date.")
        }
        do {
            let status = Status(rawValue: errSecConversionError)
            XCTAssertEqual(status, .conversionError)
            XCTAssertEqual(status?.description, "A conversion error has occurred.")
        }
        do {
            let status = Status(rawValue: errSecAppleSSLv2Rollback)
            XCTAssertEqual(status, .appleSSLv2Rollback)
            XCTAssertEqual(status?.description, "A SSLv2 rollback error has occurred.")
        }
        do {
            let status = Status(rawValue: errSecDiskFull)
            XCTAssertEqual(status, .diskFull)
            XCTAssertEqual(status?.description, "The disk is full.")
        }
        do {
            let status = Status(rawValue: errSecQuotaExceeded)
            XCTAssertEqual(status, .quotaExceeded)
            XCTAssertEqual(status?.description, "The quota was exceeded.")
        }
        do {
            let status = Status(rawValue: errSecFileTooBig)
            XCTAssertEqual(status, .fileTooBig)
            XCTAssertEqual(status?.description, "The file is too big.")
        }
        do {
            let status = Status(rawValue: errSecInvalidDatabaseBlob)
            XCTAssertEqual(status, .invalidDatabaseBlob)
            XCTAssertEqual(status?.description, "The specified database has an invalid blob.")
        }
        do {
            let status = Status(rawValue: errSecInvalidKeyBlob)
            XCTAssertEqual(status, .invalidKeyBlob)
            XCTAssertEqual(status?.description, "The specified database has an invalid key blob.")
        }
        do {
            let status = Status(rawValue: errSecIncompatibleDatabaseBlob)
            XCTAssertEqual(status, .incompatibleDatabaseBlob)
            XCTAssertEqual(status?.description, "The specified database has an incompatible blob.")
        }
        do {
            let status = Status(rawValue: errSecIncompatibleKeyBlob)
            XCTAssertEqual(status, .incompatibleKeyBlob)
            XCTAssertEqual(status?.description, "The specified database has an incompatible key blob.")
        }
        do {
            let status = Status(rawValue: errSecHostNameMismatch)
            XCTAssertEqual(status, .hostNameMismatch)
            XCTAssertEqual(status?.description, "A host name mismatch has occurred.")
        }
        do {
            let status = Status(rawValue: errSecUnknownCriticalExtensionFlag)
            XCTAssertEqual(status, .unknownCriticalExtensionFlag)
            XCTAssertEqual(status?.description, "There is an unknown critical extension flag.")
        }
        do {
            let status = Status(rawValue: errSecNoBasicConstraints)
            XCTAssertEqual(status, .noBasicConstraints)
            XCTAssertEqual(status?.description, "No basic constraints were found.")
        }
        do {
            let status = Status(rawValue: errSecNoBasicConstraintsCA)
            XCTAssertEqual(status, .noBasicConstraintsCA)
            XCTAssertEqual(status?.description, "No basic CA constraints were found.")
        }
        do {
            let status = Status(rawValue: errSecInvalidAuthorityKeyID)
            XCTAssertEqual(status, .invalidAuthorityKeyID)
            XCTAssertEqual(status?.description, "The authority key ID is not valid.")
        }
        do {
            let status = Status(rawValue: errSecInvalidSubjectKeyID)
            XCTAssertEqual(status, .invalidSubjectKeyID)
            XCTAssertEqual(status?.description, "The subject key ID is not valid.")
        }
        do {
            let status = Status(rawValue: errSecInvalidKeyUsageForPolicy)
            XCTAssertEqual(status, .invalidKeyUsageForPolicy)
            XCTAssertEqual(status?.description, "The key usage is not valid for the specified policy.")
        }
        do {
            let status = Status(rawValue: errSecInvalidExtendedKeyUsage)
            XCTAssertEqual(status, .invalidExtendedKeyUsage)
            XCTAssertEqual(status?.description, "The extended key usage is not valid.")
        }
        do {
            let status = Status(rawValue: errSecInvalidIDLinkage)
            XCTAssertEqual(status, .invalidIDLinkage)
            XCTAssertEqual(status?.description, "The ID linkage is not valid.")
        }
        do {
            let status = Status(rawValue: errSecPathLengthConstraintExceeded)
            XCTAssertEqual(status, .pathLengthConstraintExceeded)
            XCTAssertEqual(status?.description, "The path length constraint was exceeded.")
        }
        do {
            let status = Status(rawValue: errSecInvalidRoot)
            XCTAssertEqual(status, .invalidRoot)
            XCTAssertEqual(status?.description, "The root or anchor certificate is not valid.")
        }
        do {
            let status = Status(rawValue: errSecCRLExpired)
            XCTAssertEqual(status, .crlExpired)
            XCTAssertEqual(status?.description, "The CRL has expired.")
        }
        do {
            let status = Status(rawValue: errSecCRLNotValidYet)
            XCTAssertEqual(status, .crlNotValidYet)
            XCTAssertEqual(status?.description, "The CRL is not yet valid.")
        }
        do {
            let status = Status(rawValue: errSecCRLNotFound)
            XCTAssertEqual(status, .crlNotFound)
            XCTAssertEqual(status?.description, "The CRL was not found.")
        }
        do {
            let status = Status(rawValue: errSecCRLServerDown)
            XCTAssertEqual(status, .crlServerDown)
            XCTAssertEqual(status?.description, "The CRL server is down.")
        }
        do {
            let status = Status(rawValue: errSecCRLBadURI)
            XCTAssertEqual(status, .crlBadURI)
            XCTAssertEqual(status?.description, "The CRL has a bad Uniform Resource Identifier.")
        }
        do {
            let status = Status(rawValue: errSecUnknownCertExtension)
            XCTAssertEqual(status, .unknownCertExtension)
            XCTAssertEqual(status?.description, "An unknown certificate extension was encountered.")
        }
        do {
            let status = Status(rawValue: errSecUnknownCRLExtension)
            XCTAssertEqual(status, .unknownCRLExtension)
            XCTAssertEqual(status?.description, "An unknown CRL extension was encountered.")
        }
        do {
            let status = Status(rawValue: errSecCRLNotTrusted)
            XCTAssertEqual(status, .crlNotTrusted)
            XCTAssertEqual(status?.description, "The CRL is not trusted.")
        }
        do {
            let status = Status(rawValue: errSecCRLPolicyFailed)
            XCTAssertEqual(status, .crlPolicyFailed)
            XCTAssertEqual(status?.description, "The CRL policy failed.")
        }
        do {
            let status = Status(rawValue: errSecIDPFailure)
            XCTAssertEqual(status, .idpFailure)
            XCTAssertEqual(status?.description, "The issuing distribution point was not valid.")
        }
        do {
            let status = Status(rawValue: errSecSMIMEEmailAddressesNotFound)
            XCTAssertEqual(status, .smimeEmailAddressesNotFound)
            XCTAssertEqual(status?.description, "An email address mismatch was encountered.")
        }
        do {
            let status = Status(rawValue: errSecSMIMEBadExtendedKeyUsage)
            XCTAssertEqual(status, .smimeBadExtendedKeyUsage)
            XCTAssertEqual(status?.description, "The appropriate extended key usage for SMIME was not found.")
        }
        do {
            let status = Status(rawValue: errSecSMIMEBadKeyUsage)
            XCTAssertEqual(status, .smimeBadKeyUsage)
            XCTAssertEqual(status?.description, "The key usage is not compatible with SMIME.")
        }
        do {
            let status = Status(rawValue: errSecSMIMEKeyUsageNotCritical)
            XCTAssertEqual(status, .smimeKeyUsageNotCritical)
            XCTAssertEqual(status?.description, "The key usage extension is not marked as critical.")
        }
        do {
            let status = Status(rawValue: errSecSMIMENoEmailAddress)
            XCTAssertEqual(status, .smimeNoEmailAddress)
            XCTAssertEqual(status?.description, "No email address was found in the certificate.")
        }
        do {
            let status = Status(rawValue: errSecSMIMESubjAltNameNotCritical)
            XCTAssertEqual(status, .smimeSubjAltNameNotCritical)
            XCTAssertEqual(status?.description, "The subject alternative name extension is not marked as critical.")
        }
        do {
            let status = Status(rawValue: errSecSSLBadExtendedKeyUsage)
            XCTAssertEqual(status, .sslBadExtendedKeyUsage)
            XCTAssertEqual(status?.description, "The appropriate extended key usage for SSL was not found.")
        }
        do {
            let status = Status(rawValue: errSecOCSPBadResponse)
            XCTAssertEqual(status, .ocspBadResponse)
            XCTAssertEqual(status?.description, "The OCSP response was incorrect or could not be parsed.")
        }
        do {
            let status = Status(rawValue: errSecOCSPBadRequest)
            XCTAssertEqual(status, .ocspBadRequest)
            XCTAssertEqual(status?.description, "The OCSP request was incorrect or could not be parsed.")
        }
        do {
            let status = Status(rawValue: errSecOCSPUnavailable)
            XCTAssertEqual(status, .ocspUnavailable)
            XCTAssertEqual(status?.description, "OCSP service is unavailable.")
        }
        do {
            let status = Status(rawValue: errSecOCSPStatusUnrecognized)
            XCTAssertEqual(status, .ocspStatusUnrecognized)
            XCTAssertEqual(status?.description, "The OCSP server did not recognize this certificate.")
        }
        do {
            let status = Status(rawValue: errSecEndOfData)
            XCTAssertEqual(status, .endOfData)
            XCTAssertEqual(status?.description, "An end-of-data was detected.")
        }
        do {
            let status = Status(rawValue: errSecIncompleteCertRevocationCheck)
            XCTAssertEqual(status, .incompleteCertRevocationCheck)
            XCTAssertEqual(status?.description, "An incomplete certificate revocation check occurred.")
        }
        do {
            let status = Status(rawValue: errSecNetworkFailure)
            XCTAssertEqual(status, .networkFailure)
            XCTAssertEqual(status?.description, "A network failure occurred.")
        }
        do {
            let status = Status(rawValue: errSecOCSPNotTrustedToAnchor)
            XCTAssertEqual(status, .ocspNotTrustedToAnchor)
            XCTAssertEqual(status?.description, "The OCSP response was not trusted to a root or anchor certificate.")
        }
        do {
            let status = Status(rawValue: errSecRecordModified)
            XCTAssertEqual(status, .recordModified)
            XCTAssertEqual(status?.description, "The record was modified.")
        }
        do {
            let status = Status(rawValue: errSecOCSPSignatureError)
            XCTAssertEqual(status, .ocspSignatureError)
            XCTAssertEqual(status?.description, "The OCSP response had an invalid signature.")
        }
        do {
            let status = Status(rawValue: errSecOCSPNoSigner)
            XCTAssertEqual(status, .ocspNoSigner)
            XCTAssertEqual(status?.description, "The OCSP response had no signer.")
        }
        do {
            let status = Status(rawValue: errSecOCSPResponderMalformedReq)
            XCTAssertEqual(status, .ocspResponderMalformedReq)
            XCTAssertEqual(status?.description, "The OCSP responder was given a malformed request.")
        }
        do {
            let status = Status(rawValue: errSecOCSPResponderInternalError)
            XCTAssertEqual(status, .ocspResponderInternalError)
            XCTAssertEqual(status?.description, "The OCSP responder encountered an internal error.")
        }
        do {
            let status = Status(rawValue: errSecOCSPResponderTryLater)
            XCTAssertEqual(status, .ocspResponderTryLater)
            XCTAssertEqual(status?.description, "The OCSP responder is busy, try again later.")
        }
        do {
            let status = Status(rawValue: errSecOCSPResponderSignatureRequired)
            XCTAssertEqual(status, .ocspResponderSignatureRequired)
            XCTAssertEqual(status?.description, "The OCSP responder requires a signature.")
        }
        do {
            let status = Status(rawValue: errSecOCSPResponderUnauthorized)
            XCTAssertEqual(status, .ocspResponderUnauthorized)
            XCTAssertEqual(status?.description, "The OCSP responder rejected this request as unauthorized.")
        }
        do {
            let status = Status(rawValue: errSecOCSPResponseNonceMismatch)
            XCTAssertEqual(status, .ocspResponseNonceMismatch)
            XCTAssertEqual(status?.description, "The OCSP response nonce did not match the request.")
        }
        do {
            let status = Status(rawValue: errSecCodeSigningBadCertChainLength)
            XCTAssertEqual(status, .codeSigningBadCertChainLength)
            XCTAssertEqual(status?.description, "Code signing encountered an incorrect certificate chain length.")
        }
        do {
            let status = Status(rawValue: errSecCodeSigningNoBasicConstraints)
            XCTAssertEqual(status, .codeSigningNoBasicConstraints)
            XCTAssertEqual(status?.description, "Code signing found no basic constraints.")
        }
        do {
            let status = Status(rawValue: errSecCodeSigningBadPathLengthConstraint)
            XCTAssertEqual(status, .codeSigningBadPathLengthConstraint)
            XCTAssertEqual(status?.description, "Code signing encountered an incorrect path length constraint.")
        }
        do {
            let status = Status(rawValue: errSecCodeSigningNoExtendedKeyUsage)
            XCTAssertEqual(status, .codeSigningNoExtendedKeyUsage)
            XCTAssertEqual(status?.description, "Code signing found no extended key usage.")
        }
        do {
            let status = Status(rawValue: errSecCodeSigningDevelopment)
            XCTAssertEqual(status, .codeSigningDevelopment)
            XCTAssertEqual(status?.description, "Code signing indicated use of a development-only certificate.")
        }
        do {
            let status = Status(rawValue: errSecResourceSignBadCertChainLength)
            XCTAssertEqual(status, .resourceSignBadCertChainLength)
            XCTAssertEqual(status?.description, "Resource signing has encountered an incorrect certificate chain length.")
        }
        do {
            let status = Status(rawValue: errSecResourceSignBadExtKeyUsage)
            XCTAssertEqual(status, .resourceSignBadExtKeyUsage)
            XCTAssertEqual(status?.description, "Resource signing has encountered an error in the extended key usage.")
        }
        do {
            let status = Status(rawValue: errSecTrustSettingDeny)
            XCTAssertEqual(status, .trustSettingDeny)
            XCTAssertEqual(status?.description, "The trust setting for this policy was set to Deny.")
        }
        do {
            let status = Status(rawValue: errSecInvalidSubjectName)
            XCTAssertEqual(status, .invalidSubjectName)
            XCTAssertEqual(status?.description, "An invalid certificate subject name was encountered.")
        }
        do {
            let status = Status(rawValue: errSecUnknownQualifiedCertStatement)
            XCTAssertEqual(status, .unknownQualifiedCertStatement)
            XCTAssertEqual(status?.description, "An unknown qualified certificate statement was encountered.")
        }
        do {
            let status = Status(rawValue: errSecMobileMeRequestQueued)
            XCTAssertEqual(status, .mobileMeRequestQueued)
            XCTAssertEqual(status?.description, "The MobileMe request will be sent during the next connection.")
        }
        do {
            let status = Status(rawValue: errSecMobileMeRequestRedirected)
            XCTAssertEqual(status, .mobileMeRequestRedirected)
            XCTAssertEqual(status?.description, "The MobileMe request was redirected.")
        }
        do {
            let status = Status(rawValue: errSecMobileMeServerError)
            XCTAssertEqual(status, .mobileMeServerError)
            XCTAssertEqual(status?.description, "A MobileMe server error occurred.")
        }
        do {
            let status = Status(rawValue: errSecMobileMeServerNotAvailable)
            XCTAssertEqual(status, .mobileMeServerNotAvailable)
            XCTAssertEqual(status?.description, "The MobileMe server is not available.")
        }
        do {
            let status = Status(rawValue: errSecMobileMeServerAlreadyExists)
            XCTAssertEqual(status, .mobileMeServerAlreadyExists)
            XCTAssertEqual(status?.description, "The MobileMe server reported that the item already exists.")
        }
        do {
            let status = Status(rawValue: errSecMobileMeServerServiceErr)
            XCTAssertEqual(status, .mobileMeServerServiceErr)
            XCTAssertEqual(status?.description, "A MobileMe service error has occurred.")
        }
        do {
            let status = Status(rawValue: errSecMobileMeRequestAlreadyPending)
            XCTAssertEqual(status, .mobileMeRequestAlreadyPending)
            XCTAssertEqual(status?.description, "A MobileMe request is already pending.")
        }
        do {
            let status = Status(rawValue: errSecMobileMeNoRequestPending)
            XCTAssertEqual(status, .mobileMeNoRequestPending)
            XCTAssertEqual(status?.description, "MobileMe has no request pending.")
        }
        do {
            let status = Status(rawValue: errSecMobileMeCSRVerifyFailure)
            XCTAssertEqual(status, .mobileMeCSRVerifyFailure)
            XCTAssertEqual(status?.description, "A MobileMe CSR verification failure has occurred.")
        }
        do {
            let status = Status(rawValue: errSecMobileMeFailedConsistencyCheck)
            XCTAssertEqual(status, .mobileMeFailedConsistencyCheck)
            XCTAssertEqual(status?.description, "MobileMe has found a failed consistency check.")
        }
        do {
            let status = Status(rawValue: errSecNotInitialized)
            XCTAssertEqual(status, .notInitialized)
            XCTAssertEqual(status?.description, "A function was called without initializing CSSM.")
        }
        do {
            let status = Status(rawValue: errSecInvalidHandleUsage)
            XCTAssertEqual(status, .invalidHandleUsage)
            XCTAssertEqual(status?.description, "The CSSM handle does not match with the service type.")
        }
        do {
            let status = Status(rawValue: errSecPVCReferentNotFound)
            XCTAssertEqual(status, .pvcReferentNotFound)
            XCTAssertEqual(status?.description, "A reference to the calling module was not found in the list of authorized callers.")
        }
        do {
            let status = Status(rawValue: errSecFunctionIntegrityFail)
            XCTAssertEqual(status, .functionIntegrityFail)
            XCTAssertEqual(status?.description, "A function address was not within the verified module.")
        }
        do {
            let status = Status(rawValue: errSecInternalError)
            XCTAssertEqual(status, .internalError)
            XCTAssertEqual(status?.description, "An internal error has occurred.")
        }
        do {
            let status = Status(rawValue: errSecMemoryError)
            XCTAssertEqual(status, .memoryError)
            XCTAssertEqual(status?.description, "A memory error has occurred.")
        }
        do {
            let status = Status(rawValue: errSecInvalidData)
            XCTAssertEqual(status, .invalidData)
            XCTAssertEqual(status?.description, "Invalid data was encountered.")
        }
        do {
            let status = Status(rawValue: errSecMDSError)
            XCTAssertEqual(status, .mdsError)
            XCTAssertEqual(status?.description, "A Module Directory Service error has occurred.")
        }
        do {
            let status = Status(rawValue: errSecInvalidPointer)
            XCTAssertEqual(status, .invalidPointer)
            XCTAssertEqual(status?.description, "An invalid pointer was encountered.")
        }
        do {
            let status = Status(rawValue: errSecSelfCheckFailed)
            XCTAssertEqual(status, .selfCheckFailed)
            XCTAssertEqual(status?.description, "Self-check has failed.")
        }
        do {
            let status = Status(rawValue: errSecFunctionFailed)
            XCTAssertEqual(status, .functionFailed)
            XCTAssertEqual(status?.description, "A function has failed.")
        }
        do {
            let status = Status(rawValue: errSecModuleManifestVerifyFailed)
            XCTAssertEqual(status, .moduleManifestVerifyFailed)
            XCTAssertEqual(status?.description, "A module manifest verification failure has occurred.")
        }
        do {
            let status = Status(rawValue: errSecInvalidGUID)
            XCTAssertEqual(status, .invalidGUID)
            XCTAssertEqual(status?.description, "An invalid GUID was encountered.")
        }
        do {
            let status = Status(rawValue: errSecInvalidHandle)
            XCTAssertEqual(status, .invalidHandle)
            XCTAssertEqual(status?.description, "An invalid handle was encountered.")
        }
        do {
            let status = Status(rawValue: errSecInvalidDBList)
            XCTAssertEqual(status, .invalidDBList)
            XCTAssertEqual(status?.description, "An invalid DB list was encountered.")
        }
        do {
            let status = Status(rawValue: errSecInvalidPassthroughID)
            XCTAssertEqual(status, .invalidPassthroughID)
            XCTAssertEqual(status?.description, "An invalid passthrough ID was encountered.")
        }
        do {
            let status = Status(rawValue: errSecInvalidNetworkAddress)
            XCTAssertEqual(status, .invalidNetworkAddress)
            XCTAssertEqual(status?.description, "An invalid network address was encountered.")
        }
        do {
            let status = Status(rawValue: errSecCRLAlreadySigned)
            XCTAssertEqual(status, .crlAlreadySigned)
            XCTAssertEqual(status?.description, "The certificate revocation list is already signed.")
        }
        do {
            let status = Status(rawValue: errSecInvalidNumberOfFields)
            XCTAssertEqual(status, .invalidNumberOfFields)
            XCTAssertEqual(status?.description, "An invalid number of fields were encountered.")
        }
        do {
            let status = Status(rawValue: errSecVerificationFailure)
            XCTAssertEqual(status, .verificationFailure)
            XCTAssertEqual(status?.description, "A verification failure occurred.")
        }
        do {
            let status = Status(rawValue: errSecUnknownTag)
            XCTAssertEqual(status, .unknownTag)
            XCTAssertEqual(status?.description, "An unknown tag was encountered.")
        }
        do {
            let status = Status(rawValue: errSecInvalidSignature)
            XCTAssertEqual(status, .invalidSignature)
            XCTAssertEqual(status?.description, "An invalid signature was encountered.")
        }
        do {
            let status = Status(rawValue: errSecInvalidName)
            XCTAssertEqual(status, .invalidName)
            XCTAssertEqual(status?.description, "An invalid name was encountered.")
        }
        do {
            let status = Status(rawValue: errSecInvalidCertificateRef)
            XCTAssertEqual(status, .invalidCertificateRef)
            XCTAssertEqual(status?.description, "An invalid certificate reference was encountered.")
        }
        do {
            let status = Status(rawValue: errSecInvalidCertificateGroup)
            XCTAssertEqual(status, .invalidCertificateGroup)
            XCTAssertEqual(status?.description, "An invalid certificate group was encountered.")
        }
        do {
            let status = Status(rawValue: errSecTagNotFound)
            XCTAssertEqual(status, .tagNotFound)
            XCTAssertEqual(status?.description, "The specified tag was not found.")
        }
        do {
            let status = Status(rawValue: errSecInvalidQuery)
            XCTAssertEqual(status, .invalidQuery)
            XCTAssertEqual(status?.description, "The specified query was not valid.")
        }
        do {
            let status = Status(rawValue: errSecInvalidValue)
            XCTAssertEqual(status, .invalidValue)
            XCTAssertEqual(status?.description, "An invalid value was detected.")
        }
        do {
            let status = Status(rawValue: errSecCallbackFailed)
            XCTAssertEqual(status, .callbackFailed)
            XCTAssertEqual(status?.description, "A callback has failed.")
        }
        do {
            let status = Status(rawValue: errSecACLDeleteFailed)
            XCTAssertEqual(status, .aclDeleteFailed)
            XCTAssertEqual(status?.description, "An ACL delete operation has failed.")
        }
        do {
            let status = Status(rawValue: errSecACLReplaceFailed)
            XCTAssertEqual(status, .aclReplaceFailed)
            XCTAssertEqual(status?.description, "An ACL replace operation has failed.")
        }
        do {
            let status = Status(rawValue: errSecACLAddFailed)
            XCTAssertEqual(status, .aclAddFailed)
            XCTAssertEqual(status?.description, "An ACL add operation has failed.")
        }
        do {
            let status = Status(rawValue: errSecACLChangeFailed)
            XCTAssertEqual(status, .aclChangeFailed)
            XCTAssertEqual(status?.description, "An ACL change operation has failed.")
        }
        do {
            let status = Status(rawValue: errSecInvalidAccessCredentials)
            XCTAssertEqual(status, .invalidAccessCredentials)
            XCTAssertEqual(status?.description, "Invalid access credentials were encountered.")
        }
        do {
            let status = Status(rawValue: errSecInvalidRecord)
            XCTAssertEqual(status, .invalidRecord)
            XCTAssertEqual(status?.description, "An invalid record was encountered.")
        }
        do {
            let status = Status(rawValue: errSecInvalidACL)
            XCTAssertEqual(status, .invalidACL)
            XCTAssertEqual(status?.description, "An invalid ACL was encountered.")
        }
        do {
            let status = Status(rawValue: errSecInvalidSampleValue)
            XCTAssertEqual(status, .invalidSampleValue)
            XCTAssertEqual(status?.description, "An invalid sample value was encountered.")
        }
        do {
            let status = Status(rawValue: errSecIncompatibleVersion)
            XCTAssertEqual(status, .incompatibleVersion)
            XCTAssertEqual(status?.description, "An incompatible version was encountered.")
        }
        do {
            let status = Status(rawValue: errSecPrivilegeNotGranted)
            XCTAssertEqual(status, .privilegeNotGranted)
            XCTAssertEqual(status?.description, "The privilege was not granted.")
        }
        do {
            let status = Status(rawValue: errSecInvalidScope)
            XCTAssertEqual(status, .invalidScope)
            XCTAssertEqual(status?.description, "An invalid scope was encountered.")
        }
        do {
            let status = Status(rawValue: errSecPVCAlreadyConfigured)
            XCTAssertEqual(status, .pvcAlreadyConfigured)
            XCTAssertEqual(status?.description, "The PVC is already configured.")
        }
        do {
            let status = Status(rawValue: errSecInvalidPVC)
            XCTAssertEqual(status, .invalidPVC)
            XCTAssertEqual(status?.description, "An invalid PVC was encountered.")
        }
        do {
            let status = Status(rawValue: errSecEMMLoadFailed)
            XCTAssertEqual(status, .emmLoadFailed)
            XCTAssertEqual(status?.description, "The EMM load has failed.")
        }
        do {
            let status = Status(rawValue: errSecEMMUnloadFailed)
            XCTAssertEqual(status, .emmUnloadFailed)
            XCTAssertEqual(status?.description, "The EMM unload has failed.")
        }
        do {
            let status = Status(rawValue: errSecAddinLoadFailed)
            XCTAssertEqual(status, .addinLoadFailed)
            XCTAssertEqual(status?.description, "The add-in load operation has failed.")
        }
        do {
            let status = Status(rawValue: errSecInvalidKeyRef)
            XCTAssertEqual(status, .invalidKeyRef)
            XCTAssertEqual(status?.description, "An invalid key was encountered.")
        }
        do {
            let status = Status(rawValue: errSecInvalidKeyHierarchy)
            XCTAssertEqual(status, .invalidKeyHierarchy)
            XCTAssertEqual(status?.description, "An invalid key hierarchy was encountered.")
        }
        do {
            let status = Status(rawValue: errSecAddinUnloadFailed)
            XCTAssertEqual(status, .addinUnloadFailed)
            XCTAssertEqual(status?.description, "The add-in unload operation has failed.")
        }
        do {
            let status = Status(rawValue: errSecLibraryReferenceNotFound)
            XCTAssertEqual(status, .libraryReferenceNotFound)
            XCTAssertEqual(status?.description, "A library reference was not found.")
        }
        do {
            let status = Status(rawValue: errSecInvalidAddinFunctionTable)
            XCTAssertEqual(status, .invalidAddinFunctionTable)
            XCTAssertEqual(status?.description, "An invalid add-in function table was encountered.")
        }
        do {
            let status = Status(rawValue: errSecInvalidServiceMask)
            XCTAssertEqual(status, .invalidServiceMask)
            XCTAssertEqual(status?.description, "An invalid service mask was encountered.")
        }
        do {
            let status = Status(rawValue: errSecModuleNotLoaded)
            XCTAssertEqual(status, .moduleNotLoaded)
            XCTAssertEqual(status?.description, "A module was not loaded.")
        }
        do {
            let status = Status(rawValue: errSecInvalidSubServiceID)
            XCTAssertEqual(status, .invalidSubServiceID)
            XCTAssertEqual(status?.description, "An invalid subservice ID was encountered.")
        }
        do {
            let status = Status(rawValue: errSecAttributeNotInContext)
            XCTAssertEqual(status, .attributeNotInContext)
            XCTAssertEqual(status?.description, "An attribute was not in the context.")
        }
        do {
            let status = Status(rawValue: errSecModuleManagerInitializeFailed)
            XCTAssertEqual(status, .moduleManagerInitializeFailed)
            XCTAssertEqual(status?.description, "A module failed to initialize.")
        }
        do {
            let status = Status(rawValue: errSecModuleManagerNotFound)
            XCTAssertEqual(status, .moduleManagerNotFound)
            XCTAssertEqual(status?.description, "A module was not found.")
        }
        do {
            let status = Status(rawValue: errSecEventNotificationCallbackNotFound)
            XCTAssertEqual(status, .eventNotificationCallbackNotFound)
            XCTAssertEqual(status?.description, "An event notification callback was not found.")
        }
        do {
            let status = Status(rawValue: errSecInputLengthError)
            XCTAssertEqual(status, .inputLengthError)
            XCTAssertEqual(status?.description, "An input length error was encountered.")
        }
        do {
            let status = Status(rawValue: errSecOutputLengthError)
            XCTAssertEqual(status, .outputLengthError)
            XCTAssertEqual(status?.description, "An output length error was encountered.")
        }
        do {
            let status = Status(rawValue: errSecPrivilegeNotSupported)
            XCTAssertEqual(status, .privilegeNotSupported)
            XCTAssertEqual(status?.description, "The privilege is not supported.")
        }
        do {
            let status = Status(rawValue: errSecDeviceError)
            XCTAssertEqual(status, .deviceError)
            XCTAssertEqual(status?.description, "A device error was encountered.")
        }
        do {
            let status = Status(rawValue: errSecAttachHandleBusy)
            XCTAssertEqual(status, .attachHandleBusy)
            XCTAssertEqual(status?.description, "The CSP handle was busy.")
        }
        do {
            let status = Status(rawValue: errSecNotLoggedIn)
            XCTAssertEqual(status, .notLoggedIn)
            XCTAssertEqual(status?.description, "You are not logged in.")
        }
        do {
            let status = Status(rawValue: errSecAlgorithmMismatch)
            XCTAssertEqual(status, .algorithmMismatch)
            XCTAssertEqual(status?.description, "An algorithm mismatch was encountered.")
        }
        do {
            let status = Status(rawValue: errSecKeyUsageIncorrect)
            XCTAssertEqual(status, .keyUsageIncorrect)
            XCTAssertEqual(status?.description, "The key usage is incorrect.")
        }
        do {
            let status = Status(rawValue: errSecKeyBlobTypeIncorrect)
            XCTAssertEqual(status, .keyBlobTypeIncorrect)
            XCTAssertEqual(status?.description, "The key blob type is incorrect.")
        }
        do {
            let status = Status(rawValue: errSecKeyHeaderInconsistent)
            XCTAssertEqual(status, .keyHeaderInconsistent)
            XCTAssertEqual(status?.description, "The key header is inconsistent.")
        }
        do {
            let status = Status(rawValue: errSecUnsupportedKeyFormat)
            XCTAssertEqual(status, .unsupportedKeyFormat)
            XCTAssertEqual(status?.description, "The key header format is not supported.")
        }
        do {
            let status = Status(rawValue: errSecUnsupportedKeySize)
            XCTAssertEqual(status, .unsupportedKeySize)
            XCTAssertEqual(status?.description, "The key size is not supported.")
        }
        do {
            let status = Status(rawValue: errSecInvalidKeyUsageMask)
            XCTAssertEqual(status, .invalidKeyUsageMask)
            XCTAssertEqual(status?.description, "The key usage mask is not valid.")
        }
        do {
            let status = Status(rawValue: errSecUnsupportedKeyUsageMask)
            XCTAssertEqual(status, .unsupportedKeyUsageMask)
            XCTAssertEqual(status?.description, "The key usage mask is not supported.")
        }
        do {
            let status = Status(rawValue: errSecInvalidKeyAttributeMask)
            XCTAssertEqual(status, .invalidKeyAttributeMask)
            XCTAssertEqual(status?.description, "The key attribute mask is not valid.")
        }
        do {
            let status = Status(rawValue: errSecUnsupportedKeyAttributeMask)
            XCTAssertEqual(status, .unsupportedKeyAttributeMask)
            XCTAssertEqual(status?.description, "The key attribute mask is not supported.")
        }
        do {
            let status = Status(rawValue: errSecInvalidKeyLabel)
            XCTAssertEqual(status, .invalidKeyLabel)
            XCTAssertEqual(status?.description, "The key label is not valid.")
        }
        do {
            let status = Status(rawValue: errSecUnsupportedKeyLabel)
            XCTAssertEqual(status, .unsupportedKeyLabel)
            XCTAssertEqual(status?.description, "The key label is not supported.")
        }
        do {
            let status = Status(rawValue: errSecInvalidKeyFormat)
            XCTAssertEqual(status, .invalidKeyFormat)
            XCTAssertEqual(status?.description, "The key format is not valid.")
        }
        do {
            let status = Status(rawValue: errSecUnsupportedVectorOfBuffers)
            XCTAssertEqual(status, .unsupportedVectorOfBuffers)
            XCTAssertEqual(status?.description, "The vector of buffers is not supported.")
        }
        do {
            let status = Status(rawValue: errSecInvalidInputVector)
            XCTAssertEqual(status, .invalidInputVector)
            XCTAssertEqual(status?.description, "The input vector is not valid.")
        }
        do {
            let status = Status(rawValue: errSecInvalidOutputVector)
            XCTAssertEqual(status, .invalidOutputVector)
            XCTAssertEqual(status?.description, "The output vector is not valid.")
        }
        do {
            let status = Status(rawValue: errSecInvalidContext)
            XCTAssertEqual(status, .invalidContext)
            XCTAssertEqual(status?.description, "An invalid context was encountered.")
        }
        do {
            let status = Status(rawValue: errSecInvalidAlgorithm)
            XCTAssertEqual(status, .invalidAlgorithm)
            XCTAssertEqual(status?.description, "An invalid algorithm was encountered.")
        }
        do {
            let status = Status(rawValue: errSecInvalidAttributeKey)
            XCTAssertEqual(status, .invalidAttributeKey)
            XCTAssertEqual(status?.description, "A key attribute was not valid.")
        }
        do {
            let status = Status(rawValue: errSecMissingAttributeKey)
            XCTAssertEqual(status, .missingAttributeKey)
            XCTAssertEqual(status?.description, "A key attribute was missing.")
        }
        do {
            let status = Status(rawValue: errSecInvalidAttributeInitVector)
            XCTAssertEqual(status, .invalidAttributeInitVector)
            XCTAssertEqual(status?.description, "An init vector attribute was not valid.")
        }
        do {
            let status = Status(rawValue: errSecMissingAttributeInitVector)
            XCTAssertEqual(status, .missingAttributeInitVector)
            XCTAssertEqual(status?.description, "An init vector attribute was missing.")
        }
        do {
            let status = Status(rawValue: errSecInvalidAttributeSalt)
            XCTAssertEqual(status, .invalidAttributeSalt)
            XCTAssertEqual(status?.description, "A salt attribute was not valid.")
        }
        do {
            let status = Status(rawValue: errSecMissingAttributeSalt)
            XCTAssertEqual(status, .missingAttributeSalt)
            XCTAssertEqual(status?.description, "A salt attribute was missing.")
        }
        do {
            let status = Status(rawValue: errSecInvalidAttributePadding)
            XCTAssertEqual(status, .invalidAttributePadding)
            XCTAssertEqual(status?.description, "A padding attribute was not valid.")
        }
        do {
            let status = Status(rawValue: errSecMissingAttributePadding)
            XCTAssertEqual(status, .missingAttributePadding)
            XCTAssertEqual(status?.description, "A padding attribute was missing.")
        }
        do {
            let status = Status(rawValue: errSecInvalidAttributeRandom)
            XCTAssertEqual(status, .invalidAttributeRandom)
            XCTAssertEqual(status?.description, "A random number attribute was not valid.")
        }
        do {
            let status = Status(rawValue: errSecMissingAttributeRandom)
            XCTAssertEqual(status, .missingAttributeRandom)
            XCTAssertEqual(status?.description, "A random number attribute was missing.")
        }
        do {
            let status = Status(rawValue: errSecInvalidAttributeSeed)
            XCTAssertEqual(status, .invalidAttributeSeed)
            XCTAssertEqual(status?.description, "A seed attribute was not valid.")
        }
        do {
            let status = Status(rawValue: errSecMissingAttributeSeed)
            XCTAssertEqual(status, .missingAttributeSeed)
            XCTAssertEqual(status?.description, "A seed attribute was missing.")
        }
        do {
            let status = Status(rawValue: errSecInvalidAttributePassphrase)
            XCTAssertEqual(status, .invalidAttributePassphrase)
            XCTAssertEqual(status?.description, "A passphrase attribute was not valid.")
        }
        do {
            let status = Status(rawValue: errSecMissingAttributePassphrase)
            XCTAssertEqual(status, .missingAttributePassphrase)
            XCTAssertEqual(status?.description, "A passphrase attribute was missing.")
        }
        do {
            let status = Status(rawValue: errSecInvalidAttributeKeyLength)
            XCTAssertEqual(status, .invalidAttributeKeyLength)
            XCTAssertEqual(status?.description, "A key length attribute was not valid.")
        }
        do {
            let status = Status(rawValue: errSecMissingAttributeKeyLength)
            XCTAssertEqual(status, .missingAttributeKeyLength)
            XCTAssertEqual(status?.description, "A key length attribute was missing.")
        }
        do {
            let status = Status(rawValue: errSecInvalidAttributeBlockSize)
            XCTAssertEqual(status, .invalidAttributeBlockSize)
            XCTAssertEqual(status?.description, "A block size attribute was not valid.")
        }
        do {
            let status = Status(rawValue: errSecMissingAttributeBlockSize)
            XCTAssertEqual(status, .missingAttributeBlockSize)
            XCTAssertEqual(status?.description, "A block size attribute was missing.")
        }
        do {
            let status = Status(rawValue: errSecInvalidAttributeOutputSize)
            XCTAssertEqual(status, .invalidAttributeOutputSize)
            XCTAssertEqual(status?.description, "An output size attribute was not valid.")
        }
        do {
            let status = Status(rawValue: errSecMissingAttributeOutputSize)
            XCTAssertEqual(status, .missingAttributeOutputSize)
            XCTAssertEqual(status?.description, "An output size attribute was missing.")
        }
        do {
            let status = Status(rawValue: errSecInvalidAttributeRounds)
            XCTAssertEqual(status, .invalidAttributeRounds)
            XCTAssertEqual(status?.description, "The number of rounds attribute was not valid.")
        }
        do {
            let status = Status(rawValue: errSecMissingAttributeRounds)
            XCTAssertEqual(status, .missingAttributeRounds)
            XCTAssertEqual(status?.description, "The number of rounds attribute was missing.")
        }
        do {
            let status = Status(rawValue: errSecInvalidAlgorithmParms)
            XCTAssertEqual(status, .invalidAlgorithmParms)
            XCTAssertEqual(status?.description, "An algorithm parameters attribute was not valid.")
        }
        do {
            let status = Status(rawValue: errSecMissingAlgorithmParms)
            XCTAssertEqual(status, .missingAlgorithmParms)
            XCTAssertEqual(status?.description, "An algorithm parameters attribute was missing.")
        }
        do {
            let status = Status(rawValue: errSecInvalidAttributeLabel)
            XCTAssertEqual(status, .invalidAttributeLabel)
            XCTAssertEqual(status?.description, "A label attribute was not valid.")
        }
        do {
            let status = Status(rawValue: errSecMissingAttributeLabel)
            XCTAssertEqual(status, .missingAttributeLabel)
            XCTAssertEqual(status?.description, "A label attribute was missing.")
        }
        do {
            let status = Status(rawValue: errSecInvalidAttributeKeyType)
            XCTAssertEqual(status, .invalidAttributeKeyType)
            XCTAssertEqual(status?.description, "A key type attribute was not valid.")
        }
        do {
            let status = Status(rawValue: errSecMissingAttributeKeyType)
            XCTAssertEqual(status, .missingAttributeKeyType)
            XCTAssertEqual(status?.description, "A key type attribute was missing.")
        }
        do {
            let status = Status(rawValue: errSecInvalidAttributeMode)
            XCTAssertEqual(status, .invalidAttributeMode)
            XCTAssertEqual(status?.description, "A mode attribute was not valid.")
        }
        do {
            let status = Status(rawValue: errSecMissingAttributeMode)
            XCTAssertEqual(status, .missingAttributeMode)
            XCTAssertEqual(status?.description, "A mode attribute was missing.")
        }
        do {
            let status = Status(rawValue: errSecInvalidAttributeEffectiveBits)
            XCTAssertEqual(status, .invalidAttributeEffectiveBits)
            XCTAssertEqual(status?.description, "An effective bits attribute was not valid.")
        }
        do {
            let status = Status(rawValue: errSecMissingAttributeEffectiveBits)
            XCTAssertEqual(status, .missingAttributeEffectiveBits)
            XCTAssertEqual(status?.description, "An effective bits attribute was missing.")
        }
        do {
            let status = Status(rawValue: errSecInvalidAttributeStartDate)
            XCTAssertEqual(status, .invalidAttributeStartDate)
            XCTAssertEqual(status?.description, "A start date attribute was not valid.")
        }
        do {
            let status = Status(rawValue: errSecMissingAttributeStartDate)
            XCTAssertEqual(status, .missingAttributeStartDate)
            XCTAssertEqual(status?.description, "A start date attribute was missing.")
        }
        do {
            let status = Status(rawValue: errSecInvalidAttributeEndDate)
            XCTAssertEqual(status, .invalidAttributeEndDate)
            XCTAssertEqual(status?.description, "An end date attribute was not valid.")
        }
        do {
            let status = Status(rawValue: errSecMissingAttributeEndDate)
            XCTAssertEqual(status, .missingAttributeEndDate)
            XCTAssertEqual(status?.description, "An end date attribute was missing.")
        }
        do {
            let status = Status(rawValue: errSecInvalidAttributeVersion)
            XCTAssertEqual(status, .invalidAttributeVersion)
            XCTAssertEqual(status?.description, "A version attribute was not valid.")
        }
        do {
            let status = Status(rawValue: errSecMissingAttributeVersion)
            XCTAssertEqual(status, .missingAttributeVersion)
            XCTAssertEqual(status?.description, "A version attribute was missing.")
        }
        do {
            let status = Status(rawValue: errSecInvalidAttributePrime)
            XCTAssertEqual(status, .invalidAttributePrime)
            XCTAssertEqual(status?.description, "A prime attribute was not valid.")
        }
        do {
            let status = Status(rawValue: errSecMissingAttributePrime)
            XCTAssertEqual(status, .missingAttributePrime)
            XCTAssertEqual(status?.description, "A prime attribute was missing.")
        }
        do {
            let status = Status(rawValue: errSecInvalidAttributeBase)
            XCTAssertEqual(status, .invalidAttributeBase)
            XCTAssertEqual(status?.description, "A base attribute was not valid.")
        }
        do {
            let status = Status(rawValue: errSecMissingAttributeBase)
            XCTAssertEqual(status, .missingAttributeBase)
            XCTAssertEqual(status?.description, "A base attribute was missing.")
        }
        do {
            let status = Status(rawValue: errSecInvalidAttributeSubprime)
            XCTAssertEqual(status, .invalidAttributeSubprime)
            XCTAssertEqual(status?.description, "A subprime attribute was not valid.")
        }
        do {
            let status = Status(rawValue: errSecMissingAttributeSubprime)
            XCTAssertEqual(status, .missingAttributeSubprime)
            XCTAssertEqual(status?.description, "A subprime attribute was missing.")
        }
        do {
            let status = Status(rawValue: errSecInvalidAttributeIterationCount)
            XCTAssertEqual(status, .invalidAttributeIterationCount)
            XCTAssertEqual(status?.description, "An iteration count attribute was not valid.")
        }
        do {
            let status = Status(rawValue: errSecMissingAttributeIterationCount)
            XCTAssertEqual(status, .missingAttributeIterationCount)
            XCTAssertEqual(status?.description, "An iteration count attribute was missing.")
        }
        do {
            let status = Status(rawValue: errSecInvalidAttributeDLDBHandle)
            XCTAssertEqual(status, .invalidAttributeDLDBHandle)
            XCTAssertEqual(status?.description, "A database handle attribute was not valid.")
        }
        do {
            let status = Status(rawValue: errSecMissingAttributeDLDBHandle)
            XCTAssertEqual(status, .missingAttributeDLDBHandle)
            XCTAssertEqual(status?.description, "A database handle attribute was missing.")
        }
        do {
            let status = Status(rawValue: errSecInvalidAttributeAccessCredentials)
            XCTAssertEqual(status, .invalidAttributeAccessCredentials)
            XCTAssertEqual(status?.description, "An access credentials attribute was not valid.")
        }
        do {
            let status = Status(rawValue: errSecMissingAttributeAccessCredentials)
            XCTAssertEqual(status, .missingAttributeAccessCredentials)
            XCTAssertEqual(status?.description, "An access credentials attribute was missing.")
        }
        do {
            let status = Status(rawValue: errSecInvalidAttributePublicKeyFormat)
            XCTAssertEqual(status, .invalidAttributePublicKeyFormat)
            XCTAssertEqual(status?.description, "A public key format attribute was not valid.")
        }
        do {
            let status = Status(rawValue: errSecMissingAttributePublicKeyFormat)
            XCTAssertEqual(status, .missingAttributePublicKeyFormat)
            XCTAssertEqual(status?.description, "A public key format attribute was missing.")
        }
        do {
            let status = Status(rawValue: errSecInvalidAttributePrivateKeyFormat)
            XCTAssertEqual(status, .invalidAttributePrivateKeyFormat)
            XCTAssertEqual(status?.description, "A private key format attribute was not valid.")
        }
        do {
            let status = Status(rawValue: errSecMissingAttributePrivateKeyFormat)
            XCTAssertEqual(status, .missingAttributePrivateKeyFormat)
            XCTAssertEqual(status?.description, "A private key format attribute was missing.")
        }
        do {
            let status = Status(rawValue: errSecInvalidAttributeSymmetricKeyFormat)
            XCTAssertEqual(status, .invalidAttributeSymmetricKeyFormat)
            XCTAssertEqual(status?.description, "A symmetric key format attribute was not valid.")
        }
        do {
            let status = Status(rawValue: errSecMissingAttributeSymmetricKeyFormat)
            XCTAssertEqual(status, .missingAttributeSymmetricKeyFormat)
            XCTAssertEqual(status?.description, "A symmetric key format attribute was missing.")
        }
        do {
            let status = Status(rawValue: errSecInvalidAttributeWrappedKeyFormat)
            XCTAssertEqual(status, .invalidAttributeWrappedKeyFormat)
            XCTAssertEqual(status?.description, "A wrapped key format attribute was not valid.")
        }
        do {
            let status = Status(rawValue: errSecMissingAttributeWrappedKeyFormat)
            XCTAssertEqual(status, .missingAttributeWrappedKeyFormat)
            XCTAssertEqual(status?.description, "A wrapped key format attribute was missing.")
        }
        do {
            let status = Status(rawValue: errSecStagedOperationInProgress)
            XCTAssertEqual(status, .stagedOperationInProgress)
            XCTAssertEqual(status?.description, "A staged operation is in progress.")
        }
        do {
            let status = Status(rawValue: errSecStagedOperationNotStarted)
            XCTAssertEqual(status, .stagedOperationNotStarted)
            XCTAssertEqual(status?.description, "A staged operation was not started.")
        }
        do {
            let status = Status(rawValue: errSecVerifyFailed)
            XCTAssertEqual(status, .verifyFailed)
            XCTAssertEqual(status?.description, "A cryptographic verification failure has occurred.")
        }
        do {
            let status = Status(rawValue: errSecQuerySizeUnknown)
            XCTAssertEqual(status, .querySizeUnknown)
            XCTAssertEqual(status?.description, "The query size is unknown.")
        }
        do {
            let status = Status(rawValue: errSecBlockSizeMismatch)
            XCTAssertEqual(status, .blockSizeMismatch)
            XCTAssertEqual(status?.description, "A block size mismatch occurred.")
        }
        do {
            let status = Status(rawValue: errSecPublicKeyInconsistent)
            XCTAssertEqual(status, .publicKeyInconsistent)
            XCTAssertEqual(status?.description, "The public key was inconsistent.")
        }
        do {
            let status = Status(rawValue: errSecDeviceVerifyFailed)
            XCTAssertEqual(status, .deviceVerifyFailed)
            XCTAssertEqual(status?.description, "A device verification failure has occurred.")
        }
        do {
            let status = Status(rawValue: errSecInvalidLoginName)
            XCTAssertEqual(status, .invalidLoginName)
            XCTAssertEqual(status?.description, "An invalid login name was detected.")
        }
        do {
            let status = Status(rawValue: errSecAlreadyLoggedIn)
            XCTAssertEqual(status, .alreadyLoggedIn)
            XCTAssertEqual(status?.description, "The user is already logged in.")
        }
        do {
            let status = Status(rawValue: errSecInvalidDigestAlgorithm)
            XCTAssertEqual(status, .invalidDigestAlgorithm)
            XCTAssertEqual(status?.description, "An invalid digest algorithm was detected.")
        }
        do {
            let status = Status(rawValue: errSecInvalidCRLGroup)
            XCTAssertEqual(status, .invalidCRLGroup)
            XCTAssertEqual(status?.description, "An invalid CRL group was detected.")
        }
        do {
            let status = Status(rawValue: errSecCertificateCannotOperate)
            XCTAssertEqual(status, .certificateCannotOperate)
            XCTAssertEqual(status?.description, "The certificate cannot operate.")
        }
        do {
            let status = Status(rawValue: errSecCertificateExpired)
            XCTAssertEqual(status, .certificateExpired)
            XCTAssertEqual(status?.description, "An expired certificate was detected.")
        }
        do {
            let status = Status(rawValue: errSecCertificateNotValidYet)
            XCTAssertEqual(status, .certificateNotValidYet)
            XCTAssertEqual(status?.description, "The certificate is not yet valid.")
        }
        do {
            let status = Status(rawValue: errSecCertificateRevoked)
            XCTAssertEqual(status, .certificateRevoked)
            XCTAssertEqual(status?.description, "The certificate was revoked.")
        }
        do {
            let status = Status(rawValue: errSecCertificateSuspended)
            XCTAssertEqual(status, .certificateSuspended)
            XCTAssertEqual(status?.description, "The certificate was suspended.")
        }
        do {
            let status = Status(rawValue: errSecInsufficientCredentials)
            XCTAssertEqual(status, .insufficientCredentials)
            XCTAssertEqual(status?.description, "Insufficient credentials were detected.")
        }
        do {
            let status = Status(rawValue: errSecInvalidAction)
            XCTAssertEqual(status, .invalidAction)
            XCTAssertEqual(status?.description, "The action was not valid.")
        }
        do {
            let status = Status(rawValue: errSecInvalidAuthority)
            XCTAssertEqual(status, .invalidAuthority)
            XCTAssertEqual(status?.description, "The authority was not valid.")
        }
        do {
            let status = Status(rawValue: errSecVerifyActionFailed)
            XCTAssertEqual(status, .verifyActionFailed)
            XCTAssertEqual(status?.description, "A verify action has failed.")
        }
        do {
            let status = Status(rawValue: errSecInvalidCertAuthority)
            XCTAssertEqual(status, .invalidCertAuthority)
            XCTAssertEqual(status?.description, "The certificate authority was not valid.")
        }
        do {
            let status = Status(rawValue: errSecInvaldCRLAuthority)
            XCTAssertEqual(status, .invaldCRLAuthority)
            XCTAssertEqual(status?.description, "The CRL authority was not valid.")
        }
        do {
            let status = Status(rawValue: errSecInvalidCRLEncoding)
            XCTAssertEqual(status, .invalidCRLEncoding)
            XCTAssertEqual(status?.description, "The CRL encoding was not valid.")
        }
        do {
            let status = Status(rawValue: errSecInvalidCRLType)
            XCTAssertEqual(status, .invalidCRLType)
            XCTAssertEqual(status?.description, "The CRL type was not valid.")
        }
        do {
            let status = Status(rawValue: errSecInvalidCRL)
            XCTAssertEqual(status, .invalidCRL)
            XCTAssertEqual(status?.description, "The CRL was not valid.")
        }
        do {
            let status = Status(rawValue: errSecInvalidFormType)
            XCTAssertEqual(status, .invalidFormType)
            XCTAssertEqual(status?.description, "The form type was not valid.")
        }
        do {
            let status = Status(rawValue: errSecInvalidID)
            XCTAssertEqual(status, .invalidID)
            XCTAssertEqual(status?.description, "The ID was not valid.")
        }
        do {
            let status = Status(rawValue: errSecInvalidIdentifier)
            XCTAssertEqual(status, .invalidIdentifier)
            XCTAssertEqual(status?.description, "The identifier was not valid.")
        }
        do {
            let status = Status(rawValue: errSecInvalidIndex)
            XCTAssertEqual(status, .invalidIndex)
            XCTAssertEqual(status?.description, "The index was not valid.")
        }
        do {
            let status = Status(rawValue: errSecInvalidPolicyIdentifiers)
            XCTAssertEqual(status, .invalidPolicyIdentifiers)
            XCTAssertEqual(status?.description, "The policy identifiers are not valid.")
        }
        do {
            let status = Status(rawValue: errSecInvalidTimeString)
            XCTAssertEqual(status, .invalidTimeString)
            XCTAssertEqual(status?.description, "The time specified was not valid.")
        }
        do {
            let status = Status(rawValue: errSecInvalidReason)
            XCTAssertEqual(status, .invalidReason)
            XCTAssertEqual(status?.description, "The trust policy reason was not valid.")
        }
        do {
            let status = Status(rawValue: errSecInvalidRequestInputs)
            XCTAssertEqual(status, .invalidRequestInputs)
            XCTAssertEqual(status?.description, "The request inputs are not valid.")
        }
        do {
            let status = Status(rawValue: errSecInvalidResponseVector)
            XCTAssertEqual(status, .invalidResponseVector)
            XCTAssertEqual(status?.description, "The response vector was not valid.")
        }
        do {
            let status = Status(rawValue: errSecInvalidStopOnPolicy)
            XCTAssertEqual(status, .invalidStopOnPolicy)
            XCTAssertEqual(status?.description, "The stop-on policy was not valid.")
        }
        do {
            let status = Status(rawValue: errSecInvalidTuple)
            XCTAssertEqual(status, .invalidTuple)
            XCTAssertEqual(status?.description, "The tuple was not valid.")
        }
        do {
            let status = Status(rawValue: errSecMultipleValuesUnsupported)
            XCTAssertEqual(status, .multipleValuesUnsupported)
            XCTAssertEqual(status?.description, "Multiple values are not supported.")
        }
        do {
            let status = Status(rawValue: errSecNotTrusted)
            XCTAssertEqual(status, .notTrusted)
            XCTAssertEqual(status?.description, "The trust policy was not trusted.")
        }
        do {
            let status = Status(rawValue: errSecNoDefaultAuthority)
            XCTAssertEqual(status, .noDefaultAuthority)
            XCTAssertEqual(status?.description, "No default authority was detected.")
        }
        do {
            let status = Status(rawValue: errSecRejectedForm)
            XCTAssertEqual(status, .rejectedForm)
            XCTAssertEqual(status?.description, "The trust policy had a rejected form.")
        }
        do {
            let status = Status(rawValue: errSecRequestLost)
            XCTAssertEqual(status, .requestLost)
            XCTAssertEqual(status?.description, "The request was lost.")
        }
        do {
            let status = Status(rawValue: errSecRequestRejected)
            XCTAssertEqual(status, .requestRejected)
            XCTAssertEqual(status?.description, "The request was rejected.")
        }
        do {
            let status = Status(rawValue: errSecUnsupportedAddressType)
            XCTAssertEqual(status, .unsupportedAddressType)
            XCTAssertEqual(status?.description, "The address type is not supported.")
        }
        do {
            let status = Status(rawValue: errSecUnsupportedService)
            XCTAssertEqual(status, .unsupportedService)
            XCTAssertEqual(status?.description, "The service is not supported.")
        }
        do {
            let status = Status(rawValue: errSecInvalidTupleGroup)
            XCTAssertEqual(status, .invalidTupleGroup)
            XCTAssertEqual(status?.description, "The tuple group was not valid.")
        }
        do {
            let status = Status(rawValue: errSecInvalidBaseACLs)
            XCTAssertEqual(status, .invalidBaseACLs)
            XCTAssertEqual(status?.description, "The base ACLs are not valid.")
        }
        do {
            let status = Status(rawValue: errSecInvalidTupleCredendtials)
            XCTAssertEqual(status, .invalidTupleCredendtials)
            XCTAssertEqual(status?.description, "The tuple credentials are not valid.")
        }
        do {
            let status = Status(rawValue: errSecInvalidEncoding)
            XCTAssertEqual(status, .invalidEncoding)
            XCTAssertEqual(status?.description, "The encoding was not valid.")
        }
        do {
            let status = Status(rawValue: errSecInvalidValidityPeriod)
            XCTAssertEqual(status, .invalidValidityPeriod)
            XCTAssertEqual(status?.description, "The validity period was not valid.")
        }
        do {
            let status = Status(rawValue: errSecInvalidRequestor)
            XCTAssertEqual(status, .invalidRequestor)
            XCTAssertEqual(status?.description, "The requestor was not valid.")
        }
        do {
            let status = Status(rawValue: errSecRequestDescriptor)
            XCTAssertEqual(status, .requestDescriptor)
            XCTAssertEqual(status?.description, "The request descriptor was not valid.")
        }
        do {
            let status = Status(rawValue: errSecInvalidBundleInfo)
            XCTAssertEqual(status, .invalidBundleInfo)
            XCTAssertEqual(status?.description, "The bundle information was not valid.")
        }
        do {
            let status = Status(rawValue: errSecInvalidCRLIndex)
            XCTAssertEqual(status, .invalidCRLIndex)
            XCTAssertEqual(status?.description, "The CRL index was not valid.")
        }
        do {
            let status = Status(rawValue: errSecNoFieldValues)
            XCTAssertEqual(status, .noFieldValues)
            XCTAssertEqual(status?.description, "No field values were detected.")
        }
        do {
            let status = Status(rawValue: errSecUnsupportedFieldFormat)
            XCTAssertEqual(status, .unsupportedFieldFormat)
            XCTAssertEqual(status?.description, "The field format is not supported.")
        }
        do {
            let status = Status(rawValue: errSecUnsupportedIndexInfo)
            XCTAssertEqual(status, .unsupportedIndexInfo)
            XCTAssertEqual(status?.description, "The index information is not supported.")
        }
        do {
            let status = Status(rawValue: errSecUnsupportedLocality)
            XCTAssertEqual(status, .unsupportedLocality)
            XCTAssertEqual(status?.description, "The locality is not supported.")
        }
        do {
            let status = Status(rawValue: errSecUnsupportedNumAttributes)
            XCTAssertEqual(status, .unsupportedNumAttributes)
            XCTAssertEqual(status?.description, "The number of attributes is not supported.")
        }
        do {
            let status = Status(rawValue: errSecUnsupportedNumIndexes)
            XCTAssertEqual(status, .unsupportedNumIndexes)
            XCTAssertEqual(status?.description, "The number of indexes is not supported.")
        }
        do {
            let status = Status(rawValue: errSecUnsupportedNumRecordTypes)
            XCTAssertEqual(status, .unsupportedNumRecordTypes)
            XCTAssertEqual(status?.description, "The number of record types is not supported.")
        }
        do {
            let status = Status(rawValue: errSecFieldSpecifiedMultiple)
            XCTAssertEqual(status, .fieldSpecifiedMultiple)
            XCTAssertEqual(status?.description, "Too many fields were specified.")
        }
        do {
            let status = Status(rawValue: errSecIncompatibleFieldFormat)
            XCTAssertEqual(status, .incompatibleFieldFormat)
            XCTAssertEqual(status?.description, "The field format was incompatible.")
        }
        do {
            let status = Status(rawValue: errSecInvalidParsingModule)
            XCTAssertEqual(status, .invalidParsingModule)
            XCTAssertEqual(status?.description, "The parsing module was not valid.")
        }
        do {
            let status = Status(rawValue: errSecDatabaseLocked)
            XCTAssertEqual(status, .databaseLocked)
            XCTAssertEqual(status?.description, "The database is locked.")
        }
        do {
            let status = Status(rawValue: errSecDatastoreIsOpen)
            XCTAssertEqual(status, .datastoreIsOpen)
            XCTAssertEqual(status?.description, "The data store is open.")
        }
        do {
            let status = Status(rawValue: errSecMissingValue)
            XCTAssertEqual(status, .missingValue)
            XCTAssertEqual(status?.description, "A missing value was detected.")
        }
        do {
            let status = Status(rawValue: errSecUnsupportedQueryLimits)
            XCTAssertEqual(status, .unsupportedQueryLimits)
            XCTAssertEqual(status?.description, "The query limits are not supported.")
        }
        do {
            let status = Status(rawValue: errSecUnsupportedNumSelectionPreds)
            XCTAssertEqual(status, .unsupportedNumSelectionPreds)
            XCTAssertEqual(status?.description, "The number of selection predicates is not supported.")
        }
        do {
            let status = Status(rawValue: errSecUnsupportedOperator)
            XCTAssertEqual(status, .unsupportedOperator)
            XCTAssertEqual(status?.description, "The operator is not supported.")
        }
        do {
            let status = Status(rawValue: errSecInvalidDBLocation)
            XCTAssertEqual(status, .invalidDBLocation)
            XCTAssertEqual(status?.description, "The database location is not valid.")
        }
        do {
            let status = Status(rawValue: errSecInvalidAccessRequest)
            XCTAssertEqual(status, .invalidAccessRequest)
            XCTAssertEqual(status?.description, "The access request is not valid.")
        }
        do {
            let status = Status(rawValue: errSecInvalidIndexInfo)
            XCTAssertEqual(status, .invalidIndexInfo)
            XCTAssertEqual(status?.description, "The index information is not valid.")
        }
        do {
            let status = Status(rawValue: errSecInvalidNewOwner)
            XCTAssertEqual(status, .invalidNewOwner)
            XCTAssertEqual(status?.description, "The new owner is not valid.")
        }
        do {
            let status = Status(rawValue: errSecInvalidModifyMode)
            XCTAssertEqual(status, .invalidModifyMode)
            XCTAssertEqual(status?.description, "The modify mode is not valid.")
        }
        do {
            let status = Status(rawValue: errSecMissingRequiredExtension)
            XCTAssertEqual(status, .missingRequiredExtension)
            XCTAssertEqual(status?.description, "A required certificate extension is missing.")
        }
        do {
            let status = Status(rawValue: errSecExtendedKeyUsageNotCritical)
            XCTAssertEqual(status, .extendedKeyUsageNotCritical)
            XCTAssertEqual(status?.description, "The extended key usage extension was not marked critical.")
        }
        do {
            let status = Status(rawValue: errSecTimestampMissing)
            XCTAssertEqual(status, .timestampMissing)
            XCTAssertEqual(status?.description, "A timestamp was expected but was not found.")
        }
        do {
            let status = Status(rawValue: errSecTimestampInvalid)
            XCTAssertEqual(status, .timestampInvalid)
            XCTAssertEqual(status?.description, "The timestamp was not valid.")
        }
        do {
            let status = Status(rawValue: errSecTimestampNotTrusted)
            XCTAssertEqual(status, .timestampNotTrusted)
            XCTAssertEqual(status?.description, "The timestamp was not trusted.")
        }
        do {
            let status = Status(rawValue: errSecTimestampServiceNotAvailable)
            XCTAssertEqual(status, .timestampServiceNotAvailable)
            XCTAssertEqual(status?.description, "The timestamp service is not available.")
        }
        do {
            let status = Status(rawValue: errSecTimestampBadAlg)
            XCTAssertEqual(status, .timestampBadAlg)
            XCTAssertEqual(status?.description, "An unrecognized or unsupported Algorithm Identifier in timestamp.")
        }
        do {
            let status = Status(rawValue: errSecTimestampBadRequest)
            XCTAssertEqual(status, .timestampBadRequest)
            XCTAssertEqual(status?.description, "The timestamp transaction is not permitted or supported.")
        }
        do {
            let status = Status(rawValue: errSecTimestampBadDataFormat)
            XCTAssertEqual(status, .timestampBadDataFormat)
            XCTAssertEqual(status?.description, "The timestamp data submitted has the wrong format.")
        }
        do {
            let status = Status(rawValue: errSecTimestampTimeNotAvailable)
            XCTAssertEqual(status, .timestampTimeNotAvailable)
            XCTAssertEqual(status?.description, "The time source for the Timestamp Authority is not available.")
        }
        do {
            let status = Status(rawValue: errSecTimestampUnacceptedPolicy)
            XCTAssertEqual(status, .timestampUnacceptedPolicy)
            XCTAssertEqual(status?.description, "The requested policy is not supported by the Timestamp Authority.")
        }
        do {
            let status = Status(rawValue: errSecTimestampUnacceptedExtension)
            XCTAssertEqual(status, .timestampUnacceptedExtension)
            XCTAssertEqual(status?.description, "The requested extension is not supported by the Timestamp Authority.")
        }
        do {
            let status = Status(rawValue: errSecTimestampAddInfoNotAvailable)
            XCTAssertEqual(status, .timestampAddInfoNotAvailable)
            XCTAssertEqual(status?.description, "The additional information requested is not available.")
        }
        do {
            let status = Status(rawValue: errSecTimestampSystemFailure)
            XCTAssertEqual(status, .timestampSystemFailure)
            XCTAssertEqual(status?.description, "The timestamp request cannot be handled due to system failure.")
        }
        do {
            let status = Status(rawValue: errSecSigningTimeMissing)
            XCTAssertEqual(status, .signingTimeMissing)
            XCTAssertEqual(status?.description, "A signing time was expected but was not found.")
        }
        do {
            let status = Status(rawValue: errSecTimestampRejection)
            XCTAssertEqual(status, .timestampRejection)
            XCTAssertEqual(status?.description, "A timestamp transaction was rejected.")
        }
        do {
            let status = Status(rawValue: errSecTimestampWaiting)
            XCTAssertEqual(status, .timestampWaiting)
            XCTAssertEqual(status?.description, "A timestamp transaction is waiting.")
        }
        do {
            let status = Status(rawValue: errSecTimestampRevocationWarning)
            XCTAssertEqual(status, .timestampRevocationWarning)
            XCTAssertEqual(status?.description, "A timestamp authority revocation warning was issued.")
        }
        do {
            let status = Status(rawValue: errSecTimestampRevocationNotification)
            XCTAssertEqual(status, .timestampRevocationNotification)
            XCTAssertEqual(status?.description, "A timestamp authority revocation notification was issued.")
        }
        #endif
    }
}
