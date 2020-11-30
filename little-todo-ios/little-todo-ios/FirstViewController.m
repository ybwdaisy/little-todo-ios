//
//  FirstViewController.m
//  little-todo-ios
//
//  Created by ybwdaisy on 2020/11/29.
//  Copyright © 2020 ybwdaisy. All rights reserved.
//

#import "FirstViewController.h"

@interface FirstViewController ()
@property (weak, nonatomic) IBOutlet UITextField *Searchbar;
@property (weak, nonatomic) IBOutlet UIButton *SearchBtn;

@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(searchBarTextChange:)
         name:UITextFieldTextDidChangeNotification
         object:_Searchbar];
}

- (IBAction)SearchBtn:(id)sender {
    NSLog(@"search btn %@", _Searchbar.text);
}

- (void)searchBarTextChange:(NSNotification *)notification {
    UITextField *textfield = [notification object];
    NSLog(@"change text %@",textfield.text);
}

@end
