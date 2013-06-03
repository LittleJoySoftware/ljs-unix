ljs-unix
========

unix utilities for MacOS

### find operation

```
  NSString *command = @"/usr/bin/find";
  NSArray *args = @[@"/", @"-name", @".DS_Store", @"-print"];
  
  
  LjsUnixOperation *uop = [[LjsUnixOperation alloc]
                           initWithLaunchPath:command
                           launchArgs:args
                           commonName:TpUnixOperationTestsCommandLongRunningFind
                           callbackDelegate:self];
  [self.opqueue addOperation:uop];
```

### defaults read

```
 NSString *command = @"/usr/bin/defaults";
  NSArray *args = @[@"read", @"com.apple.NetworkBrowser", @"BrowseAllInterfaces"];
  
  LjsUnixOperation *uop = [[LjsUnixOperation alloc]
                           initWithLaunchPath:command
                           launchArgs:args
                           commonName:TpUnixOperationTestsDoAirDropRead
                           callbackDelegate:self];
  
  [self.opqueue addOperation:uop];
```

### motivation

sometimes you just need to do some unix operations

### version numbers

i will try my best to follow http://semver.org/ when naming the versions.

### Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

