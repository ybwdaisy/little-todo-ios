//
//  TDTableViewCell.h
//  little-todo-ios
//
//  Created by ybwdaisy on 2020/12/14.
//  Copyright © 2020 ybwdaisy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TodoItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface TDTableViewCell : UITableViewCell

- (void) layoutTableViewCell:(TodoItem *)data;

@end

NS_ASSUME_NONNULL_END
