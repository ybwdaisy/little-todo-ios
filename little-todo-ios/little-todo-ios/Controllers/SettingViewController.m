//
//  SettingViewController.m
//  little-todo-ios
//
//  Created by ybwdaisy on 2020/11/29.
//  Copyright © 2020 ybwdaisy. All rights reserved.
//

#import "SettingViewController.h"

@interface SettingViewController ()<UITableViewDelegate>

@end

@implementation SettingViewController

- (instancetype) init {
    self = [super init];
    if (self) {
        self.tabBarItem.image = [UIImage imageNamed:@"setting_inactive"];
        self.tabBarItem.selectedImage = [UIImage imageNamed:@"setting_active"];
        
        self.navigationItem.title = @"设置";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    tableView.dataSource = self;
    tableView.delegate = self;
    
    [self.view addSubview:tableView];
    
}

#pragma mark TableView Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellId"];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellId"];
    }
    
    FAKFontAwesome *angleRightIcon = [FAKFontAwesome angleRightIconWithSize:20];
    UIImage *angleRightIconImage = [angleRightIcon imageWithSize:CGSizeMake(20, 20)];
    
    UIImageView *rightIcon = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 40, 20, 20, 20)];
    rightIcon.image = angleRightIconImage;
    
    if (indexPath.row <= 2) {
        [cell.contentView addSubview:rightIcon];
    }
    
    if (indexPath.row == 0) {
        cell.textLabel.text = @"评价应用";
        FAKFontAwesome *heartOIcon = [FAKFontAwesome heartOIconWithSize:20];
        UIImage *heartOIconImage = [heartOIcon imageWithSize:CGSizeMake(20, 20)];
        cell.imageView.image = heartOIconImage;
    } else if (indexPath.row == 1) {
        cell.textLabel.text = @"反馈与建议";
        FAKFontAwesome *envelopeOIcon = [FAKFontAwesome envelopeOIconWithSize:20];
        UIImage *envelopeOIconImage = [envelopeOIcon imageWithSize:CGSizeMake(20, 20)];
        cell.imageView.image = envelopeOIconImage;
    } else if (indexPath.row == 2) {
        cell.textLabel.text = @"关于我们";
        FAKFontAwesome *handPointerOIcon = [FAKFontAwesome handPointerOIconWithSize:20];
        UIImage *handPointerOIconImage = [handPointerOIcon imageWithSize:CGSizeMake(20, 20)];
        cell.imageView.image = handPointerOIconImage;
    }
    
    return cell;
}

@end
