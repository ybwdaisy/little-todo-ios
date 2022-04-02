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
@property(nonatomic, readwrite) NSString *todoDateTimeText;
@property(nonatomic, readwrite) UIDatePicker *datePicker;
@property(nonatomic, readwrite) NSArray *priorityList;
@property(nonatomic, readwrite) NSString *todoPriorityText;
@property(nonatomic, readwrite) UIButton *priorityButton;

@end

@implementation AddTodoViewController

- (instancetype)init {
    self = [super init];
    return self;
}

-(instancetype)initWithData:(NSDictionary *)data {
    self = [super init];
    if (self) {
        self.todoTitleText = [data objectForKey:@"title"];
        self.todoRemarkText = [data objectForKey:@"remark"];
        self.todoDateTimeText = [data objectForKey:@"time"];
        self.todoPriorityText = [data objectForKey:@"tagName"];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.priorityList = [[NSArray alloc] initWithObjects:@"低", @"中", @"高", nil];
    
    // 监听输入
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(onTodoTextChanged:) name:@"UITextViewTextDidChangeNotification" object:nil];
    
    UIView *modalView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    modalView.backgroundColor = [[UIColor alloc]initWithRed:246/255.0 green:247/255.0 blue:249/255.0 alpha:1];
    
    CGFloat modelViewInnerWidth = self.view.frame.size.width - 40;
    
    // 顶部视图
    UIButton *headerLeftButton = [self makeButtonWidthTitleAndAction:@"取消" action:@selector(cancelAddTodo)];
    
    UILabel *headerTitle = [[UILabel alloc]init];
    headerTitle.text = @"新建待办事项";
    headerTitle.font = [UIFont boldSystemFontOfSize:18];
    [headerTitle setTextAlignment:NSTextAlignmentCenter];
    
    UIButton *headerRightButton = [self makeButtonWidthTitleAndAction:@"添加" action:@selector(addNewTodo)];
    
    UIStackView *headerView = [[UIStackView alloc]initWithArrangedSubviews:@[headerLeftButton, headerTitle, headerRightButton]];
    [headerView setFrame:CGRectMake(20, 10, modelViewInnerWidth, 50)];
    headerView.axis = UILayoutConstraintAxisHorizontal;
    headerView.alignment = UIStackViewAlignmentCenter;
    headerView.distribution = UIStackViewDistributionEqualSpacing;
    
    [modalView addSubview:headerView];
    
    // 标题和备注模块
    UITextView *titleTextView = [self makeTextView:1 value:self.todoTitleText placeholderText:@"标题" height:40.0];
    
    UIView *divideLine = [[UIView alloc]init];
    [divideLine.heightAnchor constraintEqualToConstant:0.5].active = TRUE;
    divideLine.backgroundColor = [[UIColor alloc]initWithRed:220/255.0f green:220/255.0f blue:220/255.0f alpha:1];
    
    UITextView *remarkTextView = [self makeTextView:2 value:self.todoRemarkText placeholderText:@"备注" height:40.0];
    
    UIStackView *inputSectionView = [[UIStackView alloc]initWithArrangedSubviews:@[titleTextView, divideLine, remarkTextView]];
    inputSectionView.backgroundColor = [UIColor whiteColor];
    inputSectionView.spacing = 0;
    inputSectionView.axis = UILayoutConstraintAxisVertical;
    [inputSectionView.heightAnchor constraintEqualToConstant:80].active = TRUE;
    
    // 日期与时间模块
    
    UIDatePicker *datePicker = [[UIDatePicker alloc]init];
    datePicker.locale = [NSLocale localeWithLocaleIdentifier:@"zh"];
    datePicker.datePickerMode = UIDatePickerModeDateAndTime;
    datePicker.minuteInterval = 5;
    if (self.todoDateTimeText) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        formatter.dateFormat = @"yyyy/MM/dd HH:mm";
        NSDate *date = [formatter dateFromString:self.todoDateTimeText];
        [datePicker setDate:date];
    }
    // 初始值
    [self dateChange:datePicker];
    // 监听时间变化
    [datePicker addTarget:self action:@selector(dateChange:) forControlEvents:UIControlEventValueChanged];
    
    UILabel *datePickerTitle = [[UILabel alloc]init];
    datePickerTitle.text = @"日期与时间";
    
    UIStackView *datePickerSectionView = [[UIStackView alloc]initWithArrangedSubviews:@[datePickerTitle, datePicker]];
    datePickerSectionView.axis = UILayoutConstraintAxisHorizontal;
    datePickerSectionView.spacing = 10;
    [datePickerSectionView.heightAnchor constraintEqualToConstant:50].active = TRUE;
    
    // 优先级模块
    
    UILabel *priorityTitle = [[UILabel alloc]init];
    priorityTitle.text = @"优先级";
    UIButton *priorityButton = [self makeButtonWidthTitleAndAction:self.todoPriorityText ? self.todoPriorityText : @"请选择" action:@selector(selectPriority)];
    self.priorityButton = priorityButton;
    
    UIStackView *prioritySectionView = [[UIStackView alloc]initWithArrangedSubviews:@[priorityTitle, priorityButton]];
    prioritySectionView.axis = UILayoutConstraintAxisHorizontal;
    [prioritySectionView.heightAnchor constraintEqualToConstant:50].active = TRUE;
    
    // 对所有子元素整体布局
    UIStackView *modalContainerView = [[UIStackView alloc]initWithArrangedSubviews:@[inputSectionView, datePickerSectionView, prioritySectionView]];
    [modalContainerView setFrame:CGRectMake(20, 100, modelViewInnerWidth, 200)];
    modalContainerView.axis = UILayoutConstraintAxisVertical;
    modalContainerView.spacing = 10;
    
    [modalView addSubview:modalContainerView];
    
    [self.view addSubview:modalView];
    self.modalPresentationStyle = UIModalPresentationPopover;
}

