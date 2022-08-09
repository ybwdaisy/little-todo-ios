//
//  Priority.m
//  little-todo-ios
//
//  Created by ybw-macbook-pro on 2022/8/8.
//  Copyright © 2022 ybwdaisy. All rights reserved.
//

#import "Priority.h"

@implementation Priority

- (instancetype)initWithName:(NSString *)name andValue:(enum PriorityTypes)value {
    self = [super init];
    if (self) {
        self.name = name;
        self.value = value;
    }
    return self;
}

+ (instancetype)priorityWithName:(NSString *)name andValue:(enum PriorityTypes)value {
    return [[self alloc]initWithName:name andValue:value];
}


@end
