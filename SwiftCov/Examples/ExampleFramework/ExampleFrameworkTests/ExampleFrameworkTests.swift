//
//  ExampleFrameworkTests.swift
//  ExampleFrameworkTests
//
//  Created by Kishikawa Katsumi on 2015/05/27.
//  Copyright (c) 2015 Realm. All rights reserved.
//

import XCTest
import ExampleFramework

class ExampleFrameworkTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testAdd() {
        let calculator = Calculator()
        let result = calculator.add(2, b: 5)
        XCTAssertEqual(result, 7)
    }

    func testSub() {
        let calculator = Calculator(a: 2, b: 6)
        let result = calculator.sub(4, b: 3)
        XCTAssertEqual(result, 1)
    }

    func testMul() {
        let calculator = Calculator(a: 1, b: 2)
        let result = calculator.mul(3, b: 4)
        XCTAssertEqual(result, 12)
    }

}
