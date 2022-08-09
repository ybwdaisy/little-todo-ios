//
//  TodoMenu.h
//  little-todo-ios
//
//  Created by ybw-macbook-pro on 2022/5/13.
//  Copyright © 2022 ybwdaisy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TodoMenu : NSObject

@property(nonatomic) NSString *name;
@property(nonatomic) NSString *icon;
@property(nonatomic) UIAction *action;
@property(nonatomic) UIMenuItem *menu;

- (instancetype)initWithName:(NSString *)name icon:(NSString *)icon handler:(UIActionHandler)handler action:(SEL)action;

+ (instancetype)todoMenuWithName:(NSString *)name icon:(NSString *)icon handler:(UIActionHandler)handler action:(SEL)action;


@end

NS_ASSUME_NONNULL_END
