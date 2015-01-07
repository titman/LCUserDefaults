LCUserDefaults
==============

A local storage strategy, faster, safer, simpler and eleganter than NSUserDefaults. ( 替代NSUserDefaults的绝佳方案！ )


Example
==============
    
    
    BOOL finished = [LCUserDefaults defaultDB][@"TEST_KEY"] = @"123"; // or [[LCUserDefaults defaultDB] setObject:(id) forKey:(NSString *)]
    
    NSLog(@"Write finished [ %@ ]",finished ? @"YES" : @"NO");
   
    NSString * result = [LCUserDefaults defaultDB][@"TEST_KEY"]; // or [[LCUserDefaults defaultDB] objectForKey:(NSString *)]
    
    NSLog(@"Read result [ %@ ]",result);
