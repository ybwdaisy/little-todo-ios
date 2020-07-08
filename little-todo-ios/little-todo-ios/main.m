//
//  main.m
//  little-todo-ios
//
//  Created by ybwdaisy on 2020/7/4.
//  Copyright © 2020 ybwdaisy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface Person : NSObject
{
    NSString *name;
    int age;
    float height;
}
- (void) run;
- (void) eat:(NSString *) foodName;
- (int) sum:(int) num1 :(int) num2;
@end

@implementation Person

- (void) run {
    NSLog(@"Execution run function");
}

- (void) eat:(NSString *) foodName {
    NSLog(@"Execution eat function, args foodName is %@", foodName);
}

- (int) sum:(int) num1 :(int) num2 {
    return num1 + num2;
}

@end

int main(int argc, char * argv[]) {
    NSString * appDelegateClassName;
    @autoreleasepool {
        // Setup code that might create autoreleased objects goes here.
        appDelegateClassName = NSStringFromClass([AppDelegate class]);
    }
    
    Person *p1 = [Person new];
    
    [p1 run];
    
    [p1 eat:@"apple"];
    
    int sum = [p1 sum:10 :20];
    NSLog(@"sum is %d", sum);
    
    return UIApplicationMain(argc, argv, nil, appDelegateClassName);
}
