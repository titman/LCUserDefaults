//
//  LCUserDefaults.mm
//  LCUserDefaults
//
//  Created by Titman ( http://github.com/titman ) on 15/1/6.
//  Copyright (c) 2015年 Licheng Guo . ( http://nsobject.me ). All rights reserved.
//

#import "LCUserDefaults.h"
#import "db.h"
#import "options.h"
#import "write_batch.h"

@interface LCUserDefaults ()
{
    leveldb::DB *_db;
    leveldb::ReadOptions _readOptions;
    leveldb::WriteOptions _writeOptions;
}

@end

@implementation LCUserDefaults


NS_INLINE leveldb::Slice SliceByString(NSString *string)
{
    if (!string) return NULL;
    const char *cStr = [string UTF8String];
    size_t len = strlen(cStr);
    if (len == 0) return NULL;
    return leveldb::Slice(cStr,strlen(cStr));
}

NS_INLINE NSString *StringBySlice(const leveldb::Slice &slice)
{
    if (slice.empty()) return nil;
    const char *bytes = slice.data();
    const size_t len = slice.size();
    if (len == 0) return nil;
    return [[NSString alloc] initWithBytes:bytes length:len encoding:NSUTF8StringEncoding];
}

- (void)dealloc
{
    delete _db;
    _db = NULL;
}


#pragma mark -


+(instancetype) defaultDB
{
    static LCUserDefaults * sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        NSString * path = NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES)[0];
        
        sharedInstance = [[self class] db:[path stringByAppendingString:$DEFAULT_NAME]];
    });
    
    return sharedInstance;
    
    
}

+(instancetype) db:(NSString *)path
{
    return [[[self class] alloc] initWithPath:path];
}

- (id)initWithPath:(NSString *)path
{
    self = [super init];
    
    if (self)
    {
        self.path = path;
        
        leveldb::Options options;
        options.create_if_missing = true;
        
        if (![[NSFileManager defaultManager] fileExistsAtPath:self.path])
        {
            BOOL sucess = [[NSFileManager defaultManager] createDirectoryAtPath:self.path
                                                    withIntermediateDirectories:YES
                                                                     attributes:NULL
                                                                          error:NULL];
            if (!sucess)
            {
                return nil;
            }
        }
        
        leveldb::Status status = leveldb::DB::Open(options, [_path fileSystemRepresentation], &_db);
        
        if (!status.ok())
        {
            return nil;
        }
        
        _writeOptions.sync = false;
    }
    
    return self;
}


#pragma mark -


- (NSString *)stringForKey:(NSString *)aKey
{
    if (!_db || !aKey)
    {
        return nil;
    }
    
    leveldb::Slice sliceKey = SliceByString(aKey);
    
    std::string v_string;
    
    leveldb::Status status = _db->Get(_readOptions, sliceKey, &v_string);
    
    if (!status.ok())
    {
        return nil;
    }
    
    return [[NSString alloc] initWithBytes:v_string.data() length:v_string.length() encoding:NSUTF8StringEncoding];
}

- (NSData *)dataForKey:(NSString *)aKey
{
    if (!_db || !aKey)
    {
        return nil;
    }
    
    leveldb::Slice sliceKey = SliceByString(aKey);
    
    std::string v_string;
    
    leveldb::Status status = _db->Get(_readOptions, sliceKey, &v_string);
    
    if (!status.ok())
    {
        return nil;
    }
    
    return [[NSData alloc] initWithBytes:v_string.data() length:v_string.length()];
}

- (id)objectForKey:(NSString *)aKey
{
    if (!_db || !aKey)
    {
        return nil;
    }
    
    leveldb::Slice sliceKey = SliceByString(aKey);
    
    std::string v_string;
    
    leveldb::Status status = _db->Get(_readOptions, sliceKey, &v_string);
    
    if (!status.ok())
    {
        return nil;
    }
    
    NSData * data = [[NSData alloc] initWithBytes:v_string.data() length:v_string.length()];
    
    id value = nil;
    
    if (!data)
    {
       return value;
    }
    
    @try
    {
        value = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    }
    @catch (NSException *exception)
    {
        
    }
    
    return value;
}


#pragma mark -


- (BOOL)setString:(NSString *)value forKey:(NSString *)aKey
{
    if (!_db || !value || !aKey)
    {
        return NO;
    }
    
    leveldb::Slice sliceKey = SliceByString(aKey);
    leveldb::Slice sliceValue = SliceByString(value);
    
    leveldb::Status status = _db->Put(_writeOptions, sliceKey, sliceValue);
    
    return status.ok();
}

- (BOOL)setData:(NSData *)value forKey:(NSString *)aKey
{
    if (!_db || !value || !aKey)
    {
        return NO;
    }
    
    leveldb::Slice sliceKey = SliceByString(aKey);
    leveldb::Slice sliceValue = leveldb::Slice((char *)[value bytes],[value length]);
    
    leveldb::Status status = _db->Put(_writeOptions, sliceKey, sliceValue);
    
    return status.ok();
}

- (BOOL)setObject:(id)value forKey:(NSString *)aKey
{
    if (!_db || !value || !aKey)
    {
        return NO;
    }
    
    NSData *data = nil;
    
    @try
    {
        data = [NSKeyedArchiver archivedDataWithRootObject:value];
    }
    @catch (NSException *exception)
    {
        return NO;
    }
    
    if (!data)
    {
        return NO;
    }
    
    leveldb::Slice sliceKey = SliceByString(aKey);
    leveldb::Slice sliceValue = leveldb::Slice((char *)[data bytes],[data length]);
    
    leveldb::Status status = _db->Put(_writeOptions, sliceKey, sliceValue);
    
    return status.ok();
}


#pragma mark -


- (BOOL)removeObjectForKey:(NSString *)aKey
{
    if (!_db || !aKey) return NO;
    
    leveldb::Slice sliceKey = SliceByString(aKey);
    leveldb::Status status = _db->Delete(_writeOptions, sliceKey);
    
    return status.ok();
}


#pragma mark -


- (NSArray *)allKeys
{
    if (_db == NULL) return nil;
    
    NSMutableArray *keys = [NSMutableArray array];
    [self enumerateKeys:^(NSString *key, BOOL *stop) {
        [keys addObject:key];
    }];
    return keys;
}

- (void)enumerateKeys:(void (^)(NSString *key, BOOL *stop))block
{
    if (_db == NULL) return;
    BOOL stop = NO;
    leveldb::Iterator* iter = _db->NewIterator(leveldb::ReadOptions());
    for (iter->SeekToFirst(); iter->Valid(); iter->Next()) {
        leveldb::Slice key = iter->key();
        NSString *k = StringBySlice(key);
        block(k, &stop);
        if (stop)
            break;
    }
    delete iter;
}


#pragma mark -


- (BOOL)removeAllObjects
{
    NSArray *keys = [self allKeys];
    BOOL result = YES;
    for (NSString *k in keys) {
        result = result && [self removeObjectForKey:k];
    }
    return result;
}

- (BOOL)removeDB
{
    delete _db;
    _db = NULL;
    return [[NSFileManager defaultManager] removeItemAtPath:_path error:NULL];
}


#pragma mark -


-(id) objectForKeyedSubscript:(id)key
{
    return [self objectForKey:key];
}

-(void) setObject:(id)object forKeyedSubscript:(id<NSCopying>)key
{
    [self setObject:object forKey:(NSString *)key];
}


#pragma mark -


@end
