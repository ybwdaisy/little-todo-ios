//
//  TDTableViewCell.m
//  little-todo-ios
//
//  Created by ybwdaisy on 2020/12/14.
//  Copyright © 2020 ybwdaisy. All rights reserved.
//

#import "TDTableViewCell.h"
#import <PureLayout/PureLayout.h>

#define kLabelHorizontalInsets      15.0f
#define kLabelVerticalInsets        10.0f

@interface TDTableViewCell ()

@property(nonatomic, strong, readwrite) UILabel *title;
@property(nonatomic, strong, readwrite) UILabel *remark;
@property(nonatomic, strong, readwrite) UILabel *time;
@property (nonatomic, assign) BOOL didSetupConstraints;

@end

@implementation TDTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.title = [UILabel newAutoLayoutView];
        self.title.numberOfLines = 0;
        self.title.font =[UIFont systemFontOfSize:16];
        self.title.textColor = [UIColor blackColor];
        self.title.lineBreakMode = NSLineBreakByTruncatingTail;
        
        self.remark = [UILabel newAutoLayoutView];
        self.remark.numberOfLines = 0;
        self.remark.font = [UIFont systemFontOfSize:12];
        self.remark.textColor = [UIColor lightGrayColor];
        self.remark.lineBreakMode = NSLineBreakByTruncatingTail;
        
        self.time = [UILabel newAutoLayoutView];
        self.time.numberOfLines = 0;
        self.time.font = [UIFont systemFontOfSize:16];
        self.time.textColor = [UIColor systemBlueColor];
        self.time.lineBreakMode = NSLineBreakByTruncatingTail;


        [self.contentView addSubview:self.title];
        [self.contentView addSubview:self.remark];
        [self.contentView addSubview:self.time];
    }
    
    return self;
}

- (void)layoutTableViewCell:(TodoItem *)data {
    self.title.text = data.title;
    self.remark.text = data.remark;
    self.time.text = [data.datetime stringByAppendingFormat:@"，%@", data.repeat];
}

- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (void)updateConstraints
{
    if (!self.didSetupConstraints) {

        if (self.title.text) {
            [NSLayoutConstraint autoSetPriority:UILayoutPriorityRequired forConstraints:^{
                [self.title autoSetContentCompressionResistancePriorityForAxis:ALAxisVertical];
            }];
            [self.title autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:kLabelVerticalInsets];
            [self.title autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:kLabelHorizontalInsets];
            [self.title autoPinEdgeToSuperviewEdge:ALEdgeTrailing withInset:kLabelHorizontalInsets];
        }
        
        if (self.remark.text) {
            if (self.title.text) {
                [self.remark autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.title withOffset:kLabelVerticalInsets];
            }
            
            [NSLayoutConstraint autoSetPriority:UILayoutPriorityRequired forConstraints:^{
                [self.remark autoSetContentCompressionResistancePriorityForAxis:ALAxisVertical];
            }];
            if (!self.title.text) {
                [self.remark autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:kLabelVerticalInsets];
            }
            [self.remark autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:kLabelHorizontalInsets];
            [self.remark autoPinEdgeToSuperviewEdge:ALEdgeTrailing withInset:kLabelHorizontalInsets];
            if (!self.time.text) {
                [self.remark autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:kLabelVerticalInsets];
            }
        }
        
        if (self.time.text) {
            [self.time autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.remark.text ? self.remark : self.title withOffset:kLabelVerticalInsets];
            
            [NSLayoutConstraint autoSetPriority:UILayoutPriorityRequired forConstraints:^{
                [self.time autoSetContentCompressionResistancePriorityForAxis:ALAxisVertical];
            }];
            [self.time autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:kLabelHorizontalInsets];
            [self.time autoPinEdgeToSuperviewEdge:ALEdgeTrailing withInset:kLabelHorizontalInsets];
            [self.time autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:kLabelVerticalInsets];
        }
        
        self.didSetupConstraints = YES;
    }
    
    [super updateConstraints];
}

@end
