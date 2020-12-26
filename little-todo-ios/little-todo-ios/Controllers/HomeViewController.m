//
//  HomeViewController.m
//  little-todo-ios
//
//  Created by ybwdaisy on 2020/11/29.
//  Copyright © 2020 ybwdaisy. All rights reserved.
//

#import "HomeViewController.h"
#import "TDTableViewCell.h"

@interface HomeViewController ()<UITableViewDelegate>

@end

@implementation HomeViewController

- (instancetype) init {
    self = [super init];
    if (self) {
        self.tabBarItem.title = @"首页";
        self.tabBarItem.image = [UIImage imageNamed:@"home_inactive"];
        self.tabBarItem.selectedImage = [UIImage imageNamed:@"home_active"];
        self.title = @"收件箱";
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:nil];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.tabBarController.navigationItem.title = self.title;
    self.tabBarController.navigationItem.rightBarButtonItem = self.navigationItem.rightBarButtonItem;

    // 设置列表
    UITableView *tableView = [[UITableView alloc]initWithFrame:self.view.bounds];
    tableView.dataSource = self;
    tableView.delegate = self;
    
    [self.view addSubview:tableView];

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 120;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UIViewController *viewController = [[UIViewController alloc] init];
    viewController.view.backgroundColor = [UIColor whiteColor];
    viewController.navigationItem.title = [NSString stringWithFormat: @"内容 - %@", @(indexPath.row)];

    viewController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:nil];

    [self.navigationController pushViewController:viewController animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellId = @"cellId";
    TDTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[TDTableViewCell alloc] initWithStyle:(UITableViewCellStyleSubtitle) reuseIdentifier:cellId];
    }
    
    [cell layoutTableViewCell];
    
    return cell;
}

- (nullable UISwipeActionsConfiguration *)tableView:(UITableView *)tableView leadingSwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath API_AVAILABLE(ios(11.0)) API_UNAVAILABLE(tvos) {
    
    UIContextualAction *leadingAction = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleNormal title:@"Done" handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
        NSLog(@"todo item done");
    }];
    leadingAction.backgroundColor = [UIColor colorWithRed:58.0f/255.0f green:197.0f/255.0f blue:105.0f/255.0f alpha:1];
    UISwipeActionsConfiguration *config = [UISwipeActionsConfiguration configurationWithActions:@[leadingAction]];
    config.performsFirstActionWithFullSwipe = NO;
    return config;
}
- (nullable UISwipeActionsConfiguration *)tableView:(UITableView *)tableView trailingSwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath API_AVAILABLE(ios(11.0)) API_UNAVAILABLE(tvos) {
    UIContextualAction *trailingDeleteAction = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleDestructive title:@"Delete" handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
        NSLog(@"todo item delete");
    }];
    UIContextualAction *trailingTopAction = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleNormal title:@"Top" handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
        NSLog(@"todo item top");
    }];
    trailingTopAction.backgroundColor = [UIColor colorWithRed:248.0f/255.0f green:128.0f/255.0f blue:66.0f/255.0f alpha:1];
    UISwipeActionsConfiguration *config = [UISwipeActionsConfiguration configurationWithActions:@[trailingDeleteAction,trailingTopAction]];
    config.performsFirstActionWithFullSwipe = NO;
    return config;
}

@end
 
