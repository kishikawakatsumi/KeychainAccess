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
            XCTAssertEqual(itemClass, .GenericPassword)
            XCTAssertEqual(itemClass?.description, "GenericPassword")
        }
        do {
            let itemClass = ItemClass(rawValue: kSecClassInternetPassword as String)
            XCTAssertEqual(itemClass, .InternetPassword)
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
            XCTAssertEqual(protocolType, .FTP)
            XCTAssertEqual(protocolType?.description, "FTP")
        }
        do {
            let protocolType = ProtocolType(rawValue: kSecAttrProtocolFTPAccount as String)
            XCTAssertEqual(protocolType, .FTPAccount)
            XCTAssertEqual(protocolType?.description, "FTPAccount")
        }
        do {
            let protocolType = ProtocolType(rawValue: kSecAttrProtocolHTTP as String)
            XCTAssertEqual(protocolType, .HTTP)
            XCTAssertEqual(protocolType?.description, "HTTP")
        }
        do {
            let protocolType = ProtocolType(rawValue: kSecAttrProtocolIRC as String)
            XCTAssertEqual(protocolType, .IRC)
            XCTAssertEqual(protocolType?.description, "IRC")
        }
        do {
            let protocolType = ProtocolType(rawValue: kSecAttrProtocolNNTP as String)
            XCTAssertEqual(protocolType, .NNTP)
            XCTAssertEqual(protocolType?.description, "NNTP")
        }
        do {
            let protocolType = ProtocolType(rawValue: kSecAttrProtocolPOP3 as String)
            XCTAssertEqual(protocolType, .POP3)
            XCTAssertEqual(protocolType?.description, "POP3")
        }
        do {
            let protocolType = ProtocolType(rawValue: kSecAttrProtocolSMTP as String)
            XCTAssertEqual(protocolType, .SMTP)
            XCTAssertEqual(protocolType?.description, "SMTP")
        }
        do {
            let protocolType = ProtocolType(rawValue: kSecAttrProtocolSOCKS as String)
            XCTAssertEqual(protocolType, .SOCKS)
            XCTAssertEqual(protocolType?.description, "SOCKS")
        }
        do {
            let protocolType = ProtocolType(rawValue: kSecAttrProtocolIMAP as String)
            XCTAssertEqual(protocolType, .IMAP)
            XCTAssertEqual(protocolType?.description, "IMAP")
        }
        do {
            let protocolType = ProtocolType(rawValue: kSecAttrProtocolLDAP as String)
            XCTAssertEqual(protocolType, .LDAP)
            XCTAssertEqual(protocolType?.description, "LDAP")
        }
        do {
            let protocolType = ProtocolType(rawValue: kSecAttrProtocolAppleTalk as String)
            XCTAssertEqual(protocolType, .AppleTalk)
            XCTAssertEqual(protocolType?.description, "AppleTalk")
        }
        do {
            let protocolType = ProtocolType(rawValue: kSecAttrProtocolAFP as String)
            XCTAssertEqual(protocolType, .AFP)
            XCTAssertEqual(protocolType?.description, "AFP")
        }
        do {
            let protocolType = ProtocolType(rawValue: kSecAttrProtocolTelnet as String)
            XCTAssertEqual(protocolType, .Telnet)
            XCTAssertEqual(protocolType?.description, "Telnet")
        }
        do {
            let protocolType = ProtocolType(rawValue: kSecAttrProtocolSSH as String)
            XCTAssertEqual(protocolType, .SSH)
            XCTAssertEqual(protocolType?.description, "SSH")
        }
        do {
            let protocolType = ProtocolType(rawValue: kSecAttrProtocolFTPS as String)
            XCTAssertEqual(protocolType, .FTPS)
            XCTAssertEqual(protocolType?.description, "FTPS")
        }
        do {
            let protocolType = ProtocolType(rawValue: kSecAttrProtocolHTTPS as String)
            XCTAssertEqual(protocolType, .HTTPS)
            XCTAssertEqual(protocolType?.description, "HTTPS")
        }
        do {
            let protocolType = ProtocolType(rawValue: kSecAttrProtocolHTTPProxy as String)
            XCTAssertEqual(protocolType, .HTTPProxy)
            XCTAssertEqual(protocolType?.description, "HTTPProxy")
        }
        do {
            let protocolType = ProtocolType(rawValue: kSecAttrProtocolHTTPSProxy as String)
            XCTAssertEqual(protocolType, .HTTPSProxy)
            XCTAssertEqual(protocolType?.description, "HTTPSProxy")
        }
        do {
            let protocolType = ProtocolType(rawValue: kSecAttrProtocolFTPProxy as String)
            XCTAssertEqual(protocolType, .FTPProxy)
            XCTAssertEqual(protocolType?.description, "FTPProxy")
        }
        do {
            let protocolType = ProtocolType(rawValue: kSecAttrProtocolSMB as String)
            XCTAssertEqual(protocolType, .SMB)
            XCTAssertEqual(protocolType?.description, "SMB")
        }
        do {
            let protocolType = ProtocolType(rawValue: kSecAttrProtocolRTSP as String)
            XCTAssertEqual(protocolType, .RTSP)
            XCTAssertEqual(protocolType?.description, "RTSP")
        }
        do {
            let protocolType = ProtocolType(rawValue: kSecAttrProtocolRTSPProxy as String)
            XCTAssertEqual(protocolType, .RTSPProxy)
            XCTAssertEqual(protocolType?.description, "RTSPProxy")
        }
        do {
            let protocolType = ProtocolType(rawValue: kSecAttrProtocolDAAP as String)
            XCTAssertEqual(protocolType, .DAAP)
            XCTAssertEqual(protocolType?.description, "DAAP")
        }
        do {
            let protocolType = ProtocolType(rawValue: kSecAttrProtocolEPPC as String)
            XCTAssertEqual(protocolType, .EPPC)
            XCTAssertEqual(protocolType?.description, "EPPC")
        }
        do {
            let protocolType = ProtocolType(rawValue: kSecAttrProtocolIPP as String)
            XCTAssertEqual(protocolType, .IPP)
            XCTAssertEqual(protocolType?.description, "IPP")
        }
        do {
            let protocolType = ProtocolType(rawValue: kSecAttrProtocolNNTPS as String)
            XCTAssertEqual(protocolType, .NNTPS)
            XCTAssertEqual(protocolType?.description, "NNTPS")
        }
        do {
            let protocolType = ProtocolType(rawValue: kSecAttrProtocolLDAPS as String)
            XCTAssertEqual(protocolType, .LDAPS)
            XCTAssertEqual(protocolType?.description, "LDAPS")
        }
        do {
            let protocolType = ProtocolType(rawValue: kSecAttrProtocolTelnetS as String)
            XCTAssertEqual(protocolType, .TelnetS)
            XCTAssertEqual(protocolType?.description, "TelnetS")
        }
        do {
            let protocolType = ProtocolType(rawValue: kSecAttrProtocolIMAPS as String)
            XCTAssertEqual(protocolType, .IMAPS)
            XCTAssertEqual(protocolType?.description, "IMAPS")
        }
        do {
            let protocolType = ProtocolType(rawValue: kSecAttrProtocolIRCS as String)
            XCTAssertEqual(protocolType, .IRCS)
            XCTAssertEqual(protocolType?.description, "IRCS")
        }
        do {
            let protocolType = ProtocolType(rawValue: kSecAttrProtocolPOP3S as String)
            XCTAssertEqual(protocolType, .POP3S)
            XCTAssertEqual(protocolType?.description, "POP3S")
        }
    }

    func testAuthenticationType() {
        do {
            let authenticationType = AuthenticationType(rawValue: kSecAttrAuthenticationTypeNTLM as String)
            XCTAssertEqual(authenticationType, .NTLM)
            XCTAssertEqual(authenticationType?.description, "NTLM")
        }
        do {
            let authenticationType = AuthenticationType(rawValue: kSecAttrAuthenticationTypeMSN as String)
            XCTAssertEqual(authenticationType, .MSN)
            XCTAssertEqual(authenticationType?.description, "MSN")
        }
        do {
            let authenticationType = AuthenticationType(rawValue: kSecAttrAuthenticationTypeDPA as String)
            XCTAssertEqual(authenticationType, .DPA)
            XCTAssertEqual(authenticationType?.description, "DPA")
        }
        do {
            let authenticationType = AuthenticationType(rawValue: kSecAttrAuthenticationTypeRPA as String)
            XCTAssertEqual(authenticationType, .RPA)
            XCTAssertEqual(authenticationType?.description, "RPA")
        }
        do {
            let authenticationType = AuthenticationType(rawValue: kSecAttrAuthenticationTypeHTTPBasic as String)
            XCTAssertEqual(authenticationType, .HTTPBasic)
            XCTAssertEqual(authenticationType?.description, "HTTPBasic")
        }
        do {
            let authenticationType = AuthenticationType(rawValue: kSecAttrAuthenticationTypeHTTPDigest as String)
            XCTAssertEqual(authenticationType, .HTTPDigest)
            XCTAssertEqual(authenticationType?.description, "HTTPDigest")
        }
        do {
            let authenticationType = AuthenticationType(rawValue: kSecAttrAuthenticationTypeHTMLForm as String)
            XCTAssertEqual(authenticationType, .HTMLForm)
            XCTAssertEqual(authenticationType?.description, "HTMLForm")
        }
        do {
            let authenticationType = AuthenticationType(rawValue: kSecAttrAuthenticationTypeDefault as String)
            XCTAssertEqual(authenticationType, .Default)
            XCTAssertEqual(authenticationType?.description, "Default")
        }
    }

    func testAccessibility() {
        guard #available(OSX 10.10, *) else {
            return
        }
        do {
            let accessibility = Accessibility(rawValue: kSecAttrAccessibleWhenUnlocked as String)
            XCTAssertEqual(accessibility, .WhenUnlocked)
            XCTAssertEqual(accessibility?.description, "WhenUnlocked")
        }
        do {
            let accessibility = Accessibility(rawValue: kSecAttrAccessibleAfterFirstUnlock as String)
            XCTAssertEqual(accessibility, .AfterFirstUnlock)
            XCTAssertEqual(accessibility?.description, "AfterFirstUnlock")
        }
        do {
            let accessibility = Accessibility(rawValue: kSecAttrAccessibleAlways as String)
            XCTAssertEqual(accessibility, .Always)
            XCTAssertEqual(accessibility?.description, "Always")
        }
        do {
            let accessibility = Accessibility(rawValue: kSecAttrAccessibleWhenPasscodeSetThisDeviceOnly as String)
            XCTAssertEqual(accessibility, .WhenPasscodeSetThisDeviceOnly)
            XCTAssertEqual(accessibility?.description, "WhenPasscodeSetThisDeviceOnly")
        }
        do {
            let accessibility = Accessibility(rawValue: kSecAttrAccessibleWhenUnlockedThisDeviceOnly as String)
            XCTAssertEqual(accessibility, .WhenUnlockedThisDeviceOnly)
            XCTAssertEqual(accessibility?.description, "WhenUnlockedThisDeviceOnly")
        }
        do {
            let accessibility = Accessibility(rawValue: kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly as String)
            XCTAssertEqual(accessibility, .AfterFirstUnlockThisDeviceOnly)
            XCTAssertEqual(accessibility?.description, "AfterFirstUnlockThisDeviceOnly")
        }
        do {
            let accessibility = Accessibility(rawValue: kSecAttrAccessibleAlwaysThisDeviceOnly as String)
            XCTAssertEqual(accessibility, .AlwaysThisDeviceOnly)
            XCTAssertEqual(accessibility?.description, "AlwaysThisDeviceOnly")
        }
    }
}
