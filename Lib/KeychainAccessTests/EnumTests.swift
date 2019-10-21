//
//  EnumTests.swift
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

class EnumTests: XCTestCase {
    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testItemClass() {
        do {
            let itemClass = ItemClass(rawValue: kSecClassGenericPassword as String)
            XCTAssertEqual(itemClass, .genericPassword)
            XCTAssertEqual(itemClass?.description, "GenericPassword")
        }
        do {
            let itemClass = ItemClass(rawValue: kSecClassInternetPassword as String)
            XCTAssertEqual(itemClass, .internetPassword)
            XCTAssertEqual(itemClass?.description, "InternetPassword")
        }
        do {
            let itemClass = ItemClass(rawValue: kSecClassCertificate as String)
            XCTAssertNil(itemClass)
        }
        do {
            let itemClass = ItemClass(rawValue: kSecClassKey as String)
            XCTAssertNil(itemClass)
        }
        do {
            let itemClass = ItemClass(rawValue: kSecClassIdentity as String)
            XCTAssertNil(itemClass)
        }
    }

    func testProtocolType() {
        do {
            let protocolType = ProtocolType(rawValue: kSecAttrProtocolFTP as String)
            XCTAssertEqual(protocolType, .ftp)
            XCTAssertEqual(protocolType?.description, "FTP")
        }
        do {
            let protocolType = ProtocolType(rawValue: kSecAttrProtocolFTPAccount as String)
            XCTAssertEqual(protocolType, .ftpAccount)
            XCTAssertEqual(protocolType?.description, "FTPAccount")
        }
        do {
            let protocolType = ProtocolType(rawValue: kSecAttrProtocolHTTP as String)
            XCTAssertEqual(protocolType, .http)
            XCTAssertEqual(protocolType?.description, "HTTP")
        }
        do {
            let protocolType = ProtocolType(rawValue: kSecAttrProtocolIRC as String)
            XCTAssertEqual(protocolType, .irc)
            XCTAssertEqual(protocolType?.description, "IRC")
        }
        do {
            let protocolType = ProtocolType(rawValue: kSecAttrProtocolNNTP as String)
            XCTAssertEqual(protocolType, .nntp)
            XCTAssertEqual(protocolType?.description, "NNTP")
        }
        do {
            let protocolType = ProtocolType(rawValue: kSecAttrProtocolPOP3 as String)
            XCTAssertEqual(protocolType, .pop3)
            XCTAssertEqual(protocolType?.description, "POP3")
        }
        do {
            let protocolType = ProtocolType(rawValue: kSecAttrProtocolSMTP as String)
            XCTAssertEqual(protocolType, .smtp)
            XCTAssertEqual(protocolType?.description, "SMTP")
        }
        do {
            let protocolType = ProtocolType(rawValue: kSecAttrProtocolSOCKS as String)
            XCTAssertEqual(protocolType, .socks)
            XCTAssertEqual(protocolType?.description, "SOCKS")
        }
        do {
            let protocolType = ProtocolType(rawValue: kSecAttrProtocolIMAP as String)
            XCTAssertEqual(protocolType, .imap)
            XCTAssertEqual(protocolType?.description, "IMAP")
        }
        do {
            let protocolType = ProtocolType(rawValue: kSecAttrProtocolLDAP as String)
            XCTAssertEqual(protocolType, .ldap)
            XCTAssertEqual(protocolType?.description, "LDAP")
        }
        do {
            let protocolType = ProtocolType(rawValue: kSecAttrProtocolAppleTalk as String)
            XCTAssertEqual(protocolType, .appleTalk)
            XCTAssertEqual(protocolType?.description, "AppleTalk")
        }
        do {
            let protocolType = ProtocolType(rawValue: kSecAttrProtocolAFP as String)
            XCTAssertEqual(protocolType, .afp)
            XCTAssertEqual(protocolType?.description, "AFP")
        }
        do {
            let protocolType = ProtocolType(rawValue: kSecAttrProtocolTelnet as String)
            XCTAssertEqual(protocolType, .telnet)
            XCTAssertEqual(protocolType?.description, "Telnet")
        }
        do {
            let protocolType = ProtocolType(rawValue: kSecAttrProtocolSSH as String)
            XCTAssertEqual(protocolType, .ssh)
            XCTAssertEqual(protocolType?.description, "SSH")
        }
        do {
            let protocolType = ProtocolType(rawValue: kSecAttrProtocolFTPS as String)
            XCTAssertEqual(protocolType, .ftps)
            XCTAssertEqual(protocolType?.description, "FTPS")
        }
        do {
            let protocolType = ProtocolType(rawValue: kSecAttrProtocolHTTPS as String)
            XCTAssertEqual(protocolType, .https)
            XCTAssertEqual(protocolType?.description, "HTTPS")
        }
        do {
            let protocolType = ProtocolType(rawValue: kSecAttrProtocolHTTPProxy as String)
            XCTAssertEqual(protocolType, .httpProxy)
            XCTAssertEqual(protocolType?.description, "HTTPProxy")
        }
        do {
            let protocolType = ProtocolType(rawValue: kSecAttrProtocolHTTPSProxy as String)
            XCTAssertEqual(protocolType, .httpsProxy)
            XCTAssertEqual(protocolType?.description, "HTTPSProxy")
        }
        do {
            let protocolType = ProtocolType(rawValue: kSecAttrProtocolFTPProxy as String)
            XCTAssertEqual(protocolType, .ftpProxy)
            XCTAssertEqual(protocolType?.description, "FTPProxy")
        }
        do {
            let protocolType = ProtocolType(rawValue: kSecAttrProtocolSMB as String)
            XCTAssertEqual(protocolType, .smb)
            XCTAssertEqual(protocolType?.description, "SMB")
        }
        do {
            let protocolType = ProtocolType(rawValue: kSecAttrProtocolRTSP as String)
            XCTAssertEqual(protocolType, .rtsp)
            XCTAssertEqual(protocolType?.description, "RTSP")
        }
        do {
            let protocolType = ProtocolType(rawValue: kSecAttrProtocolRTSPProxy as String)
            XCTAssertEqual(protocolType, .rtspProxy)
            XCTAssertEqual(protocolType?.description, "RTSPProxy")
        }
        do {
            let protocolType = ProtocolType(rawValue: kSecAttrProtocolDAAP as String)
            XCTAssertEqual(protocolType, .daap)
            XCTAssertEqual(protocolType?.description, "DAAP")
        }
        do {
            let protocolType = ProtocolType(rawValue: kSecAttrProtocolEPPC as String)
            XCTAssertEqual(protocolType, .eppc)
            XCTAssertEqual(protocolType?.description, "EPPC")
        }
        do {
            let protocolType = ProtocolType(rawValue: kSecAttrProtocolIPP as String)
            XCTAssertEqual(protocolType, .ipp)
            XCTAssertEqual(protocolType?.description, "IPP")
        }
        do {
            let protocolType = ProtocolType(rawValue: kSecAttrProtocolNNTPS as String)
            XCTAssertEqual(protocolType, .nntps)
            XCTAssertEqual(protocolType?.description, "NNTPS")
        }
        do {
            let protocolType = ProtocolType(rawValue: kSecAttrProtocolLDAPS as String)
            XCTAssertEqual(protocolType, .ldaps)
            XCTAssertEqual(protocolType?.description, "LDAPS")
        }
        do {
            let protocolType = ProtocolType(rawValue: kSecAttrProtocolTelnetS as String)
            XCTAssertEqual(protocolType, .telnetS)
            XCTAssertEqual(protocolType?.description, "TelnetS")
        }
        do {
            let protocolType = ProtocolType(rawValue: kSecAttrProtocolIMAPS as String)
            XCTAssertEqual(protocolType, .imaps)
            XCTAssertEqual(protocolType?.description, "IMAPS")
        }
        do {
            let protocolType = ProtocolType(rawValue: kSecAttrProtocolIRCS as String)
            XCTAssertEqual(protocolType, .ircs)
            XCTAssertEqual(protocolType?.description, "IRCS")
        }
        do {
            let protocolType = ProtocolType(rawValue: kSecAttrProtocolPOP3S as String)
            XCTAssertEqual(protocolType, .pop3S)
            XCTAssertEqual(protocolType?.description, "POP3S")
        }
    }

