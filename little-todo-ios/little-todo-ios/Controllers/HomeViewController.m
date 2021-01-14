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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.todoListData = [[NSMutableArray alloc]init];
    [self.todoListData addObject:@{
        @"title": [[NSString alloc]initWithFormat:@"我是标题，哈哈哈%@", [self return16LetterAndNumber]],
        @"remark": [self return16LetterAndNumber],
        @"tagName": @"紧急任务",
        @"time": @"明天, 07:00",
    }];
    [self.todoListData addObject:@{
        @"title": [[NSString alloc]initWithFormat:@"我是标题，哈哈哈%@", [self return16LetterAndNumber]],
        @"remark": [self return16LetterAndNumber],
        @"tagName": @"",
        @"time": @"明天, 08:00",
    }];

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
    self.plusButtonContainerView.backgroundColor = UIColor.orangeColor;
    self.plusButtonContainerView.layer.cornerRadius = 25;
    
    plusIconImageView.center = CGPointMake(self.plusButtonContainerView.frame.size.width / 2, self.plusButtonContainerView.frame.size.height / 2);
    
    // 添加事件
    UITapGestureRecognizer *tapAddTodo = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(addNewTodo)];
    [self.plusButtonContainerView addGestureRecognizer:tapAddTodo];
    
    [self.plusButtonContainerView addSubview:plusIconImageView];
    [self.view addSubview:self.plusButtonContainerView];

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
        // 指定的任务放最上面
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

- (void)viewSafeAreaInsetsDidChange NS_REQUIRES_SUPER API_AVAILABLE(ios(11.0), tvos(11.0)) {
    [super viewSafeAreaInsetsDidChange];
    [self.plusButtonContainerView setFrame:CGRectMake(self.view.frame.size.width - 80, self.view.frame.size.height - self.view.safeAreaInsets.bottom - 80, 50, 50)];
}

- (void)tapAddTodoButton {
    UIViewController *modalViewController = [[UIViewController alloc]init];
    
    UIView *modalView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    modalView.backgroundColor = [UIColor whiteColor];
    
    CGFloat modelViewInnerWidth = self.view.frame.size.width - 40;
    
    UIButton *headerLeftButton = [[UIButton alloc]init];
    [headerLeftButton setTitle:@"取消" forState:UIControlStateNormal];
    [headerLeftButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [headerLeftButton.heightAnchor constraintEqualToConstant:50].active = TRUE;
    [headerLeftButton.widthAnchor constraintEqualToConstant:50].active = TRUE;
    
    UILabel *headerTitle = [[UILabel alloc]init];
    headerTitle.text = @"新建代办";
    headerTitle.font = [UIFont boldSystemFontOfSize:18];
    [headerTitle setTextAlignment:NSTextAlignmentCenter];
    
    UIButton *headerRightButton = [[UIButton alloc]init];
    [headerRightButton setTitle:@"确认" forState:UIControlStateNormal];
    [headerRightButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [headerRightButton.heightAnchor constraintEqualToConstant:50].active = TRUE;
    [headerRightButton.widthAnchor constraintEqualToConstant:50].active = TRUE;
    
    UITapGestureRecognizer *tapAddNewTodo = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(addNewTodo)];
    [headerRightButton addGestureRecognizer:tapAddNewTodo];
    
    UIStackView *headerView = [[UIStackView alloc]initWithArrangedSubviews:@[headerLeftButton, headerTitle, headerRightButton]];
    [headerView setFrame:CGRectMake(20, 10, modelViewInnerWidth, 50)];
    headerView.axis = UILayoutConstraintAxisHorizontal;
    headerView.alignment = UIStackViewAlignmentCenter;
    headerView.distribution = UIStackViewDistributionEqualSpacing;
    
    [modalView addSubview:headerView];
    
    UITextView *textView = [[UITextView alloc]initWithFrame:CGRectMake(20, 70, modelViewInnerWidth, self.view.frame.size.height) textContainer:nil];
    textView.text = @"请输入代办事项";
    textView.editable = YES;
    textView.font = [UIFont systemFontOfSize:16];
    [modalView addSubview:textView];
    
    [modalViewController.view addSubview:modalView];
    modalViewController.modalPresentationStyle = UIModalPresentationPopover;
    [self presentViewController:modalViewController animated:YES completion:nil];
}

- (void)addNewTodo {
    [self.todoListData addObject:@{
        @"title": [[NSString alloc]initWithFormat:@"我是标题，哈哈哈%@", [self return16LetterAndNumber]],
        @"remark": [self return16LetterAndNumber],
        @"tagName": @"普通任务",
        @"time": @"明天, 09:00",
    }];
    [self.todoTableView reloadData];
}

- (NSString *)return16LetterAndNumber{
    NSString * strAll = @"0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
    NSString * result = [[NSMutableString alloc]initWithCapacity:16];
    for (int i = 0; i < 16; i++) {
        NSInteger index = arc4random() % (strAll.length-1);
        char tempStr = [strAll characterAtIndex:index];
        result = (NSMutableString *)[result stringByAppendingString:[NSString stringWithFormat:@"%c",tempStr]];
    }
    return result;
}


@end
 
