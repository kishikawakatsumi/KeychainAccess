#import <XCTest/XCTest.h>
#import "NimbleSpecHelper.h"

@interface ObjCContainTest : XCTestCase

@end

@implementation ObjCContainTest

- (void)testPositiveMatches {
    NSArray *array = @[@1, @2];
    expect(array).to(contain(@1));
    expect(array).toNot(contain(@"HI"));
    expect(@"String").to(contain(@"Str"));
    expect(@"Other").toNot(contain(@"Str"));
}

- (void)testNegativeMatches {
    expectFailureMessage(@"expected to contain <Optional(3)>, got <(1,2)>", ^{
        expect((@[@1, @2])).to(contain(@3));
    });
    expectFailureMessage(@"expected to not contain <Optional(2)>, got <(1,2)>", ^{
        expect((@[@1, @2])).toNot(contain(@2));
    });

    expectFailureMessage(@"expected to contain <hi>, got <la>", ^{
        expect(@"la").to(contain(@"hi"));
    });
    expectFailureMessage(@"expected to not contain <hi>, got <hihihi>", ^{
        expect(@"hihihi").toNot(contain(@"hi"));
    });
}

- (void)testNilMatches {
    expectNilFailureMessage(@"expected to contain <3.0000>, got <nil>", ^{
        expect(nil).to(contain(@3));
    });
    expectNilFailureMessage(@"expected to not contain <3.0000>, got <nil>", ^{
        expect(nil).toNot(contain(@3));
    });

    expectNilFailureMessage(@"expected to contain <hi>, got <nil>", ^{
        expect(nil).to(contain(@"hi"));
    });
    expectNilFailureMessage(@"expected to not contain <hi>, got <nil>", ^{
        expect(nil).toNot(contain(@"hi"));
    });
}

@end