    func testAuthenticationType() {
        do {
            let authenticationType = AuthenticationType(rawValue: kSecAttrAuthenticationTypeNTLM as String)
            XCTAssertEqual(authenticationType, .ntlm)
            XCTAssertEqual(authenticationType?.description, "NTLM")
        }
        do {
            let authenticationType = AuthenticationType(rawValue: kSecAttrAuthenticationTypeMSN as String)
            XCTAssertEqual(authenticationType, .msn)
            XCTAssertEqual(authenticationType?.description, "MSN")
        }
        do {
            let authenticationType = AuthenticationType(rawValue: kSecAttrAuthenticationTypeDPA as String)
            XCTAssertEqual(authenticationType, .dpa)
            XCTAssertEqual(authenticationType?.description, "DPA")
        }
        do {
            let authenticationType = AuthenticationType(rawValue: kSecAttrAuthenticationTypeRPA as String)
            XCTAssertEqual(authenticationType, .rpa)
            XCTAssertEqual(authenticationType?.description, "RPA")
        }
        do {
            let authenticationType = AuthenticationType(rawValue: kSecAttrAuthenticationTypeHTTPBasic as String)
            XCTAssertEqual(authenticationType, .httpBasic)
            XCTAssertEqual(authenticationType?.description, "HTTPBasic")
        }
        do {
            let authenticationType = AuthenticationType(rawValue: kSecAttrAuthenticationTypeHTTPDigest as String)
            XCTAssertEqual(authenticationType, .httpDigest)
            XCTAssertEqual(authenticationType?.description, "HTTPDigest")
        }
        do {
            let authenticationType = AuthenticationType(rawValue: kSecAttrAuthenticationTypeHTMLForm as String)
            XCTAssertEqual(authenticationType, .htmlForm)
            XCTAssertEqual(authenticationType?.description, "HTMLForm")
        }
        do {
            let authenticationType = AuthenticationType(rawValue: kSecAttrAuthenticationTypeDefault as String)
            XCTAssertEqual(authenticationType, .default)
            XCTAssertEqual(authenticationType?.description, "Default")
        }
    }

