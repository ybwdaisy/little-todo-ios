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
#import "Toast.h"

@interface HomeViewController ()<UITableViewDelegate, AddTodoVCDelegate>

@property(nonatomic, readwrite) UITableView *todoTableView;
@property(nonatomic, readwrite) NSMutableArray<TodoItem *> *todoList;
@property(nonatomic, readwrite) NSIndexPath *todoIndexPath;
@property(nonatomic, readwrite) BOOL isContextMenu;
@property(nonatomic, readwrite) NSMutableArray *cellMenus;

@end

@implementation HomeViewController

- (instancetype) init {
    self = [super init];
    if (self) {
        self.tabBarItem.image = [UIImage imageNamed:@"home_inactive"];
        self.tabBarItem.selectedImage = [UIImage imageNamed:@"home_active"];
        
        self.navigationItem.title = @"收件箱";
        UIImage *rightIcon = [UIImage systemImageNamed:@"ellipsis.circle"];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:rightIcon style:UIBarButtonItemStylePlain target:self action:nil];
        self.navigationItem.rightBarButtonItem.tintColor = [UIColor systemBlueColor];
        self.navigationItem.rightBarButtonItem.title = @"完成";
        if (@available(iOS 14.0, *)) {
            self.navigationItem.rightBarButtonItem.menu = [self rightActionMenus];
        } else {
            // Fallback on earlier versions
        }
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
    self.todoList = [[NSMutableArray alloc]init];
    TodoItem *todo = [[TodoItem alloc]init];
    todo.title = @"New Reminder with Remark and Date and Time and Priority and Repeat";
    todo.remark = @"This is a very long note or remark, Test for newline styles. This is a very long note or remark, Test for newline styles.";
    todo.datetime = @"2022/06/12 10:00";
    todo.repeat = @"每天";
    todo.priority = @"高";
    todo.uuid = [CommonUtils uuid];
    [self.todoList addObject:todo];
    TodoItem *todo1 = [[TodoItem alloc]init];
    todo1.title = @"New Reminder";
    todo1.remark = @"remark";
    todo1.datetime = @"2022/05/12 10:00";
    todo1.uuid = [CommonUtils uuid];
    [self.todoList addObject:todo1];

    // 设置列表
    UITableView *tableView = [[UITableView alloc]initWithFrame:self.view.bounds];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.autoresizesSubviews = FALSE;
    tableView.rowHeight = UITableViewAutomaticDimension;
    tableView.estimatedRowHeight = 100;
    self.todoTableView = tableView;
    [self.view addSubview:tableView];
    
    self.isContextMenu = YES;

    // 添加按钮
    UIImage *plusIcon = [UIImage systemImageNamed:@"plus.circle.fill" withConfiguration:[UIImageSymbolConfiguration configurationWithPointSize:50]];
    UIImageView *plusIconImageView = [[UIImageView alloc] initWithImage:plusIcon];
    plusIconImageView.tintColor = [UIColor systemBlueColor];
    UIView *plusButtonContainerView = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 80, self.view.frame.size.height - 100, 50, 50)];

    // 添加事件
    UITapGestureRecognizer *tapAddTodo = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAddTodoButton)];
    [plusButtonContainerView addGestureRecognizer:tapAddTodo];
    
    [plusButtonContainerView addSubview:plusIconImageView];
    [self.view addSubview:plusButtonContainerView];

}

