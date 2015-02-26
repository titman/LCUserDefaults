LCUserDefaults
==============

A local storage strategy, faster, safer, simpler and eleganter than NSUserDefaults. 


Example
==============
    
    
    NSLog(@"Will write '123' to  db. (Path : %@)",LCUserDefaults.DB.path);
    
    LCUserDefaults.DB[@"TEST_KEY"] = @"123"; // or [[LCUserDefaults defaultDB] setObject:(id) forKey:(NSString *)
    
    NSLog(@"Write finished.");
   
    NSString * result = LCUserDefaults.DB[@"TEST_KEY"]; // or [[LCUserDefaults defaultDB] objectForKey:(NSString *)]
    
    NSLog(@"Read from local db, result [ %@ ]",result);
    
