#import <Nimble/Nimble.h>
#import "NimbleTests-Swift.h"

// Use this when you want to verify the failure message for when an expectation fails
#define expectFailureMessage(MSG, BLOCK) \
[NimbleHelper expectFailureMessage:(MSG) block:(BLOCK) file:@(__FILE__) line:__LINE__];

// Use this when you want to verify the failure message with the nil message postfixed
// to it: " (use beNil() to match nils)"
#define expectNilFailureMessage(MSG, BLOCK) \
[NimbleHelper expectFailureMessageForNil:(MSG) block:(BLOCK) file:@(__FILE__) line:__LINE__];