#pragma mark TableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    AddTodoViewController *addTodoViewController = [[AddTodoViewController alloc]initWithData:self.todoList[indexPath.row]];
    addTodoViewController.addTodoVCDelegate = self;
    [self presentViewController:addTodoViewController animated:YES completion:nil];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.todoList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellId = @"cellId";
    TDTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[TDTableViewCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:cellId];
    }
    [cell layoutTableViewCell:[self.todoList objectAtIndex:indexPath.row]];
    
    [cell setNeedsUpdateConstraints];
    [cell updateConstraintsIfNeeded];
    
    if (!self.isContextMenu) {
        UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(cellLongPress:)];
        [cell addGestureRecognizer:longPressGesture];
    }
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (nullable UISwipeActionsConfiguration *)tableView:(UITableView *)tableView leadingSwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath API_AVAILABLE(ios(11.0)) API_UNAVAILABLE(tvos) {
    UIContextualAction *doneAction = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleNormal title:@"完成" handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
        self.todoIndexPath = indexPath;
        [self doneTodo:nil];
    }];
    doneAction.backgroundColor = [UIColor colorWithRed:58.0f/255.0f green:197.0f/255.0f blue:105.0f/255.0f alpha:1];

    UIContextualAction *topAction = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleNormal title:@"置顶" handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
        self.todoIndexPath = indexPath;
        [self topTodo:nil];
    }];
    topAction.backgroundColor = [UIColor colorWithRed:248.0f/255.0f green:128.0f/255.0f blue:66.0f/255.0f alpha:1];

    UISwipeActionsConfiguration *config = [UISwipeActionsConfiguration configurationWithActions:@[doneAction, topAction]];
    config.performsFirstActionWithFullSwipe = NO;
    return config;
}

- (nullable UISwipeActionsConfiguration *)tableView:(UITableView *)tableView trailingSwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath API_AVAILABLE(ios(11.0)) API_UNAVAILABLE(tvos) {
    UIContextualAction *deleteAction = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleDestructive title:@"删除" handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
        self.todoIndexPath = indexPath;
        [self deleteTodo:nil];
    }];

    UISwipeActionsConfiguration *config = [UISwipeActionsConfiguration configurationWithActions:@[deleteAction]];
    config.performsFirstActionWithFullSwipe = NO;
    return config;
}

- (nullable UIContextMenuConfiguration *)tableView:(UITableView *)tableView contextMenuConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath point:(CGPoint)point {
    if (self.isContextMenu) {
        self.todoIndexPath = indexPath;
        UIContextMenuConfiguration *config = [UIContextMenuConfiguration configurationWithIdentifier:nil previewProvider:nil actionProvider:^UIMenu * _Nullable(NSArray<UIMenuElement *> * _Nonnull suggestedActions) {
            UIMenu *menu = [UIMenu menuWithTitle:@"" children:[self cellActionMenus]];
            return menu;
        }];
        return config;
    }
    return nil;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    [self.todoList exchangeObjectAtIndex:sourceIndexPath.row withObjectAtIndex: destinationIndexPath.row];
    [self.todoTableView reloadData];
}

#pragma mark Custom Gesture Event

- (void)tapAddTodoButton {
    AddTodoViewController *addTodoViewController = [[AddTodoViewController alloc]init];
    addTodoViewController.addTodoVCDelegate = self;
    [self presentViewController:addTodoViewController animated:YES completion:nil];
}

- (void)cellLongPress:(UIGestureRecognizer *)recognizer {
    if (recognizer.state == UIGestureRecognizerStateBegan && !self.isContextMenu) {
        CGPoint location = [recognizer locationInView:self.todoTableView];
        self.todoIndexPath = [self.todoTableView indexPathForRowAtPoint:location];
        TDTableViewCell *cell = (TDTableViewCell *)recognizer.view;
        [cell becomeFirstResponder];
        
        UIMenuController *menuController = [UIMenuController sharedMenuController];
        menuController.arrowDirection = UIMenuControllerArrowDefault;
        [menuController setMenuItems:[self cellActionMenus]];
        [menuController showMenuFromView:self.todoTableView rect:cell.frame];
    }
}

#pragma mark Custom Methods

- (void)addTodo:(TodoItem *)todo {
    [self.todoList addObject:todo];
    [self.todoTableView reloadData];
}

- (void)updateTodo:(TodoItem *)todo {
    [self.todoTableView reloadData];
}

