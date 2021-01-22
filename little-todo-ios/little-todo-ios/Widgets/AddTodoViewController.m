//
//  AddTodoViewController.m
//  little-todo-ios
//
//  Created by ybw-macbook-pro on 2021/1/21.
//  Copyright © 2021 ybwdaisy. All rights reserved.
//

#import "AddTodoViewController.h"

@interface AddTodoViewController ()

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
    
    self.todoTitleText = @"";
    self.todoRemarkText = @"";
    
    // 监听输入
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(onTodoTextChanged:) name:@"UITextViewTextDidChangeNotification" object:nil];
    
    UIView *modalView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    modalView.backgroundColor = [[UIColor alloc]initWithRed:246/255.0 green:247/255.0 blue:249/255.0 alpha:1];
    
    CGFloat modelViewInnerWidth = self.view.frame.size.width - 40;
    
    // 顶部视图
    UIButton *headerLeftButton = [self makeButtonWidthTitleAndAction:@"取消" action:@selector(cancelAddTodo)];
    
    UILabel *headerTitle = [[UILabel alloc]init];
    headerTitle.text = @"新建代办事项";
    headerTitle.font = [UIFont boldSystemFontOfSize:18];
    [headerTitle setTextAlignment:NSTextAlignmentCenter];
    
    UIButton *headerRightButton = [self makeButtonWidthTitleAndAction:@"添加" action:@selector(addNewTodo)];
    
    UIStackView *headerView = [[UIStackView alloc]initWithArrangedSubviews:@[headerLeftButton, headerTitle, headerRightButton]];
    [headerView setFrame:CGRectMake(20, 10, modelViewInnerWidth, 50)];
    headerView.axis = UILayoutConstraintAxisHorizontal;
    headerView.alignment = UIStackViewAlignmentCenter;
    headerView.distribution = UIStackViewDistributionEqualSpacing;
    
    [modalView addSubview:headerView];
    
    // 标题和备注视图
    UITextView *titleTextView = [self makeTextView:1 placeholderText:@"标题" height:40.0];
    
    UIView *divideLine = [[UIView alloc]init];
    [divideLine.heightAnchor constraintEqualToConstant:0.5].active = TRUE;
    divideLine.backgroundColor = [[UIColor alloc]initWithRed:220/255.0f green:220/255.0f blue:220/255.0f alpha:1];
    
    UITextView *remarkTextView = [self makeTextView:2 placeholderText:@"备注" height:0.0];
    
    UIStackView *topSectionView = [[UIStackView alloc]initWithArrangedSubviews:@[titleTextView, divideLine, remarkTextView]];
    topSectionView.backgroundColor = [UIColor whiteColor];
    topSectionView.layer.cornerRadius = 10;
    [topSectionView setFrame:CGRectMake(20, 100, modelViewInnerWidth, 160.5)];

    topSectionView.spacing = 0;
    topSectionView.axis = UILayoutConstraintAxisVertical;
    
    [modalView addSubview:topSectionView];
    
    [self.view addSubview:modalView];
    self.modalPresentationStyle = UIModalPresentationPopover;
}

- (UITextView *)makeTextView:(int)tag placeholderText:(NSString *)placeholderText height:(double)height {
    UITextView *textView = [[UITextView alloc]init];
    if (height) {
        [textView.heightAnchor constraintEqualToConstant:height].active = TRUE;
    }
    textView.tag = tag;
    textView.text = @"";
    textView.editable = YES;
    textView.font = [UIFont systemFontOfSize:16];
    
    UILabel *placeholder = [[UILabel alloc] init];
    placeholder.text = placeholderText;
    placeholder.numberOfLines = 0;
    placeholder.textColor = [UIColor lightGrayColor];
    placeholder.font = [UIFont systemFontOfSize:16];
    [placeholder sizeToFit];
    
    [textView addSubview:placeholder];
    [textView setValue:placeholder forKey:@"_placeholderLabel"];
    return textView;
}

- (UIButton *)makeButtonWidthTitleAndAction:(NSString *)name action:(nullable SEL)action {
    UIButton *button = [[UIButton alloc]init];
    [button setTitle:name forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [button.heightAnchor constraintEqualToConstant:50].active = TRUE;
    [button.widthAnchor constraintEqualToConstant:50].active = TRUE;
    
    UITapGestureRecognizer *tapCancelAddTodo = [[UITapGestureRecognizer alloc]initWithTarget:self action:action];
    [button addGestureRecognizer:tapCancelAddTodo];
    return button;
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
