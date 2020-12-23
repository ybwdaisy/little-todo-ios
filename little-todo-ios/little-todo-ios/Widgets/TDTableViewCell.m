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
@property(nonatomic, strong, readwrite) UILabel *tagName;
@property(nonatomic, strong, readwrite) UILabel *time;

@end

@implementation TDTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:({
            self.title = [[UILabel alloc] initWithFrame:CGRectMake(20, 5, 375, 20)];
            self.title.numberOfLines = 0;
            self.title.lineBreakMode = NSLineBreakByWordWrapping;
            self.title.font =[UIFont systemFontOfSize:16];
            self.title.textColor = [UIColor blackColor];
            self.title;
        })];
        
        [self.contentView addSubview:({
            self.remark = [[UILabel alloc] initWithFrame:CGRectMake(20, self.title.frame.size.height + 5, 375, 20)];
            self.remark.numberOfLines = 1;
            self.remark.font = [UIFont systemFontOfSize:12];
            self.remark.textColor = [UIColor lightGrayColor];
            self.remark;
        })];
        
        [self.contentView addSubview:({
            self.tagName = [[UILabel alloc] initWithFrame:CGRectMake(20, self.title.frame.size.height + 5 + self.remark.frame.size.height + 10, 375, 20)];
            self.tagName.font = [UIFont systemFontOfSize:14];
            self.tagName.textColor = [UIColor redColor];
            self.tagName;
        })];
        
        [self.contentView addSubview:({
            self.time = [[UILabel alloc] initWithFrame:CGRectMake(20, self.title.frame.size.height + 5 + self.remark.frame.size.height + 5 + self.tagName.frame.size.height + 5, 375, 20)];
            self.time.font = [UIFont systemFontOfSize:12];
            self.time.textColor = [UIColor blueColor];
            self.time;
        })];

    }
    
    return self;
}

- (void) layoutTableViewCell {
    self.title.text = @"我是一个任务，红红火火恍恍惚惚";
    self.remark.text = @"我是一个备注哦";
    self.tagName.text = @"紧急重要";
    self.time.text = @"明天, 07:00";
}

@end
