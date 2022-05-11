//
//  AddTodoViewController.h
//  little-todo-ios
//
//  Created by ybw-macbook-pro on 2021/1/21.
//  Copyright © 2021 ybwdaisy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TodoItem.h"

NS_ASSUME_NONNULL_BEGIN

@protocol AddTodoVCDelegate <NSObject>

- (void)addTodo:(TodoItem *)todo;

@end

@interface AddTodoViewController : UIViewController

@property(nonatomic, weak) id<AddTodoVCDelegate> addTodoVCDelegate;

-(instancetype)initWithData:(TodoItem *)data;

@end

NS_ASSUME_NONNULL_END
