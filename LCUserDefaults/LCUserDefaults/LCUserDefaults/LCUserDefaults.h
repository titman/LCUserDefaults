//
//  LCUserDefaults.h
//  LCUserDefaults
//
//  Created by Titman ( http://github.com/titman ) on 15/1/6.
//  Copyright (c) 2015年 Licheng Guo . ( http://nsobject.me ). All rights reserved.
//

#import <Foundation/Foundation.h>
#include <stdio.h>
#include <dirent.h>


#undef  $DEFAULT_NAME
#define $DEFAULT_NAME @"/LCUserDefaults/"


@interface LCUserDefaults : NSObject


+ (LCUserDefaults *)levelDBWithPath:(NSString *)path error:(NSError **)errorOut;


#pragma mark -


+(instancetype) defaultDB;


#pragma mark -


+(instancetype) db:(NSString *)path;
-(instancetype) initWithPath:(NSString *)path;


#pragma mark -

// Objective-C Subscripting Support:
//   Examples:
//     db[@"key"] = @"value";
//     db[@"key"] = [NSData data];
//     NSString *s = db[@"key"];
-(id) objectForKeyedSubscript:(id)key;
-(void) setObject:(id)object forKeyedSubscript:(id<NSCopying>)key;


#pragma mark -


-(NSString *) stringForKey:(NSString *)key;
-(NSData *) dataForKey:(NSString *)key;
-(id) objectForKey:(NSString *)key;


#pragma mark -


-(BOOL) setString:(NSString *)value forKey:(NSString *)key;
-(BOOL) setData:(NSData *)value forKey:(NSString *)key;
-(BOOL) setObject:(id)value forKey:(NSString *)key;


#pragma mark -


-(BOOL) removeObjectForKey:(NSString *)key;

-(NSArray *) allKeys;

-(BOOL) removeAllObjects;
-(BOOL) removeDB;


#pragma mark -


@end









#if defined (__unix) || (CC_TARGET_PLATFORM == CC_PLATFORM_IOS)
#ifndef __ENABLE_COMPATIBILITY_WITH_UNIX_2003__
#define __ENABLE_COMPATIBILITY_WITH_UNIX_2003__

FILE *fopen$UNIX2003( const char *filename, const char *mode )
{
    return fopen(filename, mode);
}
size_t fwrite$UNIX2003( const void *a, size_t b, size_t c, FILE *d )
{
    return fwrite(a, b, c, d);
}
char *strerror$UNIX2003( int errnum )
{
    
    return strerror(errnum);
}

DIR *opendir$INODE64(const char * a)
{
    return opendir(a);
}

struct dirent *readdir$INODE64(DIR *dir)
{
    return readdir(dir);
}

#endif
#endif//</dirent.h></stdio.h>


