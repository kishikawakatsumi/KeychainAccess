import XCTest
import Nimble

class BeGreaterThanOrEqualToTest: XCTestCase {

    func testGreaterThanOrEqualTo() {
        expect(10).to(beGreaterThanOrEqualTo(10))
        expect(10).to(beGreaterThanOrEqualTo(2))
        expect(1).toNot(beGreaterThanOrEqualTo(2))
        expect(NSNumber(int:1)).toNot(beGreaterThanOrEqualTo(2))
        expect(NSNumber(int:2)).to(beGreaterThanOrEqualTo(NSNumber(int:2)))
        expect(1).to(beGreaterThanOrEqualTo(NSNumber(int:0)))

        failsWithErrorMessage("expected to be greater than or equal to <2>, got <0>") {
            expect(0).to(beGreaterThanOrEqualTo(2))
            return
        }
        failsWithErrorMessage("expected to not be greater than or equal to <1>, got <1>") {
            expect(1).toNot(beGreaterThanOrEqualTo(1))
            return
        }
        failsWithErrorMessageForNil("expected to be greater than or equal to <-2>, got <nil>") {
            expect(nil as Int?).to(beGreaterThanOrEqualTo(-2))
        }
        failsWithErrorMessageForNil("expected to not be greater than or equal to <1>, got <nil>") {
            expect(nil as Int?).toNot(beGreaterThanOrEqualTo(1))
        }
    }

    func testGreaterThanOrEqualToOperator() {
        expect(0) >= 0
        expect(1) >= 0
        expect(NSNumber(int:1)) >= 1
        expect(NSNumber(int:1)) >= NSNumber(int:1)

        failsWithErrorMessage("expected to be greater than or equal to <2>, got <1>") {
            expect(1) >= 2
            return
        }
    }
}
