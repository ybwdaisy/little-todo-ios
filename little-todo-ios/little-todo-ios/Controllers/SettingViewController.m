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
        self.tabBarItem.title = @"设置";
        self.tabBarItem.image = [UIImage imageNamed:@"setting_inactive"];
        self.tabBarItem.selectedImage = [UIImage imageNamed:@"setting_active"];
        self.title = @"设置";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.tabBarController.navigationItem.title = self.title;
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellId"];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cellId"];
    }
    
    UIImageView *rightIcon = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 40, 20, 20, 20)];
    rightIcon.image = [UIImage imageNamed:@"more"];
    
    if (indexPath.row == 0) {
        cell.textLabel.text = @"评价应用";
        [cell.contentView addSubview:rightIcon];
    } else if (indexPath.row == 1) {
        cell.textLabel.text = @"反馈与建议";
        [cell.contentView addSubview:rightIcon];
    } else if (indexPath.row == 2) {
        cell.textLabel.text = @"关于我们";
        [cell.contentView addSubview:rightIcon];
    }
    
    
    return cell;
}

@end
