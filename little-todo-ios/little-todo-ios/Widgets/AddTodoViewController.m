//
//  AddTodoViewController.m
//  little-todo-ios
//
//  Created by ybw-macbook-pro on 2021/1/21.
//  Copyright © 2021 ybwdaisy. All rights reserved.
//

#import "AddTodoViewController.h"

@interface AddTodoViewController ()

@property(nonatomic, readwrite) UIColor *modalViewBgColor;
@property(nonatomic, readwrite) NSString *todoTitleText;
@property(nonatomic, readwrite) NSString *todoRemarkText;

@end

@implementation AddTodoViewController

- (instancetype)init {
    self = [super init];
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.modalViewBgColor = [[UIColor alloc]initWithRed:246/255.0 green:247/255.0 blue:249/255.0 alpha:1];
    
    self.todoTitleText = @"";
    self.todoRemarkText = @"";
    
    // 监听输入
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(onTodoTextChanged:) name:@"UITextViewTextDidChangeNotification" object:nil];
    
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
    
    [self.view addSubview:modalView];
    self.modalPresentationStyle = UIModalPresentationPopover;
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

- (void)addNewTodo {
    if ([self.todoTitleText isEqualToString:@""] || [self.todoRemarkText isEqualToString:@""]) {
        UIAlertController *checkAlert = [UIAlertController alertControllerWithTitle:@"标题和备注不能为空" message:nil preferredStyle:UIAlertControllerStyleAlert];
        [checkAlert addAction: [UIAlertAction actionWithTitle:@"好" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
            
        }]];
        [self presentViewController:checkAlert animated:YES completion:nil];
        
        return;
    }
    
    [self.addTodoVCDelegate addTodo:@{
        @"title": self.todoTitleText,
        @"remark": self.todoRemarkText,
        @"tagName": [self return16LetterAndNumber],
        @"time": @"明天, 09:00",
    }];
    self.todoTitleText = @"";
    self.todoRemarkText = @"";
    [self dismissViewControllerAnimated:YES completion:nil];
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
    
    [self presentViewController:actionSheet animated:YES completion:nil];
    
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
