//
//  AddTodoViewController.m
//  little-todo-ios
//
//  Created by ybw-macbook-pro on 2021/1/21.
//  Copyright © 2021 ybwdaisy. All rights reserved.
//

#import "AddTodoViewController.h"

@interface AddTodoViewController () <UIPickerViewDelegate>

@property(nonatomic, readwrite) NSString *todoTitleText;
@property(nonatomic, readwrite) NSString *todoRemarkText;
@property(nonatomic, readwrite) UITextView *todoDateTimeView;
@property(nonatomic, readwrite) NSString *todoDateTimeText;
@property(nonatomic, strong) UIDatePicker *datePicker;
@property(nonatomic, readwrite) NSArray *priorityList;
@property(nonatomic, readwrite) NSString *todoPriorityText;

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
    self.priorityList = [[NSArray alloc] initWithObjects:@"高",@"中",@"低", nil];
    
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
    
    // 标题和备注模块
    UITextView *titleTextView = [self makeTextView:1 placeholderText:@"标题" height:40.0];
    
    UIView *divideLine = [[UIView alloc]init];
    [divideLine.heightAnchor constraintEqualToConstant:0.5].active = TRUE;
    divideLine.backgroundColor = [[UIColor alloc]initWithRed:220/255.0f green:220/255.0f blue:220/255.0f alpha:1];
    
    UITextView *remarkTextView = [self makeTextView:2 placeholderText:@"备注" height:0.0];
    
    UIStackView *inputSectionView = [[UIStackView alloc]initWithArrangedSubviews:@[titleTextView, divideLine, remarkTextView]];
    inputSectionView.backgroundColor = [UIColor whiteColor];
    inputSectionView.layer.cornerRadius = 10;
    [inputSectionView setFrame:CGRectMake(20, 100, modelViewInnerWidth, 160.5)];
    inputSectionView.spacing = 0;
    inputSectionView.axis = UILayoutConstraintAxisVertical;
    
    [modalView addSubview:inputSectionView];
    
    // 日期与时间模块
    self.todoDateTimeView = [[UITextView alloc]init];
    [self.todoDateTimeView setFrame:CGRectMake(20, 280, modelViewInnerWidth, 40)];
    self.todoDateTimeView.font = [UIFont systemFontOfSize:16];
    
    UIDatePicker *datePicker = [[UIDatePicker alloc]init];
    datePicker.locale = [NSLocale localeWithLocaleIdentifier:@"zh"];
    datePicker.datePickerMode = UIDatePickerModeDateAndTime;
    [datePicker setDate:[NSDate date] animated:YES];
    [datePicker setMinimumDate:[NSDate date]];
    [datePicker setMinuteInterval:5];
    [datePicker addTarget:self action:@selector(dateChange:) forControlEvents:UIControlEventValueChanged];
    self.datePicker = datePicker;
    self.todoDateTimeView.inputView = datePicker;
    
    [modalView addSubview:self.todoDateTimeView];
    
    // 优先级模块
    UIPickerView *priorityPickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(20, 340, modelViewInnerWidth, 100)];
    priorityPickerView.dataSource = self;
    priorityPickerView.delegate = self;
    
    [modalView addSubview:priorityPickerView];
    // 重复模式模块
    
    [self.view addSubview:modalView];
    self.modalPresentationStyle = UIModalPresentationPopover;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.priorityList.count;
}

- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    self.todoPriorityText = [self.priorityList objectAtIndex:row];
    return self.todoPriorityText;
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

- (void)dateChange:(UIDatePicker *)datePicker {
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"yyyy年MM月dd日 HH:mm";
    self.todoDateTimeView.text = [formatter stringFromDate:datePicker.date];
    self.todoDateTimeText = self.todoDateTimeView.text;
}

@end
