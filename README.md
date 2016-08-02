# TTGKVOGuard

[![CI Status](http://img.shields.io/travis/zekunyan/TTGKVOGuard.svg?style=flat)](https://travis-ci.org/zekunyan/TTGKVOGuard)
[![Version](https://img.shields.io/cocoapods/v/TTGKVOGuard.svg?style=flat)](http://cocoapods.org/pods/TTGKVOGuard)
[![License](https://img.shields.io/cocoapods/l/TTGKVOGuard.svg?style=flat)](http://cocoapods.org/pods/TTGKVOGuard)
[![Platform](https://img.shields.io/cocoapods/p/TTGKVOGuard.svg?style=flat)](http://cocoapods.org/pods/TTGKVOGuard)

## What

Auto remove KVO observer from object after the object or the observer dealloc, base on [TTGDeallocTaskHelper](https://github.com/zekunyan/TTGDeallocTaskHelper).

## Requirements

iOS 6 and later.

## Installation

TTGKVOGuard is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "TTGKVOGuard"
```

## Usage

1. TTGKVOGuard is default off, so you must turn it on first.
```
#import <TTGKVOGuard/NSObject+TTGKVOGuard.h>

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Enable the TTGKVOGuard
    [NSObject ttg_setTTGKVOGuardEnable:YES];
    return YES;
}
```

2. No more need to do. Just start coding as usual :)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Author

zekunyan, zekunyan@163.com

## License

TTGKVOGuard is available under the MIT license. See the LICENSE file for more info.
