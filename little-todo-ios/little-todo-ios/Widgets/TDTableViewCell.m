//
//  TDTableViewCell.m
//  little-todo-ios
//
//  Created by ybwdaisy on 2020/12/14.
//  Copyright © 2020 ybwdaisy. All rights reserved.
//

#import "TDTableViewCell.h"

@interface TDTableViewCell ()

@property(nonatomic, strong, readwrite) UILabel *title;
@property(nonatomic, strong, readwrite) UILabel *remark;
@property(nonatomic, strong, readwrite) UILabel *priority;
@property(nonatomic, strong, readwrite) UILabel *time;

@end

@implementation TDTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self.contentView addSubview:({
            self.title = [[UILabel alloc] initWithFrame:CGRectMake(20, 15, 375, 20)];
            self.title.numberOfLines = 0;
            self.title.lineBreakMode = NSLineBreakByWordWrapping;
            self.title.font =[UIFont systemFontOfSize:16];
            self.title.textColor = [UIColor blackColor];
            self.title;
        })];
        
        [self.contentView addSubview:({
            self.remark = [[UILabel alloc] initWithFrame:CGRectMake(20, self.title.frame.size.height + 15, 375, 20)];
            self.remark.numberOfLines = 1;
            self.remark.font = [UIFont systemFontOfSize:12];
            self.remark.textColor = [UIColor lightGrayColor];
            self.remark;
        })];
        
        [self.contentView addSubview:({
            self.priority = [[UILabel alloc] initWithFrame:CGRectMake(20, self.title.frame.size.height + 15 + self.remark.frame.size.height + 10, 375, 20)];
            self.priority.font = [UIFont systemFontOfSize:14];
            self.priority.textColor = [UIColor redColor];
            self.priority;
        })];
        
        [self.contentView addSubview:({
            self.time = [[UILabel alloc] initWithFrame:CGRectMake(20, self.title.frame.size.height + 15 + self.remark.frame.size.height + 5 + self.priority.frame.size.height + 5, 375, 20)];
            self.time.font = [UIFont systemFontOfSize:12];
            self.time.textColor = [UIColor systemBlueColor];
            self.time;
        })];

    }
    
    return self;
}

- (void) layoutTableViewCell:(NSDictionary *)cellData {
    self.title.text = [cellData objectForKey:@"title"];
    self.remark.text = [cellData objectForKey:@"remark"];
    self.priority.text = [cellData objectForKey:@"priority"];
    self.time.text = [cellData objectForKey:@"time"];
}

- (BOOL) canBecomeFirstResponder {
    return YES;
}

@end
