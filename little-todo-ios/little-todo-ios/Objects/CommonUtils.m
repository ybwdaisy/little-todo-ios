//
//  CommonUtils.m
//  little-todo-ios
//
//  Created by ybw-macbook-pro on 2022/5/13.
//  Copyright © 2022 ybwdaisy. All rights reserved.
//

#import "CommonUtils.h"

@implementation CommonUtils

+ (NSString *)uuid {
    CFUUIDRef uuidRef = CFUUIDCreate(NULL);
    CFStringRef uuidStringRef = CFUUIDCreateString(NULL, uuidRef);
    CFRelease(uuidRef);
    return (__bridge NSString *)uuidStringRef;
}

@end
