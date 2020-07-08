//
//  main.m
//  little-todo-c
//
//  Created by ybwdaisy on 2020/7/8.
//  Copyright © 2020 ybwdaisy. All rights reserved.
//

#import "Person.h"

int main()
{
    Person *p1 = [Person new];
    
    [p1 setName:@"向博"];
    [p1 setAge:30];
    [p1 setHeight:175.0f];
    [p1 setWeight:70.0f];
    
    NSLog(@"我是: %@, age: %d, height: %f, weight: %f", [p1 name], [p1 age], [p1 height], [p1 weight]);
    
    return 0;
}
