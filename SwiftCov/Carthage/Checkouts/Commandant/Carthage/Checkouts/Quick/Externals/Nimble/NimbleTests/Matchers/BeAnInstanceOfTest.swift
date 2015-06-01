import XCTest
import Nimble

class BeAnInstanceOfTest: XCTestCase {
    func testPositiveMatch() {
        expect(NSNull()).to(beAnInstanceOf(NSNull))
        expect(NSNumber(integer:1)).toNot(beAnInstanceOf(NSDate))
    }

    func testFailureMessages() {
        failsWithErrorMessageForNil("expected to not be an instance of NSNull, got <nil>") {
            expect(nil as NSNull?).toNot(beAnInstanceOf(NSNull))
        }
        failsWithErrorMessageForNil("expected to be an instance of NSString, got <nil>") {
            expect(nil as NSString?).to(beAnInstanceOf(NSString))
        }
        failsWithErrorMessage("expected to be an instance of NSString, got <__NSCFNumber instance>") {
            expect(NSNumber(integer:1)).to(beAnInstanceOf(NSString))
        }
        failsWithErrorMessage("expected to not be an instance of NSNumber, got <__NSCFNumber instance>") {
            expect(NSNumber(integer:1)).toNot(beAnInstanceOf(NSNumber))
        }
    }
}
