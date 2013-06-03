#import <Cocoa/Cocoa.h>
#import "LjsUnixOperation.h"

@interface LjsUnixAppDelegate : NSObject
<NSApplicationDelegate, LjsUnixOperationCallbackDelegate>

@property (assign) IBOutlet NSWindow *window;
@property (nonatomic, retain) NSOperationQueue *opqueue;
@property (nonatomic, retain) LjsUnixOperation *longRunningFindOp;
@property (nonatomic, retain) NSTimer *cancelOpTimer;


#pragma mark Tests
- (void) doLsTest;
- (void) doLongRunningFindWithCancelSignalSentToOperation;
- (void) handleCancelOperationTimerEvent:(NSTimer *) aTimer;
- (void) doLocateOperation;
- (void) doIpconfigGetIfaddr;
- (void) doCommandThatWillFail;
- (void) doReadDefaultsForAirDrop;


@end