- (void)topTodo:(id)sender {
    if (self.todoIndexPath.row > 0) {
        [self.todoList exchangeObjectAtIndex:self.todoIndexPath.row withObjectAtIndex: 0];
        [self.todoTableView reloadData];
    }
}

- (void)doneTodo:(id)sender {
    if (self.todoIndexPath.row < [self.todoList count] - 1) {
        [self.todoList exchangeObjectAtIndex:self.todoIndexPath.row withObjectAtIndex: [self.todoList count] - 1];
        [self.todoTableView reloadData];
    }
}

- (void)copyTodo:(id)sender {
    TodoItem *todo = self.todoList[self.todoIndexPath.row];
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = todo.title;
    [self.view makeToast:@"已复制到剪切板" duration:2.0 position:CSToastPositionCenter];
}

- (void)shareTodo:(id)sender {
    NSArray *activityItems = [NSArray arrayWithObjects: @"share todo text", nil];
    UIActivityViewController *controller = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
    [self presentViewController:controller animated:YES completion:nil];
}

- (void)deleteTodo:(id)sender {
    [self.todoList removeObjectAtIndex:self.todoIndexPath.row];
    [self.todoTableView reloadData];
}

- (void)editTodo {
    if (self.todoTableView.editing == NO) {
        self.todoTableView.editing = YES;
        self.navigationItem.rightBarButtonItem.image = nil;
        self.navigationItem.rightBarButtonItem.action = @selector(editTodo);
    } else {
        self.todoTableView.editing = NO;
        self.navigationItem.rightBarButtonItem.image = [UIImage systemImageNamed:@"ellipsis.circle"];
        self.navigationItem.rightBarButtonItem.action = nil;
        
    }
}

- (UIMenu *)rightActionMenus {
    UIAction *editAction = [UIAction actionWithTitle:@"编辑列表" image:[UIImage systemImageNamed:@"pencil"] identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
        [self editTodo];
    }];
    NSArray *menuActions = [NSArray arrayWithObjects:editAction, nil];
    UIMenu *menu = [UIMenu menuWithTitle:@"" children:menuActions];
    return menu;
}

- (NSArray *)cellActionMenus {
    TodoMenu *top = [[TodoMenu alloc]initWithName:@"置顶" icon:@"pin" handler:^(__kindof UIAction * _Nonnull action) {
        [self topTodo:nil];
    } action:@selector(topTodo:)];
    TodoMenu *done = [[TodoMenu alloc]initWithName:@"完成" icon:@"bookmark" handler:^(__kindof UIAction * _Nonnull action) {
        [self doneTodo:nil];
    } action:@selector(doneTodo:)];
    TodoMenu *copy = [[TodoMenu alloc]initWithName:@"复制" icon:@"doc.on.doc" handler:^(__kindof UIAction * _Nonnull action) {
        [self copyTodo:nil];
    } action:@selector(copyTodo:)];
    TodoMenu *share = [[TodoMenu alloc]initWithName:@"分享" icon:@"square.and.arrow.up" handler:^(__kindof UIAction * _Nonnull action) {
        [self shareTodo:nil];
    } action:@selector(shareTodo:)];
    TodoMenu *delete = [[TodoMenu alloc]initWithName:@"删除" icon:@"trash" handler:^(__kindof UIAction * _Nonnull action) {
        [self deleteTodo:nil];
    } action:@selector(deleteTodo:)];
    [delete action].attributes = UIMenuElementAttributesDestructive;

    if (self.isContextMenu) {
        NSArray *menuActions = [NSArray arrayWithObjects:top.action, done.action, copy.action, share.action, delete.action, nil];
        return menuActions;
    }

    NSArray *menuItems = [NSArray arrayWithObjects:top.menu, done.menu, copy.menu, share.menu, delete.menu, nil];
    return menuItems;
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    return action == @selector(topTodo:)
        || action == @selector(doneTodo:)
        || action == @selector(copyTodo:)
        || action == @selector(shareTodo:)
        || action == @selector(deleteTodo:);
}

@end
 
