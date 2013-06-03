#import "LjsUnixWhich.h"
#import "Lumberjack.h"
#import "LjsUnixOperation.h"

#ifdef LOG_CONFIGURATION_DEBUG
static const int ddLogLevel = LOG_LEVEL_DEBUG;
#else
static const int ddLogLevel = LOG_LEVEL_WARN;
#endif

static NSString *LjsUnixWhichWhichLaunchPath = @"/usr/bin/which";

static NSString *LjsUnixWhichIfconfig = @"ifconfig";
static NSString *LjsUnixWhichIfconfigDefaultLaunchPath = @"/sbin/ifconfig";
static NSString *LjsUnixWhichIfconfigCommandName = @"me.twistedpair.TwistedPair which ifconfig";

static NSString *LjsUnixWhichIpconfig = @"ipconfig";
static NSString *LjsUnixWhichIpconfigDefaultLaunchPath = @"/usr/sbin/ipconfig";
static NSString *LjsUnixWhichIpconfigCommandName = @"me.twistedpair.TwistedPair which ipconfig";

static NSString *LjsUnixWhichDefaults = @"defaults";
static NSString *LjsUnixWhichDefaultDefaultsLaunchPath = @"/usr/bin/defaults";
static NSString *LjsUnixWhichDefaultsCommandName = @"me.twistedpair.TwistedPair which defaults";

@implementation LjsUnixWhich

@synthesize ifconfigLaunchPath;
@synthesize ipconfigLaunchPath;
@synthesize defaultsLaunchPath;
@synthesize opqueue;

#pragma mark Memory Management
- (void) dealloc {
  //DDLogDebug(@"deallocating LjsUnixWhich");
  [self.opqueue cancelAllOperations];
  self.opqueue = nil;
  self.ifconfigLaunchPath = nil;
  self.ipconfigLaunchPath = nil;
  self.defaultsLaunchPath = nil;
  [super dealloc];
}

- (id) init {
  self = [super init];
  if (self != nil) {
  
    self.ifconfigLaunchPath = LjsUnixWhichIfconfigDefaultLaunchPath;
    self.ipconfigLaunchPath = LjsUnixWhichIpconfigDefaultLaunchPath;
    self.defaultsLaunchPath = LjsUnixWhichDefaultDefaultsLaunchPath;
    
    self.opqueue = [[[NSOperationQueue alloc]
                     init] autorelease];
    
    [self asyncFindIfConfigLaunchPath];
    [self asyncFindIpConfigLaunchPath];
    [self asyncFindDefaultsLaunchPath];
  }
  return self;
}

#pragma mark Unix Operation Callback Delegate
/** @name LjsUnixOperationCallbackDelegate Protocol */
/**
 A callback that the LjsUnixOperation will use to deliver results at the end
 of execution.
 
 The name parameter is a unique id that the callback delegate can use to 
 discern what operation completion prompted the callback.
 
 There is no special error handling - here failure is not a disaster because
 we can fall back on the hardcoded command paths.
 
 @param aName the name of the operation that completed
 @param aResult the result of the operation
 @warning could use a refactor to reduce code duplication.
 */
- (void) operationCompletedWithName:(NSString *)aName result:(LjsUnixOperationResult *)aResult {
  DDLogDebug(@"operation %@ completed", aName);
  if ([LjsUnixWhichIfconfigCommandName isEqualToString:aName]) {
    if (aResult.wasCancelled == YES) {
      DDLogDebug(@"operation was cancelled - nothing to do");
    } else if (aResult.launchError != nil) {
      DDLogError(@"there was a launch error: %@", [aResult.launchError localizedDescription]);
    } else if (aResult.executionError != nil) {
      DDLogError(@"there was an execution error: %@", [aResult.executionError localizedDescription]);
    } else if (aResult.stdOutput == nil || [aResult.stdOutput length] == 0) {
      DDLogError(@"expected some output to standard out - found < %@ >", aResult.stdOutput);
    } else {
      DDLogDebug(@"setting ifconfig launch path to %@", aResult.stdOutput);
      self.ifconfigLaunchPath = aResult.stdOutput;
    }
  } else if ([LjsUnixWhichIpconfigCommandName isEqualToString:aName]) {
    if (aResult.wasCancelled == YES) {
      DDLogDebug(@"operation was cancelled - nothing to do");
    } else if (aResult.launchError != nil) {
      DDLogError(@"there was a launch error: %@", [aResult.launchError localizedDescription]);
    } else if (aResult.executionError != nil) {
      DDLogError(@"there was an execution error: %@", [aResult.executionError localizedDescription]);
    } else if (aResult.stdOutput == nil || [aResult.stdOutput length] == 0) {
      DDLogError(@"expected some output to standard out - found < %@ >", aResult.stdOutput);
    } else {
      DDLogDebug(@"setting ifconfig launch path to %@", aResult.stdOutput);
      self.ipconfigLaunchPath = aResult.stdOutput;
    }
  } else if ([LjsUnixWhichDefaultsCommandName isEqualToString:aName]) {
    if (aResult.wasCancelled == YES) {
      DDLogDebug(@"operation was cancelled - nothing to do");
    } else if (aResult.launchError != nil) {
      DDLogError(@"there was a launch error: %@", [aResult.launchError localizedDescription]);
    } else if (aResult.executionError != nil) {
      DDLogError(@"there was an execution error: %@", [aResult.executionError localizedDescription]);
    } else if (aResult.stdOutput == nil || [aResult.stdOutput length] == 0) {
      DDLogError(@"expected some output to standard out - found < %@ >", aResult.stdOutput);
    } else {
      DDLogDebug(@"setting defaults launch path to %@", aResult.stdOutput);
      self.defaultsLaunchPath = aResult.stdOutput;
    }
  } else {
    DDLogError(@"unknown common name = %@", aName);
    //NSAssert(NO, nil);
  }
}


- (void) asyncFindIfConfigLaunchPath {
  DDLogDebug(@"starting async find of ifconfig launch path");
  LjsUnixOperation *uop = [[[LjsUnixOperation alloc]
                           initWithLaunchPath:LjsUnixWhichWhichLaunchPath
                           launchArgs:[NSArray arrayWithObject:LjsUnixWhichIfconfig]
                           commonName:LjsUnixWhichIfconfigCommandName
                           callbackDelegate:self] autorelease];
  
  [self.opqueue addOperation:uop];
}

- (void) asyncFindIpConfigLaunchPath {
  DDLogDebug(@"starting async find of ipconfig launch path");
  LjsUnixOperation *uop = [[[LjsUnixOperation alloc]
                           initWithLaunchPath:LjsUnixWhichWhichLaunchPath
                           launchArgs:[NSArray arrayWithObject:LjsUnixWhichIpconfig]
                           commonName:LjsUnixWhichIpconfigCommandName
                           callbackDelegate:self] autorelease];
  
  [self.opqueue addOperation:uop];
}

- (void) asyncFindDefaultsLaunchPath {
  DDLogDebug(@"starting async find of defaults launch path");
  LjsUnixOperation *uop = [[[LjsUnixOperation alloc]
                           initWithLaunchPath:LjsUnixWhichWhichLaunchPath
                           launchArgs:[NSArray arrayWithObject:LjsUnixWhichDefaults]
                           commonName:LjsUnixWhichDefaultsCommandName
                           callbackDelegate:self] autorelease];
  
  [self.opqueue addOperation:uop];
}


@end
