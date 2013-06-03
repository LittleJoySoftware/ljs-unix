#import <Cocoa/Cocoa.h>
#import "LjsUnixOperation.h"

@interface LjsUnixAppDelegate : NSObject
<NSApplicationDelegate, LjsUnixOperationCallbackDelegate>

@property (weak) IBOutlet NSWindow *window;
@property (nonatomic, strong) NSOperationQueue *opqueue;
@property (nonatomic, strong) LjsUnixOperation *longRunningFindOp;
@property (nonatomic, strong) NSTimer *cancelOpTimer;

#pragma mark Tests
- (void) doLsTest;
- (void) doLongRunningFindWithCancelSignalSentToOperation;
- (void) handleCancelOperationTimerEvent:(NSTimer *) aTimer;
- (void) doLocateOperation;
- (void) doIpconfigGetIfaddr;
- (void) doCommandThatWillFail;
- (void) doReadDefaultsForAirDrop;

@end
