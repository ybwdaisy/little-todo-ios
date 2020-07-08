//
//  Person.h
//  little-todo-c
//
//  Created by ybwdaisy on 2020/7/8.
//  Copyright © 2020 ybwdaisy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Person : NSObject
{
    @public
    NSString *_name;
    int _age;
    float _height;
    float _weight;
}

- (void)setName:(NSString *)name;
- (NSString *)name;

- (void)setAge:(int)age;
- (int)age;

- (void)setHeight:(float)height;
- (float)height;

- (void)setWeight:(float)weight;
- (float)weight;

@end
