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
@property(nonatomic, readwrite) NSMutableArray<TodoItem *> *todoListData;
@property(nonatomic, readwrite) NSIndexPath *todoIndexPath;
@property(nonatomic, readwrite) BOOL isContextMenu;

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
    self.isContextMenu = YES;
    self.todoListData = [[NSMutableArray alloc]init];

    // 设置列表
    UITableView *tableView = [[UITableView alloc]initWithFrame:self.view.bounds];
    tableView.dataSource = self;
    tableView.delegate = self;
    self.todoTableView = tableView;
    [self.view addSubview:tableView];
    
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 120;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    AddTodoViewController *addTodoViewController = [[AddTodoViewController alloc]initWithData:self.todoListData[indexPath.row]];
    addTodoViewController.addTodoVCDelegate = self;
    [self presentViewController:addTodoViewController animated:YES completion:nil];
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
//    完成
    UIContextualAction *doneAction = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleNormal title:@"完成" handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
        self.todoIndexPath = indexPath;
        [self doneTodo:nil];
    }];
    doneAction.backgroundColor = [UIColor colorWithRed:58.0f/255.0f green:197.0f/255.0f blue:105.0f/255.0f alpha:1];
//    置顶
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
//    删除
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
    [self.todoListData exchangeObjectAtIndex:sourceIndexPath.row withObjectAtIndex: destinationIndexPath.row];
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
    [self.todoListData addObject:todo];
    [self.todoTableView reloadData];
}

- (void)topTodo:(id)sender {
    if (self.todoIndexPath.row > 0) {
        [self.todoListData exchangeObjectAtIndex:self.todoIndexPath.row withObjectAtIndex: 0];
        [self.todoTableView reloadData];
    }
}

- (void)doneTodo:(id)sender {
    if (self.todoIndexPath.row < [self.todoListData count] - 1) {
        [self.todoListData exchangeObjectAtIndex:self.todoIndexPath.row withObjectAtIndex: [self.todoListData count] - 1];
        [self.todoTableView reloadData];
    }
}

- (void)copyTodo:(id)sender {
    TodoItem *todo = self.todoListData[self.todoIndexPath.row];
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = todo.title;
    [self.view makeToast:@"Copied" duration:2.0 position:CSToastPositionCenter];
}

- (void)shareTodo:(id)sender {
    NSArray *activityItems = [NSArray arrayWithObjects: @"share todo text", nil];
    UIActivityViewController *controller = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
    [self presentViewController:controller animated:YES completion:nil];
}

- (void)deleteTodo:(id)sender {
    [self.todoListData removeObjectAtIndex:self.todoIndexPath.row];
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
    if (self.isContextMenu) {
        UIAction *topAction = [UIAction actionWithTitle:@"置顶" image:[UIImage systemImageNamed:@"pin"] identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
            [self topTodo:nil];
        }];
        UIAction *doneAction = [UIAction actionWithTitle:@"完成" image:[UIImage systemImageNamed:@"bookmark"] identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
            [self doneTodo:nil];
        }];
        UIAction *copyAction = [UIAction actionWithTitle:@"复制" image:[UIImage systemImageNamed:@"doc.on.doc"] identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
            [self copyTodo:nil];
        }];
        UIAction *shareAction = [UIAction actionWithTitle:@"分享" image:[UIImage systemImageNamed:@"square.and.arrow.up"] identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
            [self shareTodo:nil];
        }];
        UIAction *deleteAction = [UIAction actionWithTitle:@"删除" image:[UIImage systemImageNamed:@"trash"] identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
            [self deleteTodo:nil];
        }];
        deleteAction.attributes = UIMenuElementAttributesDestructive;
        NSArray *menuActions = [NSArray arrayWithObjects:topAction, doneAction, copyAction, shareAction, deleteAction, nil];
        return menuActions;
    }

    UIMenuItem *topItem = [[UIMenuItem alloc]initWithTitle:@"置顶" action:@selector(topTodo:)];
    UIMenuItem *doneItem = [[UIMenuItem alloc]initWithTitle:@"完成" action:@selector(doneTodo:)];
    UIMenuItem *copyItem = [[UIMenuItem alloc]initWithTitle:@"复制" action:@selector(copyTodo:)];
    UIMenuItem *shareItem = [[UIMenuItem alloc]initWithTitle:@"分享" action:@selector(shareTodo:)];
    UIMenuItem *deleteItem = [[UIMenuItem alloc]initWithTitle:@"删除" action:@selector(deleteTodo:)];

    NSArray *menuItems = [NSArray arrayWithObjects:topItem, doneItem, copyItem, shareItem, deleteItem, nil];

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
 
