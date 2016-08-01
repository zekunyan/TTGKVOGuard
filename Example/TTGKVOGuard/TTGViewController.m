//
//  TTGViewController.m
//  TTGKVOGuard
//
//  Created by zekunyan on 07/30/2016.
//  Copyright (c) 2016 zekunyan. All rights reserved.
//

#import "TTGViewController.h"

@interface TTGObserver : NSObject

@end

@implementation TTGObserver

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
}

- (void)dealloc {
    NSLog(@"TTGObserver dealloc");
}

@end

@interface TTGSubject : NSObject
@property (nonatomic, strong) NSString *name;
@end

@implementation TTGSubject

- (void)dealloc {
    NSLog(@"TTGSubject dealloc");
}

@end

@interface TTGViewController ()
@property (nonatomic, strong) TTGSubject *subject;
@property (nonatomic, strong) TTGObserver *observer;
@end

@implementation TTGViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _observer = [TTGObserver new];
}

- (IBAction)runTest:(id)sender {
    TTGObserver *observer = [TTGObserver new];
    TTGSubject *subject = [TTGSubject new];
    
    NSString *key = @"key";

    [subject addObserver:observer forKeyPath:@"name" options:NSKeyValueObservingOptionNew context:nil];
    [subject addObserver:observer forKeyPath:@"name" options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew context:nil];
    [subject addObserver:observer forKeyPath:@"name" options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew context:nil];
    [subject addObserver:observer forKeyPath:@"name" options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew context:(__bridge void * _Nullable)(key)];
    
    @try {
//        [subject removeObserver:observer forKeyPath:@"name" context:(__bridge void * _Nullable)(key)];
        [subject removeObserver:observer forKeyPath:@"name"];
        [subject removeObserver:observer forKeyPath:@"name"];
        [subject removeObserver:observer forKeyPath:@"name"];
    } @catch (NSException *exception) {
        NSLog(@"!!!!! Remove observer exception: %@", exception);
    } @finally {
        NSLog(@"remove observer exception finally");
    }
}

@end
