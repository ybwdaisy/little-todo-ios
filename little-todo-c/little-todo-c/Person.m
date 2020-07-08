//
//  Person.m
//  little-todo-c
//
//  Created by ybwdaisy on 2020/7/8.
//  Copyright © 2020 ybwdaisy. All rights reserved.
//

#import "Person.h"

@implementation Person
- (void)setName:(NSString *)name
{
    _name = name;
}
- (NSString *)name
{
    return _name;
}
- (void)setAge:(int)age
{
    _age = age;
}
- (int)age
{
    return _age;
}

- (void)setHeight:(float)height
{
    _height = height;
}
- (float)height
{
    return _height;
}

- (void)setWeight:(float)weight
{
    _weight = weight;
}
- (float)weight
{
    return _weight;
}

@end
