//
//
//      _|          _|_|_|
//      _|        _|
//      _|        _|
//      _|        _|
//      _|_|_|_|    _|_|_|
//
//
//  Copyright (c) 2014-2015, Licheng Guo. ( http://nsobject.me )
//  http://github.com/titman
//
//
//  Permission is hereby granted, free of charge, to any person obtaining a
//  copy of this software and associated documentation files (the "Software"),
//  to deal in the Software without restriction, including without limitation
//  the rights to use, copy, modify, merge, publish, distribute, sublicense,
//  and/or sell copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
//  IN THE SOFTWARE.
//

#import <Foundation/Foundation.h>
#include <stdio.h>
#include <dirent.h>

#define $USE_SHOT_NAME ( $ )

#undef  $DEFAULT_NAME
#define $DEFAULT_NAME @"/LCUserDefaults/"


@interface LCUserDefaults : NSObject

@property(nonatomic,strong) NSString * path;

#pragma mark -


#ifdef $USE_SHOT_NAME
/** It will create DB file in /Documents/LCUserDefaults/. */
+(instancetype) DB;
#else
+(instancetype) defaultDB;
#endif


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


