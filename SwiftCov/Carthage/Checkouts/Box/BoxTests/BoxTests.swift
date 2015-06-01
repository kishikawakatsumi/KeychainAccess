//  Copyright (c) 2014 Rob Rix. All rights reserved.

import Box
import XCTest

class BoxTests: XCTestCase {
	func testBox() {
		let box = Box(1)
		XCTAssertEqual(box.value, 1)
	}
}
