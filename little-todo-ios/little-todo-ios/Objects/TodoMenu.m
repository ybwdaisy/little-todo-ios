//
//  TodoMenu.m
//  little-todo-ios
//
//  Created by ybw-macbook-pro on 2022/5/13.
//  Copyright © 2022 ybwdaisy. All rights reserved.
//

#import "TodoMenu.h"

@implementation TodoMenu

- (instancetype)initWithName:(NSString *)name icon:(NSString *)icon handler:(UIActionHandler)handler action:(SEL)action {
    self = [super init];
    if (self) {
        self.action = [UIAction actionWithTitle:name image:[UIImage systemImageNamed:icon] identifier:nil handler:handler];
        self.menu = [[UIMenuItem alloc]initWithTitle:name action:action];
    }
    return self;
}

@end
