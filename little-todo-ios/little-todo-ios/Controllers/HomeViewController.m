//
//  HomeViewController.m
//  little-todo-ios
//
//  Created by ybwdaisy on 2020/11/29.
//  Copyright © 2020 ybwdaisy. All rights reserved.
//

#import "HomeViewController.h"
#import "TDTableViewCell.h"
#import "AddTodoViewController.h"

@interface HomeViewController ()<UITableViewDelegate, AddTodoVCDelegate>

@property(nonatomic, readwrite) UITableView *todoTableView;
@property(nonatomic, readwrite) NSMutableArray *todoListData;
@property(nonatomic, readwrite) UIView *plusButtonContainerView;

@end

@implementation HomeViewController

- (instancetype) init {
    self = [super init];
    if (self) {
        self.tabBarItem.image = [UIImage imageNamed:@"home_inactive"];
        self.tabBarItem.selectedImage = [UIImage imageNamed:@"home_active"];
        
        self.navigationItem.title = @"收件箱";
        FAKFontAwesome *barsIcon = [FAKFontAwesome barsIconWithSize:20];
        UIImage *barsIconImage = [barsIcon imageWithSize:CGSizeMake(20, 20)];
        self.navigationItem.rightBarButtonItem =[[UIBarButtonItem alloc] initWithImage:barsIconImage style:UIBarButtonItemStylePlain target:self action:nil];
        self.navigationItem.rightBarButtonItem.tintColor = [UIColor blackColor];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"UITextViewTextDidChangeNotification" object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.todoListData = [[NSMutableArray alloc]init];

    // 设置列表
    UITableView *tableView = [[UITableView alloc]initWithFrame:self.view.bounds];
    tableView.dataSource = self;
    tableView.delegate = self;
    self.todoTableView = tableView;
    [self.view addSubview:tableView];
    
    // 添加按钮
    FAKFontAwesome *plusIcon = [FAKFontAwesome plusIconWithSize:20];
    [plusIcon addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor]];
    UIImageView *plusIconImageView = [[UIImageView alloc] initWithImage:[plusIcon imageWithSize:CGSizeMake(20, 20)]];
    
    self.plusButtonContainerView = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.size.width, self.view.frame.size.height, 50, 50)];
    self.plusButtonContainerView.backgroundColor = [[UIColor alloc]initWithRed:10/255.0 green:95/255.0 blue:240/255.0 alpha:1];
    self.plusButtonContainerView.layer.cornerRadius = 25;
    
    plusIconImageView.center = CGPointMake(self.plusButtonContainerView.frame.size.width / 2, self.plusButtonContainerView.frame.size.height / 2);
    
    // 添加事件
    UITapGestureRecognizer *tapAddTodo = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAddTodoButton)];
    [self.plusButtonContainerView addGestureRecognizer:tapAddTodo];
    
    [self.plusButtonContainerView addSubview:plusIconImageView];
    [self.view addSubview:self.plusButtonContainerView];

}

#pragma mark TableView Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 120;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"didSelectRow, %ld", (long)indexPath.row);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.todoListData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellId = @"cellId";
    TDTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[TDTableViewCell alloc] initWithStyle:(UITableViewCellStyleSubtitle) reuseIdentifier:cellId];
    }
    [cell layoutTableViewCell:[self.todoListData objectAtIndex:indexPath.row]];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (nullable UISwipeActionsConfiguration *)tableView:(UITableView *)tableView leadingSwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath API_AVAILABLE(ios(11.0)) API_UNAVAILABLE(tvos) {
    
    UIContextualAction *leadingAction = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleNormal title:@"Done" handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
        // 完成的任务放在最后面
        if (indexPath.row < [self.todoListData count] - 1) {
            [self.todoListData exchangeObjectAtIndex:indexPath.row withObjectAtIndex: [self.todoListData count] - 1];
            [self.todoTableView reloadData];
        }
    }];
    leadingAction.backgroundColor = [UIColor colorWithRed:58.0f/255.0f green:197.0f/255.0f blue:105.0f/255.0f alpha:1];
    UISwipeActionsConfiguration *config = [UISwipeActionsConfiguration configurationWithActions:@[leadingAction]];
    config.performsFirstActionWithFullSwipe = NO;
    return config;
}

- (nullable UISwipeActionsConfiguration *)tableView:(UITableView *)tableView trailingSwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath API_AVAILABLE(ios(11.0)) API_UNAVAILABLE(tvos) {
    UIContextualAction *trailingDeleteAction = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleDestructive title:@"Delete" handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
        [self.todoListData removeObjectAtIndex:indexPath.row];
        [self.todoTableView reloadData];
    }];
    UIContextualAction *trailingTopAction = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleNormal title:@"Top" handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
        // 置顶的任务放最上面
        if (indexPath.row > 0) {
            [self.todoListData exchangeObjectAtIndex:indexPath.row withObjectAtIndex: 0];
            [self.todoTableView reloadData];
        }
    }];
    trailingTopAction.backgroundColor = [UIColor colorWithRed:248.0f/255.0f green:128.0f/255.0f blue:66.0f/255.0f alpha:1];
    UISwipeActionsConfiguration *config = [UISwipeActionsConfiguration configurationWithActions:@[trailingDeleteAction,trailingTopAction]];
    config.performsFirstActionWithFullSwipe = NO;
    return config;
}

#pragma mark SafeAreaInsets

- (void)viewSafeAreaInsetsDidChange NS_REQUIRES_SUPER API_AVAILABLE(ios(11.0), tvos(11.0)) {
    [super viewSafeAreaInsetsDidChange];
    [self.plusButtonContainerView setFrame:CGRectMake(self.view.frame.size.width - 80, self.view.frame.size.height - self.view.safeAreaInsets.bottom - 80, 50, 50)];
}

#pragma mark Custom Gesture Event

- (void)tapAddTodoButton {
    AddTodoViewController *addTodoViewController = [[AddTodoViewController alloc]init];
    
    addTodoViewController.addTodoVCDelegate = self;
    
    [self presentViewController:addTodoViewController animated:YES completion:nil];
}

- (void)addTodo:(NSDictionary *)todo {
    [self.todoListData addObject:todo];
    [self.todoTableView reloadData];
}

@end
 