    func testAccessibility() {
        guard #available(OSX 10.10, *) else {
            return
        }
        do {
            let accessibility = Accessibility(rawValue: kSecAttrAccessibleWhenUnlocked as String)
            XCTAssertEqual(accessibility, .whenUnlocked)
            XCTAssertEqual(accessibility?.description, "WhenUnlocked")
        }
        do {
            let accessibility = Accessibility(rawValue: kSecAttrAccessibleAfterFirstUnlock as String)
            XCTAssertEqual(accessibility, .afterFirstUnlock)
            XCTAssertEqual(accessibility?.description, "AfterFirstUnlock")
        }
        #if !targetEnvironment(macCatalyst)
        do {
            let accessibility = Accessibility(rawValue: kSecAttrAccessibleAlways as String)
            XCTAssertEqual(accessibility, .always)
            XCTAssertEqual(accessibility?.description, "Always")
        }
        #endif
        do {
            let accessibility = Accessibility(rawValue: kSecAttrAccessibleWhenPasscodeSetThisDeviceOnly as String)
            XCTAssertEqual(accessibility, .whenPasscodeSetThisDeviceOnly)
            XCTAssertEqual(accessibility?.description, "WhenPasscodeSetThisDeviceOnly")
        }
        do {
            let accessibility = Accessibility(rawValue: kSecAttrAccessibleWhenUnlockedThisDeviceOnly as String)
            XCTAssertEqual(accessibility, .whenUnlockedThisDeviceOnly)
            XCTAssertEqual(accessibility?.description, "WhenUnlockedThisDeviceOnly")
        }
        do {
            let accessibility = Accessibility(rawValue: kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly as String)
            XCTAssertEqual(accessibility, .afterFirstUnlockThisDeviceOnly)
            XCTAssertEqual(accessibility?.description, "AfterFirstUnlockThisDeviceOnly")
        }
        #if !targetEnvironment(macCatalyst)
        do {
            let accessibility = Accessibility(rawValue: kSecAttrAccessibleAlwaysThisDeviceOnly as String)
            XCTAssertEqual(accessibility, .alwaysThisDeviceOnly)
            XCTAssertEqual(accessibility?.description, "AlwaysThisDeviceOnly")
        }
        #endif
    }
}
