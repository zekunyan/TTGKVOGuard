//
//  NSObject+TTGKVOGuard.m
//  Pods
//
//  Created by tutuge on 16/7/31.
//
//

#import "NSObject+TTGKVOGuard.h"
#import <objc/runtime.h>
#import <objc/message.h>
#import <pthread.h>
#import <NSObject+TTGDeallocTaskHelper.h>

static pthread_mutex_t TTGKVOGuardInfoDictLock;
static NSMutableDictionary *TTGKVOGuardInfoDict;

@interface TTGKVOGuardInfo : NSObject
@property (nonatomic, unsafe_unretained) id unsafeObject;
@property (nonatomic, unsafe_unretained) id unsafeObserver;

@property (nonatomic, copy) NSString *keyPath;
@property (nonatomic, assign) NSKeyValueObservingOptions options;
@property (nonatomic, unsafe_unretained) void *context;

@property (nonatomic, assign) NSInteger kvoCount;
@property (nonatomic, assign) BOOL valid;
@end

@implementation TTGKVOGuardInfo
@end

@implementation NSObject (TTGKVOGuard)

+ (void)load {
    pthread_mutex_init(&TTGKVOGuardInfoDictLock, NULL);
    TTGKVOGuardInfoDict = [NSMutableDictionary new];
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self.class _ttg_methodSwizzlingWithClass:self.class
                                 originalSelector:@selector(addObserver:forKeyPath:options:context:)
                                 swizzledSelector:@selector(ttg_addObserver:forKeyPath:options:context:)];
    });
}

#pragma mark - Swizzling methods

- (void)ttg_addObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(nullable void *)context {
    [self ttg_addObserver:observer forKeyPath:keyPath options:options context:context];
    
    // Generate key
    NSString *infoKey = [self.class _ttg_getInfoKeyForObject:self observer:observer keyPath:keyPath context:context];
    
    // Lock
    pthread_mutex_lock(&TTGKVOGuardInfoDictLock);
    
    NSMutableDictionary *objectInfoDict = TTGKVOGuardInfoDict[@((NSInteger)self)];
    if (!objectInfoDict) {
        objectInfoDict = [NSMutableDictionary new];
        TTGKVOGuardInfoDict[@((NSInteger)self)] = objectInfoDict;
        [self.class _ttg_setupDeallocTaskForObject:self];
    }
    
    NSMutableDictionary *observerInfoDict = TTGKVOGuardInfoDict[@((NSInteger)observer)];
    if (!observerInfoDict) {
        observerInfoDict = [NSMutableDictionary new];
        TTGKVOGuardInfoDict[@((NSInteger)observer)] = observerInfoDict;
        [self.class _ttg_setupDeallocTaskForObject:observer];
    }
    
    TTGKVOGuardInfo *info = [objectInfoDict valueForKey:infoKey];
    if (info) {
        info.kvoCount += 1;
    } else {
        info = [TTGKVOGuardInfo new];
        info.unsafeObject = self;
        info.unsafeObserver = observer;
        info.keyPath = [keyPath copy];
        info.options = options;
        info.context = context;
        info.kvoCount = 1;
        info.valid = YES;
    }
    
    [objectInfoDict setValue:info forKey:infoKey];
    [observerInfoDict setValue:info forKey:infoKey];
    
    // Unlock
    pthread_mutex_unlock(&TTGKVOGuardInfoDictLock);
}

#pragma mark - Private methods

+ (void)_ttg_methodSwizzlingWithClass:(Class) class originalSelector:(SEL)originalSelector swizzledSelector:(SEL)swizzledSelector {
    if (!class || !originalSelector || !swizzledSelector) {
        return;
    }
    
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
    
    BOOL didAddMethod =
    class_addMethod(class, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
    
    if (didAddMethod) {
        class_replaceMethod(class, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

+ (NSString *)_ttg_getInfoKeyForObject:(id)object observer:(id)observer keyPath:(NSString *)keyPath context:(nullable void *)context {
    return [NSString stringWithFormat:@"%p-%p-%@-%p", object, observer, keyPath, context];
}

+ (void)_ttg_setupDeallocTaskForObject:(id)object {
    [object ttg_addDeallocTask:^(__unsafe_unretained id object, NSUInteger identifier) {
        pthread_mutex_lock(&TTGKVOGuardInfoDictLock);
        
        NSDictionary *infoDict = TTGKVOGuardInfoDict[@((NSInteger)object)];
        [infoDict enumerateKeysAndObjectsUsingBlock:^(NSString *key, TTGKVOGuardInfo *info, BOOL * _Nonnull stop) {
            [self.class _ttg_performRemoveKVOWithInfo:info];
        }];
        TTGKVOGuardInfoDict[@((NSInteger)object)] = nil;
        
        pthread_mutex_unlock(&TTGKVOGuardInfoDictLock);
    }];
}

+ (void)_ttg_performRemoveKVOWithInfo:(TTGKVOGuardInfo *)info {
    if (!info.valid) {
        return;
    }
    
    for (NSInteger i = 0; i < info.kvoCount; i++) {
        @try {
            [info.unsafeObject removeObserver:info.unsafeObserver forKeyPath:info.keyPath context:info.context];
        } @catch (NSException *exception) {}
    }
    info.kvoCount = 0;
    info.valid = NO;
}

@end
