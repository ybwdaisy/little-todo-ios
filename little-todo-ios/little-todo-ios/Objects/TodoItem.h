//
//  TodoItem.h
//  little-todo-ios
//
//  Created by ybw-macbook-pro on 2022/5/11.
//  Copyright © 2022 ybwdaisy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TodoItem : NSObject

@property(nonatomic, readwrite) NSString *uuid;
@property(nonatomic, readwrite) NSString *title;
@property(nonatomic, readwrite) NSString *remark;
@property(nonatomic, nullable, readwrite) NSString *datetime;
@property(nonatomic, nullable, readwrite) NSString *repeat;
@property(nonatomic, nullable, readwrite) NSString *priority;

@end

NS_ASSUME_NONNULL_END
