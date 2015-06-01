import XCTest
import Nimble

class RaisesExceptionTest: XCTestCase {
    var exception = NSException(name: "laugh", reason: "Lulz", userInfo: ["key": "value"])

    func testPositiveMatches() {
        expect { self.exception.raise() }.to(raiseException())
        expect { self.exception.raise() }.to(raiseException(named: "laugh"))
        expect { self.exception.raise() }.to(raiseException(named: "laugh", reason: "Lulz"))
        expect { self.exception.raise() }.to(raiseException(named: "laugh", reason: "Lulz", userInfo: ["key": "value"]))
    }

    func testPositiveMatchesWithSubMatchers() {
        expect { self.exception.raise() }.to(raiseException(named: equal("laugh")))
        expect { self.exception.raise() }.to(raiseException(reason: beginWith("Lu")))
        expect { self.exception.raise() }.to(raiseException(userInfo:equal(["key": "value"])))
        expect { self.exception.raise() }.to(raiseException(named: equal("laugh"), reason: beginWith("Lu")))
        expect { self.exception.raise() }.to(
            raiseException(named: equal("laugh"), reason: beginWith("Lu"), userInfo:equal(["key": "value"])))
        expect { self.exception.raise() }.toNot(raiseException(named: equal("smile")))
        expect { self.exception.raise() }.toNot(raiseException(reason: beginWith("Lut")))
        expect { self.exception.raise() }.toNot(raiseException(userInfo:equal(["key": "no value"])))
        expect { self.exception.raise() }.toNot(raiseException(named: equal("laugh"), reason: beginWith("Lut")))
        expect { self.exception }.toNot(raiseException(named: equal("laugh"), reason: beginWith("Lu")))
    }

    func testNegativeMatches() {
        failsWithErrorMessage("expected to raise exception with name equal <foo>") {
            expect { self.exception.raise() }.to(raiseException(named: "foo"))
        }

        failsWithErrorMessage("expected to raise exception with name equal <laugh> with reason equal <bar>") {
            expect { self.exception.raise() }.to(raiseException(named: "laugh", reason: "bar"))
        }

        failsWithErrorMessage(
            "expected to raise exception with name equal <laugh> with reason equal <Lulz> with userInfo equal <{k = v;}>") {
            expect { self.exception.raise() }.to(raiseException(named: "laugh", reason: "Lulz", userInfo: ["k": "v"]))
        }

        failsWithErrorMessage("expected to raise any exception") {
            expect { self.exception }.to(raiseException())
        }
        failsWithErrorMessage("expected to not raise any exception") {
            expect { self.exception.raise() }.toNot(raiseException())
        }
        failsWithErrorMessage("expected to raise exception with name equal <laugh> with reason equal <Lulz>") {
            expect { self.exception }.to(raiseException(named: "laugh", reason: "Lulz"))
        }

        failsWithErrorMessage("expected to raise exception with name equal <bar> with reason equal <Lulz>") {
            expect { self.exception.raise() }.to(raiseException(named: "bar", reason: "Lulz"))
        }
        failsWithErrorMessage("expected to not raise exception with name equal <laugh>") {
            expect { self.exception.raise() }.toNot(raiseException(named: "laugh"))
        }
        failsWithErrorMessage("expected to not raise exception with name equal <laugh> with reason equal <Lulz>") {
            expect { self.exception.raise() }.toNot(raiseException(named: "laugh", reason: "Lulz"))
        }

        failsWithErrorMessage("expected to not raise exception with name equal <laugh> with reason equal <Lulz> with userInfo equal <{key = value;}>") {
            expect { self.exception.raise() }.toNot(raiseException(named: "laugh", reason: "Lulz", userInfo: ["key": "value"]))
        }
    }

    func testNegativeMatchesWithSubMatchers() {
        failsWithErrorMessage("expected to raise exception with name equal <foo> with reason begin with <bar>") {
            expect { self.exception.raise() }.to(raiseException(named: equal("foo"), reason: beginWith("bar")))
        }

        failsWithErrorMessage("expected to raise exception with name equal <foo>") {
            expect { self.exception.raise() }.to(raiseException(named: equal("foo")))
        }

        failsWithErrorMessage("expected to raise exception with reason begin with <bar>") {
            expect { self.exception.raise() }.to(raiseException(reason: beginWith("bar")))
        }

        failsWithErrorMessage("expected to raise exception with userInfo equal <{k = v;}>") {
            expect { self.exception.raise() }.to(raiseException(userInfo: equal(["k": "v"])))
        }

        failsWithErrorMessage("expected to not raise exception with name equal <laugh> with reason begin with <Lu>") {
            expect { self.exception.raise() }.toNot(raiseException(named: equal("laugh"), reason: beginWith("Lu")))
        }

        failsWithErrorMessage("expected to not raise exception with name equal <laugh>") {
            expect { self.exception.raise() }.toNot(raiseException(named: equal("laugh")))
        }

        failsWithErrorMessage("expected to not raise exception with reason begin with <Lu>") {
            expect { self.exception.raise() }.toNot(raiseException(reason: beginWith("Lu")))
        }

        failsWithErrorMessage("expected to raise exception with name equal <laugh> with reason begin with <Lu>") {
            expect { self.exception }.to(raiseException(named: equal("laugh"), reason: beginWith("Lu")))
        }
    }
}
