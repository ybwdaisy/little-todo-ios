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
@property(nonatomic, readwrite) UIViewController *addTodoViewController;
@property(nonatomic, readwrite) UIColor *modalViewBgColor;
@property(nonatomic, readwrite) NSString *todoTitleText;
@property(nonatomic, readwrite) NSString *todoRemarkText;

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
    
    self.modalViewBgColor = [[UIColor alloc]initWithRed:246/255.0 green:247/255.0 blue:249/255.0 alpha:1];
    
    self.todoListData = [[NSMutableArray alloc]init];
    [self.todoListData addObject:@{
        @"title": [[NSString alloc]initWithFormat:@"我是标题，哈哈哈%@", [self return16LetterAndNumber]],
        @"remark": [self return16LetterAndNumber],
        @"tagName": @"紧急任务",
        @"time": @"明天, 07:00",
    }];
    
    self.todoTitleText = @"";
    self.todoRemarkText = @"";

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
    UITapGestureRecognizer *tapAddTodo = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAddTodoButton)];
    [self.plusButtonContainerView addGestureRecognizer:tapAddTodo];
    
    [self.plusButtonContainerView addSubview:plusIconImageView];
    [self.view addSubview:self.plusButtonContainerView];
    
    // 监听输入
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(onTodoTextChanged:) name:@"UITextViewTextDidChangeNotification" object:nil];

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 120;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"didSelectRow, %d", indexPath.row);
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
    UIViewController *addTodoViewController = [[UIViewController alloc]init];
    
    UIView *modalView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    modalView.backgroundColor = self.modalViewBgColor;
    
    CGFloat modelViewInnerWidth = self.view.frame.size.width - 40;
    
    UIButton *headerLeftButton = [[UIButton alloc]init];
    [headerLeftButton setTitle:@"取消" forState:UIControlStateNormal];
    [headerLeftButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [headerLeftButton.heightAnchor constraintEqualToConstant:50].active = TRUE;
    [headerLeftButton.widthAnchor constraintEqualToConstant:50].active = TRUE;
    
    UITapGestureRecognizer *tapCancelAddTodo = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cancelAddTodo)];
    [headerLeftButton addGestureRecognizer:tapCancelAddTodo];
    
    UILabel *headerTitle = [[UILabel alloc]init];
    headerTitle.text = @"新建代办事项";
    headerTitle.font = [UIFont boldSystemFontOfSize:18];
    [headerTitle setTextAlignment:NSTextAlignmentCenter];
    
    UIButton *headerRightButton = [[UIButton alloc]init];
    [headerRightButton setTitle:@"添加" forState:UIControlStateNormal];
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
    
    UIView *topSectionView = [[UIView alloc]initWithFrame:CGRectMake(20, 70, modelViewInnerWidth, 180.5)];
    topSectionView.backgroundColor = [UIColor whiteColor];
    topSectionView.layer.cornerRadius = 6;
    
    UITextView *titleTextView = [[UITextView alloc]initWithFrame:CGRectMake(10, 10, topSectionView.frame.size.width - 20, 40) textContainer:nil];
    titleTextView.tag = 1;
    titleTextView.text = @"";
    titleTextView.editable = YES;
    titleTextView.font = [UIFont systemFontOfSize:16];
    UILabel *titlePlaceholder = [self makePlaceholderWithTitle:@"标题"];
    [titleTextView addSubview:titlePlaceholder];
    [titleTextView setValue:titlePlaceholder forKey:@"_placeholderLabel"];
    [topSectionView addSubview:titleTextView];
    
    UIView *divideLineView = [[UIView alloc] initWithFrame:CGRectMake(10, 60, topSectionView.frame.size.width - 20, 0.5)];
    divideLineView.backgroundColor = [UIColor lightGrayColor];
    [topSectionView addSubview:divideLineView];
    
    UITextView *remarkTextView = [[UITextView alloc]initWithFrame:CGRectMake(10, 70.5, topSectionView.frame.size.width - 20, 100) textContainer:nil];
    remarkTextView.tag = 2;
    remarkTextView.text = @"";
    remarkTextView.editable = YES;
    remarkTextView.font = [UIFont systemFontOfSize:16];
    UILabel *remarkPlaceholder = [self makePlaceholderWithTitle:@"备注"];
    [remarkTextView addSubview:remarkPlaceholder];
    [remarkTextView setValue:remarkPlaceholder forKey:@"_placeholderLabel"];
    [topSectionView addSubview:remarkTextView];
    
    [modalView addSubview:topSectionView];
    
    [addTodoViewController.view addSubview:modalView];
    addTodoViewController.modalPresentationStyle = UIModalPresentationPopover;
    
    self.addTodoViewController = addTodoViewController;
    
    [self presentViewController:addTodoViewController animated:YES completion:nil];
}

- (void)addNewTodo {
    if ([self.todoTitleText isEqualToString:@""] || [self.todoRemarkText isEqualToString:@""]) {
        UIAlertController *checkAlert = [UIAlertController alertControllerWithTitle:@"标题和备注不能为空" message:nil preferredStyle:UIAlertControllerStyleAlert];
        [checkAlert addAction: [UIAlertAction actionWithTitle:@"好" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
            
        }]];
        [self.addTodoViewController presentViewController:checkAlert animated:YES completion:nil];
        
        return;
    }
    [self.todoListData addObject:@{
        @"title": self.todoTitleText,
        @"remark": self.todoRemarkText,
        @"tagName": [self return16LetterAndNumber],
        @"time": @"明天, 09:00",
    }];
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.todoTableView reloadData];
    self.todoTitleText = @"";
    self.todoRemarkText = @"";
}

- (void)cancelAddTodo {
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [actionSheet addAction: [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [actionSheet addAction: [UIAlertAction actionWithTitle:@"放弃更改" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        self.todoTitleText = @"";
        self.todoRemarkText = @"";
        [self dismissViewControllerAnimated:YES completion:nil];
    }]];
    
    [self.addTodoViewController presentViewController:actionSheet animated:YES completion:nil];
    
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

- (UILabel *)makePlaceholderWithTitle:(NSString *)title {
    UILabel *placeholder = [[UILabel alloc] init];
    placeholder.text = title;
    placeholder.numberOfLines = 0;
    placeholder.textColor = [UIColor lightGrayColor];
    placeholder.font = [UIFont systemFontOfSize:16];
    [placeholder sizeToFit];
    
    return placeholder;
}

- (void)onTodoTextChanged:(NSNotification *)obj {
    UITextView *todoTextView = (UITextView *)obj.object;
    if (todoTextView.tag == 1) {
        self.todoTitleText = todoTextView.text;
    }
    if (todoTextView.tag == 2) {
        self.todoRemarkText = todoTextView.text;
    }
}

@end
 
