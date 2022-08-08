//
//  Priority.h
//  little-todo-ios
//
//  Created by ybw-macbook-pro on 2022/8/8.
//  Copyright © 2022 ybwdaisy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

enum PriorityTypes {
    PriorityTypesLow = 1,
    PriorityTypesMedium = 2,
    PriorityTypesHigh = 3,
};

@interface Priority : NSObject

@property(nonatomic, readwrite) NSString *name;
@property(nonatomic, readwrite) enum PriorityTypes value;

- (instancetype)initWithName:(NSString *)name andValue:(enum PriorityTypes)value;

+ (instancetype)priorityWithName:(NSString *)name andValue:(enum PriorityTypes)value;


@end

NS_ASSUME_NONNULL_END
