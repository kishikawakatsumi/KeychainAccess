//  Copyright (c) 2014 Rob Rix. All rights reserved.

import Box
import XCTest

class BoxTypeTests: XCTestCase {
	func testEquality() {
		let (a, b, c) = (Box(1), Box(1), Box(2))
		XCTAssertTrue(a == b)
		XCTAssertFalse(b == c)
	}

	func testInequality() {
		let (a, b, c) = (Box(1), Box(1), Box(2))
		XCTAssertFalse(a != b)
		XCTAssertTrue(b != c)
	}

	func testMap() {
		let a = Box(1)
		let b: Box<String> = map(a, toString)
		XCTAssertEqual(b.value, "1")
	}
}
