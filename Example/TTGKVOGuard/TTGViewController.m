//
//  TTGViewController.m
//  TTGKVOGuard
//
//  Created by zekunyan on 07/30/2016.
//  Copyright (c) 2016 zekunyan. All rights reserved.
//

#import "TTGViewController.h"
#import <TTGKVOGuard/NSObject+TTGKVOGuard.h>

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
@property (nonatomic, strong) NSNumber *number;
@end

@implementation TTGSubject

- (void)dealloc {
    NSLog(@"TTGSubject dealloc");
}

@end

@interface TTGViewController ()
@property (weak, nonatomic) IBOutlet UILabel *kvoGuardSwitchInfoLabel;

@property (nonatomic, strong) TTGSubject *subject;
@property (nonatomic, strong) TTGObserver *observer;
@end

@implementation TTGViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [NSObject ttg_setTTGKVOGuardEnable:YES];
}

- (IBAction)switchKVOGuard:(UISwitch *)sender {
    _kvoGuardSwitchInfoLabel.text = [NSString stringWithFormat:@"TTGKVOGuard is %@", (sender.on ? @"on" : @"off")];
    [NSObject ttg_setTTGKVOGuardEnable:sender.on];
}

- (IBAction)runTest1:(id)sender {
    _observer = [TTGObserver new];
    
    @autoreleasepool {
        // subject will release after @autoreleasepool
        TTGSubject *subject = [TTGSubject new];
        NSString *key = @"key";
        
        [subject addObserver:_observer forKeyPath:@"name" options:NSKeyValueObservingOptionNew context:nil];
        [subject addObserver:_observer forKeyPath:@"name" options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew context:nil];
        [subject addObserver:_observer forKeyPath:@"name" options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew context:nil];
        [subject addObserver:_observer forKeyPath:@"name" options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew context:(__bridge void * _Nullable)(key)];
        [subject addObserver:_observer forKeyPath:@"number" options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew context:nil];
    }
}

- (IBAction)runTest2:(id)sender {
    _subject = [TTGSubject new];
    
    @autoreleasepool {
        // observer will release after @autoreleasepool
        TTGObserver *observer = [TTGObserver new];
        NSString *key = @"key";
        
        [_subject addObserver:observer forKeyPath:@"name" options:NSKeyValueObservingOptionNew context:nil];
        [_subject addObserver:observer forKeyPath:@"name" options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew context:nil];
        [_subject addObserver:observer forKeyPath:@"name" options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew context:nil];
        [_subject addObserver:observer forKeyPath:@"name" options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew context:(__bridge void * _Nullable)(key)];
        [_subject addObserver:observer forKeyPath:@"number" options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew context:nil];
    }
}

@end
