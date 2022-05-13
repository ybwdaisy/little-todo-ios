//
//  AddTodoViewController.m
//  little-todo-ios
//
//  Created by ybw-macbook-pro on 2021/1/21.
//  Copyright © 2021 ybwdaisy. All rights reserved.
//

#import "AddTodoViewController.h"

@interface AddTodoViewController ()

@property(nonatomic, readwrite) TodoItem *todo;
@property(nonatomic, readwrite) BOOL *editing;
@property(nonatomic, readwrite) UIDatePicker *datePicker;
@property(nonatomic, readwrite) UIButton *repeatButton;
@property(nonatomic, readwrite) NSArray *repeatList;
@property(nonatomic, readwrite) NSArray *priorityList;
@property(nonatomic, readwrite) UIButton *priorityButton;

@end

@implementation AddTodoViewController

- (instancetype)init {
    self = [super init];
    self.todo = [[TodoItem alloc]init];
    self.editing = FALSE;
    return self;
}

-(instancetype)initWithData:(TodoItem *)data {
    self = [super init];
    if (self) {
        self.todo = data;
        self.editing = TRUE;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.repeatList = [[NSArray alloc] initWithObjects:@"永不", @"每小时", @"每天", @"工作日", @"周末", @"每周", @"每两周", @"每月", @"每 3 个月", @"每 6 个月", @"每年", nil];
    self.priorityList = [[NSArray alloc] initWithObjects:@"低", @"中", @"高", nil];
    
    // 监听输入
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(onTodoTextChanged:) name:@"UITextViewTextDidChangeNotification" object:nil];
    
    UIView *modalView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    modalView.backgroundColor = [[UIColor alloc]initWithRed:246/255.0 green:247/255.0 blue:249/255.0 alpha:1];
    
    CGFloat modelViewInnerWidth = self.view.frame.size.width - 40;
    
    // 顶部视图
    UIButton *headerLeftButton = [self makeButtonWidthTitleAndAction:@"取消" contentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft action:@selector(cancelAddTodo)];
    
    UILabel *headerTitle = [[UILabel alloc]init];
    headerTitle.text = @"详细信息";
    headerTitle.font = [UIFont boldSystemFontOfSize:18];
    [headerTitle setTextAlignment:NSTextAlignmentCenter];
    
    UIButton *headerRightButton = [self makeButtonWidthTitleAndAction: @"完成" contentHorizontalAlignment:UIControlContentHorizontalAlignmentRight action:@selector(addNewTodo)];
    
    UIStackView *headerView = [[UIStackView alloc]initWithArrangedSubviews:@[headerLeftButton, headerTitle, headerRightButton]];
    [headerView setFrame:CGRectMake(20, 10, modelViewInnerWidth, 50)];
    headerView.axis = UILayoutConstraintAxisHorizontal;
    headerView.alignment = UIStackViewAlignmentCenter;
    headerView.distribution = UIStackViewDistributionEqualSpacing;
    
    [modalView addSubview:headerView];
    
    // 标题和备注模块
    UITextView *titleTextView = [self makeTextView:1 value:self.todo.title placeholderText:@"标题" height:40.0];
    
    UIView *divideLine = [[UIView alloc]init];
    [divideLine.heightAnchor constraintEqualToConstant:0.5].active = TRUE;
    divideLine.backgroundColor = [[UIColor alloc]initWithRed:220/255.0f green:220/255.0f blue:220/255.0f alpha:1];
    
    UITextView *remarkTextView = [self makeTextView:2 value:self.todo.remark placeholderText:@"备注" height:40.0];
    
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
    if (self.todo.datetime) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        formatter.dateFormat = @"yyyy/MM/dd HH:mm";
        NSDate *date = [formatter dateFromString:self.todo.datetime];
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
    
    // 重复模式
    UILabel *repeatTitle = [[UILabel alloc]init];
    repeatTitle.text = @"重复";
    UIButton *repeatButton = [self makeButtonWidthTitleAndAction:self.todo.repeat ? self.todo.repeat : @"请选择" contentHorizontalAlignment:UIControlContentHorizontalAlignmentRight action:@selector(selectRepeat)];
    self.repeatButton = repeatButton;
    UIStackView *repeatSectionView = [[UIStackView alloc]initWithArrangedSubviews:@[repeatTitle, repeatButton]];
    repeatSectionView.axis = UILayoutConstraintAxisHorizontal;
    [repeatSectionView.heightAnchor constraintEqualToConstant:50].active = TRUE;
    
    // 优先级模块
    
    UILabel *priorityTitle = [[UILabel alloc]init];
    priorityTitle.text = @"优先级";
    UIButton *priorityButton = [self makeButtonWidthTitleAndAction:self.todo.priority ? self.todo.priority : @"请选择" contentHorizontalAlignment:UIControlContentHorizontalAlignmentRight action:@selector(selectPriority)];
    self.priorityButton = priorityButton;
    
    UIStackView *prioritySectionView = [[UIStackView alloc]initWithArrangedSubviews:@[priorityTitle, priorityButton]];
    prioritySectionView.axis = UILayoutConstraintAxisHorizontal;
    [prioritySectionView.heightAnchor constraintEqualToConstant:50].active = TRUE;
    
    // 对所有子元素整体布局
    UIStackView *modalContainerView = [[UIStackView alloc]initWithArrangedSubviews:@[inputSectionView, datePickerSectionView, repeatSectionView, prioritySectionView]];
    [modalContainerView setFrame:CGRectMake(20, 100, modelViewInnerWidth, 300)];
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

- (UIButton *)makeButtonWidthTitleAndAction:(NSString *)name contentHorizontalAlignment:(UIControlContentHorizontalAlignment)contentHorizontalAlignment action:(nullable SEL)action {
    UIButton *button = [[UIButton alloc]init];
    [button setTitle:name forState:UIControlStateNormal];
    [button setTitleColor:[UIColor systemBlueColor] forState:UIControlStateNormal];
    [button.heightAnchor constraintEqualToConstant:50].active = TRUE;
    [button.widthAnchor constraintEqualToConstant:100].active = TRUE;
    button.contentHorizontalAlignment = contentHorizontalAlignment;
    
    UITapGestureRecognizer *tapCancelAddTodo = [[UITapGestureRecognizer alloc]initWithTarget:self action:action];
    [button addGestureRecognizer:tapCancelAddTodo];
    return button;
}

#pragma mark Custom Gesture Events

- (void)addNewTodo {
    if (self.todo.title == nil ||
        self.todo.remark == nil ||
        [self.todo.title isEqualToString:@""] ||
        [self.todo.remark isEqualToString:@""]) {
        UIAlertController *checkAlert = [UIAlertController alertControllerWithTitle:@"标题和备注不能为空" message:nil preferredStyle:UIAlertControllerStyleAlert];
        [checkAlert addAction: [UIAlertAction actionWithTitle:@"好" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
            
        }]];
        [self presentViewController:checkAlert animated:YES completion:nil];
        
        return;
    }
    
    if (self.editing) {
        [self.addTodoVCDelegate updateTodo:self.todo];
    } else {
        self.todo.uuid = [CommonUtils uuid];
        [self.addTodoVCDelegate addTodo:self.todo];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)cancelAddTodo {
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [actionSheet addAction: [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [actionSheet addAction: [UIAlertAction actionWithTitle:@"放弃更改" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }]];
    
    [self presentViewController:actionSheet animated:YES completion:nil];
    
}

- (void)selectRepeat {
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"重复" message:@"" preferredStyle:(UIAlertControllerStyleActionSheet)];
    
    for (int i = 0; i < self.repeatList.count; i++) {
        [actionSheet addAction:[UIAlertAction actionWithTitle:self.repeatList[i] style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
            NSString *repeat = [self.repeatList objectAtIndex:i];
            self.todo.repeat = repeat;
            [self.repeatButton setTitle:repeat forState:(UIControlStateNormal)];
        }]];
    }
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction * _Nonnull action) {
        [self.presentingViewController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    }]];
    
    [self presentViewController:actionSheet animated:YES completion:nil];
}

- (void)selectPriority {
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"优先级" message:@"" preferredStyle:(UIAlertControllerStyleActionSheet)];
    
    for (int i = 0; i < self.priorityList.count; i++) {
        [actionSheet addAction:[UIAlertAction actionWithTitle:self.priorityList[i] style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
            NSString *priority = [self.priorityList objectAtIndex:i];
            self.todo.priority = priority;
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
        self.todo.title = todoTextView.text;
    }
    if (todoTextView.tag == 2) {
        self.todo.remark = todoTextView.text;
    }
}


- (void)dateChange:(UIDatePicker *)datePicker {
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"yyyy/MM/dd HH:mm";
    self.todo.datetime = [formatter stringFromDate:datePicker.date];
}

@end
