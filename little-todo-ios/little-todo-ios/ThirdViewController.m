//
//  ThirdViewController.m
//  little-todo-ios
//
//  Created by ybwdaisy on 2020/12/13.
//  Copyright © 2020 ybwdaisy. All rights reserved.
//

#import "ThirdViewController.h"

@interface ThirdViewController ()

@end

@implementation ThirdViewController

- (instancetype) init {
    self = [super init];
    if (self) {
        self.tabBarItem.title = @"推荐";
        self.tabBarItem.image = [UIImage imageNamed:@"first"];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    
    scrollView.backgroundColor = [UIColor lightGrayColor];
    scrollView.contentSize = CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.height * 5);
    scrollView.pagingEnabled = YES;
    scrollView.showsVerticalScrollIndicator = NO;
    
    NSArray *bgColors = @[[UIColor redColor], [UIColor yellowColor], [UIColor greenColor], [UIColor cyanColor], [UIColor blueColor]];
    
    for (int i = 0; i < 5; i++) {
        [scrollView addSubview:({
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, scrollView.bounds.size.height * i, scrollView.bounds.size.width, scrollView.bounds.size.height)];
            view.backgroundColor = [bgColors objectAtIndex:i];
            view;
        })];
    }
    
    [self.view addSubview:scrollView];
}

@end
