//
//  FirstViewController.m
//  little-todo-ios
//
//  Created by ybwdaisy on 2020/11/29.
//  Copyright © 2020 ybwdaisy. All rights reserved.
//

#import "FirstViewController.h"

@interface FirstViewController ()

@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 设置导航条
    UINavigationBar *navigationBar = [[UINavigationBar alloc]initWithFrame:CGRectMake(0, [self getStatusBarHeight], self.view.frame.size.width, 44)];
    UINavigationItem *navigationItem = [[UINavigationItem alloc]initWithTitle:@"收件箱"];
    [navigationBar setItems:@[navigationItem]];
    [self.view addSubview:navigationBar];
    // 设置搜索条
    UISearchBar *searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 110, self.view.frame.size.width, 40)];
    searchBar.placeholder = @"搜索";
    searchBar.backgroundColor = [UIColor systemGray6Color];
    searchBar.returnKeyType = UIReturnKeyGo;
    [self.view addSubview:searchBar];
    // 设置列表
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 170, self.view.frame.size.width, 1000)];
    tableView.dataSource = self;
    tableView.delegate = self;
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellId = @"cellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleSubtitle) reuseIdentifier:cellId];
    }
    [cell.textLabel setText:@"标题"];
    [cell.detailTextLabel setText:@"副标题"];

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
 