#pragma mark Custom View Makers

- (UITextView *)makeTextView:(int)tag value:(NSString*)value placeholderText:(NSString *)placeholderText height:(double)height {
    UITextView *textView = [[UITextView alloc]init];
    if (height) {
        [textView.heightAnchor constraintEqualToConstant:height].active = TRUE;
    }
    textView.tag = tag;
    textView.text = value;
    textView.editable = YES;
    textView.font = [UIFont systemFontOfSize:16];
    
    if (value == nil) {
        UILabel *placeholder = [[UILabel alloc] init];
        placeholder.text = placeholderText;
        placeholder.numberOfLines = 0;
        placeholder.textColor = [UIColor lightGrayColor];
        placeholder.font = [UIFont systemFontOfSize:16];
        [placeholder sizeToFit];
        [textView addSubview:placeholder];
        [textView setValue:placeholder forKey:@"_placeholderLabel"];
    }

    return textView;
}

- (UIButton *)makeButtonWidthTitleAndAction:(NSString *)name action:(nullable SEL)action {
    UIButton *button = [[UIButton alloc]init];
    [button setTitle:name forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [button.heightAnchor constraintEqualToConstant:50].active = TRUE;
    [button.widthAnchor constraintEqualToConstant:60].active = TRUE;
    
    UITapGestureRecognizer *tapCancelAddTodo = [[UITapGestureRecognizer alloc]initWithTarget:self action:action];
    [button addGestureRecognizer:tapCancelAddTodo];
    return button;
}

#pragma mark Custom Gesture Events

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
        @"tagName": self.todoPriorityText,
        @"time": self.todoDateTimeText,
    }];
    self.todoTitleText = @"";
    self.todoRemarkText = @"";
    self.todoDateTimeText = @"";
    self.todoPriorityText = @"";
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)cancelAddTodo {
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [actionSheet addAction: [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [actionSheet addAction: [UIAlertAction actionWithTitle:@"放弃更改" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        self.todoTitleText = @"";
        self.todoRemarkText = @"";
        self.todoDateTimeText = @"";
        self.todoPriorityText = @"";
        [self dismissViewControllerAnimated:YES completion:nil];
    }]];
    
    [self presentViewController:actionSheet animated:YES completion:nil];
    
}

- (void)selectPriority {
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"优先级" message:@"" preferredStyle:(UIAlertControllerStyleActionSheet)];
    
    for (int i = 0; i < self.priorityList.count; i++) {
        [actionSheet addAction:[UIAlertAction actionWithTitle:self.priorityList[i] style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
            NSString *priority = [self.priorityList objectAtIndex:i];
            self.todoPriorityText = priority;
            [self.priorityButton setTitle:priority forState:(UIControlStateNormal)];
        }]];
    }
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction * _Nonnull action) {
        [self.presentingViewController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    }]];
    
    [self presentViewController:actionSheet animated:YES completion:nil];
    
}

#pragma mark Event Listeners

- (void)onTodoTextChanged:(NSNotification *)obj {
    UITextView *todoTextView = (UITextView *)obj.object;
    if (todoTextView.tag == 1) {
        self.todoTitleText = todoTextView.text;
    }
    if (todoTextView.tag == 2) {
        self.todoRemarkText = todoTextView.text;
    }
}


- (void)dateChange:(UIDatePicker *)datePicker {
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"yyyy/MM/dd HH:mm";
    self.todoDateTimeText = [formatter stringFromDate:datePicker.date];
}

@end
