//
//  FirstViewController.m
//  little-todo-ios
//
//  Created by ybwdaisy on 2020/11/29.
//  Copyright © 2020 ybwdaisy. All rights reserved.
//

#import "FirstViewController.h"

@interface FirstViewController ()<UITableViewDelegate>

@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 设置搜索条
    UISearchBar *searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
    searchBar.placeholder = @"搜索";
    searchBar.backgroundColor = [UIColor systemGray6Color];
    searchBar.returnKeyType = UIReturnKeyGo;
    // 设置列表
    UITableView *tableView = [[UITableView alloc]initWithFrame:self.view.bounds];
    tableView.dataSource = self;
    tableView.delegate = self;
    
    tableView.tableHeaderView = searchBar;
    
    [self.view addSubview:tableView];
    
    // 监听搜索条值变化
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(searchBarTextChange:)
         name:UITextFieldTextDidChangeNotification
         object:searchBar.searchTextField];

}

- (void)searchBarTextChange:(NSNotification *)notification {
    UITextField *textfield = [notification object];
    NSLog(@"searchbar text is: %@",textfield.text);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleSubtitle) reuseIdentifier:cellId];
    }
    
    cell.imageView.image = [UIImage imageNamed:@"first"];
    cell.textLabel.text = [NSString stringWithFormat: @"标题 - %@", @(indexPath.row)];
    cell.detailTextLabel.text = @"副标题";
    
//    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushController)];
//    [cell addGestureRecognizer:tapGesture];

    return cell;
}

- (CGFloat)getStatusBarHeight {
    float statusBarHeight = 0;
    if (@available(iOS 13.0, *)) {
        UIStatusBarManager *statusBarManager = [UIApplication sharedApplication].windows.firstObject.windowScene.statusBarManager;
        statusBarHeight = statusBarManager.statusBarFrame.size.height;
    } else {
        statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
    }
    return statusBarHeight;
}

@end
 
